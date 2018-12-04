import UIKit

var str = "Hello, playground"

let label = "Label's width is "
let width = 94
let Lw = label + String(width) + " \(label) \(width)"

let mulstr = """
This is first line
    This is second line
"""

// 指定数组类型
var arr: [String] = []
arr = []
arr.append(label)
arr = [String]()
//arr = [Int]()//不能修改数组类型

// 可以存储任意类型
var typeArr = [Any]()
typeArr.append(12)
typeArr.append("String type")
typeArr.append(arr)

// 字典的key必须可以哈希
// 哈希:一个对象在他的生命周期内是不可变的就可以哈希
// 如果一个可散列对象与另一个可散列对象是相等的，那么他们的散列值hash value一定是相等的。
var dic = [String : Int]()
var mDic = [String : Int]()
var dict = [dic : Int()]
dic["one"] = 1
dict.hashValue
dic["two"] = 2
dict.hashValue

let addrB = String(format: "%p", dic)

dic = mDic

let addrA = String(format: "%p", dic)

dict.hashValue




/// 对象和类

class Shap {
    
    var numberOfSides = 0
    var name: String
    var color: UIColor?
    
    
    
    init(name: String) {
        self.name = name
    }
    
    
    
    func simpleDesc() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    func drawColor(color: UIColor, defaultColor: UIColor = UIColor.white) {
        
    }

}


