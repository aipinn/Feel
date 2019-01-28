//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

//: [Next](@next)

class PNButton: UIControl {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    init(image: String, title: String, frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 40))
        addSubview(imageView!)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 40, width: frame.size.width, height: 40))
        
       addSubview(titleLabel!)
        let img = UIImage(named: "share")
        imageView?.image = img
        titleLabel?.text = title
    }
}

let btn = PNButton(image: "1", title: "浇水", frame: CGRect(x: 0, y: 0, width: 50, height: 80) )

PlaygroundPage.current.liveView = btn
