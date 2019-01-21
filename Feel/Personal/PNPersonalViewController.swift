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
        let textF = UITextView(frame: CGRect(x: 0, y: 100, width: 200, height: 200))
        textF.backgroundColor = .cyan
        textF.delegate = self
        view.addSubview(textF)
        
        let tf = UITextField(frame: CGRect(x: 0, y: 400, width: 400, height: 100))
        tf.backgroundColor = .red
        tf.delegate = self
        view.addSubview(tf)
    }
    
}

extension PNPersonalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "W" {
            let vc = PNWebController()
            navigationController?.pushViewController(vc, animated: true)
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
