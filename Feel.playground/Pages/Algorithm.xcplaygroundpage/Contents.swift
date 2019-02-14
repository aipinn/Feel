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
 n^2
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
/*:
 时间复杂度
 n^2
 */


//: 归并排序
var new: [Int] = []
for i in 0...7 {
    new.append(i)
}
new = [2,4,5,7,1,2,3,6]
func merge(_ arr: [Int], _ min: Int, _ mid: Int, _ max: Int) {
    
}
merge(new, 0, 3, 7) {
    
}

/*:
 时间复杂度
 nlgn
 */

/*:
 快速排序(采用分治法)
 在时间复杂度为O(nlogn)中较快的方法
 */

func QuickSqrt(arr: [Int], left: Int, right: Int) {
    var i = left
    var j = right
    //基数
    var b = arr[0]
    while i < j {
        while j < i && arr[j] <= b {
            j = j - 1
        }
        arr[i] = arr[j]
    
        while i < j && arr[i] >= b {
            i = i + 1
        }
        arr[j] = arr[i]
    }
    
}
