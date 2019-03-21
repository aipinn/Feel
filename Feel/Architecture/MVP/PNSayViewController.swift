//
//  PNSayViewController.swift
//  Feel
//
//  Created by emoji on 2019/3/20.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

class PNSayViewController: UIViewController, SayingView {

    var presenter: SayingPresenter!
    var sayingBtn: UIButton?
    var sayLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        btn.backgroundColor = .cyan
        view.addSubview(btn)
        btn.addTarget(self, action:#selector(didTapSaying) , for: .touchUpInside)
        sayingBtn = btn
        
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: 100, height: 30))
        label.textColor = .green
        label.backgroundColor = .orange
        view.addSubview(label)
        sayLabel = label
    }
    
    @objc func didTapSaying() {
        self.presenter.saying()
    }
    
    func setSaying(saying: String) {
        sayLabel?.text = saying
    }

}
