import UIKit

var str = "Hello, playground"

// 指定数组类型
let label = "label"
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

let ssss = """
I am a corder
    hello world!
"""

print(ssss)

