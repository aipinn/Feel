//
//  PNMsgHandlerController.swift
//  Feel
//
//  Created by emoji on 2019/1/22.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

enum PNWKType: String{
    case location = "Location"
    case scan = "ScanAction"
    case pay = "Pay"
    case back = "GoBack"
    case playSound = "PlaySound"
    case share = "Share"
    case shake = "Shake"
    case color = "Color"
}

protocol EnumerableEnum {
    static var allValues: [Self] {get}
}

extension PNWKType: EnumerableEnum {
    static var allValues: [PNWKType] {
        return [.location, .scan, .pay, .back, .playSound, .share, .shake, .color]
    }
}

class PNMsgHandlerController: BaseViewController {
    var observation: NSKeyValueObservation?
    private var wkWebView: WKWebView?
    private var progressView: UIProgressView?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKScriptMessageHandler"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printing("+++++")
        for type in PNWKType.allValues {
            // addScriptMessageHandler 很容易导致循环引用
            // 控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration， configuration copy （强引用了）userContentController
            // userContentController 强引用了 self （控制器）
            //1. 直接添加, 侧滑取消重复添加会导致崩溃
            wkWebView?.configuration.userContentController.add(self, name: type.rawValue)
            
            //2. 使用此方法可以不移除messageHandler, 但是仍然可以在deinit中移除messageHandler
            // 可以直接在viewDidLoad中添加
            //wkWebView?.configuration.userContentController.add(LeakAvoider(delegate: self), name: type.rawValue)

        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printing("-----")
        //这里要记得移除handlers
        for type in PNWKType.allValues {
            wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: type.rawValue)
        }
    }

    
    deinit {
        printing("")
        
    }
}

extension PNMsgHandlerController {
    override func setupUI() {
        do {
            // 加载本地HTML
            let fileUrl = Bundle.main.url(forResource: "index1", withExtension: "html")
            guard let url = fileUrl else {
                return
            }
            let request = URLRequest(url: url)

            let config = WKWebViewConfiguration()
            let pref = WKPreferences()
            pref.javaScriptCanOpenWindowsAutomatically = true
            pref.javaScriptEnabled = true
            pref.minimumFontSize = 40
            config.preferences = pref

            wkWebView = WKWebView(frame: kScreenBounds, configuration: config)
            wkWebView?.load(request)
            wkWebView?.uiDelegate = self
            view.addSubview(wkWebView!)
        }

        do {
            // 加载进度
            progressView = UIProgressView(frame: CGRect(x: 0, y: kTopBarHeight, width: kScreenWidth, height: 5))
            progressView?.backgroundColor = .blue
            view.addSubview(progressView!)
            observation = wkWebView?.observe(\WKWebView.estimatedProgress, options: [.old, .new], changeHandler: {[unowned self] _, new in
                guard let newV = new.newValue else {
                    return
                }
                self.progressView?.setProgress(Float(newV), animated: true)
                if newV == 1 {
                    self.progressView?.setProgress(1.0, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        self.progressView?.setProgress(Float(newV), animated: true)
                        self.progressView?.isHidden = true
                    })
                }

            })
        }
    }
}

extension PNMsgHandlerController: WKUIDelegate {
    // Provisional临时
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        //completionHandler() 必须调用
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { action in
            completionHandler()
        }))
        present(alert, animated: true)
    }
}

extension PNMsgHandlerController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let type = PNWKType(rawValue: message.name) else {
            return
        }
        switch type {
        case .location:
            getLocation()
        case .color:
            changeColor(message.body)
        case .share:
            share(message.body)
        case .pay:
            pay(message.body)
        case .shake:
            ShakeAction()
        case .back:
            goBack()
        case .playSound:
            playSound(message.body)
        case .scan:
            scanAction()
        }
    }
    
}

extension PNMsgHandlerController {
    func getLocation() {
        //获取位置信息
        
        //将结果返回给JS
        let locationStr  = "北京石景山万商大厦"
        let js = "setLocation('\(locationStr)')"
        wkWebView?.evaluateJavaScript(js, completionHandler: { (result, error) in
            guard let _ = error else {
                return
            }
            if let ret = result {
                print(ret)
            }
        })
    }
    
    func ShakeAction() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func changeColor(_ params: Any) {
        guard let arr: [CGFloat] = params as? [CGFloat],
            arr.count == 4 else {
            return
        }
        let color = UIColor.init(red: (arr[0]/255.0),
                                 green: (arr[1]/255.0),
                                 blue: (arr[2]/255.0),
                                 alpha: arr[3])
   
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
        
    }
    
    func share(_ params: Any) {
        guard let dict: [String: String] = params as? [String : String] else {
            return
        }
        guard let title = dict["title"], let content = dict["content"], let url = dict["url"] else {
            return
        }
        let string = "title:\(title),content:\(content),url:\(url)"
        //分享
        
        //分享回调
        wkWebView?.evaluateJavaScript("shareResult('\(string)')",
            completionHandler: { (result, error) in
            
        })
        
    }
    
    func pay(_ params: Any) {
        guard let dict: [String: Any] = params as? [String : Any] else {
            return
        }
        guard let order_no = dict["order_no"],
            let amount = dict["amount"],
            let subject = dict["subject"],
            let channel = dict["channel"] else {
            return
        }
        let string = "order_no:\(order_no)\\namount:\(amount)\\nsubject:\(subject)\\nchannel:\(channel)"
        
        //支付操作
        
        //支付回调
        wkWebView?.evaluateJavaScript("payResult('支付成功\(string)')", completionHandler: { (result, error) in
        })
    }
    
    func goBack() {
        wkWebView?.goBack()
    }
    
    func scanAction() {
        print("scan...")
    }
    
    func playSound(_ params: Any) {
        print("playing music...")
    }
    
}

//MARK: - 一个好方法
class LeakAvoider : NSObject {
    weak var delegate : WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
}

extension LeakAvoider: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        delegate?.userContentController(
            userContentController, didReceive: message)
    }
}
