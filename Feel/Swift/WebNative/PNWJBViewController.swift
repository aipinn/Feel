//
//  PNWJBViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/25.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebViewJavascriptBridge
/*
 
 */
class PNWJBViewController: PNWebBaseViewController {

    private var webViewBrige: WebViewJavascriptBridge?
    override func viewDidLoad() {
        super.viewDidLoad()
        fileName1 = "index4"
        fileName2 = "index4"

        setupBridge()
        registerFunction()
    }
    
    func setupBridge() {
        //webViewBrige = WebViewJavascriptBridge.init(wkWebView)
        webViewBrige = WebViewJavascriptBridge.init(webView)
        webViewBrige?.setWebViewDelegate(self)
    }
    

}
/*
 //无参数,不需要回调
 webViewBrige?.callHandler("")
 //需要参数,不需要回调
 webViewBrige?.callHandler("", data: "")
 //需要参数,需要回调
 webViewBrige?.callHandler("", data: "", responseCallback: { (data) in
 
 })
 //没有参数,回调传参
 webViewBrige?.registerHandler("", handler: { (data, callBack) in
 
 })
 */
extension PNWJBViewController {
    func registerFunction() {
        registerScan()
        registerLocation()
    }
    
    func registerScan() {

        webViewBrige?.registerHandler("scanClick", handler: { (data, callBack) in
            if let call = callBack {
                call("http://www.baidu.com")
            }
        })
    }
    
    func registerLocation() {

        webViewBrige?.registerHandler("locationClick", handler: { (data, callBack) in
            if let call = callBack {
                call("北京市石景山区...")
            }
        })
    }
}
