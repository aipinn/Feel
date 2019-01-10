//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

//: [Next](@next)

/*:
 ## Swift 命令行工具
 
 在终端中输入`xcrun swift`来启动REPL环境, 要指出的是,REPL环境只是表现的像是即使的解释执行,但是其实质还是每次输入代码后进行编译再运行.这就限制了我们不可能在REPL中做太复杂的事情.
 另一种做法是直接将一个`.swift`文件作为命令行工具的输入.
 ```
 #!/usr/bin/env swift
 print("hello")
 
 //Terminal
 > chmod 755 hello.swift
 > ./hello.swift
 
 ```
 相对于直接使用swift命令执行,swift命令行工具的另一个常用的地方是直接脱离Xcode环境进行编译和生成可执行的二进制文件,命令`swiftc`
 
 ```
 //Terminal
 //生成一个可执行的文件main
 > swiftc MyClass.swift main.swift
 
 //运行
 > .main
 
 ```
 利用这个方法,我们就可以用Swift写出一些命令行程序了.
 
 最后, swift命令行工具使用案例是生成汇编级别的代码.
 ```
 swift -O hello.swift -o hello.asm
 
 //更更多命令查看帮助
 swift --help
 swiftc --help
 ```
 */

/*:
 ## 随机数生成
 */

//arc4random返回值不管在什么平台都是一个UInt32,于是在32位平台就有一半几率在进行Int转换时越界,产生崩溃
let diceFaceCount = 6
let randmRoll = Int(arc4random()) % diceFaceCount + 1

//func arc4random_uniform(_: UInt32) -> UInt32
//这个方法接收一个UInt32的数字n作为输入,将结果归一化到0到n-1之间.只要我们输入的不超过Int的范围,就可以避免危险的转换:
let dice: UInt32 = 6
let random = Int(arc4random_uniform(dice)) + 1

//:最佳实践

func random(in range: Range<Int>) -> Int {
    let count = UInt32(range.endIndex - range.startIndex)
    return Int(arc4random_uniform(count)) + range.startIndex
}

for _ in 0...10 {
    let range = Range<Int>(5...12)
    print(random(in: range))
}

/*:
 ## print和debugPrint
 
 * print与CustomStringConvertible
 */
class Mars {
    var num: Int
    init() {
        num = 1
    }
}
let mars = Mars()
print(mars)

struct Universe {
    var date: NSDate
    var place: String
}

let universe = Universe(date: NSDate(timeIntervalSinceNow: 10), place: "earth")
print(universe)//输出更详细


extension Universe: CustomStringConvertible {
    var description: String {
        return "于\(self.date)在\(self.place)大战"
    }
}
print(universe)

//: * debugPrint与CustomDebugStringConvertible
//和CustomDebugStringConvertible类似, 在调试时po输出
extension Universe: CustomDebugStringConvertible {
    var debugDescription: String {
        return "po 在此 \(self.date)...."
    }
}

/*:
 ## 错误和异常处理
 
 错误指不可预期产生的问题,用户在使用过程中操作产生,比如因为磁盘空间不足导致文件写入错误.用户登录密码错误等
 异常指程序在开发过程中
 */

//: Error, OC 通过NSError实例指针保存错误. Swift中添加了异常捕捉

let data = NSData()
do {
    try data.write(toFile: "file", options: [])
} catch let error as NSError {
    print("Error: \(error)")
}
//: 上面的write方法必须添加try才能编译通过,这样就可以时刻提醒我们不能对可能产生的错误置之不理. 将error转化为NSError.这其实主要是针对Cocoa现有的API的,是对历史的妥协.
//: 对于新写的可以抛出异常的API.我们应当抛出一个实现了Err协议的类型,enum就非常合适:
enum LoginError: Error {
    case UserNotFound, UserPasswordNotMatch
}
let users = [String: String]() //[用户名:密码]
func login(user: String, pwd: String) throws {
    if !users.keys.contains(user) {
        throw LoginError.UserNotFound
    }
    if users[user] != pwd {
        throw LoginError.UserPasswordNotMatch
    }
    print("Login successfully.")
}

//: 这样的ErrorType可以非常明确的指出问题所在.在调用时,catch语句实质上是在进行模式匹配:

