import UIKit
import PlaygroundSupport

var str = "Hello, Tips_2"

//-----------------------------------------
//------------Reflection和Mirror--------------
//-----------------------------------------

// Reflection是Java中的反射; 这是在运行时检测 访问 或者修改类型行为的特征, 是动态语言的特征.
// 一般静态语言类型的结构和方法的调用等都需要在编译器决定,开发者能够做的很多时候只是使用控制流(if switch等)来决定作出怎样的设置或者调用哪个方法, 而反射特性可以让我们有机会再运行时的时候通过某些条件实时决定调用哪个方法, 或者向某个类型动态的条件属性和方法.
// OC 很少提到反射, 因为OC的运行时比反射强大的多.

// swift中所有类型都实现了_Reflectale协议(一个内部协议),....现在的swift可以使用Mirror来获取所有类型的的基本信息.

struct Person {
    let name: String
    let age: Int
}

let xm = Person(name: "xiaoming", age: 16)
let r = Mirror(reflecting: xm)
print("xiaoming是:\(r.displayStyle!)")
print("属性个数:\(r.children.count)")
for child in r.children {
    print("属性名:\(child.label!), 值:\(child.value)")
}
/*
 public typealias Child = (label: String?, value: Any)
 public typealias Children = AnyCollection<Mirror.Child>
 */
//AnyCollection是遵守collectionType协议的, 因此可以使用count获取元素个数
// 上面声明的Person类的所有实例都包含有两个多元组(label: String?, value: Any)
// lable?是属性名, value是属性值, 可能是嵌套的(eg: 数组 字典等)

// dump 可以快速获取.
dump(xm)
/*
 ▿ __lldb_expr_28.Person
 - name: "xiaoming"
 - age: 16
 */

//另一个场景是类似OC中的KVC通过ValueForKey取值.
func valueFor(_ object: Any, key: String) -> Any? {
    let mirror = Mirror(reflecting: object)
    for child in mirror.children {
        let (targetKey, targetMirror) = (child.label, child.value)
        if key == targetKey {
            return targetMirror
        }
    }
    return nil
}

if let name = valueFor(xm, key: "name") as? String {
    print(name)
}

//-----------------------------------------
//------------隐式解包Optional--------------
//-----------------------------------------
class MyClass {
    func foo(){
        print("foo")
    }
}
// 类型后面添加感叹号❗️这个语法糖告诉编译器我们需要一个可以隐式解包的Optional值
var maybeObj: MyClass!
// 对于隐式解包下面是等效的, 如果c是nil,不加检测直接调用会导致崩溃. 但在OC中可以向nil发送任何消息
var c: MyClass! = MyClass()
//c = nil
c!.foo()
c.foo()
print("------")
var obj: MyClass?
//obj!.foo()
obj?.foo()
// 通过可选绑定处理
if let oo = obj {
    oo.foo()
}
//更多解释查看swifter开发者必备Tips.pdf

//-----------------------------------------
//------------多重Optional--------------
//-----------------------------------------

// Optional解决了困扰OC许久以来的"有"与"无"的哲学概念
// 但是多重Optional是个问题:
// 在类型后面加上问号❓的语法只不过是Optional类型的语法糖,而实际上这个类型是一个enum:
/*
 public enum Optional<Wrapped> : ExpressibleByNilLiteral {
 case none
 case some(Wrapped)
 ...
 }
 */

var string: String? = "string"
var anotherString: String?? = string
//很容易理解anotherString是Optional<Optional<String>>
var literalOptional: String?? = "string"
//这是我们将Optional<String>放入到literalOptional中,可以知道它与上面的anotherString是等效的.
//但是如果我们将nil赋值给它的话,情况就不同了:
var aNil: String? = nil
var anotherNil: String?? = aNil

var literalNil: String?? = nil

// 一个盒子里面放一个盒子,里面的盒子是空的(anotherNil)与一个空盒子(literalNil)
// 使用:
if anotherNil != nil {
    print("anotherNil")
}
if literalNil != nil {
    print("literalNil")
} else {
    print(".....")
}
//输出:
//anotherNil
//.....
// lldb po输出都是nil
// 可以使用 fr v -R <var> 输出查看变量未加工过时的信息.

//-----------------------------------------
//------------Otional Map--------------
//-----------------------------------------

//我们常对数组使用map.   public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
let arr = [1,2,3]
let doubled = arr.map { (i: Int) -> Int in
    return i*2
}
arr //[1,2,3]
doubled //[2,4,6]

//另一个场景:如果某个值是Int?呢,
//操作: 如果有值乘2(注释第三行), 没有就直接返回nil(注释前两行):
//let n: Int? = nil
//let num: Int? = n
let num: Int? = 3
var ret: Int?
if let realNum = num {
    ret = realNum * 2
} else {
    ret = nil
}

//更优雅的做法是使用Optional的map.
// Optional也有一个map方法: public func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
let real = num.map {
    $0 * 2
}
// 通过上面的操作查看结果.

//-----------------------------------------
//------------Protocol Extension--------------
//-----------------------------------------
print("---Protocol Extension--")
//协议扩展可以为遵守了某一协议的类型统一添加一些共通的功能.
//eg:
protocol MyProtocol {
    func method()
}

