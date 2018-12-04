//
//  PNTextArrowView.swift
//  Feel
//
//  Created by emoji on 2018/11/22.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

typealias TACallBackClosure = (_ para: AnyObject?)->(AnyObject?)

class PNTextArrowView: UIView {

    /// 左边标题
    var title: String?
    /// 右边自标题
    var subTitle: String?
    /// 箭头图片名字
    var arrow: String?
    /// 文本框
    var textField: UITextField?
    /// 文本框占位文字
    var placeHolder: String?
    /// 回调闭包
    var closure: TACallBackClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
