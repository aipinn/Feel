//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

//: [Next](@next)

//主view
let view = UIView(frame: CGRect(x: 0, y: 10, width: 375, height: 667))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view

let redView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
redView.backgroundColor = .red
view.addSubview(redView)

let moveAnia = CABasicAnimation()
moveAnia.keyPath = "position.x"
moveAnia.fromValue = 0
moveAnia.toValue = 300
moveAnia.duration = 2.0
//moveAnia.byValue = 100
//moveAnia.timingFunction = CAMediaTimingFunction(name: .easeIn)
moveAnia.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0, 0.9, 0)


//保持最后状态:两种方法
//推荐
redView.layer.add(moveAnia, forKey: "basic")
redView.layer.position = CGPoint(x: 300, y:15)
//或者
//moveAnia.fillMode = .forwards
//moveAnia.isRemovedOnCompletion = false
//redView.layer.add(moveAnia, forKey: "basic")

//实际创建的动画被添加到layer上时就立刻被复制了一份,这个特性在多个view动画中可以重用
let blueView = UIView(frame: CGRect(x: 0, y: 50, width: 60, height: 30))
blueView.backgroundColor = .blue
view.addSubview(blueView)

//只会影响blueView的动画开始时间.不会对redView产生影响
moveAnia.beginTime = CACurrentMediaTime() + 1.0
moveAnia.isAdditive = true
moveAnia.byValue = 300
moveAnia.fillMode = .forwards
moveAnia.isRemovedOnCompletion = false
blueView.layer.add(moveAnia, forKey: "basic")
//blueView.layer.position = CGPoint(x: 300, y: 65)


let tf = UITextField(frame: CGRect(x: 20, y: 100, width: 150, height: 30))
tf.placeholder = "关键帧-抖动"
tf.borderStyle = .roundedRect
view.addSubview(tf)
var keyAnim = CAKeyframeAnimation()
keyAnim.keyPath = "position.x"
keyAnim.values = [0, 10, -10, 10, 0]
keyAnim.keyTimes = [NSNumber(value: 0), NSNumber(value: (1/6.0)),  NSNumber(value: (3/6.0)),  NSNumber(value: (5/6.0)),  NSNumber(value: (1.0))]
keyAnim.duration = 0.4

//将当前的values添加到model layer中.
//设置相对位置,使视图在当前位置抖动.否则会将属性值按values的值进行变动.
keyAnim.isAdditive = true

keyAnim.repeatCount = 5
tf.layer.add(keyAnim, forKey: "shake")


let satellite = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
satellite.backgroundColor = .orange
var boundingRect = CGRect(x: 50, y: 150, width: 200, height: 200)
var orbit = CAKeyframeAnimation()
view.addSubview(satellite)

orbit.keyPath = "position"
orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
orbit.duration = 4
orbit.isAdditive = true
orbit.repeatCount = 1000
orbit.calculationMode = .paced//设置为.paced将无视设置的所有keyTimes
orbit.rotationMode = .rotateAuto//自转,设置为nil只公转不自转
satellite.layer.add(orbit, forKey: "orbit")



let card = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
card.backgroundColor = .cyan
view.addSubview(card)

let zPosition = CABasicAnimation()
zPosition.keyPath = "zPosition"
zPosition.fromValue = -1
zPosition.toValue = 1
zPosition.duration = 1.2

let rotation = CAKeyframeAnimation()
rotation.keyPath = "transform.rotation"
rotation.values = [0, 0.5, 0]
rotation.duration = 1.2
rotation.timingFunctions = [
    CAMediaTimingFunction(name: .easeInEaseOut),
    CAMediaTimingFunction(name: .easeInEaseOut),
]

let position = CAKeyframeAnimation()
position.keyPath = "position"
position.values = [
NSValue(cgPoint: CGPoint.zero),
NSValue(cgPoint: CGPoint(x: 110, y: -20)),
NSValue(cgPoint: CGPoint.zero)
]
position.timingFunctions = [
CAMediaTimingFunction(name: .easeInEaseOut),
CAMediaTimingFunction(name: .easeInEaseOut)
]
position.isAdditive = true
position.duration = 1.2

var group = CAAnimationGroup()
group.animations = [zPosition, rotation, position]
group.duration = 1.2
//group.beginTime = 0.5
card.layer.add(group, forKey: "shuffle")
card.layer.zPosition = 1


var myView = UIView()
myView.backgroundColor = .purple
//myView.center = view.center
//myView.bounds.size = CGSize(width: 100, height: 100);
view.addSubview(myView)


import Masonry

//myView.mas_makeConstraints { make in
//    make?.center.equalTo()
//    make?.width.equalTo()(50)
//    make?.height.equalTo()(50)
//}

let img = UIImageView()
img.image = UIImage(named: "arrow_right")
view.addSubview(img)
img.mas_makeConstraints { make in
    make?.center.equalTo()
}
