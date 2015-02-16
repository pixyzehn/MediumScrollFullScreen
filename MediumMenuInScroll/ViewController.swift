//
//  ViewController.swift
//  MediumMenuInScroll
//
//  Created by pixyzehn on 2/13/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MediumMenuInScrollDelegate {

    @IBOutlet weak var webView: UIWebView!

    var scrollProxy: MediumMenuInFullScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollProxy = MediumMenuInFullScreen(forwardTarget: webView)
        webView.scrollView.delegate = scrollProxy
        scrollProxy?.delegate = self as MediumMenuInScrollDelegate
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.apple.com/macbook-pro/")!))
    }
    
    // MediumMenuInFullScreenDelegate
    
    func scrollFullScreen(fullScreenProxy: MediumMenuInFullScreen, scrollViewDidScrollUp deltaY: Float) {
        moveNavigationBar(deltaY, animated: true)
    }
    
    func scrollFullScreen(fullScreenProxy: MediumMenuInFullScreen, scrollViewDidScrollDown deltaY: Float) {
        moveNavigationBar(deltaY, animated: true)
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: MediumMenuInFullScreen) {
        hideNavigationBar(true)
    }
    
    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: MediumMenuInFullScreen) {
        showNavigationBar(true)
    }

}

