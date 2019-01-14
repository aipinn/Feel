import UIKit

var str = "Hello, Tips_0"


struct fixLengthRange {
    var firstValue: Int
    let length: Int
}

var range = fixLengthRange(firstValue: 0, length: 3)
range.firstValue = 3

//常量的内部属性是变量也不可修改
//let rang1 = fixLengthRange(firstValue: 0, length: 3)
//rang1.firstValue = 4

class DataImporter {
    var fileName = "data.txt"
}

class DataManager {
    // 多线程访问未初始化的懒加载属性,不能保证属性被初始化一次
    lazy var importer = DataImporter()
    var data = [String]()
    
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")

/*:
 ## 柯里化(Currying)
 */

func addOne(num: Int) -> Int {
    return num + 1
}

func addTo(_ adder: Int) ->(Int) -> Int {
    return {
        num in
        return num + adder
    }
}
let addTwo = addTo(2)
let result = addTwo(6)

//: 另一个例子
func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}

let greaterThan10 = greaterThan(10)
greaterThan10(12)
greaterThan10(3)

//: 实际应用Selector
protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
    //...
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    
    func setTarget<T: AnyObject>(target: T,
                                 action: @escaping(T) -> () -> (),
                                 controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    func performActionForControlEvent(contolEvent: ControlEvent) {
        actions[contolEvent]?.performAction()
    }
}
//: 使用
class MyViewController {
    let button = Control()

    func viewDidLoad() {
        button.setTarget(target: self,
                         action: MyViewController.onButtonTap,
                         controlEvent: .TouchUpInside)

    }
    func onButtonTap() {
        print("Button was tapped")
    }
}


class Mark {
    func look() {
        print("Looking...")
    }
    class func drinking () {
        print("driking...")
    }
    static func playing() {
        print("playing...")
    }
}

Mark.drinking()
Mark().look()
Mark.playing()

/*:
 ## 将protocol的方法声明为mutating
 
 Swift中的mutating关键字修饰方法是为了能够在该方法中修改struct或enum的变量,所以如果你没有在协议方法中写mutating的话,
 别人如果用struct和enum来实现这个协议的话,就不能再协议方法中修改自己的变量了
 */

protocol Vehicle {
    var numberOfWheels: Int { get }
    var color: UIColor { get set }
    
    mutating func changColor()
    
}

struct MyCar: Vehicle {
    var numberOfWheels = 4
    var color = UIColor.blue
    var seat: Int
    mutating func changColor() {
        color = .red
    }
    mutating func change() {
        numberOfWheels = 5
    }
    mutating func changeSeat() {
        seat = 4
    }
}


/*:
 ## @autoclosure和??
 @autoclosure做的事情就是把一句表达式自动的封装成一个闭包
 
 * autoclosure
 */

func logIfTure(_ predicate: () -> Bool) {
    if predicate() {
        print("True")
    }
}

//: 调用

//自动填充
logIfTure { () -> Bool in
   return 2 < 3
}
//没有参数省去in
logIfTure { return 2 < 3 }
//省掉return
logIfTure({ 2 < 3 })
//因为闭包是最后一个参数,可以使用尾随闭包的方法
logIfTure{ 2 < 3 }
//使用autoclosure
func logIfTure_new(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("Ture new")
    }
}
//此时调用方式:
logIfTure_new(2 < 3)
/*:
 Swift将会把2<3这个表达式自动转换为()->Bool.
 */

/*:
 * ??
 和三目中`?:`相同, 其实现本质使用了@autoclosure
 */

var level: Int?
var startLevel = 1

var currentLevel = level ?? startLevel


/*:
 ## @escaping
 */
func dowork(block: ()->()) {
    block()
}

dowork {
    print("work")
}

func doworkAsync(block: @escaping ()->()) {
    DispatchQueue.main.async {
        block()
    }
}

class Mars {
    var foo = "foo"
    
    func method1() {
        dowork {
            print(foo)
        }
        foo = "bar"
    }
    
    func method2() {
        doworkAsync {
            print(self.foo)
        }
        foo = "bar"
    }
    
    func method3() {
        doworkAsync {
            [weak self] in
            print(self?.foo ?? "--nil--")
        }
        print("1")
    }
}

Mars().method1()
Mars().method2()
Mars().method3()

protocol ppp {
    func work(b: @escaping ()->())
}

class Jupiter: ppp {
    func work(b: @escaping () -> ()) {
        DispatchQueue.main.async {
            print("in C")
            b()
        }
    }
}
Jupiter().work {
    
}
class Jupiter1: ppp {
    func work(b: () -> ()) {
        b()
        print("iiii")
    }
}

