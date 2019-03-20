//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, Objective-Swift-0"

//: [Next](@next)

/*:
 ## seltctor
 * OC中@selector或者为了更加灵活使用NSSelectorFromString
 * swift使用#selector, SEL是一个结构体
 */

class OneClass{
    @objc func callMe() {
        
    }
    let someMethod = #selector(callMe)

}

/*:
 > 需要注意的是,selector其实是Objective-C runtime的概念, swift4中默认所有的swift方法在Objective-C中是
 不可见的,所以需要加上@objc关键字,将方法暴露给oc.
 另外,如果方法名字在域内是唯一的话,可以简单的使用方法的名字作为#selector的内容,可以省去参数冒号;
 如果多个函数名字参数不同可以进行强制转换在swift4.2行不通了
 */
class TwoClass{
    @objc func callYou() -> (Int) {
        return 10
    }
//    @objc func callYou(para: String) {
//
//    }
    let someMethodNoPara = #selector(callYou)
//    let someMethodWithPara = #selector(callYou(_:))
}

/*:
 ## 实例方法的动态调用
 
 */

class MyClass {
    func method(number: Int) -> Int {
        return number+1
    }
}

//:正常调用
let object = MyClass()
let result = object.method(number: 2)

//:动态调用
let f = MyClass.method
//: * f的类型 let f: (MyClass) -> (Int) -> Int
let obj = MyClass()
let ret = f(obj)(2)

//:其实对于Type.instanceMethod这样的取值语句,对于刚才let f的声明,做的事情类似于
let ff = {(obj: MyClass) in obj.method}

//: 这种情况只适用于实例方法,对于属性的access方法是不可以的. 另外如果遇到类型方法的名字冲突时:
class MyClassnew {
    func method(number: Int) -> Int {
        return number+1
    }
    class func method(number: Int) -> Int {
        return number
    }
}

//: 对于f1的类型为:(Int) -> Int, 取到的是类型方法
let f1 = MyClassnew.method
//: 如果想取实例方法的话,可以显示的加上类型声明加以区别.
//: * 和f1相同
let f2: (Int) -> Int = MyClassnew.method
//: * func method的柯里话版本
let f3: (MyClassnew) -> (Int) -> Int = MyClassnew.method

/*
 ## 单例
 */

//: swift改写OC通过dispatch_once方法实现单例

/* swift3移除了dispatch_once
class MyManager {
    class var sharedManger: MyManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var staticInstance: MyManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.staticInstance = MyManager()
        }
        return Static.staticInstance
    }
}
*/
//: 在swift中有一个更加简单的保持线程安全的方式,那就是let. 简化上面的单例:
class MyManager {
    class var shared: MyManager {
        struct Static {
            static let sharedInstance: MyManager = MyManager()
        }
        return Static.sharedInstance
    }
}

//:swift1.2之前
//在类中这行放上面:
//private let sharedInstance = MyManager_1()

class MyManager_1 {
    class var shared: MyManager_1 {
        return sharedInstance
    }
}
private let sharedInstance = MyManager_1()

//:swift1.2之后添加了类变var量的支持,因此单例可以进一步简化. 如果没有特别的需求,这是最佳实践:
class MyManager_best {
    static var shared = MyManager_best()
    private init(){}
}
//:> 这种写法简单,而且保证了单例的独一无二.在初始化变量的时候, apple会把这个初始化包装在一次swift_once_block_invoke中,
//:> 以保证它的唯一性.不仅如此,对于所有的全局变量,apple都会在底层使用这个类似dispatch_once的方式来确保只以lazy的方式初始化一次.
//: 另外, 我们在这个类型中加入了一个私有的初始化方法,来覆盖默认的公开的初始化方法,这让项目中的其他地方不能通过init来生成自己的MyManage_best实例,也保证f单例的唯一性.如果你需要的是类似default的形式的单例(也就是这个类的使用者可以创建自己的单例)的话,可以去掉私有的init方法
//: * 简单调用
MyManager_best.shared
//: * 下面初始化失败
//MyManager_best()
//MyManager_best.init()

