//
//  PNWebNativeController.swift
//  Feel
//
//  Created by emoji on 2019/1/21.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class PNWebNativeController: PNWebBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fileName1 = "First"
        fileName2 = "Second"
        
        do {
            let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(js))
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    deinit {
        printing("")
    }
    //直接执行JS
    @objc func js() {
        let context: JSContext = webView?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let textJS = "showAlert('这里是JS中alert弹出的message')"
        context.evaluateScript(textJS)
    }

}

//MARK: - WKWebView-Delegate
/*
 WKWebView支持侧滑返回手势(allowsBackForwardNavigationGestures),加载进度(estimatedProgress)
 */

extension PNWebNativeController {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.location.href") { (href, e) in

        }
        
        webView.evaluateJavaScript("document.title") { (title, error) in
            
        }
        
    }
    
}

//MARK: - UIWebViewDelegate
extension PNWebNativeController {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let _ = webView.stringByEvaluatingJavaScript(from: "document.location.href")
        
        let _ = webView.stringByEvaluatingJavaScript(from: "document.title")
        
       jsInject()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let url = request.url
        guard let urlstr = url else {
            return false
        }
        //通过协议进行交互
        if let scheme = urlstr.scheme, scheme == "firstclick",
            let arr = urlstr.query?.components(separatedBy: "&") {
            for  param in arr {
                print(param.removingPercentEncoding ?? "")
            }
            view.makeToast("自定义协议调用)")
        }
        
        return true
    }
    
}
//MARK: - JS注入,只有UIWebView支持
extension PNWebNativeController {
    func jsInject() {
    
        let context: JSContext = webView?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let block : @convention(block) ()->() = {
            let arr = JSContext.currentArguments()
            guard let args = arr else {
                return
            }
            for value in args {
                print(value)
            }
        }

        context.setObject(block, forKeyedSubscript: "share" as NSCopying & NSObjectProtocol)
    }
}
