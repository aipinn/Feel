//
//  PNHomeViewController.swift
//  Feel
//
//  Created by emoji on 2018/11/20.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

class PNHomeViewController: BaseViewController {
    
    private var tableView: UITableView?
    lazy var dataSource: [String] = {
        var array:[String] = Array()
        for _ in 1...20 {
            array.append("PNTransViewController")
        }
        return array
    }()
    lazy var str: String = "Lazy string"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}

//MARK: - Delegate
extension PNHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = dataSource[indexPath.row].getViewController() else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - private methods
extension PNHomeViewController {
    func configTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }
    
    func setupUI() {
        
    }
}


extension PNHomeViewController {
    func signatureView() {
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
