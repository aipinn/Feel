//
//  String+PNAdd.swift
//  Feel
//
//  Created by emoji on 2019/1/10.
//  Copyright © 2019 PINN. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getViewController() -> UIViewController? {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            printing("Not get namesapce")
            return nil
        }
        let vcName = "\(namespace).\(self)"
        guard let type = NSClassFromString(vcName) as? UIViewController.Type else {
            printing("Not get class type")
            return nil
        }
        return type.init()
    }
}
//let regex = "[a-zA-Z]"//单个字母
//let regex = "[0-9]"//单个数字
//let regex = "[0-9a-zA-Z]"//单个数字或字母
//let regex = "[\\u4e00-\\u9fa5]"//汉字

//1或N个, MATCHES[c]表示大小写不敏感,[0-9]可以换成\\d
//let regex = "[a-zA-Z]+"//字母
//let regex = "[0-9a-zA-Z]+"//字母或数字
//let regex = "[0-9a-zA-Z]{2,5}"//2-5位字母或数字
//(不能都是小写字母或大写字母或数字,是数字字母组合)6-12位数字和字母组合
//let regex = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9a-zA-Z]{6,12}"
//(必须包含大写字母和小写字母和数字)8-20必须包含大小写字母和数字
//let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}"

//MARK: - 谓词+正则(NSPredicate+Regex)
public extension String {

    /// 是否是空白
    ///
    /// - Returns: 是否
    func isBlank() -> Bool {
        let regex = "\\s+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是字母
    ///
    /// - Returns: 是否
    func isLetter() -> Bool {
        let regex = "[a-zA-Z]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是数字
    ///
    /// - Returns: 是否
    func isNumber() -> Bool {
        let regex = "[0-9]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是字母或数字
    ///
    /// - Returns: 是否
    func isNumberOrLetter() -> Bool {
        let regex = "[0-9a-zA-Z]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是字母和数字
    ///
    /// - Returns: 是否
    func isNumberAndLetter() -> Bool {
        let regex = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[a-zA-Z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是大小写字母和数字组合
    ///
    /// - Parameters:
    ///   - min: 最小位数
    ///   - max: 最大位数
    /// - Returns: 是否
    func isLowerUpperLetterAndNumberRange(_ min: UInt, _ max: UInt) -> Bool {
        
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{\(min),\(max)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是数字和字母组合
    ///
    /// - Parameters:
    ///   - min: 最小位数
    ///   - max: 最大位数
    /// - Returns: 是否
    func isLetterAndNumberRange(_ min: UInt, _ max: UInt) -> Bool {
        let regex = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9a-zA-Z]{\(min),\(max)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
