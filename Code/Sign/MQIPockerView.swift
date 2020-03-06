//
//  MQIPockerView.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/11.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIPockerView: UIView {
    var placeholderImgView:UIImageView?
    
    var contentimageView:UIImageView?
    
    var premiumLabel:UILabel!
//    var commonText:String = "\(COPYRIGHTNAME)"+kLocalized("ReadTheBeans")
     var commonText:String = kLocalized("ReadTheBeans")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createPockerUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func createPockerUI() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize (width: 0, height: 0)
        layer.shadowOpacity = 0.3
        
        //背面
        placeholderImgView = UIImageView(frame: self.bounds)
        placeholderImgView?.backgroundColor = UIColor.white
        placeholderImgView?.image = UIImage.init(named: "Sign_FlipCardImg")
        placeholderImgView?.layer.cornerRadius = 5
        placeholderImgView?.clipsToBounds = true
        
        self.addSubview(placeholderImgView!)
        //正面
        contentimageView = UIImageView(frame: self.bounds)
        contentimageView?.backgroundColor = UIColor.white
        contentimageView?.layer.cornerRadius = 5
        contentimageView?.clipsToBounds = true
        contentimageView?.layer.borderColor = UIColor.colorWithHexString("#d69c3b").cgColor
        contentimageView?.layer.borderWidth = 1
        
        let bgView = UIView(frame: CGRect (x: 3, y: 3, width: contentimageView!.width-6, height: contentimageView!.height-6))
        bgView.backgroundColor = UIColor.colorWithHexString("#ffe5bb")
        contentimageView?.addSubview(bgView)
        premiumLabel = UILabel(frame: CGRect (x: 0, y: 0, width: contentimageView!.width, height: 27*gdscale))
        premiumLabel.font = UIFont.systemFont(ofSize: 26*gdscale)
        premiumLabel.textAlignment = .center
        premiumLabel.textColor = UIColor.colorWithHexString("#be6628")
        contentimageView?.addSubview(premiumLabel)
        premiumLabel.center = CGPoint (x: contentimageView!.width/2, y: 27*gdscale/2 + 20*gdscale)
        let typeLabel = UILabel(frame: CGRect (x: 0, y: self.height - 23*gdscale - 10*gdscale, width: self.width, height: 10*gdscale))
        typeLabel.textAlignment = .center
        typeLabel.text = commonText
        typeLabel.font = UIFont.systemFont(ofSize: 10)
        typeLabel.textColor = UIColor.colorWithHexString("#be6628")
        contentimageView?.addSubview(typeLabel)
        
    }
}
