//
//  MediumMenuInScroll.swift
//  MediumMenuInScroll
//
//  Created by pixyzehn on 2/14/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public protocol MediumScrollFullScreenDelegate: class {
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollUp deltaY: CGFloat, userInteractionEnabled enabled: Bool)
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollDown deltaY: CGFloat, userInteractionEnabled enabled: Bool)
    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled: Bool)
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled:   Bool)
}

public class MediumScrollFullScreen: NSObject {
    public enum Direction {
        case None
        case Up
        case Down
    }
    
    private func detectScrollDirection(currentOffsetY: CGFloat, previousOffsetY: CGFloat) -> Direction {
        if currentOffsetY > previousOffsetY {
            return .Up
        } else if currentOffsetY < previousOffsetY {
            return .Down
        } else {
            return .None
        }
    }
    
    public weak var delegate: MediumScrollFullScreenDelegate?
    public var upThresholdY: CGFloat = 0.0
    public var downThresholdY: CGFloat = 0.0
    public var forwardTarget: UIScrollViewDelegate?

    private var previousScrollDirection: Direction = .None
    private var previousOffsetY: CGFloat = 0.0
    private var accumulatedY: CGFloat = 0.0

    override public init() {
        super.init()
    }
    
    convenience public init(forwardTarget: UIScrollViewDelegate) {
        self.init()
        self.forwardTarget = forwardTarget
    }
}

extension MediumScrollFullScreen: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        forwardTarget?.scrollViewDidScroll!(scrollView)

        let currentOffsetY = scrollView.contentOffset.y
        let currentScrollDirection = detectScrollDirection(currentOffsetY, previousOffsetY: previousOffsetY)

        let topBoundary = -scrollView.contentInset.top
        let bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom

        let isOverTopBoundary = currentOffsetY <= topBoundary
        let isOverBottomBoundary = currentOffsetY >= bottomBoundary
        
        let isBouncing = (isOverTopBoundary && currentScrollDirection != .Down) || (isOverBottomBoundary && currentScrollDirection != .Up)
        
        if isBouncing || !scrollView.dragging {
            return
        }
        
        let deltaY = previousOffsetY - currentOffsetY
        accumulatedY += deltaY
        
        switch currentScrollDirection {
            case .Up:
                let isOverThreshold = accumulatedY < -upThresholdY
                if isOverThreshold || isOverBottomBoundary {
                    if currentOffsetY <= 0 {
                        delegate?.scrollFullScreen(self, scrollViewDidScrollUp: deltaY, userInteractionEnabled: true)
                    } else {
                        delegate?.scrollFullScreen(self, scrollViewDidScrollUp: deltaY, userInteractionEnabled: false)
                    }
                }
            case .Down:
                let isOverThreshold = accumulatedY > downThresholdY
                if isOverThreshold || isOverTopBoundary {
                    if currentOffsetY <= 0 {
                        delegate?.scrollFullScreen(self, scrollViewDidScrollDown: deltaY, userInteractionEnabled: true)
                    } else {
                        delegate?.scrollFullScreen(self, scrollViewDidScrollDown: deltaY, userInteractionEnabled: false)
                    }
                }
            case .None: break
        }
        
        if !isOverTopBoundary && !isOverBottomBoundary && previousScrollDirection != currentScrollDirection {
            accumulatedY = 0
        }
        
        previousScrollDirection = currentScrollDirection
        previousOffsetY = currentOffsetY
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        forwardTarget?.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)

        let currentOffsetY = scrollView.contentOffset.y
        let topBoundary = -scrollView.contentInset.top
        let bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        switch previousScrollDirection {
            case .Up:
                let isOverThreshold = accumulatedY < -upThresholdY
                let isOverBottomBoundary = currentOffsetY >= bottomBoundary
                if isOverBottomBoundary || isOverThreshold {
                    if currentOffsetY < 0 {
                        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollUp(self, userInteractionEnabled: true)
                    } else {
                        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollUp(self, userInteractionEnabled: false)
                    }
                }
            case .Down:
                let isOverThreshold = accumulatedY > downThresholdY
                let isOverTopBoundary = currentOffsetY <= topBoundary
                if isOverThreshold || isOverTopBoundary {
                    if currentOffsetY < 0 {
                        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown(self, userInteractionEnabled: true)
                    } else {
                        delegate?.scrollFullScreenScrollViewDidEndDraggingScrollDown(self, userInteractionEnabled: false)
                    }
                }
            case .None: break
        }
    }
}

