import UIKit

var str = "Hello, protocol and extension"

protocol ExampleProtocol {
    var simpleDesc: String { get }
    mutating func adjust()
}

// 类, 枚举, 结构体 都兼容协议.
// 协议
//1. 类
class SimpleClass: ExampleProtocol {
    var simpleDesc: String = "A very simple class confirm protocol"
    var anotherProperty: Int = 95081
    func adjust() {
        simpleDesc += " Now 100% adjusted."
    }
    
}

var exa = SimpleClass()
exa.adjust()
let aDesc = exa.simpleDesc

//2. 结构体
struct SimpleStruct: ExampleProtocol {
    var simpleDesc: String = "A simple struct that confirm protocol."
    mutating func adjust() {
        simpleDesc += " Now 100% adjusted."
    }
}

var ss = SimpleStruct()
ss.adjust()
let ssDesc = ss.simpleDesc

/*
 注意使用 mutating关键字来声明在 SimpleStructure中使方法可以修改结构体。在 SimpleClass中则不需要这样声明，因为类里的方法总是可以修改其自身属性的。
 */

// 扩展
extension Int: ExampleProtocol {
    var simpleDesc: String {
        return "The number \(self)"
    }
    
    mutating func adjust() {
        self += 2
    }
    
}
print(7.simpleDesc)


var protocolValue: ExampleProtocol = exa
print(protocolValue.simpleDesc)
protocolValue.adjust()
// 尽管变量protocolValue有SimpleaClass的运行时类型, 但编译器还是把它看做ExampleProtocol. 这意味着我们不能访问在类在这个协议中扩展的属性和方法
//print(protocolValue.anotherProperty)


