import UIKit

var str = "Hello, Tips_1"

//-----------------------------------------
//------------初始化方法顺序--------------
//-----------------------------------------

// swift要保证类型的所有属性都被初始化, 所以初始化方法的调用顺序就很有讲究
// 我们需要保证当前子类实例的成员初始化完成后才能调用父类的初始化方法

class Cat {
    var name: String
    init() {
        name = "cat"
    }
}

class Tiger: Cat {
    let power: Int
    override init() {
        power = 10
        super.init()
        name = "Tiger"
    }
}

// 一般来说,子类的初始化顺序是:
//1. 设置子类自己需要初始化的参数
//2. 调用父类的相应的初始化方法
//3. 对父类中需要改变的成员变量进行设定
//** 第三步视情况而定,如果我们在子类中不需要对父类的成员变量做出改变的话,就不需要调用第三步
//** 而这种情况下, swift会自动的调用对应的父类init方法,即第二步也可以不显示调用,但实际上是调用的(自动)
class CafeCat: Cat {
    let body: Int
    override init() {
        body = 7
//        super.init()
//        name = "Cat"
    }
}

//-----------------------------------------
//-----Designated, Convenience, Required------
//-----------------------------------------

class ClassA {
    let numA: Int
    init(num: Int) {
        numA = num
    }
}

class ClassB: ClassA {
    let numB: Int
    override init(num: Int) {
        numB = num+1
        super.init(num: num)
    }
}

//与Ddesignated初始化方法对应的是在init前加convenience关键字的初始化方法.
//这类初始化方法是初始化方法的"二等公民",只做补充和提供便利.
//所有的convenience初始化方法都必须调用同一个类中的designated

class Class0 {
    let num0: Int
    var name: String?
    
    init(num: Int) {
        num0 = num
    }
    convenience init(bigNum: Bool) {
        self.init(num: bigNum ? 1000 : 1)
    }
}

class Class1: Class0 {
    let num1: Int
    override init(num: Int) {
        num1 = num + 1
        super.init(num: num)
    }
}
// 只要实现父类convenience方法必须的init方法.就可以在子类中使用convenience方法.
let num = Class1(bigNum: true)

/*
 总结初始化方法原则:
 1. 初始化路径必须保证对象完全初始化, 这个可以调用本类型的designated初始化方法来保证
 2. 子类的designated初始化方法必须调用父类的designated方法, 保证父类d也完成初始化
 */

// 对与某些希望子类一定实现的designated方法,可以通过required关键字限制,强制子类对此方法重写
// 这样做的最大好处是可以保证依赖于某个designated初始化方法的convenience一直可以被使用.
// convenience方法也可以使用required,这在要求子类不能直接使用父类的convenience的s初始化方法会非常用帮助

//-----------------------------------------
//------------初始化返回nil--------------
//-----------------------------------------
//初始化函数的可选绑定init?

let url = NSURL(string: "ht tp://aipinn.com")
let aipinn = URL(string: "http://aipinn. com")
URL.init(string: " ")

//-----------------------------------------
//------------static 和 class--------------
//-----------------------------------------

// swift中表示类型范围作用域的关键字: static和class
// 在非class的类型上下文中,统一使用cstatic来描述类型的所用于. 这包括在enum和struct中表述类型方法和类型属性时.在这两个值类型中,我们可以在类型范围内声明并使用存储属性 计算属性和方法.
// static的使用场景:
struct Point {
    let x: Double
    let y: Double

    //存储属性
    static let zero = Point(x: 0, y: 0)

    //计算属性
    static var ones: [Point] {
        return [
            Point(x: 1, y: 1),
            Point(x: -1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1)
        ]
    }
    // 类型方法
    static func add(p1: Point, p2: Point) -> Point {
        return Point(x: p1.x+p2.x, y: p1.y+p2.y)
    }
}
// enum和此类似
let p1 = Point(x: 1, y: 1)
let p2 = Point(x: 2, y: 2)
//p1.add
//p1.zero
//p1.ones
// 类方法与类属性
Point.add(p1: p1, p2: p2)
Point.zero
Point.ones

