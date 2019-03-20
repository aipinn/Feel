import UIKit

var str = "Hello, Flow"

/// ==============控制流=============

/// swift 判断条件不再隐式与0做计算,必须是布尔表达式
var scores = [45,56,23,54,65,23,50,89]
let scoresStr = ["1", "3","5"]
var ts = 0
for score in scores {
    if score > 50 {
        ts += 3
    } else {
        ts += 1
    }
    
}

for str in scoresStr {
    let l = str.lengthOfBytes(using: .utf8)
    if l > 0 {
        print(l)
    }
}

/// if let 保存可能丢失的值
var optionStr: String? = "hello"

var greeting = "Hello "
var optionalName: String? = "pinn"

if let name = optionalName {
    greeting = greeting + name
}else{
    greeting = greeting + "who"
}
/// ?? 提供默认值
var defName = "swift"

greeting = "Hi \(optionalName ?? defName)"


/// switch 可以支持任意类型, 不需要显示添加break

let vagetable = "red pepper"
switch vagetable {
case "celery":
    print(vagetable)
case "red":
    print("red")
case let x where x.hasPrefix("red"):
    print(x)
default:
    print("No match")
}

/// 遍历字典
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0

for (_, value) in interestingNumbers {
    for num in value {
        if num > largest {
            largest = num
        }
    }
}
print(largest)

var n = 2
while n < 100 {
    n = n * 2
}
print(n)

/// do while
var m = 2
repeat {
    m = m * 2
} while m < 100
print(m)

/// 创建序列区间 ..<   ...
var total = 0

//闭区间
for i in 0...4 {
    total += i
}
//开区间
for i in 0..<4 {
    total += i
}
print(total)
