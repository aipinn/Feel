import UIKit

var str = "Hello, Function"
/// 函数,函数是一等公民,可以作为参数,返回值,可以嵌套
func greet(person: String, day: String) -> String {
    return person + day;
}

greet(person: "AL", day: "Mon")

//自定义实参标签on
func greet(_ person: String, on day: String) -> String {
    return person + day;
}
greet("name", on: "fir")

/// 元组返回符合值,返回多个值
func calculate(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    
    return (min, max, sum)
}
// 元组可以通过名字和下标获取值
let ret = calculate(scores: [3,5,7,9,10,3])
let sum = ret.sum
let second = ret.1

// 函数接收可变参数,在函数内部通过数组获取
func sumOf(numbers: Int...) -> Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}

sumOf()
sumOf(numbers: 1,2,3,4)

// 函数内嵌
// 内部函数可以访问外部函数的变量
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}

returnFifteen()

// 返回函数
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return number + 1
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

// 函数作为参数
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}

func lessThanTen(number: Int) -> Bool {
    return number < 10
}

var numbers = [20, 19, 17, 23]
hasAnyMatches(list: numbers, condition: lessThanTen)

/// 闭包
// 函数其实是闭包的一种特殊性形式:一段可以被随后调用的代码块。
// in 分割实际参数和返回值类型
numbers.map ({ (number: Int) -> Int in
    let ret = 3 * number
    return ret
})
// 当一个闭包的类型已经可知,可以省略参数类型,返回类型或全部去掉
// 如果闭包是函数的唯一参数，你可以去掉圆括号直接写闭包。
numbers.map {number in number * 3}
let mappedNum = numbers.map ({number in number * 3})

let sortedInc = numbers.sorted { (a, b) -> Bool in
    return a < b
}
print(sortedInc)

let sortedDec = numbers.sorted {$0 > $1}
print(sortedDec)



class myList {
   
    func mySort() {
        
    }
}

var list: myList?

list?.mySort()