// class的使用场景:
class MyClass {
    //类的存储属性是不能使用class的, 但是可以使用static
    //class var bar: UIBarButtonItem?
    static var bar: UIBarButtonItem?
    class func classAdd(){}
    static func staticAdd(){}
    //计算属性可以使用class/static
    class var name: String {
        get {
            return "name"
        }
        set {
            print(name)
        }
    }
}
// 类属性
let bar = MyClass.bar
// 计算属性
MyClass.name = "somestring"
// 类方法
MyClass.classAdd()
MyClass.staticAdd()

//对于协议只能使用static
protocol MyProtocol {
    static func foo() -> String
}
struct MyStruct: MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}

enum MyEnum: MyProtocol {
    static func foo() -> String {
        return "MyEnum"
    }
}

class MyClassNew: MyProtocol {
    // 可以使用static
//    static func foo() -> String {
//        return "MyClassNew"
//    }
    
    // 也可以使用class
    class func foo() -> String {
        return "MyClassnew"
    }
}

MyStruct.foo()
MyEnum.foo()
MyClassNew.foo()

// ***任何时候使用static都是可以的***

//-----------------------------------------
//------------多类型和容器--------------
//-----------------------------------------

// 容器默认情况下只能存储同一种类型的数据
// 要存储多种类型需要做一些转换
// any 类型可以隐式转换
let mix: [Any] = ["123", 1]
let objArr = [1 as NSObject, "two" as NSObject]
objArr[0]
mix[0]
type(of: objArr[0])
type(of: mix[0])

let mixed: [CustomStringConvertible] = [1, "two", 3, [2]]
mixed.forEach { (ele) in
    print(type(of: ele), ele)
}

//另外, 可以利用枚举可以带值得特性
enum IntOrString {
    case IntValue(Int)
    case StringValue(String)
}

let mix_enum = [IntOrString.IntValue(0), IntOrString.StringValue("one")]
for value in mix_enum {
    switch value {
    case let .IntValue(i):
        print(i)
    case let .StringValue(s):
        print(s)
    }
}



//-----------------------------------------
//------------默认参数--------------
//-----------------------------------------

// 默认参数不限制参数位置和数量
func sayHello(str1: String, str2: String = "空格", str3: String, str4: String = "!") {
    print(str1 + str2 + str3)
}
//sayHello(str1: <#T##String#>, str2: <#T##String#>, str3: <#T##String#>, str4: <#T##String#>)
//sayHello(str1: <#T##String#>, str3: <#T##String#>)

// 默认参数时default, 这是含有默认参数的方法生成的swift的调用接口.
// 当我们指定一个编译时就能确定的常量作为默认参数取值时,这个取值是隐藏在方法内部实现, 而不应该暴露给其他部分.
//NSLocalizedString(<#T##key: String##String#>, comment: <#T##String#>)
//public func NSLocalizedString(_ key: String,
//                          tableName: String? = default,
//                             bundle: Bundle = default,
//                              value: String = default,
//                            comment: String) -> String

// 自己怎么使用default呢????

//-----------------------------------------
//------------...和..<--------------
//-----------------------------------------

for i in 0...5 {
    print(i)
}
for i in 0..<6 {
    print(i)
}

let hello = "hello!"
let interval = "a"..."z"
for c in hello {
    if !interval.contains(String(c)) {
        print("\(c)不是字母")
    }
}

//ASCII字符范围(\0和~是ASCII的第一个和最后一个字符)
//let ascii = \0...~

//-----------------------------------------
//------------AnyClass 元类型 .self--------------
//-----------------------------------------

