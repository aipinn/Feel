import UIKit

var str = "Hello, Class and Object"

/// 对象和类

class Shap {
    var numberOfSides = 0
    var color: UIColor?

    func simpleDesc() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    func drawColor(color: UIColor, defaultColor: UIColor = UIColor.white) {
        
    }
    
}

// 初始化器
var shape = Shap()
shape.simpleDesc()


class NamedShape {
    var name: String
    var numberOfSise = 0
    init(name: String) {
        self.name = name
    }
    
    func simpleDesc() -> String {
        return "A square with \(numberOfSise) sides."
    }
}

//子类
class Square: NamedShape {
    var sideLength: Double
    
    init(sideLength: Double ,name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSise = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDesc() -> String {
        return "A square with sides of length \(sideLength)."
    }
    
}

let ss = Square(sideLength: 5, name: "My Shape")
ss.area()
ss.simpleDesc()


// 除了存储属性,还可以拥有带有getter和setter的计算属性
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0
    /*
     注意 EquilateralTriangle类的初始化器有三个不同的步骤：
     
     设定子类声明的属性的值；
     调用父类的初始化器；
     改变父类定义的属性中的值，以及其他任何使用方法，getter 或者 setter 等需要在这时候完成的内容。
     */
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSise = 3
    }
    var perimter: Double {
        get {
            return 3 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
        /* 自定义setter名字
        set (newValueName) {
            sideLength = newValueName / 3.0
        }
        */
    }
    
    override func simpleDesc() -> String {
        return "An equilateral triangel with side of length \(sideLength)"
    }
}

var triangle = EquilateralTriangle(sideLength: 3, name: "Equal Triangle")
print(triangle.perimter)
triangle.perimter =  18
print(triangle.sideLength)

//如果你不需要计算属性但仍然需要在设置一个新值的前后执行代码，使用 willSet和 didSet。

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            suqare.sideLength = newValue.sideLength
        }
    }
    var suqare: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    
    init(size: Double, name: String) {
        suqare = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

let optionalSquare: Square? = Square(sideLength: 3.3, name: "optional square.")
let sideLength = optionalSquare?.sideLength
