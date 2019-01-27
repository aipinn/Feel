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
        webView.evaluateJavaScript("var arr = [3, 4, 'abc']") { (result, error) in
            if error != nil {
                print(result!)
            }
        }
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