do {
    try login(user: "aipinn", pwd: "123")
} catch LoginError.UserNotFound {
    print("User Not Found.")
} catch LoginError.UserPasswordNotMatch {
    print("User pwd not match.")
}



/*:
 * swift现在的机制也不是完美的,最大的问题是类型安全,不借助文档的话,我们现在无法从代码中直接得出抛出的异常的类型,比如上面的login方法,只看方法定义我们并不知道LoginError会被抛出,一个理想的API因该是这样的:
 ```
 func login(user: String, pwd: String) throws LoginError
 
 ```
 * 另一个限制是对于非同步的API来说,抛出异常是不可用的,异常只是一个同步方法专用的处理机制.Cocoa框架对于异步API出错时,保留了原来的Error机制,比如很常见的`URLSessiond`中的`dataTask` API:
 
 ```
 open func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
 ```
 
 * 对于异步的API,虽然不能使用异常机制,但是这类API一般涉及到y网络和耗时操作,我们平时不会直接使用,而会进行封装. 一种现在比较常用的方式就是借助enum. enum可以与其他实例类型进行绑定,可以让方返回枚举类型,然后在枚举中定义成功或错误的状态.
 */

enum Result {
    case Success(String)
    case Error(NSError)
}

func doSomethingParam(param: AnyObject) -> Result {
    //...做一些操作,成功结果放在success 中
    let success: Bool = false//模拟错误
    if success {
        return Result.Success("success")
    } else {
        let error = NSError(domain: "errorDomain", code: 1, userInfo: nil)
        return Result.Error(error)
    }
}

//: 使用时,利用switch的let来从枚举中取出即可:
/*:
 
 ```
 let path = ""
 let ret = doSomethingParam(param: path as AnyObject)
 switch ret {
 case let .Success(ok):
 let serverResponse = ok
 case let .Error(error):
 let serverResponse = error.description
 }
 ```
 */
//: enum中可以指定泛型,这样就使结果统一化了
enum ResultNew<T> {
    case Success(T)
    case Failure(NSError)
}

func doSomethingParam(param: AnyObject) -> ResultNew<Any> {
    
    let success = false
    let arr = [Int]()// 通过泛型枚举,可以使用同样的ResultNewd代表不同的返回结果
    if success {
        return ResultNew.Success(arr)
    } else {
        let error = NSError(domain: "errorDomain", code: 1, userInfo: nil)
        return ResultNew.Failure(error)
    }
}

//: 因此,在swift2以后中的错误处理,现在一般的最佳实践是对同步API使用异常机制,对于异步API使用泛型枚举.


/*:
 try! 强制执行,这代表确定知道这次调用不会抛出异常,如果出现异常就会崩溃,和optional类似.try?会返回一个Optional值,如果成功,它会包含这条语句的返回值,否则将为nil.
 一个典型的try?的应用场景是和if let这样的语句搭配使用,如果你只用了try?的话,意味着你无视了错误的具体类型.
 >需要注意的是我们不应该返回一个Optional的值,两者结合将会产生双重Optional的值非常y容易产生错误,应该避免.
 */
enum E: Error {
    case Negative
}

func methodThrowsWhenPassingNegative(number: Int) throws -> Int {
    if number < 0 {
        throw E.Negative
    }
    return number
}

if let num = try? methodThrowsWhenPassingNegative(number: 100) {
    print(type(of: num))
} else {
    print("failed")
}

//: 另外还有一个`rethrows`,一般用在参数中含有可以throws的方法的高阶函数中,来表示它可以接受一个普通的函数,也可以接受一个能throw的函数作为参数.

func methodThrows(num: Int) throws {
    if num < 0 {
        throw E.Negative
    }
}

func methodRethrows(num: Int, f: (Int) throws -> ()) rethrows {
    try f(num)
}

do {
    try methodRethrows(num: 1, f: methodThrows)
} catch _ {
    
}

//: 其实这种情况将rethrows改为throws也可以运行,rethrows可以看看做是throws的"子类", rethrows方法可以用来重载哪些被标记为throws的方法和参数,或者用来满足被标记为throws的协议,但是反过来不行.

