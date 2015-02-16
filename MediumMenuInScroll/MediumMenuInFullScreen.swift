//
//  MediumMenuInScroll.swift
//  MediumMenuInScroll
//
//  Created by pixyzehn on 2/14/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

class MediumMenuInFullScreen: NSObject, UIScrollViewDelegate {
   
    enum Direction {
        case None
        case Up
        case Down
        
    }
    
    func detectScrollDirection(currentOffsetY: Float, previousOffsetY: Float) -> Direction {
        if currentOffsetY > previousOffsetY {
            return .Up
        } else if currentOffsetY < previousOffsetY {
            return .Down
        } else {
            return .None
        }
    }
    
    var delegate: MediumMenuInScrollDelegate?
    var upThresholdY: Float?
    var downThresholdY: Float?
    
    private var previousScrollDirection: Direction = .None
    private var previousOffsetY: Float?
    private var accumulatedY: Float?
    private var forwardTarget: UIScrollViewDelegate?
    
    override init() {
        super.init()
    }
    
    convenience init(forwardTarget: AnyObject) {
        self.init()
        reset()
        downThresholdY = 200.0
        upThresholdY = 0.0
    }
    
    func reset() {
        previousOffsetY = 0.0
        accumulatedY = 0.0
        previousScrollDirection = .None
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        forwardTarget?.scrollViewDidScroll!(scrollView)
        
        var currentOffsetY: Float = Float(scrollView.contentOffset.y)
        var currentScrollDirection: Direction = detectScrollDirection(currentOffsetY, previousOffsetY: previousOffsetY!)
        var topBoundary: Float = -Float(scrollView.contentInset.top)
        var bottomBoundary: Float = Float(scrollView.contentSize.height + scrollView.contentInset.bottom)
        
        var isOverTopBoundary: Bool = currentOffsetY <= topBoundary
        var isOverBottomBoundary: Bool = currentOffsetY >= bottomBoundary
        
        var isBouncing: Bool = (isOverTopBoundary && currentScrollDirection != Direction.Down) || (isOverBottomBoundary && currentScrollDirection != Direction.Up)
        
        if (isBouncing || !scrollView.dragging) {
            return
        }

        var deltaY: Float = previousOffsetY! - currentOffsetY
        accumulatedY! += deltaY
        
        switch currentScrollDirection {
        case .Up:
            let isOverThreshold: Bool = accumulatedY! < -upThresholdY!
            if isOverThreshold || isOverBottomBoundary {
                delegate?.scrollFullScreen(self, scrollViewDidScrollUp: deltaY)
            }
        case .Down:
            let isOverThreshold : Bool = accumulatedY > downThresholdY
            if isOverThreshold || isOverTopBoundary {
                delegate?.scrollFullScreen(self, scrollViewDidScrollDown: deltaY)
            }
        case .None:
            break
        }
        
        if !isOverTopBoundary && !isOverBottomBoundary && previousScrollDirection != currentScrollDirection {
            accumulatedY = 0
        }
        
        previousScrollDirection = currentScrollDirection
        previousOffsetY = currentOffsetY
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        forwardTarget?.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        
        var currentOffsetY: Float = Float(scrollView.contentOffset.y)
        var topBoundary: Float = -Float(scrollView.contentInset.top)
        var bottomBoundary: Float = -Float(scrollView.contentSize.height + scrollView.contentInset.bottom)
        
        switch previousScrollDirection {
        case .Up:
            var isOverThreshold = accumulatedY! < -upThresholdY!
            var isOverBottomBoundary = currentOffsetY >= bottomBoundary
            if isOverBottomBoundary || isOverThreshold {
                delegate?.scrollFullScreenScrollViewDidEndDraggingScrollUp(self)
            }
        case .Down:
            var isOverThreshold = accumulatedY! > downThresholdY!
            var isOverTopBoundary = currentOffsetY <= topBoundary
            if isOverThreshold || isOverTopBoundary {
                delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown(self)
            }
            break
        case .None:
            break
        }
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        var ret = true
        ret = forwardTarget!.scrollViewShouldScrollToTop!(scrollView)
        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown(self)
        return ret
    }
    
}

@objc protocol MediumMenuInScrollDelegate {
    func scrollFullScreen(fullScreenProxy: MediumMenuInFullScreen, scrollViewDidScrollUp deltaY: Float)
    func scrollFullScreen(fullScreenProxy: MediumMenuInFullScreen, scrollViewDidScrollDown deltaY: Float)
    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumMenuInFullScreen)
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumMenuInFullScreen)
}

extension UIViewController {
    func showNavigationBar(animated: Bool) {
        let statusBarHeight: CGFloat = getStatusBarHeight()
        let appKeyWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView: UIView = appKeyWindow.rootViewController!.view
        let viewControllerFrame: CGRect = appBaseView.convertRect(appBaseView.frame, toView: appKeyWindow)
        let overwrapStatusBarHeight: CGFloat = statusBarHeight - viewControllerFrame.origin.y
        self.setNavigationBarOriginY(Float(overwrapStatusBarHeight), animated: animated)
    }
    func hideNavigationBar(animated: Bool) {
        let statusBarHeight: CGFloat = getStatusBarHeight()
        let appKeyWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView: UIView = appKeyWindow.rootViewController!.view
        let viewControllerFrame: CGRect = appBaseView.convertRect(appBaseView.frame, toView: appKeyWindow)
        let overwrapStatusBarHeight: CGFloat = statusBarHeight - viewControllerFrame.origin.y
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.size.height
        let top: CGFloat = -navigationBarHeight
        self.setNavigationBarOriginY(Float(top), animated: animated)
    }
    func moveNavigationBar(deltaY: Float, animated: Bool) {
        let frame: CGRect = self.navigationController!.navigationBar.frame
        let nextY: CGFloat = frame.origin.y + CGFloat(deltaY)
        self.setNavigationBarOriginY(Float(nextY), animated: animated)
    }
    func setNavigationBarOriginY(y: Float, animated: Bool) {
        let statusBarHeight: CGFloat = getStatusBarHeight()
        let appKeyWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView: UIView = appKeyWindow.rootViewController!.view
        let viewControllerFrame: CGRect = appBaseView.convertRect(appBaseView.frame, toView: appKeyWindow)
        let overwrapStatusBarHeight: CGFloat = statusBarHeight - viewControllerFrame.origin.y
        var frame = self.navigationController!.navigationBar.frame
        let navigationBarHeight = frame.size.height
        let topLimit: CGFloat = -navigationBarHeight
        let bottomLimit = overwrapStatusBarHeight
        
        let x = CGFloat(min(max(CGFloat(y), topLimit), bottomLimit))
        frame.origin.y = x
        let navBarHiddenRatio: CGFloat = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0
        let alpha: CGFloat = max(1.0 - navBarHiddenRatio, 0.00001)
        UIView.animateWithDuration(animated ? 0.1 : 0, animations: {[unowned self]() -> () in
        
            self.navigationController!.navigationBar.frame = frame
            var index: Int = 0
            for v in self.navigationController!.navigationBar.subviews {
                index++
//                if index == 1 || v.hidden == true || v.alpha <= 0.0 {
//
//                }
            }
        })
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarFrameSize: CGSize = UIApplication.sharedApplication().statusBarFrame.size
        return statusBarFrameSize.height
    }
}
