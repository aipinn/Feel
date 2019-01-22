//
//  PNOCViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/21.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class PNOCViewController: BaseViewController {

    private var wkWebView: WKWebView?
    private var webView: UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()


    }

}

extension PNOCViewController {
    override func setupUI() {
        do {
            let str = Bundle.main.path(forResource: "Second", ofType: "html")
            //str = "https://baidu.com"
            guard let filePath = str, let url = URL(string: filePath) else {
                return
            }
            let request = URLRequest(url: url)
            wkWebView = WKWebView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: kScreenHeight/2 - 20))
            wkWebView?.backgroundColor = .gray
            wkWebView?.load(request)
            wkWebView?.navigationDelegate = self
            wkWebView?.uiDelegate = self
            view.addSubview(wkWebView!)
        }
        
        do {
            let str = Bundle.main.path(forResource: "First", ofType: "html")
            guard let filePath = str, let url = URL(string: filePath) else {
                return
            }
            let request = URLRequest(url: url)
            webView = UIWebView(frame: CGRect(x: 0, y: kScreenHeight/2 + 20, width: kScreenWidth, height: kScreenHeight/2 - 20))
            webView?.backgroundColor = .cyan
            webView?.loadRequest(request)
            webView?.delegate = self
            view.addSubview(webView!)
        }
    }
}

//MARK: - WKWebView-Delegate
extension PNOCViewController: WKUIDelegate {
    //Provisional临时
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.location.href") { (href, e) in
            
        }
        
        webView.evaluateJavaScript("document.title") { (title, error) in
            
        }
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
}
extension PNOCViewController: WKNavigationDelegate {
    
}

//MARK: - UIWebViewDelegate
extension PNOCViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let _ = webView.stringByEvaluatingJavaScript(from: "document.location.href")
        
        let _ = webView.stringByEvaluatingJavaScript(from: "document.title")
        
        //let id = webView.stringByEvaluatingJavaScript(from: "document.getElementsByName('')")
        
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let url = request.url
        guard let urlstr = url else {
            return false
        }

        if let scheme = urlstr.scheme, scheme == "firstclick",
            let arr = urlstr.query?.components(separatedBy: "&") {
            for  param in arr {
                print(param.removingPercentEncoding ?? "")
            }
        }
        view.makeToast("自定义协议调用")
        
        return true
    }
    
}

extension PNOCViewController: UINavigationControllerDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
}
