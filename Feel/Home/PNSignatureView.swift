//
//  PNSignatureView.swift
//  Feel
//
//  Created by emoji on 2018/11/21.
//  Copyright © 2018 PINN. All rights reserved.
//

import UIKit

private func midpoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
    return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
}

typealias SigImageClosure = (_ img:UIImage?) ->Void

class PNSignatureView: UIView {

    var sigImage: UIImage?
    var pointArr: [CGPoint]?
    var closure: SigImageClosure?
    var callBack: ((_ img: UIImage?) -> ())?
    fileprivate var path: UIBezierPath?
    fileprivate var priorPoint = CGPoint()
    var isSignature = false
    var isClean: Bool = false
    {
        didSet{
            if isClean == true {
                minX = kScreenWidth
                minY = kScreenHeight
                maxX = 0
                maxY = 0
                pointArr?.removeAll()
                isSignature = false
                path = UIBezierPath.init()
                path?.lineWidth = 2
                setNeedsDisplay()
            }else{
                
            }
        }
    }
    fileprivate var minX: CGFloat = kScreenWidth
    fileprivate var minY: CGFloat = kScreenHeight
    fileprivate var maxX: CGFloat = 0
    fileprivate var maxY: CGFloat = 0
    private var newV: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        path = UIBezierPath.init()
        path?.lineWidth = 2
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(generateImage))
        addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearHistory))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
        
        pointArr = Array()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        placeHolder(rect: rect)
        UIColor.black.setStroke()
        path?.stroke()
    }
    
    /// 计算手势范围
    private func calculateArea(point: CGPoint){
        let x = point.x
        let y = point.y
        minX = minX < x ? minX : x
        minY = minY < y ? minY : y
        maxX = maxX < x ? x : maxX
        maxY = maxY < y ? y : maxY
    }
    
    
    /// 识别手势
    @objc func handleGesture(pan: UIPanGestureRecognizer){
        isSignature = true
        isClean = false
        
        let curPoint = pan.location(in: self)
        pointArr?.append(curPoint)
        calculateArea(point: curPoint)
        
        let midPoint = midpoint(p0: priorPoint, p1: curPoint)
        switch pan.state {
        case .began:
            path?.move(to: curPoint)
            break
            
        case .changed:
            path?.addQuadCurve(to: midPoint, controlPoint: priorPoint)
            //path?.addLine(to: curPoint)
            break
            
        default: break
            
        }
        priorPoint = curPoint
        
        setNeedsDisplay()
        
    }
    
    /// 生成图片
    @objc private func generateImage() {
        
        UIGraphicsBeginImageContext(bounds.size)
        let cxt = UIGraphicsGetCurrentContext()
        layer.render(in: cxt!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        sigImage = image
        
        callBack?(cutImage(image: image!))
        
    }

    
    /// 剪切图片
    func cutImage(image: UIImage) -> UIImage? {
    
        let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY-minY)
        let imgRef = image.cgImage?.cropping(to: rect)
        guard imgRef != nil else {
            return nil
        }
        let img = UIImage.init(cgImage: imgRef!)
        return img
    }
    
    /// 占位文字
    func placeHolder(text: String = "请在此签名", rect: CGRect) {
        if isSignature {
            return
        }
        /*
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.setTextDrawingMode(.stroke)
         */
        let font = UIFont.systemFont(ofSize: 15)
        let textRect = CGRect(x: 0, y: center.y-20, width: rect.width-20, height: 20)
        text.draw(in: textRect, withAttributes: [NSAttributedString.Key.font: font,
                                                 NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    /// 清除历史
     @objc private func clearHistory(){
        isClean = true
    }
}



extension PNSignatureView {

    func testPrivate() {

    }
    
}