Jupiter1().work {
    
}


/*:
 ## Optional Chaining
 可以让我们摆脱很多不必要的判断和取值, 但是在使用的时候需要小心陷阱.
 因为Optional Chaining是随时都可能提前返回nil的,所以使用Optional Chaining所得到的东西都是Optional的.
 */

class Toy {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Pet {
    var toy: Toy?
}
class Child {
    var pet: Pet?
}
let xiaoming = Child()
let cat = Pet()
let woolen = Toy(name: "woolen")
cat.toy = woolen
xiaoming.pet = cat
//: 虽然我们最后访问的是name,在Toy中name是被定义的一个确定的String而非String?,但是toyName其实依然是一个String?的类型.
let toyName = xiaoming.pet?.toy?.name
if let toyname = xiaoming.pet?.toy?.name {
    print(toyname)
} else {
    print("none")
}
//: 另一个栗子
extension Toy {
    func play() {
        print("is playing")
    }
}

let some: ()? = xiaoming.pet?.toy?.play()// let some: ()?

//: 如果对其抽象出来,做一个闭包方便传入不同的对象以供方便调用,可能会写出下面的代码,是错误的:
let pc = {(child: Child) -> () in child.pet?.toy?.play()}
/*:
 原因在于对play()的调用上,定义的时候我们没有写play()的返回,这表示这个方法返回void(或者是一对小括号(),它们是等价的).但是对于上面的情况,经过Optional Chaining以后我们得到的是一个Optional的结果.正确的写法如下:
 */
let playClosure = { (child: Child) -> ()? in child.pet?.toy?.play()}

if let _: () = playClosure(xiaoming) {
    print("happy")
} else {
    print("No toys")
}



/*:
 ## 操作符
 */
struct Vector2D {
    var x = 0.0
    var y = 0.0
}

let v1 = Vector2D(x: 2.0, y: 3.0)
let v2 = Vector2D(x: 1.0, y: 4.0)
let v3 = Vector2D(x: v1.x + v2.x, y: v1.y + v2.y)

func +(left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}

let v4 = v1 + v2


//: +*

precedencegroup DotProductPrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
    
    
}

infix operator +*: DotProductPrecedence

func +*(left: Vector2D, right: Vector2D) -> Double {
    return left.x * right.x + left.y * right.y
}

let v5 = v1 +* v2

//-----------------------------------------
//------------func的参数修饰符--------------
//-----------------------------------------

func incrementor(variable: Int) -> Int {
    //variable += 1// 错误，参数variable默认是let修饰
    //return variable
    return variable + 1
}
//等效于如下代码,swift2.2之后不再支持let或var
//func incrementor(variable: let Int) -> Int {
//    variable += 1
//    return variable + 1
//}

// 可以使用
// inout相当于在函数内部创建了一个新值, 在函数返回时将这个值赋值给&修饰的变量
func incrementor(variable: inout Int) {
    variable += 1
}

var newNum = 7
incrementor(variable: &newNum)
newNum = incrementor(variable: newNum)
print(newNum)
// 注意: 函数的参数的修饰是有限制的, 对于跨层级的调用要保证同一参数的修饰符是统一的
// 返回函数的参数也需要inout, 和内部函数incrementor参数修饰符一致
func makeIncrementor(addNumber: Int) -> ((inout Int) -> ()) {
    func incrementor(varibale: inout Int) -> () {
        varibale += addNumber
    }
    return incrementor
}
makeIncrementor(addNumber: 3)(&newNum)// 9+3

//-----------------------------------------
//------------字面量表达--------------
//-----------------------------------------
// Bool 只遵守了ExpressibleByBooleanLiteral协议, 所以自定义的Bool字面量需要遵守此协议,完成协议方法init即可
enum MyBool: Int {
    case myTrue, myFalse
}

extension MyBool: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .myTrue : .myFalse
    }
}

let myTrue: MyBool = true
myTrue.rawValue

// 字符串字面量比较复杂,
// ExpressibleByStringLiteral : ExpressibleByExtendedGraphemeClusterLiteral
// ExpressibleByExtendedGraphemeClusterLiteral : ExpressibleByUnicodeScalarLiteral
// 需要实现三个协议的init方法
// 所有init方法前加required是由"初始化方法的完备性需求"决定的