/*:
 ## 断言
 用来检测输入参数是否满足一定条件,并对其进行"论断".
 断言的另一个优点是他只是一个开发时的特性,只有在Debug编译的时候有效,在运行时是不被执行的,因此不会消耗运行时的性能.发布代码时也不用可以移除.
 但是有时候我们可能希望在调试时也让断言不执行: target -> Build Setting中,Swift Compiler - Custom Flags中的Other Swift Flags中添加`-assert-config Debug` 来强制启用断言,或者`-assert-config Release`来强制禁用断言...OC中NSAssert被彻底移除.
 */
let absoluteZeroCelsius = -273.15
func convertToKelvin(_ celsius: Double) -> Double {
    assert(celsius > absoluteZeroCelsius, "输入的摄氏温度不能低于绝对零度")
    return celsius - absoluteZeroCelsius
}

let roomTemp = convertToKelvin(20)

//let tooCold = convertToKelvin(-300)


/*:
 ## fatalError(致命错误)
 
 ```
 public func fatalError(_ message: @autoclosure () -> String = default,
                             file: StaticString = #file,
                             line: UInt = #line) -> Never
 ```
 >返回类型是Never,表示调用这个方法的话可以不再需要返回值,因为整个程序都会终止.
 
 * 比如在Switch中,我们希望将被switch的值锁定在某个范围内:
 */



enum MyEnum {
    case Value1, Value2, Value3
}

func check(someValue: MyEnum) -> String {
    switch someValue {
    case .Value1:
        return "OK"
    case .Value2:
        return "Maybe ok"
//    case .Value3:
//        return "Maybe ok ok"
    default:
        fatalError("should not show")
    }
}

check(someValue: .Value2)

// *

class ClassA {
    func methodMustBeImplementedInSubClass() {
        fatalError("这个方法必须在子类中被重写")
    }
}

class ClassMy: ClassA {
    override func methodMustBeImplementedInSubClass() {
        print("ClassMy 实现了该方法")
    }
}

class ClassTheir:ClassA {
    func someOtherMethod() {
        
    }
}

ClassMy().methodMustBeImplementedInSubClass()
//ClassMy 实现了该方法
//ClassTheir().methodMustBeImplementedInSubClass()
//Fatal error: 这个方法必须在子类中被重写

//: Swift2开始提出了面向协议编程的概念.在协议中的方法,遵守协议的类型必须实现这个方法(如果协议扩展没有提供默认实现),提供了编译时的保证,而不需要推迟到运行的时候.

