//
//  One.swift
//  Feel
//
//  Created by emoji on 2019/1/9.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation
 
class OneClass {
    var name: String?
    private var age: UInt?
    private(set) var addr: String?
    
    func method() {
        name = "pinn"
        age = 12
        addr = "Beijing"
    }
}
