//
//  PNGreetViewController.swift
//  Feel
//
//  Created by pinn on 2019/3/19.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

class PNGreetViewController: BaseViewController {

    var greetingLabel: UILabel?
    var greetingButton: UIButton?
    
    var viewModel: PNGreetViewModelProtocol! {
        didSet {
            self.viewModel.greetingDidChanged = { [unowned self] viewModel in
                self.greetingLabel?.text = viewModel.greeting
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(frame: CGRect(x: 0, y: 100, width: 60, height: 30))
        btn.backgroundColor = .cyan
        view.addSubview(btn)
        btn.addTarget(self.viewModel, action:#selector(PNGreetViewModel.showGreeting) , for: .touchUpInside)
        greetingButton = btn
        
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: 60, height: 30))
        label.textColor = .green
        label.backgroundColor = .orange
        view.addSubview(label)
        greetingLabel = label
        
        
    }
    

}
