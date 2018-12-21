//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

/*:
 ## 内存管理, weak, unowned
 * 在swift中防止引用循环
 */

class RequestManager: RequestHandler {
    @objc func requestFinished() {
        print("request completed!")
    }
    func sendRequest() {
        let req = Request()
        req.delegate = self
        req.send()
    }
}

@objc protocol RequestHandler {
    @objc optional func requestFinished()
}

class Request {
    weak var delegate: RequestHandler!
    func send() {
        
    }
    func gotResponse() {
        delegate?.requestFinished?()
    }
}

/*:
 * 闭包和循环引用
 
 weak, unowned. unowned类似OC中的unsafe_unretained,当被unowned引用的对象被释放后,引用其的对象会持有一个无效的引用,它不是Optional也不是nil,而weak这种情况为nil.
 */

class Person {
    let name: String
    //造成循环引用
//    lazy var printName: ()->() = {
//        print("The name is \(self.name)")
//    }
    
    //解决循环引用
//    lazy var printName: ()->() = {
//        [weak self] in
//        if let strongself = self {
//            print("The name is \(strongself.name)")
//        }
//    }
    // 如果在整个过程中,self被释放而printName这个闭包没有被释放的话,使用unowned将造成崩溃.
    // 这时就不需要再添加strongself判断了
        lazy var printName: ()->() = {
            [unowned self] in
            print("The name is \(self.name)")
        }

    
    init(personName: String) {
        name = personName
    }
    deinit {
        print("Person deinit \(self.name)")
    }
}

var xiaoming: Person? = Person(personName: "XM")
xiaoming!.printName()
xiaoming = nil

//: 多个参数标记使用中括号将多个参数括起来,中间使用逗号括号隔开
//标注前:
//_ = {
//    (number: Int) -> Bool in
//    return true
//}
//标注后:
//_ = {
//    [unowned self, weak someobject] (number: Int) -> Bool in
//    return true
//}

/*:
 ## @autoreleasepool
 autorelease会将接收f该消息的对象放在一个预先建立的自动释放池中,并在自动释放池收到drain消息时将这些对象的引用计数减一,然后将他们从池子中移除.
 app中整个主线程其实就是跑在一个自动释放池中的,并在每个主Runloop结束时进行drain操作.这是一种必要的延时释放的方式,因为我们有时候需要在方法内部初始化生成的对象被返回后别人还能使用,而不是立即释放.
 在swift中因为有@UIApplicationMain,我们不需要main文件和main函数,所以就不存在自动释放池,即使自己实现main.swift也不需要自己添加自动释放池.
 但是.............
 
 */

/*:
 ## 值类型和引用类型
 
 * 值类型在传递时进行复制而引用类型是"指向".
 * swift中enum和struct是值类型,class是引用类型.值得注意的是在swift中所有的内建类型都是值类型不仅包含传统的Int,Boolz甚至包括String,Array,Dictionary都是值类型.
 * 使用值类型好处是,相对于引用类型来说,一个显而易见的好处是减少了堆上内存的分配和回收的次数.首先需要知道的是swift的值类型特别是数组字典这样的容器,在内存管理上经过精心设计.值类型在传递时并不一定会进行真正的复制.
 */

func test(_ arr: [Int]) {
    for i in arr {
        print(i)
    }
}
var a = [1,2,3]
var b = a
let c = b
test(a)
//: 对于上面的传递数组在内存中始终只有一份,而且还是在栈空间上,整个过程只是进行了指针的移动,没有堆内存的分配与释放.
//: * 值类型被复制的时机是值类型内容发生了改变,eg:

var a0 = [1, 2, 3]
var b0 = a0
b0.append(6)
// 此时b和a的内存地址不再相同


/*:
 * 值类型在复制时,会将存储在其中的值类型一并复制, 而对于其中的引用类型则只复制一份.
 */
class MyClass {
    var num = 0
}
var myobject = MyClass()
var a1 = [myobject]
var b1 = a1
b1.append(myobject)
myobject.num = 100
print(b1[0].num)
print(b1[1].num)

