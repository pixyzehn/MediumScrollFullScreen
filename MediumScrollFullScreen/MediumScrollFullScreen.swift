//
//  MediumMenuInScroll.swift
//  MediumMenuInScroll
//
//  Created by pixyzehn on 2/14/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public class MediumScrollFullScreen: NSObject, UIScrollViewDelegate {
    
    public enum Direction {
        case None
        case Up
        case Down
    }
    
    private func detectScrollDirection(currentOffsetY: Float, previousOffsetY: Float) -> Direction {
        
        if currentOffsetY > previousOffsetY {
            return .Up
        } else if currentOffsetY < previousOffsetY {
            return .Down
        } else {
            return .None
        }
    }
    
    public var delegate: MediumScrollFullScreenDelegate?
    public var upThresholdY: Float = 0.0
    public var downThresholdY: Float = 0.0
    public var forwardTarget: UIScrollViewDelegate?
    private var previousScrollDirection: Direction = .None
    private var previousOffsetY: Float = 0.0
    private var accumulatedY: Float = 0.0
    
    override public init() {
        
        super.init()
    }
    
    convenience public init(forwardTarget: UIScrollViewDelegate) {
        
        self.init()
        self.forwardTarget = forwardTarget
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        forwardTarget?.scrollViewDidScroll!(scrollView)
        let currentOffsetY = Float(scrollView.contentOffset.y)
        let currentScrollDirection = detectScrollDirection(currentOffsetY, previousOffsetY: previousOffsetY)

        let topBoundary = -Float(scrollView.contentInset.top)
        let bottomBoundary = Float(scrollView.contentSize.height + scrollView.contentInset.bottom)
        let isOverTopBoundary = currentOffsetY <= topBoundary
        let isOverBottomBoundary = currentOffsetY >= bottomBoundary
        
        let isBouncing = (isOverTopBoundary && currentScrollDirection != Direction.Down) || (isOverBottomBoundary && currentScrollDirection != Direction.Up)
        
        if (isBouncing || !scrollView.dragging) {
            return
        }
        
        let deltaY = previousOffsetY - currentOffsetY
        accumulatedY += deltaY
        
        switch currentScrollDirection {
        case .Up:
            let isOverThreshold = accumulatedY < -upThresholdY
            if isOverThreshold || isOverBottomBoundary {
                if currentOffsetY <= 0 {
                    delegate?.scrollFullScreen!(self, scrollViewDidScrollUp: deltaY, userInteractionEnabled: true)
                } else {
                    delegate?.scrollFullScreen!(self, scrollViewDidScrollUp: deltaY, userInteractionEnabled: false)
                }
            }
        case .Down:
            let isOverThreshold = accumulatedY > downThresholdY
            if isOverThreshold || isOverTopBoundary {
                if currentOffsetY <= 0 {
                    delegate?.scrollFullScreen!(self, scrollViewDidScrollDown: deltaY, userInteractionEnabled: true)
                } else {
                    delegate?.scrollFullScreen!(self, scrollViewDidScrollDown: deltaY, userInteractionEnabled: false)
                }
                
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
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        forwardTarget?.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        let currentOffsetY = Float(scrollView.contentOffset.y)
        let topBoundary = -Float(scrollView.contentInset.top)
        let bottomBoundary = Float(scrollView.contentSize.height + scrollView.contentInset.bottom)
        
        switch previousScrollDirection {
        case .Up:
            let isOverThreshold = accumulatedY < -upThresholdY
            let isOverBottomBoundary = currentOffsetY >= bottomBoundary
            if isOverBottomBoundary || isOverThreshold {
                if currentOffsetY < 0 {
                    delegate?.scrollFullScreenScrollViewDidEndDraggingScrollUp!(self, userInteractionEnabled: true)
                } else {
                    delegate?.scrollFullScreenScrollViewDidEndDraggingScrollUp!(self, userInteractionEnabled: false)
                }
            }
        case .Down:
            let isOverThreshold = accumulatedY > downThresholdY
            let isOverTopBoundary = currentOffsetY <= topBoundary
            if isOverThreshold || isOverTopBoundary {
                if currentOffsetY < 0 {
                    delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown!(self, userInteractionEnabled: true)
                } else {
                    delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown!(self, userInteractionEnabled: false)
                }
            }
            break
        case .None:
            break
        }
    }
    
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        
        var ret = true
        ret = forwardTarget!.scrollViewShouldScrollToTop!(scrollView)
        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown!(self, userInteractionEnabled: true)
        return ret
    }
}