/*:
 ## 条件编译
 C系语言中,可以使用#if或者#ifdef之类的编译条件.swift中没有宏额概念,但是其还是提供了几种简单的机制来根据需求来定制编译内容.
 首先呢#if这一套标记还是存在的.
 #if <condition>
 
 #elseif <condition>
 
 #else
 
 #endif
 但是这几个表达式里的条件不是任意的.swift内建了几种平台和架构的组合,来帮助我们为不同的平台编译不同的代码.
 方法: os()    可选参数:macOS, iOS, tvOS, watchOS, Linux
 方法: arch()  可选参数:x86_64, arm, arm64,i386
 方法: swift() 可选参数:>=某个版本
 > 这几个方法和参数是大小敏感的
 */

#if os(macOS)
    typealias Color = NSColor
#else
    typealias Color = UIColor
#endif

//: 虽然现在只能在上面列表中列出的平台上运行,但是os参数还包括"FreeBSD","Windows","Android"
//: arm, arm64对应32和64位的CPU. i386和x86_64对应32和64位的模拟器

//:对于自定义的符号进行条件编译.
//:例如对于某个按钮的收费版本和免费版本的方法
func someButtonPressed(sender: AnyObject!) {
    #if FREE_VERSION
    
    #else
    
    #endif
    
    #if false
    print("++++")
    #elseif true
    print("----")
    #else
    print("+-+-+")
    #endif
}
//:此处的FREE_VERSION需要进行设置:Build Setting -> Swift Compiler - Custom Flags并在其中的Other Swift Flags加上-D FREE_VERSION就可以了
let btn = UIButton()
someButtonPressed(sender: btn)

/*:
 ## 编译标记
 //MARK:
 //TODO:
 //FIXME:
 //暂时还没有#warning之类的东西
 */

/*:
 # @UIApplication
 
 1. 自己实现main函数
 注释AppDelegate中@UIApplicationMain,程序就找不到入口的main函数,可以添加实现main.swift文件.
 对于第三个参数nil表示使用默认的UIApplication,可以替换成继承UIApplication的自定义子类
 UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv,nil,
 NSStringFromClass(AppDelegate.self))
 
 2. 自定义UIApplication
 class PNApplication: UIApplication {
 override func sendEvent(_ event: UIEvent) {
 super.sendEvent(event)
 print("Event sent: \(event)")ß
 }
 }
 UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv,NSStringFromClass(PNApplication.self),
 NSStringFromClass(AppDelegate.self))
 */

/*:
 ## @objc和dynamic
 继承自NSObject的swift类不需要添加@objc就可以在OC中引用. 虽然使用了@objc也并不意味着这个方法或者属性会变成动态派发,swift依然可能将其优化为动态调用.如果需要和Objective-C里的动态调用时相同的运行时特性的话,需要使用dynamic.具体使用在KVO中介绍.
 */
//: 这样才能在OC中调用特殊名字的方法和类
@objc(MyChineseClass)
class 我的类: NSObject {
    @objc(greeting:)
    func 打招呼(名字: String) {
        print("你好\(名字)")
    }
}
我的类().打招呼(名字: "李四")

/*:
 ## 可选协议和协议扩展
 * 可选协议
 OC中的@optional决定可选实现协议,swift必须全部实现.
 使用@objc的协议只能被class实现,也就是说对于struct和enum是所实现的协议是无法包含可选方法的.
 另外,实现协议的class必须添加@objc或者继承自NSObject
 */

@objc protocol OptionalProtocol {
   @objc optional
    func optionalMethod()
    func requiredMethod()
//    func anotherOptionMethod()
}
extension OptionalProtocol {
    func anotherOptionMethod(){
        
    }

}
extension MyClass: OptionalProtocol {
    func requiredMethod() {

    }
}
class Object: NSObject, OptionalProtocol {
    func requiredMethod() {

    }
}

/*:
 * 协议扩展
 
    可以在协议扩展中实现可选协议的默认实现
*/
protocol MyProtocol {
    func optionalMethod()
    func requiredMethod()
    
}

extension MyProtocol {
    // 提供默认实现
    func optionalMethod() {

    }

}
class ObjectClass: MyProtocol {
    func requiredMethod() {

    }
    
}

protocol SubMyProtocol: MyProtocol {
    func newMethod()
}

class newObjectClass: SubMyProtocol {
    
    func requiredMethod() {
        
    }
    func newMethod() {

    }
}
