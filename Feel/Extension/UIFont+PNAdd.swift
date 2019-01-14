//
//  UIFont+PNAdd.swift
//  Feel
//
//  Created by emoji on 2019/1/10.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

enum FONT: String {
    case SC_Semibold
    case SC_Medium
    case SC_Regular
    func desc()-> String {
        switch self {
        case .SC_Semibold:
            return "PingFangSC-Semibold"
        case .SC_Medium:
            return "PingFangSC-Medium"
        case .SC_Regular:
            return "PingFangSC-Regular"
        }
    }

}

extension UIFont {

    class func pfSemiBoldSize(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: FONT.SC_Semibold.desc(), size: size)
        return font!
    }
    
    class func pfMediumSize(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: FONT.SC_Medium.desc(), size: size)
        return font!
    }
    class func pfRegularSize(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: FONT.SC_Regular.desc(), size: size)
        return font!
    }
}
