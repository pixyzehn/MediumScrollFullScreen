//
//  ViewController.swift
//  MediumScrollFullScreen
//
//  Created by pixyzehn on 2/16/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MediumScrollFullScreenDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var scrollProxy: MediumScrollFullScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollProxy = MediumScrollFullScreen(forwardTarget: webView)
        webView.scrollView.delegate = scrollProxy
        scrollProxy?.delegate = self as MediumScrollFullScreenDelegate
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.apple.com/macbook-pro/")!))
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
