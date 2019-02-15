//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

//: [Next](@next)


extension Int {
    func randomArray(_ max: UInt32) -> [UInt] {
        var arr: [UInt] = []
        for _ in 1...self {
            let o = UInt(arc4random_uniform(max))
            arr.append(o)
        }
        return arr
    }
}

var arr = 20.randomArray(100)


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

var a = 3, b = 5
(a, b)=(b, a)
a
b

//:选择排序

var selArr = 5.randomArray(20)

for j in 0...selArr.count-1 {
    var k = j
    var i = j+1
    while i<selArr.count {
        if selArr[i] < selArr[k] {
            k = i
        }
        i = i+1
    }
    if k != j {
        (selArr[j], selArr[k]) = (selArr[k], selArr[j])
    }
}

selArr

let btn = PNButton(image: "1", title: "浇水", frame: CGRect(x: 0, y: 0, width: 50, height: 80) )

PlaygroundPage.current.liveView = btn

