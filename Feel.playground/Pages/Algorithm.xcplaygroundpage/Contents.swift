//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

extension Int {
    func randomArray(_ max: UInt32) -> [UInt] {
        var a: [UInt] = []
        for _ in 0...self {
            a.append(UInt(arc4random_uniform(max)))
        }
        return a
    }
}

var arr = 10.randomArray(20)

//: 插入排序
//5,2,4,6,1,3
for j in 1...arr.count-1 {
    //保存游标值key
    let key = arr[j]
    
    var i = j - 1
    while i >= 0, arr[i] > key {//更换为小于号'<'切换为降序
        //移位(右移)
        arr[i+1] = arr[i]
        i = i - 1
    }
    //确定key的适当位置
    arr[i+1] = key
}
arr
/*:
 时间复杂度
 n^2
*/

//: 利用元组交换多个值
var a = 2, b = 3, c = 4
(a, b, c) = (c, a, b)
a
b
c
//: 选择排序

var selArr = 5.randomArray(20)
for i in 0...selArr.count - 1 {
    var idx = i//idx指向最小元素的索引
    var j = i+1
    while j < selArr.count {
        if (selArr[j] < selArr[i]) {
            idx = j
        }
        j = j + 1
    }
    if i != idx {
        (selArr[i], selArr[idx]) = (selArr[idx], selArr[i])
    }
}
selArr
/*:
 时间复杂度
 
 */

//: 冒泡排序
var bubbling = 10.randomArray(100)

for i in 0...bubbling.count-1 {
    
    var j = i+1
    while j < bubbling.count {
        if bubbling[i] > bubbling[j] {
            (bubbling[i], bubbling[j]) = (bubbling[j], bubbling[i])
        }
        j = j+1
    }
}

bubbling


//: 归并排序
func merge(arr:[Int], p: [Int], q: [Int], r: [Int]) {
    
}
