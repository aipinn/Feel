//: [Previous](@previous)

import Foundation
import UIKit
var str = "Hello, playground"

//: [Next](@next)


/*:
 ## 1. 交换两个整形变量的值
 1. 定义临时变量
 2. 使用元组
 3. 使用加法
 4. 使用异或
    - 一个整与自己异或为0
    - 一个整与0异或为本身
 */

5 ^ 5
5 ^ 0
//: 使用加法
func swapIntAdd(_ a: inout Int, _ b: inout Int) {
    a = a + b
    b = a - b
    a = a - b
}

var a = 10, b = 3
swapIntAdd(&a, &b)
a
b

//: 使用异或
func swapIntXor(_ a: inout Int, _ b: inout Int) {
    if a == b {
        return
    }
    a = a ^ b
    b = a ^ b
    a = a ^ b
}

swapIntXor(&a, &b)
a
b

/*:
 ## 2. 求最大公约数
 扩展: 最小公倍数 = (a * b)/最大公约数
 */

//: ### 直接遍历法
do {
    func maxCommonDivisor(a: Int, b: Int) -> Int {
        var max = 0
        for i in 1...a {
            if a%i == 0 && b%i == 0 {
                max = i
            }
        }
        return max
    }

    let max = maxCommonDivisor(a: 15, b: 18)
}

//: ### 辗转相除法
do {
    func maxCommonDivisor(a: inout Int, b: inout Int) -> Int {
        var r = 0
        while a % b > 0 {
            r = a % b
            a = b
            b = r
        }
        return b
    }
    var a = 12, b = 15
    let max1 = maxCommonDivisor(a: &a, b: &b)
}

do {
    
    var arr: NSArray = [1, 3, 6, 8, 10, 20]
    let idx = arr.index(of: 7, inSortedRange: NSRange(location: 0, length: arr.count), options: .insertionIndex, usingComparator: { obj1, obj2 in
        print("obj1:\(obj1), obj2:\(obj2)")
        return .orderedAscending
    })
    print(idx)

}

//: ## 3.字符串逆序输出
do {
    let str = "hello world !"//0->12=13
    for i in str.reversed() {
        //print(i)
    }
    
    //最后一个值包含through的值
    for i in stride(from: str.count-1, through: 0, by: -1) {
        let char: Character = str[str.index(str.startIndex, offsetBy: i)]
        //print(char)
    }
    //最后一个值不包含to的值
    for i in stride(from: str.count-1, to: -1, by: -1) {
        let char: Character = str[str.index(str.startIndex, offsetBy: i)]
        //print(char)
        //print(i)
    }
    
    for i in (0...str.count-1).reversed() {
        //print(i)
        let char = str[str.index(str.startIndex, offsetBy: i)]
        //print(char)
    }
    
}

/*:
 ## 4.阶乘
 ### 1. 递归
 递归的基本原理:
 1. 退出条件
 2. 递归
 3. 尾递归优化
 
 > 0的阶乘等于1
 
 ### 2. 循环相乘
 */

//n太大导致崩溃
func Factorial(n: Int) -> Int {
    if n == 0 || n == 1 {
        return 1;
    }
    return n * Factorial(n: n-1)
}

Factorial(n: 5)

//尾递归优化
func TailFactorial(_ n: Int) -> Int {
    
    func FactorialIn(n: Int, current: Int) -> Int {
        if n == 0 || n == 1 {
            return current
        } else {
            return FactorialIn(n: n-1, current: n * current)
        }
    }
    
    return FactorialIn(n: n, current: 1)
}

TailFactorial(10)

//使用数组解决超大数字阶乘溢出问题

func BigFactorial(_ n: Int) -> String {
    
    if n == 1 || n == 0 {
        return "1"
    }
    var f = [1]//初始化
    for i in 1...n {
        //var sin = SeparatorSingle(f)
        f = Itera(arr: &f, num: i)
    }
    //逆序输出
    var str: String = ""
    for i in f.reversed() {
        str.append("\(i)")
    }
    return str
}

