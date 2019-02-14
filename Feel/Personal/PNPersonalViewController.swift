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

        let btn = PNButton(image: "1", title: "浇水", frame: CGRect(x: 20, y: 100, width: 50, height: 80) )
        view.addSubview(btn)
        
    }
    

    
}

extension PNPersonalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        if let text = textField.text, text.isNumberAndLetter() {
            _ = text.isLowerUpperLetterAndNumberRange(2, 6)
            return false;
        }
        if string == "W" {


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

extension PNPersonalViewController {
    //GCD异步线程优化
    func AsynOptimize() {
        //        for _ in 0...1000 {
        //1.异步线程处理耗时任务,创建线程过多影响性能
        //            DispatchQueue.global(qos: .default).async(execute: {
        //                print(Thread.current)
        //            })
        
        //需要限制线程数量
        //2.dispatch_apply
        /*
         dispatch_apply(6, dispatch_get_global_queue(0, 0), ^(size_t size) {
         
         });
         */
        //swift用法
        //            DispatchQueue.concurrentPerform(iterations: 6) { (num) in
        //                print(Thread.current)
        //                print(num)
        //            }
        //3.信号量
        
        //        }
        //        let sem = DispatchSemaphore(value: 6)
        //        for _ in 0...1000 {
        //            DispatchQueue.global(qos: .default).async {
        //                print(Thread.current)
        //                sem.signal()
        //            }
        //            let ret = sem.wait(timeout: .distantFuture)
        //            if ret == .success {
        //
        //            } else if ret == .timedOut {
        //
        //            }
        //        }
        //4.NSOperation
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 5
        for _ in 0...1000 {
            q.addOperation {
                print(Thread.current)
            }
        }

    }
    // I/O性能优化
    func IOOptimize() {
        /*
        I/O是性能消耗大户,任何I/O操作都会使低功耗状态被打破,所以减少I/O次数是性能优化的关键
         1. 将零碎的内容作为一个整体进行写入
         2. 使用合适的I/O操作API
         3. 使用合适的线程
         4. 使用NSCache做缓存能够减少I/O
         */
        
    }
    
    //控制App的wake次数
    func WakeOptimize() {
        /*
         通知,VoIP,定位,蓝牙都会使设备从Standby状态唤醒.
         */
    }
}
