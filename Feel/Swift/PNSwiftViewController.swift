//
//  PNSwiftViewController.swift
//  Feel
//
//  Created by emoji on 2018/12/3.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNSwiftViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let btn = UIButton(frame: CGRect(x: 0, y: kTopBarHeight, width: 100, height: 50))
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.text = "Appliction"
        view.addSubview(btn)
        
        
    }
    
}




