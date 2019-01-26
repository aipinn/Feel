//
//  PNJSCViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/22.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class PNJSCViewController: PNWebBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fileName2 = "index2"
    }

    deinit {
        
    }
}

extension PNJSCViewController {
    func addActions() {
        let context: JSContext = webView?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        context.evaluateScript("var arr = [3, 4, 'abc'];")
        addScan(context)
        addLocation(context)
        addShare(context)
        addSetColor(context)
        addGoback(context)
    }
    
    func addScan(_ context: JSContext) {
        //@convention(block)必须是"block" 其他不能编译
        let block : @convention(block) (NSString?) -> Void = {
            (string : NSString!) -> Void in
            print("scan....")
        }
        context.setObject(unsafeBitCast(block, to: AnyObject.self),
                          forKeyedSubscript: "scan" as NSCopying & NSObjectProtocol)
        
    }
    
    func addLocation(_ context: JSContext) {
        let block: @convention(block) () -> () = {
            //获取位置信息
            
            //将结果返回给JS
            JSContext.current()?.evaluateScript("setLocation('北京市石景山区')")
        }
        context.setObject(unsafeBitCast(block, to: AnyObject.self),
                          forKeyedSubscript: "getLocation" as NSCopying & NSObjectProtocol)
    }
    
    func addShare(_ context: JSContext) {
        let block: @convention(block) ()->() = {
            let arr = JSContext.currentArguments()
            guard let args = arr, args.count >= 3 else {
                return
            }
            let str = "\(args[0]),\(args[1]),\(args[2])"
            JSContext.current()?.evaluateScript("shareResult('\(str)')")
        }
        context.setObject(unsafeBitCast(block, to: AnyObject.self),
                          forKeyedSubscript: "share" as NSCopying & NSObjectProtocol)
    }
    
    func addSetColor(_ context: JSContext) {
        let block: @convention(block) ()->() = {
            DispatchQueue.main.async {
                //现在执行JS是在webThread的子线程,操作UI要回到主线程
            }
        }
        context.setObject(unsafeBitCast(block, to: AnyObject.self), forKeyedSubscript: "setColor" as NSCopying & NSObjectProtocol)
    }
    func addGoback(_ context: JSContext) {
        let block: @convention(block) ()->() = {
            DispatchQueue.main.async {
                
            }
        }
        context.setObject(unsafeBitCast(block, to: AnyObject.self), forKeyedSubscript: "goback" as NSCopying & NSObjectProtocol)
    }
    //..........dengdeng
    
}

extension PNJSCViewController {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        addActions()
    }
}

extension PNJSCViewController {
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //JS是在webThread的子线程
        //You cannot obtain the context, because layout and javascript is handled on another process.
        //Instead, add scripts to your webview configuration, and set your view controller (or another object) as the script message handler.
        //addActions()
    }
}

