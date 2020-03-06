//
//  GYUserPayListCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/8.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYUserPayListCell: MQITableViewCell {
    
    
    //第二张样式
    @IBOutlet weak var titleLabel2: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var preiumLabel: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var board: UIView!
    let coinFont = boldFont(28)
    let coinColor = mainColor

    let preiumFont = systemFont(14)
    let preiumColor = mainColor

    let timeFont = systemFont(15)
    let timeColor = UIColor.white

    let costFont = boldFont(28)
    let costColor = UIColor.white
    
    var orderLog: MQIEachOrderLog! {
        didSet {
            
            if orderLog.order_coin.integerValue() == 0 {
                titleLabel2.text = orderLog.product_name
                titleLabel.text = ""
                coinLabel.text = ""
                preiumLabel.text = ""
            } else {
                titleLabel2.text = ""
                titleLabel.text = orderLog.product_name
                coinLabel.text = "+" + orderLog.order_coin + COINNAME
                if NSString(string: orderLog.order_premium).integerValue > 0 {
                    preiumLabel.text = kLocalized("SpecialGifts")+orderLog.order_premium+COINNAME_PREIUM
                }else {
                    preiumLabel.text =  " "
                }
            }
            
            timeLabel.text =  getTimeStampToString(orderLog.order_modify, format: "yyyy-MM-dd HH:mm:ss")
            if orderLog.currency_code == "" {
               costLabel.text = "CNY "+orderLog.order_fee
            }else{
                costLabel.text = orderLog.currencyStr + orderLog.order_fee
            }
            costLabel.adjustsFontSizeToFitWidth = true
       
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        board.layer.borderWidth = 1
        board.layer.borderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1).cgColor
        board.layer.masksToBounds = true
        
//        let bg = UIImageView(frame: CGRect(x: 9, y: 0, width: screenWidth - 18, height: 102))
//        addSubview(bg)
//        bg.image = #imageLiteral(resourceName: "recordsCellBG")
//
//        coinLabel.font = coinFont
//        coinLabel.textColor = coinColor
//
//        preiumLabel.font = preiumFont
//        preiumLabel.textColor = preiumColor
//
//        timeLabel.font = timeFont
//        timeLabel.textColor = timeColor
//
//        costLabel.font = costFont
//        costLabel.textColor = costColor
//
//        self.backgroundColor = UIColor.white
//        contentView.backgroundColor = UIColor.white
//        leftView.backgroundColor = RGBColor(242, g: 242, b: 242)
//
//        let image = pay_userPayListRightImage?.withRenderingMode(.alwaysTemplate)
//        rightBacImageView.tintColor = mainColor
//        rightBacImageView.image = image
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 122
    }


}