// swift中除了Any AnyObject可以表示任意之外,还有AnyClass
// AnyClass是被一个typealias所定义
//typealias AnyClass = AnyObject.Type
// AnyObject.Type得到一个元类型(Meta)
class A {
    class func method(){
        print("hello")
    }
}
let typeA: A.Type = A.self
typeA.method()

// 或者
let anyClass: AnyClass = A.self
(anyClass as! A.Type).method()

class MusicVC: UIViewController {
    func playMusic() {
        print("Playing music")
    }
}

class AlbumVC: UIViewController {
    func showPic() {
        print("Show picture")
    }
}

let usingVCTypes: [AnyClass] = [MusicVC.self, AlbumVC.self]
func setupViewController(_ vcTypes: [AnyClass]) {
    for vcType in vcTypes {
        if vcType is MusicVC.Type {
            let vc = (vcType as! MusicVC.Type).init()
            vc.playMusic()
        } else if vcType is AlbumVC.Type {
            let vc = (vcType as! AlbumVC.Type).init()
            vc.showPic()
        }
    }
}
setupViewController(usingVCTypes)

//.Type表示某个类型的元类型,enum, struct, class可用
// 对于协议使用.Protocol来获取协议的元类型
protocol ProtocolA {
    func method()
}
let metaProtocol: ProtocolA.Protocol = ProtocolA.self

//-----------------------------------------
//------------协议和类方法中的Self--------------
//-----------------------------------------
// swift中的某些协议中出现大写的Self
//protocol IntervalType {
//    func clamp(intervalToClamp: Self) -> Self
//}

// 如果在协议中使用的类型就是遵守协议的类型的本身的话就需要使用Self
protocol Copyable {
    func copy() -> Self //返回遵守此协议的类型本身
}

class OneClass: Copyable {
    var num = 1
    func copy() -> Self {
        let result = type(of: self).init()//必须要有required修饰的初始化方法,这是因为swift必须保证当前类和其子类都能相应这个init方法. 另一个解决方案是声明当前类为final
        result.num = num
        return result //Self 类型
        
//        let ret = OneClass()
//        ret.num = num
//        // 编译错误
//        return ret //Cannot convert return expression of type 'OneClass' to return type 'Self'
    }
    
    required init() {

    }
}

let obj = OneClass()
obj.num = 100

let newObj = obj.copy()
obj.num = 1

print(obj.num)
print(newObj.num)

// 另一个使用Self的地方是类方法中,使用起来类似,核心就是保证自来也能返回恰当的类型.

//-----------------------------------------
//------------动态类型和多方法--------------
//-----------------------------------------
/* OC 中报错
 - (void)method:(NSString *)name{
 
 }
 - (void)method:(id)obj{
 
 }
 */
// 保证参数不同就可以
func method(num: Int){
    
}
func method(num: String){
    
}

class Pet {}
class Pig: Pet {}
class Dog: Pet {}

func printPet(_ pet: Pet) {
    print("Pet")
}
func printPet(_ pet: Dog) {
    print("Wang")
}
func printPet(_ pet: Pig) {
    print("Heng")
}
// 编译器帮助我们找到最精确的匹配
printPet(Dog())
printPet(Pig())
printPet(Pet())

// 对于Pig或Dog实例,总会找到合适的方法,而不会去调用一个通用的父类Pet的方法.这一切都是在编译期发生的
// 对于下面的代码:
func printThem(_ pet: Pet, _ pig: Pig) {
    printPet(pet)
    printPet(pig)
}

printThem(Dog(), Pig())
//输出:
//Pet //OC会输出Wang
//Heng

// 没有输出wang, 采用了编译期间决定的pet版本的方法.
// 这是因为Swift默认情况下不是采用动态派发的,因此方法的调用只能在编译时决定的.
// 要想绕过这个限制, 我们可能需要对输入进行类型判断和转换
print("-------")
func printThemNew(_ pet: Pet, _ pig: Pig) {
    if let aPig = pet as? Pig {
        printPet(aPig)
    } else if let aDog = pet as? Dog {
        printPet(aDog)
    }
    printPet(pig)
}

