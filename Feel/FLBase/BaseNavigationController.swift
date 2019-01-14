//
//  PNBaseNavigationController.swift
//  Feel
//
//  Created by pinn on 2018/11/19.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            hidesBottomBarWhenPushed = true
        } else {
            hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }

}
