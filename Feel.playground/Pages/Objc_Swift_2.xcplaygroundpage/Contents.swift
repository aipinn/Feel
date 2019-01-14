//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

//: [Next](@next)

/*:
 ## 判等
 
 swift没有isEqualToString:或者isEqual:的判等的方法.swift使用==操作符来进行.
 OC中的==是判断两个变量的内存地址是否相等.而我们常常判断的是内容是否相等,所以就会让子类重写NSObject的`isEqual:`方法,比如`isEqualToString:` `isEqualToClass:`
 
 swift中情况大不一样,swift里的==是一个操作符的声明,在Equatable里声明了这个操作符的协议方法:
 
 ```
 protocol Equatable {
    func ==(lhs: Self, rhs: Self) -> Bool
 }
 ```
 实现这个协议的类型需要定义适合自己类型的==操作符.实现了Equatable的类型就可以使用==和!=(我们只需要自己实现==,!=的话标准库会自动去反).
 */

let str1 = "name"
let str2 = "name"
str1 == str2 //true

class TodoItem {
    let uuid: String
    var title: String
    init(uuid: String, title: String) {
        self.uuid = uuid
        self.title = title
    }
}

extension TodoItem: Equatable {

}

func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
    return lhs.uuid == rhs.uuid
}

/*:
 对于`==`的实现我们并没有像其他协议一样将其放在对应的extension里,而是放在了全局的scope中.这是合理的做法,因为你应该在全局范围内都能使用`==`. 实际上,swift的操作符都是全局的.
 
 Swift的基本类型都重载了对应的`==`,而对于NSObject的子类来说,如果我们使用`==`并且没有对应这个子类的重载的话,将会调用这个类的
 `isEqual:`的方法. 如果这个NSObject子类原来就实现了`isEqual:`的话,直接使用`==`并不会造成他和swift类型的行为差异;但是如果无法找到合适的重写的话,这个方法将会回滚到最初的NSObject里的实现,对其引用的地址进行比较.因此对于NSObject子类的判等你有两种选择:
 
 * 要么重载`==`
 * 要么重写`-isEqual:`
 
 如果只是在swift中使用类的话,两种等效;如果还需要在OC中使用的话,因为OC不支持操作符重载,只能使用`-isEqual:`
 对于原来在OC中的`==`在swift中使用`===`;在swift中`===`只有一种重载:
 `func ===(lhs: AnyObject?, rhs: AnyObject?) -> Bool`
 用来判断两个Anyobject是否是同一个t引用.
 等于判等,与之紧密相连的就是哈希
 */

/*:
 ## 哈希Hash
 
 哈希表即散列,是一种基础的数据结构. 对于判等,我们需要为判等结果为相同的对象提供相同的hash值,以保证在被
 作为字典的key时的准确性和性能.
 
 swift中对于NSObject的子类对象在使用==时要是该子类没有实现这个操作符重载的话将回滚到`-isEqual:`方法.对于哈希计算,swift也采用类似的策略.swift提供了一个Hashable的协议.
 ```
 protocol Hashable: Equatable {
    var hashValue: Int { get }
    ...
 }
 ```
 在重写哈希方法时所采用的策略与判等的时候是类似的:
 * 对于非NSObject的类,我们需要遵守Hashable并根据`==`操作符的内容提供哈希算法;
 * 而对于NSObject子类,需要根据是否需要在OC中访问选择合适的方式,去实现Hashable的hashValue或者直接重写NSObject的`-hash`方法.
 */

class Hash {
    
}
let hash = Hash()
let dict = ["key":"value"]
//var dict = [dict: "value", hash: "value"]

/*:
 ## 类簇
 
 类簇是Cocoal框架中广泛使用的设计模式之一.简单来说类簇就是使用一个统一的公共的类来定制单一的接口,然后
 在表面之下对应若干个私有类进行实现的方式.eg:NSNumber.
 
 在Objective-C中,init开头的初始化方法虽然打着初始化的名号,但是实际上做的事情k和其他方法并没有太多的不同之处.类簇在OC中实现起来也很自然,在所谓的"初始化方法"中将self进行替换,根据调用的方式或者输入的类型返回合适的私有子类对象就可以了.
 
 但是在swift中的情况有所不同.因为swift有真正的初始化方法,在初始化的时候只能得到当前类的实例,并且要完成
 所有的配置.也就是说对于一个公共类来说,是不肯能在初始化方法中d返回子类的信息的.对于swift中的类簇构建,可以使用工厂方法进行.eg:下面的代码通过Drinking的工厂方法将可乐和啤酒两个私有类进行了类簇化.

 */
class Drinking {
    typealias LiquidColor = UIColor
    var color: LiquidColor {
        return .clear
    }
    class func drinking(name: String) -> Drinking {
        var drinking: Drinking
        switch name {
        case "Coke":
            drinking = Coke()
        case "Beer":
            drinking = Beer()
        default:
            drinking = Drinking()
        }
        return drinking;
    }

}

class Coke: Drinking {
    override var color: Drinking.LiquidColor {
        return .black
    }
}
class Beer: Drinking {
    override var color: Drinking.LiquidColor {
        return .yellow
    }
}

let coke = Drinking.drinking(name: "Coke")
coke.color
let beer = Drinking.drinking(name: "Beer")
beer.color
let cokeClass = NSStringFromClass(type(of: coke))
let beerClass = NSStringFromClass(type(of: beer))

/*:
 ## 调用C动态库
 压缩libz.dylib, xml解析一般链接libxml.dylib就会方便一些.
 
 OC中可以无缝访问C的内容,只需要指定依赖导入头文件就可以了.但是swift想甩开C的包袱,所以现在swift中直接使用c代码或者c的库是不可能的. 例如计算MD5值不能直接#import<CommonCrypto/CommonCrypto.h>这样的代码,这些动态库暂时也没有module化,因此快捷方式只能通过桥接文件实现:
 //Target-Name-Bridging-Header.h
 #import<CommonCrypto/CommonCrypto.h>
 
 //StringMD5.swift
 extension: String {
    ...
 }
 
 */

