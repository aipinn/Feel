//
//  PNWebBaseViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/25.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit

class PNWebBaseViewController: BaseViewController {

    var wkWebView: WKWebView?
    var webView: UIWebView?
    var fileName1: String? {
        didSet {
 
            let fileUrl = Bundle.main.url(forResource: fileName1, withExtension: "html")
            guard let url = fileUrl else {
                return
            }
            view.addSubview(wkWebView!)
            let request = URLRequest(url: url)
            wkWebView?.load(request)
        }
    }
    var fileName2: String? {
        didSet {
            let str = Bundle.main.path(forResource: fileName2, ofType: "html")
            guard let filePath = str, let url = URL(string: filePath) else {
                return
            }
            view.addSubview(webView!)
            let request = URLRequest(url: url)
            webView?.loadRequest(request)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension PNWebBaseViewController {
    override func setupUI() {
        AddWebView()
        
    }
    
    func AddWebView() {
        do {
            
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = WKUserContentController()
            let preferences = WKPreferences()
            preferences.javaScriptCanOpenWindowsAutomatically = true
            preferences.minimumFontSize = 30.0
            configuration.preferences = preferences
            
            wkWebView = WKWebView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: kScreenHeight/2 - 20), configuration: configuration)
            wkWebView?.uiDelegate = self
            wkWebView?.navigationDelegate = self
            
        }
        
        do {
            
            webView = UIWebView(frame: CGRect(x: 0, y: kScreenHeight/2 + 20, width: kScreenWidth, height: kScreenHeight/2 - 20))
            webView?.backgroundColor = .cyan
            webView?.delegate = self
            
        }
    }
}

extension PNWebBaseViewController: UIWebViewDelegate {
    
}

extension PNWebBaseViewController: WKUIDelegate {
    
}

extension PNWebBaseViewController: WKNavigationDelegate {
    
}
