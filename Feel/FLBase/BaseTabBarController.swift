//
//  PNBaseTabBarController.swift
//  Feel
//
//  Created by pinn on 2018/11/19.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    
    //MARK:- private var
    fileprivate var titleArr: [String] = []
    fileprivate var imageArr: [String] = []
    fileprivate var imageSelArr: [String] = [];
    fileprivate var clsNameArr: [String] = [];
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        initChildViewControllers()
    }
    
    //MARK:- private func
    
    ///初始化加子控制器
    fileprivate func initChildViewControllers(){
        
        var clsArr: [BaseNavigationController] = []
        for (idx, clsName) in clsNameArr.enumerated() {

            let vcls = NSClassFromString(clsName) as! BaseViewController.Type
            let vc = vcls.init()
            let nav = BaseNavigationController(rootViewController: vc)
            clsArr.append(nav)
            vc.title = titleArr[idx]
            nav.tabBarItem.title = titleArr[idx]
            nav.tabBarItem.image = UIImage.init(named: imageArr[idx])?.withRenderingMode(.alwaysOriginal)
            nav.tabBarItem.selectedImage = UIImage.init(named: imageSelArr[idx])?.withRenderingMode(.alwaysOriginal)
        }
        viewControllers = clsArr
   
    }
    
    fileprivate func prepareData(){
        
        clsNameArr = [NSStringFromClass(PNHomeViewController.classForCoder()),
                      NSStringFromClass(PNPersonalViewController.classForCoder()),
                      NSStringFromClass(PNSwiftViewController.classForCoder())
                     ]
        
        titleArr = ["Home", "Swift", "Personal"]
        
        imageArr = [
                    "tab_bar_discover",
//                    "tab_bar_add",
//                    "tab_bar_msg",
                     "tab_bar_pro",
                     "tab_bar_my",
                ]
        
        imageSelArr = [
                       "tab_bar_discover_selected",
//                       "tab_bar_add_selected",
//                       "tab_bar_msg_selected",
                        "tab_bar_pro_selected",
                        "tab_bar_my_selected",
                    ]
        
    }


}
