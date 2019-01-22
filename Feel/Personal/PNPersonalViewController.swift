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

<<<<<<< HEAD
        if let text = textField.text, text.isNumberAndLetter() {
            _ = text.isLowerUpperLetterAndNumberRange(2, 6)
            return false;
=======
        if string == "W" {
            let vc = PNWebController()
            navigationController?.pushViewController(vc, animated: true)
>>>>>>> c45a1623b5868018423502546d9d458d3b54a02f
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
