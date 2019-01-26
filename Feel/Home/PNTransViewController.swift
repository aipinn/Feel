//
//  PNTransViewController.swift
//  Feel
//
//  Created by emoji on 2019/1/9.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

class PNTransViewController: BaseViewController {
    
    private var offsetY: CGFloat = 0
    private var scrollView: UIScrollView?
    private var rightItem: UIButton?
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func buttonSelected() {
        navigationController?.pushViewController(PNSwiftViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rightItem?.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rightItem?.isHidden = true

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

}

extension PNTransViewController {
    override func setupUI() {
        view.backgroundColor = .cyan
    
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        topView.backgroundColor = .orange
        view.addSubview(topView)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: -kTopBarHeight, width: kScreenWidth, height: kScreenHeight+kTopBarHeight))
        scrollView?.contentSize = CGSize(width: kScreenWidth, height: kScreenHeight * 2)
        scrollView?.delegate = self
        view.addSubview(scrollView!)
        
        //下一页
        do {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            button.setTitle("next->swift", for: .normal)
            button.titleLabel?.font = UIFont.pfMediumSize(16)
            button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            button.backgroundColor = .green
            let item = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItems = [item]
        }
        do {
            
            let button = UIButton(frame: CGRect(x: kScreenWidth-16-89, y: kSatusBarHeight+88+(44-35)/2, width: 89, height: 35))
            button.setTitle("next->swift", for: .normal)
            button.titleLabel?.font = UIFont.pfMediumSize(16)
            button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            button.backgroundColor = .blue
            rightItem = button
            scrollView?.addSubview(button)
        }
        
        
        //标题
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown,
                                                                   NSAttributedString.Key.font: UIFont.pfMediumSize(17)]
        title = "我的"
        
        if #available(iOS 11.0, *) {
            
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension PNTransViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var diff: CGFloat = 0
        let offsetY = scrollView.contentOffset.y
        diff =  offsetY - self.offsetY
        self.offsetY = offsetY
        
        guard let item = rightItem else {
            return
        }
        item.transform = item.transform.translatedBy(x: 0, y: diff)

        if  offsetY < 0 {
            navigationController?.navigationBar.isHidden = true
            item.alpha = abs(offsetY)/kTopBarHeight

        } else if offsetY >= 0 {
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.alpha = offsetY / 150.0

        }
    }
}
