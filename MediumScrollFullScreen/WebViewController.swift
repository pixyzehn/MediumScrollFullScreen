//
//  ViewController.swift
//  MediumScrollFullScreen
//
//  Created by pixyzehn on 2/16/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, MediumScrollFullScreenDelegate, UIGestureRecognizerDelegate {
    
    enum State {
        case Showing
        case Hiding
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    var statement: State = .Hiding
    var scrollProxy: MediumScrollFullScreen?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideToolbar(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollProxy = MediumScrollFullScreen(forwardTarget: webView)
        scrollProxy?.downThresholdY = Float.infinity
        webView.scrollView.delegate = scrollProxy
        scrollProxy?.delegate = self as MediumScrollFullScreenDelegate
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://nshipster.com/swift-collection-protocols/")!))
        
        let screenTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        screenTap.numberOfTapsRequired = 1
        screenTap.delegate = self
        webView.addGestureRecognizer(screenTap)
        
        self.title = "Title"
        navigationItem.hidesBackButton = true
        
        var backButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: UIBarButtonItemStyle.Plain, target: self, action: "popView")
        backButton.tintColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        navigationItem.leftBarButtonItem = backButton
        
        var rightButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        rightButton.frame = CGRectMake(0, 0, 60, 60)
        rightButton.addTarget(self, action: "changeIcon:", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.setImage(UIImage(named: "star_n"), forState: UIControlState.Normal)
        rightButton.setImage(UIImage(named: "star_s"), forState: UIControlState.Selected)
        let barItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    func changeIcon(sender: UIButton) {
        var btn = sender
        if btn.selected == true {
            btn.selected = false
        } else {
            btn.selected = true
        }
    }
    
    func popView() {
        navigationController?.popViewControllerAnimated(true)
    }

    func tapGesture(sender: UITapGestureRecognizer) {
        if statement == .Hiding {
            if navigationController?.toolbarHidden == true {
                UIView.animateWithDuration(0.3, animations: {[unowned self]() -> () in
                    self.navigationController!.toolbarHidden = false
                })
            }
            showNavigationBar(true)
            showToolbar(true)
            statement = .Showing
        } else {
            hideNavigationBar(true)
            hideToolbar(true)
            statement = .Hiding
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MediumMenuInFullScreenDelegate
    
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollUp deltaY: Float) {
        moveNavigationBar(deltaY: deltaY, animated: true)
        moveToolbar(deltaY: -deltaY, animated: true)
    }

    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollDown deltaY: Float) {
        moveNavigationBar(deltaY: deltaY, animated: true)
    }

    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumScrollFullScreen) {
        hideNavigationBar(true)
        hideToolbar(true)
        statement = .Hiding
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumScrollFullScreen) {
        showNavigationBar(true)
        showToolbar(true)
        statement = .Showing
    }
    
}
