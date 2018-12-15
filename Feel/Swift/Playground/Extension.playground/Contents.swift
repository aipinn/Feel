import UIKit

var str = "Hello, Extension"


// 扩展
// 扩展没有名字
// 可以向每一个类型添加新的方法,但不能重写已有的方法
// 扩展可以添加新的计算属性，但是不能添加存储属性，也不能向已有的属性添加属性观察者。

//计算属性
extension Double {
    // 省略get关键字,只读属性
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    /// 英尺
    var ft: Double{ return self / 3.28084 }
}
let oneft = 1.ft
let two = 2.km.cm //2000cm等于多少米


//初始化器
struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}


extension Rect {
    /// 扩展初始化器
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
// 如果使用扩展提供一个新的初始化器,要确保每一个实例都在初始化完成时完全初始化
let centerRect = Rect(center: Point(x: 3, y: 3),
                      size: Size(width: 3, height: 4))

// 方法
// 可以添加实例方法和类方法
extension Int {
    func repetitions(task: ()-> Void) {
        for _ in 0..<self {
            task()
        }
    }
}


3.repetitions {
    print("Hello")
}

// 异变实例方法
// 扩展方法可以修改实例本身,结构体和枚举类型方法修改self或本身的属性必须标记实例方法为mutating

extension Int {
    mutating func square() {
        self = self * self
    }
}

var someInt = 5
someInt.square()

// 下标
// 扩展能为已有的类型添加下标.
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

73489585895[3]
// 自动补0
2453[9]

// 内嵌类型
// 扩展可以为已有的类 结构体 枚举添加新的内嵌类型
extension Int {
    // 添加枚举类型
    enum Kind {
        case nagative, zero, positive
    }
    // 添加计算属性
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .nagative
        }
    }
}

9.kind
