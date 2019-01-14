//
//  String+PNAdd.swift
//  Feel
//
//  Created by emoji on 2019/1/10.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getViewController() -> UIViewController? {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            printing("Not get namesapce")
            return nil
        }
        let vcName = "\(namespace).\(self)"
        guard let type = NSClassFromString(vcName) as? UIViewController.Type else {
            printing("Not get class type")
            return nil
        }
        return type.init()
    }
}
