//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

//: [Next](@next)

let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
view.backgroundColor = .brown
PlaygroundPage.current.liveView = view

let vv = UIView(frame: CGRect(x: 40, y: 60, width: 120, height: 80))
vv.backgroundColor = .cyan
view.addSubview(vv)

UIView.animate(withDuration: 2.0) {
    vv.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
}

//: ## 改变Layer的属性

//: 1. 隐式动画, 直接改变对象的一个属性,默认时间是0.25秒
/*
UIView.animate(withDuration: 2) {

    vv.layer.opacity = 0.2
}
*/



/*:
 2. 显式动画
     不像隐式动画那样会更新并改变对象的数据,
     显示动画不会改变layer树数据值,只是提供动画;
     当动画完成后,核心动画会从layer对象移除动画并用当前值重绘layer,
     如果要保持持久不变,必须手动更新改变对象的属性值.
 */
let layer = CALayer()
layer.backgroundColor = UIColor.red.cgColor
layer.frame = CGRect(x: 0, y: 100, width: 80, height: 80)
view.layer.addSublayer(layer)
var fadeAnim = CABasicAnimation(keyPath: "opacity")
fadeAnim.fromValue = 1.0//不指定from会从当前的值开始变化
fadeAnim.toValue = 0.2
fadeAnim.duration = 5.0

//透明度
layer.add(fadeAnim, forKey: "opacity")
layer.opacity = 0.5

//: ### 关键帧动画

var thePath = CGMutablePath()
thePath.move(to: CGPoint(x:10, y: 100), transform: .identity)
thePath.addCurve(to: CGPoint(x: 200, y: 100), control1: CGPoint(x: 0, y: 300), control2: CGPoint(x: 200, y: 300))
thePath.addCurve(to: CGPoint(x: 300, y: 100), control1: CGPoint(x: 200, y: 300), control2: CGPoint(x: 300, y: 300))

//位置
let theAnim = CAKeyframeAnimation(keyPath: "position")
theAnim.path = thePath
theAnim.duration = 5.0
layer.add(theAnim, forKey: "position")
layer.position = CGPoint(x: 300, y: 100)//固定最后的位置

//背景颜色
var val = [UIColor.red.cgColor, UIColor.green.cgColor,
           UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.orange.cgColor]
let colorAnim = CAKeyframeAnimation(keyPath: "backgroundColor")
colorAnim.values = val//values数组中可以添加多种属性,必须是对象类型
colorAnim.duration = 5.0
layer.add(colorAnim, forKey: "backgroundColor")
layer.backgroundColor = val.last

//: 3. 移除动画, 不能移除隐式动画
//layer.removeAnimation(forKey: "opacity")
//layer.removeAllAnimations()

//: 4 .多个动画一起执行,动画组
do {
let widthAnim = CAKeyframeAnimation(keyPath: "borderWidth")
let widthValues = [NSNumber(value: 1.0), NSNumber(value: 10.0), NSNumber(value: 5.0), NSNumber(value: 30.0), NSNumber(value: 0.5), NSNumber(value: 15.0), NSNumber(value: 2.0), NSNumber(value: 50.0), NSNumber(value: 0.0)]
widthAnim.values = widthValues
widthAnim.calculationMode = .paced
// Animation 2
let colorAnim = CAKeyframeAnimation(keyPath: "borderColor")
let colorValues = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
colorAnim.values = colorValues
colorAnim.calculationMode = .paced
// Animation group
let group = CAAnimationGroup()
group.animations = [colorAnim, widthAnim]
group.duration = 5.0
layer.add(group, forKey: "BorderChanges")
    
}

//: 5. 监听(detecting)动画的结束状态
/*:
 - 当前事务的block
 - CAAnimation的代理
 */

CATransaction.begin()
CATransaction.setCompletionBlock {
    print("---事务完成---")
}
CATransaction.setAnimationDuration(5)
vv.layer.cornerRadius = 40
CATransaction.commit()

//: 6. UIView动画

let orangeV = UIView(frame: CGRect(x: 0, y: 400, width: 100, height: 50))
orangeV.backgroundColor = .orange
view.addSubview(orangeV)
//UIView.animate(withDuration: 3) {
//    orangeV.layer.opacity = 0.2
//
//    let b = CABasicAnimation(keyPath: "position")
//    b.fromValue = NSValue.init(cgPoint: orangeV.layer.position)
//    b.toValue = NSValue.init(cgPoint: CGPoint(x: 100, y: 500))
//    b.duration = 5
//    orangeV.layer.add(b, forKey: "AnimateFrame")
//
//}

//: Advanced Animation tricks, 高级动画技巧

let transition = CATransition()
transition.startProgress = 0
transition.endProgress = 1.0
transition.type = .push
transition.subtype = .fromRight
transition.duration = 3.0

orangeV.layer.add(transition, forKey: "transition")
vv.layer.add(transition, forKey: "transition")

//orangeV.isHidden = true
//vv.isHidden = false

let filter = CIFilter.filterNames(inCategory: "")

