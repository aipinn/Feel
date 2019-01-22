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
    


}

extension PNWebViewController {
    override func setupUI() {
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight, width: 100, height: 50))
            button.setTitle("One", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button1Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+60, width: 100, height: 50))
            button.setTitle("Two", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button2Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
        
        do {
            let button = UIButton(frame: CGRect(x: 0, y: kTopBarHeight+120, width: 100, height: 50))
            button.setTitle("Three", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(button3Selected), for: .touchUpInside)
            button.backgroundColor = .blue
            view.addSubview(button)
        }
    }
}

extension PNWebViewController {
    @objc func button1Selected() {
        let vc = PNOCViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func button2Selected() {
        
    }
    
    @objc func button3Selected() {
        
    }
}