public extension UIViewController {
    // MARK: NavigationBar
    public func showNavigationBar() {
        let statusBarHeight = getStatusBarHeight()
        
        let appKeyWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView = appKeyWindow.rootViewController!.view
        let viewControllerFrame = appBaseView.convertRect(appBaseView.bounds, toView: appKeyWindow)
        
        let overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y
        
        setNavigationBarOriginY(overwrapStatusBarHeight)
    }
    
    public func hideNavigationBar() {
        let navigationBarHeight = navigationController!.navigationBar.frame.size.height
        setNavigationBarOriginY(-navigationBarHeight)
    }
    
    public func moveNavigationBar(deltaY deltaY: CGFloat) {
        let frame = navigationController!.navigationBar.frame
        let nextY = frame.origin.y + deltaY
        setNavigationBarOriginY(nextY)
    }
    
    public func setNavigationBarOriginY(y: CGFloat) {
        let statusBarHeight = getStatusBarHeight()
        
        let appKeyWindow = UIApplication.sharedApplication().keyWindow!
        let appBaseView = appKeyWindow.rootViewController!.view
        let viewControllerFrame = appBaseView.convertRect(appBaseView.bounds, toView: appKeyWindow)
        
        let overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y
        
        var frame = navigationController!.navigationBar.frame
        let navigationBarHeight = frame.size.height
        
        let topLimit = -navigationBarHeight
        let bottomLimit = overwrapStatusBarHeight
        
        frame.origin.y = min(max(y, topLimit), bottomLimit)
        
        let navBarHiddenRatio = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0
        let alpha = max(1.0 - navBarHiddenRatio, 0.000001)
        
        UIView.animateWithDuration(0.3, animations: {[unowned self]() -> () in
            self.navigationController!.navigationBar.frame = frame
            var index = 0
            for v in self.navigationController!.navigationBar.subviews {
                let navView = v 
                index++
                if index == 1 || navView.hidden == true || navView.alpha <= 0.0 {
                    continue
                }
                navView.alpha = alpha
            }
        })
    }
    
    private func getStatusBarHeight() -> CGFloat {
        let statusBarFrameSize = UIApplication.sharedApplication().statusBarFrame.size
        return statusBarFrameSize.height
    }
    
    // MARK:ToolBar
    
    public func showToolbar() {
        if navigationController?.toolbarHidden == true {
            navigationController?.setToolbarHidden(false, animated: true)
        }
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        let toolbarHeight = navigationController!.toolbar.frame.size.height
        setToolbarOriginY(y: viewHeight - toolbarHeight)
    }
    
    public func hideToolbar() {
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        setToolbarOriginY(y: viewHeight)
    }
    
    public func moveToolbar(deltaY deltaY: CGFloat) {
        let frame = navigationController!.toolbar.frame
        let nextY = frame.origin.y + deltaY
        setToolbarOriginY(y: nextY)
    }
    
    public func setToolbarOriginY(y y: CGFloat) {
        var frame = navigationController!.toolbar.frame
        let toolBarHeight = frame.size.height
        let viewSize = navigationController!.view.frame.size
        let viewHeight = bottomBarViewControlleViewHeightFromViewSize(viewSize)
        
        let topLimit = viewHeight - toolBarHeight
        let bottomLimit = viewHeight
        
        frame.origin.y = fmin(fmax(y, topLimit), bottomLimit)
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
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
    }
}

public extension UIToolbar {
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
    }
}
