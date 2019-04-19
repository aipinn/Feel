//
//  One.swift
//  Feel
//
//  Created by emoji on 2019/1/9.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation
import UIKit

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

class Foo {
    private let privateBtn = UIButton()
    fileprivate let fileprivateBtn = UIButton()
}

class Baz {
    func baz() {
        print(Foo().fileprivateBtn)
//                print(Foo().privateBtn)
    }
}

extension Foo {
    func fooExtension() {
        print(privateBtn)
        print(Foo().fileprivateBtn)
    }
}

class Tool: Foo {
    func subFoo() {
        print(fileprivateBtn)
        //        print(privateBtn)
    }
}
