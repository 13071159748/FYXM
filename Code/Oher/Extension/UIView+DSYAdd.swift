//
//  UIView+DSYAdd.swift
//  Reader
//
//  Created by CQSC  on 2018/3/19.
//  Copyright © 2018年 ___MQ___. All rights reserved.
//

import UIKit


//MARK: UIView  圆角分类
extension UIView {
    
    /// 自定义圆角  必须在有frame 地方调用
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个[,]
    ///   - radii: 圆角半径
    func dsySetCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat)  -> Void{
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 快速圆角 比较吃内存
    ///
    /// - Parameter radius: 圆角大小
    func dsySetCorner(radius:CGFloat) -> Void{
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if !self.isMember(of: UIImageView.self){
            self.layer.shouldRasterize = true;
            self.layer.rasterizationScale = UIScreen.main.scale;
        }
    }
    
    /// 快速边框
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func dsySetBorderr(color:UIColor ,width:CGFloat) -> Void{
        self.layer.borderColor =  color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 快速阴影
    ///
    /// - Parameters:
    ///   - radius: 阴影显示半径
    ///   - shadowColor: 阴影颜色
    ///   - offset: 阴影偏移量
    func dsySetShadow(radius:CGFloat = 5,shadowColor:UIColor = UIColor.black,offset:CGSize = CGSize.zero) -> Void {
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    /// 添加点击方法
    ///
    /// - Parameters:
    ///   - target: 方法绑定对象
    ///   - action: 方法名称
    /// - Returns: 点击对象
    @discardableResult func dsyAddTap(_ target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap)
        return tap
    }
    
 
}

extension UIImage {
    
    /// 重新缩放一个图片
    ///
    /// - Parameter size: 缩放大小
    /// - Returns: 缩放后图片
    func dsyChangeOriginImage(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaleImage!;
    }
    /// 拉伸一张图片
    ///
    /// - Parameter size: 拉伸点
    /// - Returns: 拉伸后的图片
    func dsyTensileImage( leftCap:Int = 0,topCap:Int = 0) -> UIImage {
        
        let left = (leftCap > 0) ? leftCap:Int(self.size.width*0.5)
        let top = (topCap > 0) ? leftCap:Int(self.size.height*0.5)
        let imageOld = self.stretchableImage(withLeftCapWidth: left, topCapHeight: top)
        return imageOld
    }
    
    
    /// 更具颜色生成图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 生成的图片
    class func  imageWithColor(color:UIColor) -> UIImage? {
        
        let  rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context =  UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIButton {
    
    /// 根据颜色设置背景图片
    ///
    /// - Parameters:
    ///   - backgroundColor: 背景颜色值
    ///   - state: 按钮组状态
    func setBackgroundColor(_ backgroundColor:UIColor,for state:UIControl.State)  {
        self.setBackgroundImage(UIImage.imageWithColor(color: backgroundColor), for: state)
    }
    
    
}