/*:
 ## 输出格式化
 
 Swift中,print是支持字符串插值的,而字符串插值时将直接使用类型的Streamable,printable或者DebugPrintable协议(按照先后顺序,前面的没实现就是用后面的)中的方法返回的字符串并打印.
 */
//: 插值
let a = 3
let b = 3.14956
let c = "Hello"
print("int:\(a) double:\(b) string:\(c)")
//: 格式化
let format = String(format: "%.2f", b)
print(format)
//: 上面比较麻烦,可以为Double写一个扩展
extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
let f = ".2"
print("double\(b.format(f))")


/*:
 ## Options
 
 Options不是Optional, 对应OC中的NS_OPTIONS
 OC中通过typedef把各个选项映射为每一位都不同的一组NSUInteger,如果什么都不选的话可以使用kNilOptions,表示0
 
 在Swift中NS_ENUM对应enum.NS_OPTIONS并没有枚举那么重要,所以没有原生类型来进行定义,Swift中Option值现在被映射为了满足OptionsSetType协议的struct类型,以及一组静态的get属性:
 ```
 public struct AnimationOptions : OptionSet 大括号
 
 public init(rawValue: UInt)
 
 
 public static var layoutSubviews: UIView.AnimationOptions { get }
 
 public static var allowUserInteraction: UIView.AnimationOptions { get }
 
 ...
 public static var transitionFlipFromBottom: UIView.AnimationOptions { get }
 
 大括号
 
 ```
 
 */

UIView.animate(withDuration: 0.5,
               delay: 0.0,
               options: [.curveEaseIn, .allowUserInteraction],
               animations: {},
               completion: nil)

//: 对于kNilOptionals可以使用空集合[]来表示.
//: 自定义一个Options,可以实现一个snippet快速重用
struct MyOption: OptionSet {
    let rawValue: UInt
    static let none = MyOption(rawValue: 0)
    static let option1 = MyOption(rawValue: 1)
    static let option2 = MyOption(rawValue: 1<<1)
    //.....
}

/*:
 ## 数组enumerate
 
 可以获取数组的元素和对应的下标:
 
 * 转化为NSArray
 */

let arr: NSArray = [1,2,3,4,5]
var result = 0
arr.enumerateObjects { (num, idx, stop) in
    result += num as! Int
    if idx == 2 {
        stop.pointee = true
    }
}
print(result)//6

//: * 对与Swift我们有一个更好的更安全更高效的替代,那就是快速枚举某个数组的EnumrateGenerator

var ret = 0
for (idx, num) in [1,2,3,4,5].enumerated() {
    ret += num
    if idx == 2 {
        break
    }
}
print(ret)//6

/*:
 ## 类型编码@encode

 Objective-C中有一些很冷僻,但是如果知道的话在特定情况下很有用的关键字,比如说通过类型获取对应编码的@encode就是其中之一.
 
 OC中使用很简单,通过传入一个类型就可以获取代表这个类型的编码C字符串
 ```
 char *char1 = @encode(int32_t)
 char *char2 = @encode(NSArray)
 ```
 这个关键字最常用的地方是在Objective-C运行时的消息发送机制中,在传递参数时由于类型缺失,需要类型编码进行辅助
 以保证类型信息也能被传递.
 ........暂时不写了......
 */

let p = NSValue(cgPoint: CGPoint(x: 3, y: 3))
String(validatingUTF8: p.objCType)
//"{CGPoint=dd}"
let t = NSValue(cgAffineTransform: .identity)
String(validatingUTF8: t.objCType)
//"{CGAffineTransform=dddddd}"

/*:
 ## C代码调用和@asmname
 
 @asmname可以通过方法名字将某个C函数直接映射为Swift中的函数
 
 ```
 //test.h
 int test(int a);
 
 //test.c
 int test(int a) {
    return a + 1;
 }
 
 //Module-Bridging-Header.h
 #import "test.h"
 
 //file.swift
 func testSwift:(input: Int32) 大括号
    let result = test(input)
    print(result)
 大括号
 testSwift(1)
 //输出:2
 
 ```
 
 通过@asmnamem我们就要不用借助桥接文件了,对于上面的栗子🌰
 ```
 @asmname("test") func c_test(a: Int32) -> Int32
 
 func testSwift() 大括号
    let result = c_test(input)
    print(result)
 大括号
 testSiwft(1)
 ```
 如果导入的第三方C方法与系统的标准库重名导致调用发生冲突时,可以用来为其中之一的函数重命名解决问题;当然也可以使用Module名字+方法名字的方式来解决.
 另外,...
 */

/*:
 ## delegate
 
 * 在swift中实现OC的写法是无法编译通过的,因为swift中的协议是可以被除了class以外的其他类型遵守的,而对于像
 struct或者enum这样的类型,本身就不通过u引用计数来管理内存,所以也不可能使用weak这样的ARC的概念来进行修饰.
 
 * 想要在swift中使用weak delegate.我们就需要将Protocol限制在class内.一种做法就是将protocol声明为Objective-C的,这样就可以在protocol前面加上@objc关键字来达到,Objective-C的protocol都只有类能实现,因此使用weak来修饰就合理了.
 
 */
@objc protocol MyClassDelegate {
    func method()
}
 /*:
 * 另一种可能更好的办法是在protocol声明的名字后面加上class,这样可以为编译器显式地指明这个协议只能由class来实现.
 */
protocol MyClassDelegateNew: class {
    func method()
}

