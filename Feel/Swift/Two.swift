//
//  Two.swift
//  Feel
//
//  Created by emoji on 2019/1/9.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation

//class OneClass {
//    var name: String?
//    private var age: UInt?
//    private(set) var addr: String?
//
//    func method() {
//        name = "pinn"
//        age = 12
//        addr = "Beijing"
//    }
//}

class TwoClass {
    func method() {
        let one = OneClass()
        one.name = "pinn"//默认internals修饰
        print(one.name!)
        //age私有都无法访问
        //print(one.age)
        //one.age = 12;
        
        //addr的set私有
        //one.addr = "Beijing"
        print(one.addr!)
        
    }
}