@objc public protocol MediumScrollFullScreenDelegate {
    
    optional func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollUp deltaY: Float, userInteractionEnabled enabled: Bool)
    optional func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollDown deltaY: Float, userInteractionEnabled enabled: Bool)
    optional func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled: Bool)
    optional func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled:   Bool)
}

public extension UIViewController {
    
    // MARK: NavigationBar
    
    public func showNavigationBar() {
        
        let statusBarHeight = getStatusBarHeight()
        
        let appKeyWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView = appKeyWindow.rootViewController!.view
        let viewControllerFrame = appBaseView.convertRect(appBaseView.bounds, toView: appKeyWindow)
        
        let overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y
        
        self.setNavigationBarOriginY(y: Float(overwrapStatusBarHeight))
    }
    
    public func hideNavigationBar() {
        
        let statusBarHeight = getStatusBarHeight()
        
        let appKeyWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView = appKeyWindow.rootViewController!.view
        let viewControllerFrame = appBaseView.convertRect(appBaseView.bounds, toView: appKeyWindow)
        
        let overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y
        
        let navigationBarHeight = navigationController!.navigationBar.frame.size.height
        let top = -navigationBarHeight
        
        self.setNavigationBarOriginY(y: Float(top))
    }
    
    public func moveNavigationBar(#deltaY: Float) {
        
        let frame = navigationController!.navigationBar.frame
        let nextY = frame.origin.y + CGFloat(deltaY)
        self.setNavigationBarOriginY(y: Float(nextY))
    }
    
    public func setNavigationBarOriginY(#y: Float) {
        
        let statusBarHeight = getStatusBarHeight()
        
        let appKeyWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView = appKeyWindow.rootViewController!.view
        let viewControllerFrame = appBaseView.convertRect(appBaseView.bounds, toView: appKeyWindow)
        
        let overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y
        
        var frame = navigationController!.navigationBar.frame
        let navigationBarHeight = frame.size.height
        
        let topLimit = -navigationBarHeight
        let bottomLimit = overwrapStatusBarHeight
        
        frame.origin.y = min(max(CGFloat(y), topLimit), bottomLimit)
        
        let navBarHiddenRatio = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0
        let alpha = max(1.0 - navBarHiddenRatio, 0.000001)
        
        UIView.animateWithDuration(0.3, animations: {[unowned self]() -> () in
            self.navigationController!.navigationBar.frame = frame
            var index = 0
            for v in self.navigationController!.navigationBar.subviews {
                let navView = v as! UIView
                index++
                if index == 1 || navView.hidden == true || navView.alpha <= 0.0 {
                    continue
                }
                navView.alpha = alpha
            }
        })
    }
    
    private func getStatusBarHeight() -> CGFloat {
        
        var statusBarFrameSize = UIApplication.sharedApplication().statusBarFrame.size
        return statusBarFrameSize.height
    }
    
    // MARK:ToolBar
    
    public func showToolbar() {
        
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        let toolbarHeight = navigationController!.toolbar.frame.size.height
        setToolbarOriginY(y: Float(viewHeight - toolbarHeight))
    }
    
    public func hideToolbar() {
        
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        setToolbarOriginY(y: Float(viewHeight))
    }
    
    public func moveToolbar(#deltaY: Float) {
        
        let frame = navigationController!.toolbar.frame
        let nextY = frame.origin.y + CGFloat(deltaY)
        setToolbarOriginY(y: Float(nextY))
    }
    
    public func setToolbarOriginY(#y: Float) {
        
        var frame = navigationController!.toolbar.frame
        let toolBarHeight = frame.size.height
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        
        let topLimit = viewHeight - toolBarHeight
        let bottomLimit = viewHeight
        
        frame.origin.y = fmin(fmax(CGFloat(y), topLimit), bottomLimit)
        UIView.animateWithDuration(0.3, animations: {[unowned self]() -> () in
            self.navigationController!.toolbar.frame = frame
        })
    }
    
    private func bottomBarViewControlleViewHeightFromViewSize(viewSize: CGSize) -> CGFloat {
        
        var viewHeight: CGFloat = 0.0
        viewHeight += viewSize.height
        return viewHeight
    }
}

public extension UINavigationBar {
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        let newSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
        return newSize
    }
}

public extension UIToolbar {
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        let newSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
        return newSize
    }
}