//引入数组
func Itera(arr: inout [Int], num: Int) -> [Int] {
    //遍历数组
    var s: Int = 0, l: Int = 0, h: Int = 0
    for (idx, i) in arr.enumerated() {
        //分离个位和其他位(除以10取余数为个位,取整为其他位)
        s = num * i + h
        l = s % 10//余数
        h = s / 10//整数
        arr[idx] = l
    }
    
    if h != 0 {
        //print(h)
//        var m: Int = 0
//        var tmp: [Int] = []
//        if h != 0 {
//            while h > 0 {
//                m = h % 10
//                h = h / 10
//            }
//            tmp.append(m)
//        }
//        arr.append(contentsOf: tmp.reversed())
        arr.append(h)
    }
    return arr
}

//"2432902008176640000"
//BigFactorial(20)


/*:
 ## 5.判断质数/素数
 质数定义为在大于1的自然数中,约数只有1和本身的整数称为质数，或称素数。
 */

//: * 直观判断

do {
    func isPrime(_ num: Int) -> Bool {
        if num <= 1 {
            print("输入必须大于1")
            return false
        }
        for i in 2..<num {
            if num % i == 0 {
                return false
            }
        }
        return true
    }
    isPrime(5)
    
}

/*:
 * 直观法改进
 一个数可以分解的话,一定是一个大于等于sqrt(n), 另一个小于等于sqrt(n), 只需要遍历到sqrt(n)即可
*/

do {
    func isPrime(_ num: Int) -> Bool {
        if num <= 1 {
            print("输入必须大于1")
            return false
        }
        for i in 2...Int(sqrt(Double(num))) {
            if num % i == 0 {
                return false
            }
        }
        return true
    }
    isPrime(101)
}

/*:
 * 另一种更高效的方法
 */

do {
    func isPrime(_ num: Int) -> Bool {
        if num == 2 || num == 3 {
            return true
        }
        //不在6的倍数两侧的一定不是质数
        if num % 6 != 1 && num % 6 != 5 {
            return false
        }
        
        //在6的倍数两侧也可能不是质数
        //stride(from: to:by:) 左闭右开和stride(from:though:by:)闭区间
        //循环的步长可以定为6，每次判断循环变量k和k+2的情况即可
        for i in stride(from: 5, through: Int(sqrt(Double(num))), by: 6) {
            if num % i == 0 || num % (i + 2) == 0 {
                return false
            }
        }
        return true
    }
    //https://blog.csdn.net/huang_miao_xin/article/details/51331710
    isPrime(53)
}

/*:
 斐波那切数列生成\求和
        0             n = 0
 f(n) = 1             n = 1
        f(n-1)+f(n-2) n >=2
 
 */

do {
    /*
     求裴波那契数列的第n项
     使用递归计算时存在大量的重复计算问题,可以使用二叉树表示, 时间复杂度是指数级
     2^((n+1)/2+1)-1 其中"/"除号取整
     时间复杂度为: O(2^n)
     */

    func fibs(_ num: Int) -> Int {
        if num <= 0 {
            return 0
        }
        if num == 1 {
            return 1
        }
        return fibs(num-1) + fibs(num-2)
    }
    //fibs(30)
    
    //改进:从下往上计算,时间复杂度为O(n)
    func fibseq(_ n: Int) -> Int{
        var result = [0, 1]
        if n < 2 {
            return result[n]
        }
        var a = 0
        var b = 1
        var fib = 0
        for i in 2...n {
            fib = a + b
            a = b
            b = fib
        }
        return fib
    }
    fibseq(8)
    
    //小于某值得fib数列
    func FibonacciSequence(_ max: Int) -> [Int] {
        if max == 0 {
            return [0]
        }
        if max == 1 {
            return [1]
        }
        var a = 0
        var b = 1
        var seq: [Int] = [1]
        var s = 0
        
        while s < max {
            s = a + b
            a = b
            b = s
            if s <= max {
                seq.append(s)
            }
        }
        
        return seq
    }
    
    FibonacciSequence(30)
}