extension MyProtocol {
    func method() {
        print("called")
    }
}

struct MyStruct: MyProtocol {
    //1. 不需要任何实现,可以编译通过和使用. 调用的话会直接调用extension中的实现
    //输出:
    //called
    
    //2. 当然也可以自己实现
    //    func method() {
    //        print("myself impl")
    //    }
    //输出:
    //myself impl
}
//调用:
MyStruct().method()

/**
 也就是说: protocol extension为protocol中定义的方法提供了一个默认的实现.
 有了这个以后之前放在全局环境中的接受CollectionType的map方法就可以被移动到CollectionType的协议扩展中去了.
 */

// 另一个可以用到协议扩展的地方就是可选的协议方法, 我们通过protocol extension为协议提供默认的实现,这相当于变相的将协议的方法设定为optional.

// 那如果在协议扩展中实现了协议中没有方法呢?
protocol A1 {
    func method1() -> String
}

struct B1: A1 {
    func method1() -> String {
        return "hello"
    }
}

// 无论实例类型为A1还是B1, 都输出hello
let b1 = B1()
b1.method1()

let a1: A1 = B1()
a1.method1()
// 如果协议扩展实现了额外的方法就变得有趣了:
protocol A2 {
    // 只有一个方法
    func method1() -> String
}

extension A2 {
    func method1() -> String {
        return "hi"
    }
    // 实现了额外的方法
    func method2() -> String {
        return "hi"
    }
}
// 尝试实现协议
struct B2: A2 {
    func method1() -> String {
        return "hello"
    }
    func method2() -> String {
        return "hello"
    }
}

// 我们的B2对A2的扩展的默认实现进行了覆盖,都返回hello
let b2 = B2()
b2.method1()
b2.method2()

let a2 = b2 as A2
a2.method1()//hello
a2.method2()//hi
// 这里: a2和b2是同一个对象.但是结果不同, WHY?
// a2调用method2实际上是扩展中的方法被调用了,而不是实例中的方法被调用.
// 我们不妨这样理解:...对于method1,实例a2遵守了协议必定实现了method1,我们可以放心的用动态派发的方式使用最终的实现
// (不论他是在类型中的实现还是协议扩展中的默认实现)l; 但是对method2来说,我们只在扩展中定义并实现, 没有任何规定说它必须在类型中实现. 在使用时,a2是只符合A2协议的实例,编译器对method2唯一能确定的只是在协议中有一个方法并实现,因此在调用时无法确定安全,也就不去进行动态派发,而是转而编译期间就确定的默认实现.

/*:
 ## where和模式匹配
 使用场景:
 */
//: 1. switch语句中, 可以使用where来限制某些条件case

let name = ["王小二", "张小三", "李小四", "王二小"]

name.forEach {
    switch $0 {
    case let x where x.hasPrefix("王"):
        print(x)
    default:
        print("非王")
    }
}
//:这可以说是模式匹配的标准用法,对case进行限制可以更灵活使用switch语句

//: 2. 在for语句中使用
let number: [Int?] = [45, 89, nil]
let n = number.compactMap{$0}

for score in n where score > 60 {
    print("及格\(score)")
}


//: 3. 和for类似, 可以使用可选绑定进行限制.
//: >不过在swift3之后,if let 和 guard let的条件不再使用where语句,而是直接在if或guard后面添加逗号
    
number.forEach {

    if let score = $0 ,score > 60 {
        print("--及格\(score)")
    } else {
        print("++😣")
    }
    
}

//: 4. 在泛型中对方法的类型进行限定, 比如在标准库中不等于!=的定义
//: 5. 在协议扩展protocol extension. 有时候,我们希望一个协议的扩展的默认实现只在某些情况下使用,这时候可以使用where限定.

/*:
 ## indirect和嵌套enum
 */

//: 单向列表
class Node<T> {
    let value: T?
    let next: Node<T>?
    
    init(value: T?, next: Node<T>?) {
        self.value = value
        self.next = next
    }
}

let list = Node(value: 1, next:
                Node(value: 2, next:
                    Node(value: 3, next:
                        Node(value: 4, next: nil))))
list

/*: 这样似乎没什么问题, 但是当节点为空时使用nil并不恰当,因为nil和空节点并不是一回事
 swift2以后我们可以使用enum嵌套,用enum重新定义链表的话,如下:
 */
indirect enum LinkedList<Element: Comparable> {
    case empty
    case node(Element, LinkedList<Element>)
    
    func removing(_ element: Element) -> LinkedList<Element> {
        guard case let .node(value, next) = self else {
            return .empty
        }
        return value == element ? next: LinkedList.node(value, next.removing(element))
    }
}
let linkedList = LinkedList.node(1, .node(2, .node(3, .node(4, .empty))))

/*:
 在enum的定义中嵌套自身对于class这样的引用类型时没有任何问题的,但是对于enum struct这样的值类型来说
 普通的做法是不可行的. 我们需要在定义前加上indirect来提示编译器不要直接在值类型中世界嵌套.用enum表达链表的好处在于,我们可以清晰的表示出空节点这一定义.同时我们可以使用寥寥数行就能轻易实现链表的节点删除方法. 在enum中添加removing方法
 */

let result = linkedList.removing(2)
print(result)
