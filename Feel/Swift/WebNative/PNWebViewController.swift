//
//  PNWebViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/21.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit


class PNWebViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
    }
    
    deinit {
        printing("")
    }


}

extension PNWebViewController {
    override func setupUI() {
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight, width: 200, height: 50))
            button.setTitle("Summary", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button1Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+60, width: 300, height: 50))
            button.setTitle("MessageHandler", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button2Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+120, width: 300, height: 50))
            button.setTitle("JavaScriptCore", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button3Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+180, width: 300, height: 50))
            button.setTitle("URL", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button4Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+240, width: 300, height: 50))
            button.setTitle("WebViewJavascriptBridge", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button5Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+300, width: 300, height: 50))
            button.setTitle("Cordova", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button6Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
    }
}

extension PNWebViewController {
    @objc func button1Selected() {
        let vc = PNWebNativeController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func button2Selected() {
        let vc = PNMsgHandlerController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func button3Selected() {
        let vc = PNJSCViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func button4Selected() {
        let vc = PNURLViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func button5Selected() {
        let vc = PNWJBViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func button6Selected() {
        let vc = PNURLViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


