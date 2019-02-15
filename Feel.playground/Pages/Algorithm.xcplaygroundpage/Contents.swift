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

do {
    //: 归并排序
    var new: [Int] = []
    for i in 0...7 {
        new.append(i)
    }
    new = [2,4,5,7,1,2,3,6]
    /*:
     * 将一个数组的两个相邻有序区间合并成一个
     arr: 包含两个有序区间的数组
     low: 第一个有序区间的起始地址
     mid: 第一个有序区间的结束地址,也是第二个有序区间的起始地址
     hige:第二个有序区间的结束地址
     */
    func mergeArr(_ arr: inout [Int], _ low: Int, _ mid: Int, _ high: Int) {
        var i = low
        var j = mid+1
        var k = 0
        var temp = Array<Int>(repeatElement(0, count: high-low+1))//临时数组
        
        while i <= mid && j <= high {
            if arr[i] < arr[j] {
                temp[k] = arr[i]
                k += 1
                i += 1
            } else {
                temp[k] = arr[j]
                k += 1
                j += 1
            }
        }
        //高序列先越界
        while i <= mid {
            temp[k] = arr[i]
            i += 1
            k += 1
        }
        //低序列先越界
        while j <= high {
            temp[k] = arr[j]
            j += 1
            k += 1
        }
        
        //将排列好的序列复制回原序列
        k = 0;
        for i in low...high {
            arr[i] = temp[k]
            k += 1
        }
    }
    //归并排序
    func mergeSort(_ arr: inout [Int]) {
        var gap = 1//1,2,4,8,16...
        while gap < arr.count {
            mergePass(&arr, gap: gap)
            gap *= 2
        }
    }
    //分解合并序列
    func mergePass(_ arr: inout [Int], gap: Int) {
        var i = 0
        let count = arr.count
        
        while i + 2*gap - 1 < count {
            mergeArr(&arr, i, i+gap-1, i+2*gap-1)
            i = i + 2*gap
        }
        //合并剩余序列
        if i+gap-1 < count {
            mergeArr(&arr, i, i+gap-1, count-1)
        }
    }

    var array = [2, 5, 8, 9, 10, 4, 3, 16, 1, 7, 8];

    mergeSort(&array);
}
    
/*:
 时间复杂度
 nlgn
 */

/*:
 快速排序(采用分治法)
 在时间复杂度为O(nlogn)中较快的方法
 */
do {
    //1.调整数组, 返回调整后的基数的位置
    func AdjustArr(_ arr: inout [Int], _ left: Int, _ right: Int) -> Int {
        var i = left
        var j = right
        //基数
        let b = arr[left]
        while i < j {
            //自右向左查找比基数小的数
            while i < j && arr[j] >= b {
                j = j - 1
            }
            if (i < j) {
                arr[i] = arr[j]
                i = i + 1
            }
            //自左向右查找比基数大的数
            while i < j && arr[i] <= b {
                i = i + 1
            }
            if i < j {
                arr[j] = arr[i]
                j = j - 1
            }
        }
        //确定基数的位置
//        if i == j {
            arr[i] = b
//        }
        return i
    }
    
    //2.分治
    func QuickSqrt(_ arr: inout [Int], _ left: Int, _ right: Int) {

        if left < right {
            var idx = AdjustArr(&arr, left, right)
            QuickSqrt(&arr, left, idx-1)
            
            QuickSqrt(&arr, idx+1, right)
            
            
        }
    }
    
    var arr: [Int] = [72, 6, 57, 88, 60, 42, 83, 73, 48, 85]

    //QuickSqrt(&arr, 0, arr.count-1)
    
    //合并代码
    func QS(_ arr: inout [Int], _ left: Int, _ right: Int) {
        
        if left < right {
            var i = left
            var j = right
            //基数
            let b = arr[left]
            while i < j {
                //自右向左查找比基数小的数
                while i < j && arr[j] >= b {
                    j = j - 1
                }
                if (i < j) {
                    arr[i] = arr[j]
                    i = i + 1
                }
                //自左向右查找比基数大的数
                while i < j && arr[i] <= b {
                    i = i + 1
                }
                if i < j {
                    arr[j] = arr[i]
                    j = j - 1
                }
            }
            //确定基数的位置
            arr[i] = b
            QuickSqrt(&arr, left, i-1)
            QuickSqrt(&arr, i+1, right)
        }
    
    }
    QS(&arr, 0, 9)
    
    
}
