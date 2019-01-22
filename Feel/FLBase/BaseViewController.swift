//
//  PNBaseViewController.swift
//  Feel
//
//  Created by pinn on 2018/11/19.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rand = CGFloat(arc4random() % 10+5)
        view.backgroundColor = UIColor(white: CGFloat(rand/10.0), alpha: 1)
        setupUI()
        
    }

}

@objc extension BaseViewController {
    public func setupUI() {
        
    }
}
