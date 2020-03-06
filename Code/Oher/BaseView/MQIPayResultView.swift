//
//  MQIPayResultView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIPayResultView: UIView {

    var finishBtn: UIButton!
    var priceLabel: UILabel!
    var pingtaiLabel:UILabel!
    var price:String = "" {
        didSet{
            priceLabel.attributedText = getAttStr(money: "\(COINNAME)\(price)" as NSString, att1: kLocalized("AmountPaid") as NSString)
        }
    }
    var pingtai:String = "" {
        didSet{
            pingtaiLabel.attributedText = getAttStr(money: pingtai as NSString,att1: kLocalized("PaymentMethod") as NSString)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let blackLine = UILabel.init(frame: CGRect (x: 0, y: root_nav_height + root_status_height, width: screenWidth, height: hdscale))
        blackLine.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(blackLine)
        
        finishBtn = UIButton(frame: CGRect(x: screenWidth - 52 * gdscale, y: root_nav_height - 10, width: 42 * gdscale, height: 22 * hdscale))
        finishBtn.setTitle(kLocalized("complete"), for: .normal)
        finishBtn.setTitleColor(colorWithHexString("#333333"), for: .normal)
        finishBtn.titleLabel?.font = systemFont(16 * gdscale)
        finishBtn.addTarget(self, action: #selector(MQIPayResultView.closed), for: .touchUpInside)
        self.addSubview(finishBtn)
        
        let imgView = UIImageView.init(frame: CGRect(x: (screenWidth - 191 * gdscale) / 2, y: blackLine.maxY + 61 * hdscale , width: 191 * gdscale, height: 136 * hdscale))
        imgView.image = UIImage.init(named: "Line")
        self.addSubview(imgView)
        
        
        priceLabel = createLabel(CGRect (x: 126 * gdscale, y: imgView.maxY + 28 * hdscale, width: screenWidth, height: 20 * hdscale), font: systemFont(14 * gdscale), bacColor: UIColor.clear, textColor: nil, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: 0)
        self.addSubview(priceLabel)
        
        pingtaiLabel = createLabel(CGRect (x: 126 * gdscale, y: priceLabel.maxY + 8 * hdscale, width: screenWidth, height: 20 * hdscale), font: systemFont(14 * gdscale), bacColor: UIColor.clear, textColor: nil, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: 0)
        self.addSubview(pingtaiLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func show(){
        let window = getWindow()
        window.addSubview(self)
        window.bringSubviewToFront(self)
        self.frame = window.bounds
        self.frame.origin.y = screenHeight
        UIView.animate(withDuration: 0.1, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.frame.origin.y = 0
            }
            }, completion: { (suc) in
        })
    }
    @objc func closed(){
        UIView.animate(withDuration: 0.1, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.frame.origin.y = screenHeight
                strongSelf.removeFromSuperview()
            }
            }, completion: { (suc) in
        })
    }
    func getAttStr(money:NSString,att1:NSString) ->NSMutableAttributedString {
        let attStr = NSMutableAttributedString(string:att1 as String)
        attStr.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14 * gdscale)], range: NSMakeRange(0, att1.length))
        attStr.addAttribute(.foregroundColor, value: UIColor.black,
                            range: NSMakeRange(0, att1.length))
        
        let str1 = NSMutableAttributedString(string:money as String)
        str1.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14 * gdscale)], range: NSMakeRange(0, str1.length))
        str1.addAttribute(.foregroundColor, value: colorWithHexString("#EB5567"),
                          range: NSMakeRange(0, str1.length))
        attStr.append(str1)
        return attStr
    }

}
