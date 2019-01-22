//
//  PNWebController.swift
//  Feel
//
//  Created by pinn on 2019/1/21.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit
import WebKit

class PNWebController: BaseViewController {

    private var webView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: kScreenBounds)
        view.addSubview(webView!)
        //加载本地文件
        do {
//            //1.Create Groups类型文件夹使用Bundle.main.url方式
//            let path = Bundle.main.url(forResource: "H1", withExtension: "html")
//            guard let url = path  else { return }
//            let request = URLRequest(url: url)
//            webView?.load(request)
        }
        do {
            //2.Create Folder References类型文件夹使用Bundle.main.bundlePath方式,文件路径大小写敏感
            let bundlePath = Bundle.main.bundlePath
            let filePath = "file://\(bundlePath)/html2/H2.html"
            guard let url = URL(string: filePath) else {
                return
            }
            let request = URLRequest(url: url)
            webView?.load(request)
        }
        

    }
    

}

