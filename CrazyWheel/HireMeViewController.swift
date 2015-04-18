//
//  HireMeViewController.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 18/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class HireMeViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        let url = NSURL(string: "http://medium.com/@fr00tloops/3ed995913b73")!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        indicator.hidden = true
        webView.hidden = false
    }
}
