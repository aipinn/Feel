//
//  PNButton.swift
//  Feel
//
//  Created by emoji on 2019/1/26.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

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
        
        imageView?.image = UIImage.init(named: image)
        titleLabel?.text = title
    }
    
}
