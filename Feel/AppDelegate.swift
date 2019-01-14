//
//  AppDelegate.swift
//  Feel
//
//  Created by pinn on 2018/11/19.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit
import HelloKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let root = BaseTabBarController()
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        
        //自己制作的框架
        /*
         dyld: Library not loaded: @rpath/HelloKit.framework/HelloKit
         Referenced from: /Users/penn/Library/Developer/CoreSimulator/Devices/4D49FCD0-CA52-422C-AC32-8F7359BD40F2/data/Containers/Bundle/Application/597DDFFD-42E2-4A2F-94D3-F82691CE4229/Feel.app/Feel
         Reason: image not found
         
         */
        Hello.sayHello()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