// Person类没有使用扩展方式来使其可以使用自字符串赋值,这是因为在extension中,我们不能定义required的s初始化方法的.
// 也就是说我们不能为现有的非final的calss添加字面量表达(至少目前为止不可swift4.2)
class Person: ExpressibleByStringLiteral {
    var name: String
    init(name value: String) {
        self.name = value
    }
    // 两种表示形式
//    required init(stringLiteral value: String) {
//        self.name = value
//    }
    
    required convenience init(stringLiteral value: String) {
        self.init(name: value)
    }
    
//    required init(unicodeScalarLiteral value: String) {
//        self.name = value
//    }
    required convenience init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
    
//    required init(extendedGraphemeClusterLiteral value: String) {
//        self.name = value
//    }
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
}

// 此Person类可以通过字面量初始化
let person: Person = "Pinn"
person.name

//-----------------------------------------
//------------下标--------------
//-----------------------------------------
// 数组 字典已经实现下标访问

let arr = [1,2,3]
arr[2]
let dict = ["one": 1, "two": 2, "three": 3]
dict["one"]

// 扩展数组下标实现通过下标数组访问数组元素
// 不推荐此种方式,可以使用参数列表实现会更加清晰优雅
extension Array {
//    subscript(input: Int...) -> ArraySlice<Element> {
//        get {
//            return [......]
//        }
//        set {
//
//        }
//    }
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        set {
            for (index, i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
var newArr = [1,2,3,4,5,6,7,8,9,0]
newArr[[2,4,7]]
newArr[[3,6,8]] = [-3,-6,-8]
newArr

//-----------------------------------------
//------------命名空间--------------
//-----------------------------------------

// 同一个target属于同一个命名空间
// 除了使用不同target, 还可以通过包装结构体实现隔离

struct MyClassContainer1 {
    class MyClass {
        class func hello() {
            print("Container1")
        }
    }
}

struct MyClassContainer2 {
    class MyClass {
       class func hello() {
            print("Container2")
        }
    }
}

MyClassContainer1.MyClass.hello()
MyClassContainer2.MyClass.hello()

//-----------------------------------------
//------------typealias--------------
//-----------------------------------------

// 1.常规用法同typedefine
// 2.对于泛型
class Biology<T>{
    
}
// 错误
//typealias Bird = Biology
//typealias Fish = Biology<T>
//let fh = Bird()
//let bqt = Fish()
// 正确
typealias Mammal<T> = Biology<T>
let sz = Mammal<Any>()
// 3.在协议中的x使用场景
protocol Cat {}
protocol Dog {}
typealias Pat = Cat & Dog
// 遵守多个协议
extension Biology: Pat {
    
}

//-----------------------------------------
//------------associatedtype--------------
//-----------------------------------------

protocol Food {}
protocol Animal {
    func eat(_ food: Food)
}

struct Meat: Food {}
struct Grass: Food {}

struct Tiger: Animal {
    func eat(_ food: Food) {
        // 所有的逻辑判断在此处理, 把责任扔给运行时, 不太友好;
        // 更好的方式是让编译器处理, 保证老虎不吃草的条件
        // 这时就可以使用associatedtype
        if let meat = food as? Meat {
            print("eat \(meat)")
        } else {
            fatalError("Tiger can only eat meat")
        }
    }
}

let meat = Meat()
Tiger().eat(meat)

// 无法编译通过
//struct Wolf: Animal {
//    func eat(_ food: Meat) {
//        print("eat \(food)")
//    }
//}
//协议中除了定义属性和方法外,还可以定义类型的占位符,让实现协议的类型来指定具体的类型.
//使用addociatedtype可以在Animal协议中添加一个限定,让Wolf来指定食物的具体类型
//此时我们需要修改协议如下
protocol Animal_new {
    associatedtype F: Food // 添加:Food限制F的类型
    func eat(_ food: F)
}
struct Wolf: Animal_new {
    typealias F = Meat
    func eat(_ food: Meat) {
        print("eat \(food)")
    }
}
struct Sheep: Animal_new {
    func eat(_ food: Grass) {
        print("eat \(food)")
    }
}
let meat_blood = Meat()
let grass = Grass()
//Wolf().eat(grass)//让狼吃草是不可能的
Wolf().eat(meat_blood)


//-----------------------------------------
//------------可变参数函数--------------
//-----------------------------------------

//OC中字符串的格式话就是可变参数函数[NSString stringWithFormat:@"%..%..%..", ..x..];
//String(format: "%d%s", arguments: 1,"one")
let s = String(format: "%d-%@", 1, "one")

//系统对NSString的扩展
//extension NSString {
//    public convenience init(format: NSString, _ args: CVarArg...)
//}
let ns = NSString(format: "%@", "hello")


