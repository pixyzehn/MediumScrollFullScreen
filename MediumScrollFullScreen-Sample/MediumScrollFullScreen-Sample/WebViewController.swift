//
//  ViewController.swift
//  MediumScrollFullScreen-Sample
//
//  Created by pixyzehn on 2/24/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    enum State {
        case Showing
        case Hiding
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    var statement: State = .Hiding
    var scrollProxy: MediumScrollFullScreen?
    var scrollView: UIScrollView?
    var enableTap = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollProxy = MediumScrollFullScreen(forwardTarget: webView)
        webView.scrollView.delegate = scrollProxy
        scrollProxy?.delegate = self as MediumScrollFullScreenDelegate
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://nshipster.com/swift-collection-protocols/")!))
        
        let screenTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        screenTap.delegate = self
        webView.addGestureRecognizer(screenTap)
        
        // Add temporary item
        
        navigationItem.hidesBackButton = true
        
        let menuColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .Plain, target: self, action: "popView")
        backButton.tintColor = menuColor
        navigationItem.leftBarButtonItem = backButton
        
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 60, 60)
        rightButton.addTarget(self, action: "changeIcon:", forControlEvents: .TouchUpInside)
        rightButton.setImage(UIImage(named: "star_n"), forState: .Normal)
        rightButton.setImage(UIImage(named: "star_s"), forState: .Selected)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        let favButton = UIButton(type: .Custom)
        favButton.frame = CGRectMake(0, 0, 60, 60)
        favButton.addTarget(self, action: "changeIcon:", forControlEvents: .TouchUpInside)
        favButton.setImage(UIImage(named: "fav_n"), forState: .Normal)
        favButton.setImage(UIImage(named: "fav_s"), forState: .Selected)
        let toolItem: UIBarButtonItem = UIBarButtonItem(customView: favButton)
        
        let timeLabel = UILabel(frame: CGRectMake(0, 0, 100, 20))
        timeLabel.text = "?? min left"
        timeLabel.textAlignment = .Center
        timeLabel.tintColor = menuColor
        let timeButton = UIBarButtonItem(customView: timeLabel as UIView)
        
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: nil, action: nil)
        actionButton.tintColor = menuColor
        
        let gap = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 20
        toolbarItems = [toolItem, gap, timeButton, gap, actionButton, fixedSpace]
    }
    
    func changeIcon(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    func popView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        if !enableTap {
            return
        }

        if statement == .Hiding {
            statement = .Showing
            showNavigationBar()
            showToolbar()
        } else {
            statement = .Hiding
            hideNavigationBar()
            hideToolbar()
        }
    }
}

extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension WebViewController: MediumScrollFullScreenDelegate {
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollUp deltaY: CGFloat, userInteractionEnabled enabled: Bool) {
        enableTap = enabled ? false : true
        moveNavigationBar(deltaY: deltaY)
        moveToolbar(deltaY: -deltaY)
    }
    
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollDown deltaY: CGFloat, userInteractionEnabled enabled: Bool) {
        enableTap = enabled ? false : true
        if enabled {
            moveNavigationBar(deltaY: deltaY)
            hideToolbar()
        } else {
            moveNavigationBar(deltaY: -deltaY)
            moveToolbar(deltaY: deltaY)
        }
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled: Bool) {
        statement = .Hiding
        hideNavigationBar()
        hideToolbar()
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumScrollFullScreen, userInteractionEnabled enabled: Bool) {
        if enabled {
            statement = .Showing
            showNavigationBar()
            hideToolbar()
        } else {
            statement = .Hiding
            hideNavigationBar()
            hideToolbar()
        }
    }
}