//: * 虽然将数组和字典设计成值类型是为了线程安全,但是这样的设计在存储的元素或者条目数量较少时,会给我们带来另一个优点就是非常高效.以为一旦赋值就不会改变这种情况在cocoa中是占大多数的,这有效减少了内存的分配与回收;但是对于存储内容很多并且还要对其中的内容进行修改时,swift内建容器类型在每次操作都要复制一份,即使存储的是引用类型,在复制时还是需要存储大量的引用,这个开销就不容忽视了.此时可以使用cocoa中的引用类型容器来应对即:NSMutableArray和NAMutableDictionary.
//: * 所以,在使用数组和字典的最佳实践是,按照具体的规模和操作特点来决定使用值类型容器还是容器类型容器:在需要处理大量数据并进行频繁的增减时,使用引用类型NSMutableArray和NSMutableDictionary会更好,而对于容器条目较少而容器数目多的情况使用Array和Dictionary

/*:
 ## String还是NSString
 
 虽好还是使用swift原生类型String,原因:
 * String是struct,配合let保证线程安全
 * 在不触及NSString特有的操作和动态特性的时候可以提升性能
 * String实现了Collection协议,拥有可以使用for..in等特性
 */
let sites = "https://aipinn.com"
for _ in sites {
    //print(i)
}
let length = sites.lengthOfBytes(using: .utf8)

/*:
 转化为NSString是没有枚举的
 */

let nsRange = NSMakeRange(1, 2)

let idxPositionOne = sites.index(sites.startIndex, offsetBy: 1)
let swiftRange = idxPositionOne..<sites.index(sites.startIndex, offsetBy: 1)
sites.replacingCharacters(in: swiftRange, with: "23")
//: 可以看到此方法使用比较麻烦,可以转化为NSString

/*:
 ## UnsafePointer
 */

//: * 不可变
/*
void method(const int *num) {
    
}
 */
func method(_ num: UnsafePointer<Any>) {
    
}

//: * 可变
func method(_ mnum: UnsafeMutablePointer<Any>) {
    
}
//: ... ...

/*:
 ## GCD和延时调用
 展示部分常用场景
 */