/*:
 ## 代码组织和Framework
 
 Apple为了iOS平台的安全性考虑,是不允许动态链接非系统框架的. 因此在app开发中我们所使用的第三方框架如果是以库文件的范式提供的话, 一定都是需要链接并打包进最后的二进制可执行文件中的静态库.最初级和原始的静态库是以`.a`的二进制文件并加上一些`.h`的头文件进行定义的形式提供的,这样的静态库在使用的时候比较麻烦,我们除了将其添加到项目和配置链接外,还需要指明头文件e位置等工作. 这样造成的结果不仅是添加起来麻烦,而且因为头文件路径可能在不同的环境中存在不一样的情况,而造成项目无法编译.
 
 而Apple自己的框架都是以`.framework`为后缀的动态框架,我们在使用的时候,只需要在target配置时进行实名就可以,非常方便.
 因为framework的易用性，因此很多开发者都很喜欢类似的“即拖即用，无需配置”的体验。一些框架和库的开发者为了使用体验一般会用一些第三方提供的方法来模拟地生成行为类似的框架，比如Dropbox或者Facebook的iOS SDK都是基于这种技术完成的。
 > 但是,要特别指出,虽然和Apple的框架的后缀名一样是`.framework`,使用方式也类似,但是这些第三方是是实实在在的静态库,每个app需要在编译的时候进行独立的链接.
 
 从Xcode6开始,Apple官方提供了单独制作的类似的framework的方法,这种便利性可能使代码的组织方式发生重大变化.我们现在可以添加新的类型为CocoaTouchFramework的target,并在同一个项目中通过import这个target的module名字(一般和这个target的名字一样的,除非使用了向杠`-`这样在module中非法字符)来引入并进行使用.
 
 * 1. 新创建一个Cocoa Touch Framework项目,eg:HelloKit,然后添加一个Swift文件,写一些内容,eg:
 ```
     public class Hello {
         public class func sayHello() {
         print("Hello Kit")
         }
     }
 ```
 * 2. 分别使用模拟器和真机进行Profiling编译. 命令: `cmd+shift+i`
 * 3. 在项目生成的数据文件夹中可以找到`Hello.framework`,eg:
    `Build/Products/Release-iphonesimulator/Hello.framework`
 ```
     emoji:Products penn$ pwd
     /Users/penn/Library/Developer/Xcode/DerivedData/HelloKit-edtvjjflaagiqhfdxynofibzvlsc/Build/Products
     emoji:Products penn$ ls
     Debug-iphoneos        HelloKit        Release-iphonesimulator
     Debug-iphonesimulator    Release-iphoneos
     emoji:Products penn$
 ```
 * 4. 将`Hello.framework`拖到新的Xcode项目中,勾选Copy items if needed.
 * 5. 和使用其他框架略有不同,最后一步还需要在编译的时候将这个框架复制到项目包中.在Build Phases选项里添加一个Copy File的阶段,然后将目标设置为Frameworks,将HelloKit.framework添加进来,以指定IDE在编译的时候进行复制.
 * 6. 现在可以使用,模拟器下编译,运行eg:
 
 ```
 import UIKit
 import HelloKit
 
 //@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 
 var window: UIWindow?
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 // Override point for customization after application launch.

     真机下运行报错:
     dyld: Library not loaded: @rpath/HelloKit.framework/HelloKit
     Referenced from: /Users/penn/Library/Developer/CoreSimulator/Devices/4D49FCD0-CA52-422C-AC32-8F7359BD40F2/data/Containers/Bundle/Application/597DDFFD-42E2-4A2F-94D3-F82691CE4229/Feel.app/Feel
     Reason: image not found

     Hello.sayHello()
 
     return true
 }
 ```
 * 7. 刚才的只是模拟器版本,换成真机发生上述注释中的错误.接下来需要制作真机版本并进行合并.
 
 ```
 emoji:~ penn$ cd /Users/penn/Library/Developer/Xcode/DerivedData/HelloKit-edtvjjflaagiqhfdxynofibzvlsc/Build/Products
 emoji:Products penn$ lipo -create -output HelloKit \
 > Release-iphoneos/HelloKit.framework/HelloKit \
 > Release-iphonesimulator/HelloKit.framework/HelloKit
 emoji:Products penn$ lipo -create -output HelloKit Release-iphoneos/HelloKit.framework/HelloKit Release-iphonesimulator/HelloKit.framework/HelloKit
 ```
 * 8. 用新生成的Hellokit可执行文件替换目录
 `/Build/Products/Release-iphoneos/HelloKit.framework/`下的HelloKit文件.
 并复制`/Build/Products/Release-iphoneos/HelloKit.framework/Modules/HelloKit.swiftmodule`下的arm64.swiftmodule和arm.module文件到`/Build/Products/Release-iphonesimulator/HelloKit.framework/Modules/HelloKit.swiftmodule`,此时`HelloKit.swiftmodule`下应该包含4个swiftmodule文件:`arm.swiftmodule` `arm64.swiftmodule` `i386.swiftmodule` `x86_64.swiftmodule`.
 * 9. 至此,`Release-iphonesimulator`下的`HelloKit.framework`就是通用的HelloKit框架,替换掉我们要使用的项目中的HelloKit就可以正常使用了.
 
 */


/*:
 ## 安全的资源组织方式
 
 以前我们使用字符串生成图片,但是当图片名字发生改变时需要全部替换,为代码维护增加了压力.
 虽然可以通过全局替换来解决,但仍不是理想的办法.
 OC中可以使用宏来定义,可以更加方便,但是仍然没有改变本质.
 
 swift中可以使用rawValue为String的enum类型生成字符串, 然后通过为资源类型提那家合适的extension来让编辑器帮助我们在代码中做相应的更改.
 */

//:eg:
let image = UIImage(named: "some_image")

enum ImageName: String {
    case someImage = "some_image"
}

extension UIImage {
    convenience init(imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
}

extension UIViewController {
    let image = UIImage(imageName: .someImage)
}


/*:
 更好的办法请参考:
 https://github.com/mac-cain13/R.swift
 https://github.com/SwiftGen/SwiftGen
 */
