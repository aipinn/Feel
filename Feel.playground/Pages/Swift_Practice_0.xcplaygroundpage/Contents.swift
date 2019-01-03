//: [Previous](@previous)

import Foundation

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
 */