//: * 异步调用
let workingQueue = DispatchQueue(label: "my_queue")
workingQueue.async {
    print("working hard")
    Thread.sleep(forTimeInterval: 2)
    DispatchQueue.main.async {
        print("working end, refresh UI")
    }
}
//: * 延时执行
let time: TimeInterval = 2.0
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
    print("2秒后输出")
}
//: 封装延时执行并且可以取消的功能
typealias Task = (_ cancel: Bool) -> Void
func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancle in
        if let internalClosure = closure {
            if cancle == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancle(_ task: Task?) {
    task?(true)
}
//: 使用
delay(2) {
    print("2秒后输出...")
}
let task = delay(5) {
    print("拨打110")
}
cancle(task)

/*:
 ## 获取对象类型
 */

//: * 对于NSObject的子类
//: object_getClass其实是OC的运行时特性
let date = NSDate()
let name: AnyClass! = object_getClass(date)
print(name)

//: * swift更好的写法
let swiftName = type(of: date)
print(name)

//: > 似乎是解决问题了.上面使用的都是OC的动态特性,要是换成swift的内建类型的话呢?
let string = "Hello"
let strname = type(of: string)
print(strname)
debugPrint(strname)
//: 也是可行的, 其实真正的类型是带有module名字的:Swift.String,可以使用debugPrint输出确认

/*:
 ## 内省
 程序设计和人类哲学所面临的同一个很大的课题就是解决"我是谁"这个问题.哲学中这属于自我认知的范畴,程序设计中这个问题涉及到内省
 
 * OC中:isKindOfClass和isMemberOfClass
 * 在swift中如果继承自NSObject的话,可以直接使用isKind, isMember

 */
class ClassA: NSObject {}
class ClassB: ClassA {}
let obj1 = ClassA()
let obj2 = ClassB()
obj1.isKind(of: ClassA.self)//true,判当前类或者子类
obj2.isKind(of: ClassA.self)//true
obj2.isMember(of: ClassA.self)//false,判当前类型

/*:
 Swift中对于AnyObject使用最多的地方就是原来那些返回id的Cocoa API了.为了快速确定类型,swift提供了一个简洁的写法:
 对于一个不确定的类型,我们现在可以使用is来判断.is在功能上相当于原来的isKindOf,可以检测某类型或其子类.和原来的区别主要在于
 两点:
 
 * 首先,它不仅可以用于class类型上,也可以对于swift的dstruct和enum类型进行判断.
 * 另外,编译器将对这种类型进行必要的判断:如果编译器能够确定唯一类型,那么is的判断就没有必要,编译器会抛出异常进行提示.
 */

let obj3: AnyObject = ClassB()
if (obj3 is ClassA) {
    print("obj3 is ClassA")
}
if (obj3 is ClassB) {
    print("obj3 is ClassB")
}
//: 编译警告并报错
//let str = "String"
//if str is String {
//    //TODO
//}

/*:
 ## KeyPath和KVO
 
 继承自NSObject类才能使用
 */

//: * swift4之前
class KVOClass: NSObject {
    @objc dynamic var date = Date()
    var name: String = "KVOClassBaseClass"
}
private var myContext = 0

class Class: NSObject {
    var kvoObject: KVOClass!
    
    override init() {
        super.init()
        kvoObject = KVOClass()
        print("初始化日期\(kvoObject.date)")
        kvoObject.addObserver(self, forKeyPath: "date", options: .new, context: &myContext)
        delay(3) {
            self.kvoObject.date = Date()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 毕竟世事难料,做一下可选绑定,从字典中取到的是Any值,试用前需要进行一下转换
        if let change = change, context == &myContext {
            if let newDate = change[.newKey] as? Date {
                print("日期变化\(newDate)")
            }
        }
    }
}
let oo = Class()

//: * 改进? Swift4中Y引入了KeyPath的表达式.现在对于类型Foo中的变量bar: Bar,对应的KeyPath可以写为\Foo.bar. 在这种表达方式下,KeyPath将通过泛型的方式带有类型信息,eg:KeyPath<Foo, Bar>.借助这个信息,Apple在NSObject上添加了一个基于block的KVO API,重写上面的栗子🌰:

class AnotherClass: NSObject {
    var kvoObj: KVOClass!
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        kvoObj = KVOClass()
        print("another date \(kvoObj.date)")
        observation = kvoObj.observe(\KVOClass.date, options: [.new]) { (_, change) in
            if let newDate = change.newValue {
                print("another after date: \(newDate)")
            }
        }
        delay(2) {
            self.kvoObj.date = Date()
        }
    }
}

let ooo = AnotherClass()
/*: 代码在一块维护简单; 在处理时我们得到的是类型安全的结果,而不是从字典取值; 最后,我们不用通过context来区分哪一个观察量发生了变化,而且使用observation来持有观察者j可以让我们从麻烦的内存管理中解放出来,观察者的生命周期将随AnotherClass的释放而结束.对比q之前的实现还要找好时机停止观察,否则造成内存泄漏.
 
  **不过在swift中的KVO存在两个显而易见的问题**
 * 第一, @objc,dynamic进行修饰.如果想要观察的类型没有@objc和dynamic修饰只能通过继承使用@objc和dynamic重写对应的属性
 * 第二, 对于非NSObject的swift类型怎么办?因为Swift类型并没有通过KVC进行实现,所以就谈不上什么对属性进行KVO了;暂时只能通过属性观察来实现类似的机制.
 */

//: 继承重写
class ChildKVOClass: KVOClass {
    @objc dynamic override var name: String {
        get { return super.name }
        set { super.name = newValue }
    }
}
