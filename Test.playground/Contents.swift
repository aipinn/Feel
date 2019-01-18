import UIKit
import PlaygroundSupport
import QuartzCore

var str = "Hello, playground"


let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
bgView.backgroundColor = .white
PlaygroundPage.current.liveView = bgView


let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
btn.backgroundColor = UIColor.blue
btn.setTitle("下一步", for: .normal)
btn.setTitleColor(UIColor.white, for: .normal)

let layer = CAGradientLayer()
layer.frame = btn.bounds
layer.startPoint = CGPoint(x: 0, y: 0)
layer.endPoint = CGPoint(x: 1, y: 0)
layer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
layer.locations = [0.0, 1.0]
//: > 注意:此处是插入在最底层,不然会覆盖设置文字的layer
btn.layer.insertSublayer(layer, at: 0)
bgView.addSubview(btn)




