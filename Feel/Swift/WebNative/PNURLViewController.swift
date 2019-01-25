//
//  PNURLViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/23.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class PNURLViewController: PNWebBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fileName1 = "index3"
        fileName2 = "index3"
        
    }
    deinit {
        printing("")
    }
}

extension PNURLViewController {
//    override func setupUI() {
//
//        do {
//            let str = Bundle.main.path(forResource: "index3", ofType: "html")
//            guard let filePath = str, let url = URL(string: filePath) else {
//                return
//            }
//            let request = URLRequest(url: url)
//            webView = UIWebView(frame: CGRect(x: 0, y: kScreenHeight/2 + 20, width: kScreenWidth, height: kScreenHeight/2 - 20))
//            webView?.backgroundColor = .cyan
//            webView?.loadRequest(request)
//            webView?.delegate = self
//            view.addSubview(webView!)
//        }
//        do {
//            //加载本地HTML
//            let fileUrl = Bundle.main.url(forResource: "index3", withExtension: "html")
//            guard let url = fileUrl else {
//                return
//            }
//            let request = URLRequest(url: url)
//
//            let configuration = WKWebViewConfiguration()
//            configuration.userContentController = WKUserContentController()
//            let preferences = WKPreferences()
//            preferences.javaScriptCanOpenWindowsAutomatically = true
//            preferences.minimumFontSize = 30.0
//            configuration.preferences = preferences
//
//            wkWebView = WKWebView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: kScreenHeight/2 - 20), configuration: configuration)
//            wkWebView?.backgroundColor = .gray
//            wkWebView?.load(request)
//            wkWebView?.uiDelegate = self
//            wkWebView?.navigationDelegate = self
//            view.addSubview(wkWebView!)
//
//
//        }
//    }
    
    
    func handleAction(_ url: URL) {
        guard let host = url.host else { return }
        switch host {
        case "scanClick":
            scan()
        case "shareClick":
            share(url)
        case "shake":
            shake()
        default:
            break
        }
    }
    
    func share(_ url: URL) {
        //分享
        
        //回调
        webView?.stringByEvaluatingJavaScript(from: "shareResult('来自swift分享成功回调')")
    }
    
    func scan() {
        
    }
    
    func shake() {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}

extension PNURLViewController {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "var arr = [3, 4, 'abc']")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if let url = request.url, let scheme = url.scheme, scheme == "haleyaction" {
            handleAction(url)
            return false
        }
        return true
    }
}

extension PNURLViewController {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    //实现此方法必须调用decisionHandler()这个闭包,否则崩溃;
    //参数WKNavigationActionPolicy是一个枚举类型,包括cancel和allow两种类型.
    //相当于UIWebView中返回Bool值的方法
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
        if let url = navigationAction.request.url, let scheme = url.scheme, scheme == "haleyaction" {
            handleAction(url)
        }
    }
    
    //如果在WKWebView中使用alert、confirm 等弹窗,需要实现WKWebView的WKUIDelegate中相应的代理方法.
    //实现此方法必须调用completionHandler(),具体的调用位置在哪里在此不重要.
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
       
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { action in
            completionHandler()//必须调用
        }))
        present(alert, animated: true)
    }

}
