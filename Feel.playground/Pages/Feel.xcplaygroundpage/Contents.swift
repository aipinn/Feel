//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

var arr: [UInt32] = []
for _ in 1...20 {
    let o = arc4random_uniform(100)
    arr.append(o)
}

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


