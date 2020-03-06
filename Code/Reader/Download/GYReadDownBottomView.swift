//
//  GYReadDownBottomView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadDownBottomView: UIView {
    
    public var book: MQIEachBook!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    
    
    fileprivate let lightBlackColor = UIColor.white
    fileprivate let originColor = mainColor
    
    public var payBlock: (() -> ())?
    public var toPayVC: (() -> ())?
    
    // 0  是 免费 1 是 VIP 3 是 vip 的 money 汇总
    public var selChapters: ([MQIEachChapter], [MQIEachChapter], Int)! {
        didSet {
            var title = ""
            if selChapters.1.count > 0 {
                let priceChapters = selChapters.1.filter({$0.isSubscriber == false})
                title = "，需要付费章节 \(priceChapters.count) 章"
                payBtn.setTitle("订阅并下载", for: .normal)
            }else {
                title = "，无付费章节"
                payBtn.setTitle("下载", for: .normal)
            }
            titleLabel.text = "已选章节 \(selChapters.0.count+selChapters.1.count) 章"+title
            
            price = selChapters.2
        }
    }
    
    public var price: Int! {
        didSet {
//            configPrice(price)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = boldFont(14)
        titleLabel.textColor = blackColor
        
        coinLabel.font = systemFont(12)
        coinLabel.isHidden = true
        payBtn.layer.cornerRadius = 20
        payBtn.layer.masksToBounds = true
        payBtn.setTitle("下载", for: .normal)
        payBtn.titleLabel?.font = systemFont(13)
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.backgroundColor = originColor
        
        selChapters = ([], [], 0)
    }
    
    @IBAction func payAction(_ sender: Any) {
        if selChapters.0.count+selChapters.1.count <= 0 {
            return
        }
        
        if MQIUserManager.shared.checkIsLogin() == false {
            if selChapters.1.count > 0 {
                MQIloginManager.shared.toLogin(nil, finish: {

                })
                return
            }
        }else {
            if price > MQIUserManager.shared.user!.user_coin.integerValue() {
                MQILoadManager.shared.makeToast("余额不足，即将跳转购买页面")
                after(1, block: {
                    self.toPayVC?()
                })
                return
            }
        }

        

        payBlock?()
    }
    
    func reloadUserCoin() {
        configPrice(price)
    }
    
    func configPrice(_ price: Int) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: "价格: ", attributes:
            [NSAttributedString.Key.font : coinLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : lightBlackColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: "\(price)\(COINNAME)", attributes:
            [NSAttributedString.Key.font : coinLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : originColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        if MQIUserManager.shared.checkIsLogin() == false {
            attStr.append(attStr2)
            coinLabel.attributedText = attStr
        }else {
            let attStr3 = NSMutableAttributedString(string: ", 余额: ", attributes:
                [NSAttributedString.Key.font : coinLabel.font,
                 NSAttributedString.Key.paragraphStyle : paragraph,
                 NSAttributedString.Key.foregroundColor : lightBlackColor,
                 NSAttributedString.Key.backgroundColor : UIColor.clear])
            
            let user = MQIUserManager.shared.user
            let attStr4 = NSMutableAttributedString(string: user!.user_coin+COINNAME+"（\(user!.user_premium)\(COINNAME_PREIUM)）", attributes:
                [NSAttributedString.Key.font : coinLabel.font,
                 NSAttributedString.Key.paragraphStyle : paragraph,
                 NSAttributedString.Key.foregroundColor : originColor,
                 NSAttributedString.Key.backgroundColor : UIColor.clear])
            
            attStr.append(attStr2)
            attStr.append(attStr3)
            attStr.append(attStr4)
            coinLabel.attributedText = attStr
        }
    }
    
    
    class func getHeight() -> CGFloat {
        return 150
    }
}
