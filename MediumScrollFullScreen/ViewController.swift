//
//  ViewController.swift
//  MediumScrollFullScreen
//
//  Created by pixyzehn on 2/16/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MediumScrollFullScreenDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var scrollProxy: MediumScrollFullScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollProxy = MediumScrollFullScreen(forwardTarget: webView)
        scrollProxy?.downThresholdY = Float.infinity
        webView.scrollView.delegate = scrollProxy
        scrollProxy?.delegate = self as MediumScrollFullScreenDelegate
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://medium.com/@pixyzehn/mediummenu-for-ios-5ff001f04ab5")!))
        
        let screenTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        screenTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(screenTap)
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        showNavigationBar(true)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MediumMenuInFullScreenDelegate
    
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollUp deltaY: Float) {
        moveNavigationBar(deltaY, animated: true)
    }
    
    func scrollFullScreen(fullScreenProxy: MediumScrollFullScreen, scrollViewDidScrollDown deltaY: Float) {
        moveNavigationBar(deltaY, animated: true)
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumScrollFullScreen) {
        hideNavigationBar(true)
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumScrollFullScreen) {
        showNavigationBar(true)
    }
    
}
