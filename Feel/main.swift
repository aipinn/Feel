//
//  main.swift
//  Feel
//
//  Created by emoji on 2018/12/18.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

//自己实现main函数
// 注释AppDelegate中@UIApplicationMain,程序就找不到入口的main函数,可以添加实现此文件.
// 对于第三个参数nil表示使用默认的UIApplication,可以替换成继承UIApplication的自定义子类
//UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv,nil,
//NSStringFromClass(AppDelegate.self))

// 自定义UIApplication
class PNApplication: UIApplication {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        print("Event sent: \(event)")
    }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv,NSStringFromClass(PNApplication.self),
                  NSStringFromClass(AppDelegate.self))
