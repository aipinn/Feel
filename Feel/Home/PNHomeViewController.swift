//
//  PNHomeViewController.swift
//  Feel
//
//  Created by emoji on 2018/11/20.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNHomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singatureView = PNSignatureView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 500))
        singatureView.backgroundColor = UIColor.cyan
        view.addSubview(singatureView)
        
//        singatureView.closure =  { (img: UIImage?) -> () in
//            
//        }
        
        singatureView.callBack = { (img: UIImage?) -> () in
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 510, width: kScreenWidth, height: 200))
            imageView.backgroundColor = UIColor.white
            imageView.contentMode = .center
            imageView.removeFromSuperview()
            imageView.image = img
            self.view.addSubview(imageView)
        }
        
    }
    
}