printThemNew(Dog(), Pig())
//输出
//Wang
//Heng

//-----------------------------------------
//------------属性观察--------------
//-----------------------------------------

// 可以在willSet中获取新值newValue,在didSet中获取旧值oldValue
// 可以自定义新值旧值的名字,eg:willSet(myCustomNewValue){}, didSet(myCustomOldValue){}
// swift包括存储属性和计算属性两种:
// 其中存储属性将会在内存中实际分配地址对属性进行存储,而计算属性则不包括背后的存储,只是提供set和get两种方法.
// 同一个属性的access与属性观察不能共存, 在access中可以设计逻辑达到属性观察的效果
// 如果某个类无法更改,却想观察他的属性变化情况,可以对其进行子类化,子类重写父类属性,任意添加属性观察而不用关心父类的此属性是计算属性还是存储属性.
class AA {
    var number: Int {
        get {
            print("get")
            return 1
        }
        set {
            print("set")
        }
    }
}

class BB: AA {
    override var number: Int {
        willSet {
//            print(newValue)
            print("willset")
        }
        didSet {
//            print(oldValue)
            print("didset")
        }
    }
}
print("-----")
let b = BB()
b.number = 10
print("-----")
//输出:
//get 此处先输出get比较意外,因为实现了didSet,didSet中会获取oldValue,
//    而这个值需要在set动作之前获取并进行存储代用,否则无法保证正确性, 如果不实现didset的话,这次get操作也将不复存在.
//willset
//set
//didset

//-----------------------------------------
//------------final--------------
//-----------------------------------------
//
// final可以用在class func var之前进行修饰
// swift使用是为了权限控制,主要有以下几种情况:
// 1. 类或者方法确实已经完备了
// 2. 子类继承或者修改是一件危险的事情
// 3. 为了父类中的一些代码一定会执行
// 4. 性能考虑

//对于第三点
class Parent {
    final func method() {
        print("开始配置")
        methodImpl()
        print("结束配置")
    }
    
    func methodImpl() {
        fatalError("子类必须实现此方法")
    }
}

class Child: Parent {
    override func methodImpl() {
        //子类的业务逻辑
    }
}

let child = Child()
child.method() // methodImpl()不实现会崩溃报错

//-----------------------------------------
//------------Lazy--------------
//-----------------------------------------

class AAA {
    lazy var str: String = {
        let str = "hello"
        print("初次访问")
        return str
    }()
    // 如果没有什么额外的工作的话可以简写:
    lazy var sim_str: String = "Lazy string"
}

// 另外swift标准库中还有一组懒加载的方法

//可以配合map或者filter这类接收闭包并运行的方法一起,e让整个行为编程延迟进行. 这是会对性能有不小帮助
//eg:
print("----lazy---")
let data = 1...3
let result = data.map { (i: Int) -> Int in
    print("正在处理")
    return i * 2
}
print("准备访问结果")
for i in result {
    print("操作后的结果\(i)")
}
print("操作完毕")
// 输出结果:
//正在处理
//正在处理
//正在处理
//准备访问结果
//操作后的结果2
//操作后的结果4
//操作后的结果6
//操作完毕

print("----lazy---")
// 而我们先进行一次lazy操作的话:
let lazyRet = data.lazy.map { (i: Int) -> Int in
    print("lazy-正在处理")
    return i * 2
}

print("lazy-准备访问结果")
for i in lazyRet {
    print("lazy-操作后的结果\(i)")
}
print("lazy-操作完毕")
// 输出
//lazy-准备访问结果
//lazy-正在处理
//lazy-操作后的结果2
//lazy-正在处理
//lazy-操作后的结果4
//lazy-正在处理
//lazy-操作后的结果6
//lazy-操作完毕

//** 从结果中可以看到,s对于那些需要提前退出的情况,使用lazy来提升性能是非常有效的.
