//
//  PNBaseTabBarController.swift
//  Feel
//
//  Created by pinn on 2018/11/19.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initChildViewControllers()
    }
    
    fileprivate func initChildViewControllers(){
        let one = PNBaseViewController()
        let navOne = PNBaseNavigationController(rootViewController: one)
        one.title = "One"
        navOne.tabBarItem.title = "One"
        
        let two = PNBaseViewController()
        let navTwo = PNBaseNavigationController(rootViewController: two)
        two.title = "Two"
        navTwo.tabBarItem.title = "Two"
        
        let three = PNBaseViewController()
        let navThree = PNBaseNavigationController(rootViewController: three)
        three.title = "Three"
        navThree.tabBarItem.title = "Three"
        
        viewControllers = [navOne, navTwo, navThree]
        

        
    }


}
