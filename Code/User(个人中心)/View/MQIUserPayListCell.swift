//
//  MQIUserPayListCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/12.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserPayListCell: MQITableViewCell {

    var coinLabel: UILabel!
    var preiumLabel: UILabel!
    var timeLabel: UILabel!
    var costLabel: UILabel!
    
    let coinFont = boldFont(28)
    let coinColor = mainColor
    
    let preiumFont = systemFont(14)
    let preiumColor = mainColor
    
    let timeFont = systemFont(15)
    let timeColor = UIColor.white
    
    let costFont = boldFont(28)
    let costColor = UIColor.white

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    var orderLog: MQIEachOrderLog! {
        didSet {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            
            let attStr = NSMutableAttributedString(string: "+"+orderLog.order_coin, attributes:
                [.font : coinFont,
                 .paragraphStyle : paragraph,
                 .foregroundColor : coinColor,
                 .backgroundColor : UIColor.clear])
            
            let attStr2 = NSMutableAttributedString(string: COINNAME, attributes:
                [.font : boldFont(13),
                 .paragraphStyle : paragraph,
                 .foregroundColor : coinColor,
                 .backgroundColor : UIColor.clear])
            
            attStr.append(attStr2)
            coinLabel.attributedText = attStr
            
            if NSString(string: orderLog.order_premium).integerValue > 0 {
                preiumLabel.text = kLocalized("SpecialGifts")+orderLog.order_premium+COINNAME_PREIUM
            }else {
//                preiumLabel.text = ""
                  preiumLabel.text = kLocalized("SpecialGifts")+"200"+COINNAME_PREIUM
            }
            
            //            currency_code"CNY"
            timeLabel.text = orderLog.order_create
            if orderLog.currency_code == "" {
                costLabel.text = "CNY "+orderLog.order_fee
            }else{
                costLabel.text = orderLog.currency_code + orderLog.order_fee
            }
            costLabel.adjustsFontSizeToFitWidth = true
            
        }
    }
    
    
    
    func setupUI() -> Void {
        contentView.backgroundColor  =  UIColor.white

        
        let  rightView = UIView()
        rightView.backgroundColor = RGBColor(242, g: 242, b: 242)
        contentView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-30)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(contentView.snp.height).multipliedBy(1.2)
        }
        
       let  leftView = UIView()
        leftView.backgroundColor = RGBColor(242, g: 242, b: 242)
        contentView.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(30)
            make.top.bottom.equalTo(rightView)
            make.right.equalTo(rightView.snp.left)
        }
        
        
        coinLabel = UILabel()
        coinLabel.font = coinFont
        coinLabel.textColor = coinColor
        leftView.addSubview(coinLabel)
        coinLabel.snp.makeConstraints { (make) in
            make.right.equalTo(leftView)
            make.top.equalTo(leftView).offset(10)
            make.left.equalTo(10)
        }
        
        
        preiumLabel = UILabel()
        preiumLabel.font = preiumFont
        preiumLabel.textColor = preiumColor
        leftView.addSubview(preiumLabel)
        preiumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(leftView)
            make.bottom.equalTo(leftView).offset(-10)
            make.left.right.equalTo(coinLabel)
        }
        
       let rightBacImageView = UIImageView()
        rightBacImageView.image = pay_userPayListRightImage
        rightView.addSubview(rightBacImageView)
        rightBacImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(rightView)
        }
        
        let moneyImage = UIImageView()
        moneyImage.image = UIImage(named: "userPayListRightCoinImage")
        rightView.addSubview(moneyImage)
        moneyImage.snp.makeConstraints { (make) in
           make.width.height.equalTo(52)
           make.right.equalTo(rightBacImageView).offset(-5)
           make.bottom.equalTo(rightBacImageView).offset(-2)
        }
        timeLabel = UILabel()
        timeLabel.numberOfLines = 2
        timeLabel.textColor = timeColor
        timeLabel.font = timeFont
        rightView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
           make.top.equalTo(rightView).offset(5)
           make.height.equalTo(rightView).multipliedBy(0.5)
           make.width.equalTo(rightView).multipliedBy(0.5)
           make.centerX.equalTo(rightView)
        }
        costLabel = UILabel()
        costLabel.numberOfLines = 1
        costLabel.textColor = costColor
        costLabel.font = costFont
        rightView.addSubview(costLabel)
        
        costLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(rightView).offset(-5)
            make.height.width.centerX.equalTo(timeLabel)
        }
       
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 140
    }
}
