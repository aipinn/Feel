import UIKit

var str = "Hello, Protocol"

// 协议
// 属性要求: 标明读写属性,

protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedTobeSettable: Int { get }
    //var noMarkAccessIsError: Int
}

protocol OneProtocol {
    static var someTypeProperty: Int { get set }
    var oneProperty: String { set get }
    var oneOptionalProperty: String? { set get }

}
// 遵守协议
class OneClass: OneProtocol {
    static var someTypeProperty: Int = 100
    var oneOptionalProperty: String?
    var oneProperty: String = "one"
}
class SubOneClass: OneClass {
    
}

//方法要求
// 协议的定义中，方法参数不能定义默认值。
//
protocol MethodsProtocol {
    static func someTypeMethod()
    func random() -> Double
}

class RandomClass: MethodsProtocol {
    static func someTypeMethod() {
        
    }
    
    func random() -> Double {
        return 0.0
    }
    
    
}

class SubRandom: RandomClass {
    // static标记的协议方法不可以在遵守协议的类子类中重写
    override func random() -> Double {
        return 1.0
    }
}
