//
//  PNSwiftViewController.swift
//  Feel
//
//  Created by emoji on 2018/12/3.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit
import YYKit
import Alamofire

class PNSwiftViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let btn = UIButton(frame: CGRect(x: 0, y: kTopBarHeight, width: 100, height: 50))
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.text = "Appliction"
        view.addSubview(btn)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         request()
    }
    
    func request() {
        let urlsting = URL(string: "https://www.httpbin.org/get")
        guard let url = urlsting else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
                

        
        /// 相应结果
        Alamofire.request(url, parameters: ["ai":"pinnnn"])
        ///Serialized into String
            
            .responseString { response in
            
        }/// JSON Serialized into Any
            .responseJSON { response in
                
        }/// Serialized into Data
            .responseData { (response) in
                
        }/// PropertyList Serialized into Any
            .responsePropertyList { resopnse in
                
        }/// 未序列化的
            .response { response in
                
        }
        
        
        /// Response Validation
        Alamofire.request(url, parameters: ["ai":"pinnnn"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success(let v):
                    print(v)
                case .failure(let e):
                    print(e)
                }
        }
        /// 自动校验x状态码200..<300,and that the Content-Type header of the response matches the Accept header of the request, if one is provided.
        Alamofire.request(url, parameters: ["ai":"pinnnn"])
            .validate()
            .responseJSON { response in
                if let v = response.result.value {
                    print(v)
                }
        }
    }
        
}




