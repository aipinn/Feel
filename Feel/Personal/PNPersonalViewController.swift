//
//  PNPersonalViewController.swift
//  Feel
//
//  Created by emoji on 2018/11/20.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNPersonalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = PNHomeViewController()
        home.viewControllers = [UIViewController]()
        home.viewControllers?.append(UIViewController())
        home.viewControllers?.append(UIViewController())
    }
    


}
