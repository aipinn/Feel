//
//  Int+PNAdd.swift
//  Feel
//
//  Created by emoji on 2019/1/10.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation

extension Int {
    /// 闭包中代码执行若干次
    func times (f: () -> Void) {
        for _ in 1...self {
            f()
        }
    }
}

