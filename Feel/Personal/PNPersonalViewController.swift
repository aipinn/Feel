//
//  PNPersonalViewController.swift
//  Feel
//
//  Created by emoji on 2018/11/20.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNPersonalViewController: BaseViewController {

    var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension PNPersonalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, text.isNumberAndLetter() {
            _ = text.isLowerUpperLetterAndNumberRange(2, 6)
            return false;
        }
        return true
    }
}

extension PNPersonalViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !text.isNumberOrLetter() {
            return false
        }
        return true
    }
}
