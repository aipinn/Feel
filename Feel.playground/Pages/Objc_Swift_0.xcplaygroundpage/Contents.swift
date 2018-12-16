//: [Previous](@previous)

import Foundation

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
    @objc func callYou() {

    }
    @objc func callYou(_ para: String) {

    }
    let someMethodNoPara = #selector(callYou as ()->())
    let someMethodWithPara = #selector(callYou as (String)->())
}
