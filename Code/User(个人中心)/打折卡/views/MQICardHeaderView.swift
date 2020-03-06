//
//  MQICardHeaderView.swift
//  CQSC
//
//  Created by moqing on 2019/7/4.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardHeaderView: UIView {
    
    var  moneyLabel:UILabel!
    var  cardBacView:UIImageView!
    var  clickBlick:((_ tag:Int)->())?
    
    var nameLabel:UILabel!
    var dateLabel:UILabel!
    var headIconImg:UIImageView!
    var saveLabel:UILabel!
    var  openBtn:DSYRightImgBtn!
    var type:DiscountCardType  = .buy{
        didSet(oldValue) {
            if type == .buy{
                while self.subviews.count > 0 {
                    self.subviews.last?.removeFromSuperview()
                }
                 setupUI1()
            }else{
                while self.subviews.count > 0 {
                    self.subviews.last?.removeFromSuperview()
                }
                setupUI2()
            }
        }
    }
    override init(frame: CGRect) {
         super.init(frame: frame)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
    }
  
    func setupUI1() {
        
        self.backgroundColor = UIColor.colorWithHexString("2C2B40")
        let cardH = kUIStyle.scale1PXW(110)
        
        cardBacView = UIImageView(frame: CGRect(x: 22, y:10, width: cardH*2.6583, height:  cardH+40))
        self.addSubview(cardBacView)
//        cardBacView.contentMode  = .scaleAspectFill
        cardBacView.dsySetCorner(byRoundingCorners: [.topLeft,.topRight], radii: 5)
        cardBacView.backgroundColor = UIColor.colorWithHexString("E7EAF1")
//        cardBacView.maxY = self.maxY
        cardBacView.centerX = self.width*0.5
        cardBacView.isUserInteractionEnabled = true
        
        moneyLabel = UILabel()
        moneyLabel.font = UIFont.boldSystemFont(ofSize: 30)
        moneyLabel.textAlignment = .left
        moneyLabel.textColor  =  UIColor.colorWithHexString("2C2B40")
        moneyLabel.adjustsFontSizeToFitWidth = true
        addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardBacView).offset(15)
            make.right.lessThanOrEqualTo(cardBacView).offset(-140)
        }
        openBtn = DSYRightImgBtn()
        openBtn.titleX = 15
        addSubview(openBtn)
        openBtn.setTitle(kLocalized("Open_immediately"), for: .normal)
        openBtn.setImage(UIImage(named: "dzk_jt2_img")?.withRenderingMode(.alwaysTemplate), for: .normal)
        openBtn.tintColor = UIColor.white
        openBtn.setTitleColor(UIColor.white, for: .normal)
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        openBtn.dsySetCorner(radius: 16)
        openBtn.tag = 100
        openBtn.backgroundColor = mainColor
        openBtn.addTarget(self, action: #selector(clcikBtn(btn:)), for: UIControl.Event.touchUpInside)
        openBtn.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLabel)
            make.top.equalTo(moneyLabel.snp.bottom).offset(7)
            make.bottom.equalTo(cardBacView).offset(-55)
            make.width.equalTo(88)
            make.height.equalTo(32)
        }
       
        
    }
    func setupUI2() {
        self.backgroundColor = UIColor.colorWithHexString("2C2B40")
        let cardH = kUIStyle.scale1PXW(120)
          cardBacView = UIImageView(frame: CGRect(x: 22, y:10, width: cardH*2.6583, height:  cardH+40))
        self.addSubview(cardBacView)
        cardBacView.dsySetCorner(byRoundingCorners: [.topLeft,.topRight], radii: 10)
        cardBacView.backgroundColor = UIColor.colorWithHexString("E7EAF1")
//        cardBacView.maxY = self.maxY
        cardBacView.centerX = self.width*0.5
        cardBacView.isUserInteractionEnabled = true
        
        openBtn = DSYRightImgBtn()
        addSubview(openBtn)
        openBtn.titleX = 15
        openBtn.setImage(UIImage(named: "dzk_jt2_img")?.withRenderingMode(.alwaysTemplate), for: .normal)
        openBtn.tintColor = UIColor.white
        openBtn.setTitleColor(UIColor.white, for: .normal)
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        openBtn.dsySetCorner(radius: 16)
        openBtn.tag = 100
        openBtn.backgroundColor = mainColor
        openBtn.addTarget(self, action: #selector(clcikBtn(btn:)), for: UIControl.Event.touchUpInside)
        let  iconW:CGFloat = kUIStyle.scale1PXW(54)
        headIconImg = UIImageView()
        headIconImg.layer.cornerRadius = iconW*0.5
        headIconImg.clipsToBounds = true
        headIconImg.image = UIImage(named: "mine_header")
        addSubview(headIconImg)
        headIconImg.snp.makeConstraints { (make) in
            make.left.equalTo(cardBacView).offset(20)
//            make.top.equalTo(cardBacView).offset(15)
            make.width.height.equalTo(iconW)
        }
        
        openBtn.snp.makeConstraints { (make) in
            make.right.equalTo(cardBacView).offset(-20)
            make.centerY.equalTo(headIconImg).offset(-5)
            make.width.equalTo(88)
            make.height.equalTo(30)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.colorWithHexString("#2C2B40")
        nameLabel.text = ""
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8;
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headIconImg.snp.right).offset(5)
            make.bottom.equalTo(headIconImg.snp.centerY)
            make.right.equalTo(openBtn.snp.left).offset(-5)
        }

        dateLabel = UILabel ()
        dateLabel.text = kLocalized("NotLoggedIn")
        dateLabel.textColor = kUIStyle.colorWithHexString("#2C2B40")
        dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel.textAlignment = .left
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.8;
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(headIconImg.snp.centerY).offset(5)
         
        }
        
        saveLabel = UILabel ()
        saveLabel.textColor = kUIStyle.colorWithHexString("#151D54")
        saveLabel.font = UIFont.boldSystemFont(ofSize: 13)
        saveLabel.textAlignment = .left
        saveLabel.adjustsFontSizeToFitWidth = true
        saveLabel.minimumScaleFactor = 0.8;
        addSubview(saveLabel)
        saveLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headIconImg)
            make.top.equalTo(headIconImg.snp.bottom).offset(kUIStyle.scale1PXW(10))
            make.bottom.equalTo(cardBacView).offset(kUIStyle.scale1PXW(-60))
            
        }
        
        

        let watchBtn = cardBacView.addCustomButton(CGRect.zero, title: kLocalized("Check_the_details")) { [weak self](btn) in
            self?.clickBlick?(btn.tag)}
        watchBtn.setTitleColor(mainColor, for: .normal)
        watchBtn.tag = 101
        watchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        watchBtn.setImage(UIImage(named: "dzk_jsq_img"), for: .normal)
        watchBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        watchBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(openBtn)
            make.centerY.equalTo(saveLabel)
            make.left.greaterThanOrEqualTo(saveLabel.snp.right).offset(10)
        }
        
        
        let  watchImg = UIImageView()
        watchImg.image =  UIImage(named: "dzk_jt_img")
        cardBacView.addSubview(watchImg)
        watchImg.snp.makeConstraints { (make) in
            make.left.equalTo(watchBtn.snp.right)
            make.right.equalTo(openBtn)
            make.centerY.equalTo(watchBtn)
        }
    }
    @objc func clcikBtn(btn:UIButton)  {
        clickBlick?(btn.tag)
    }
    
    class func  getDefaultHeight() -> CGFloat {
        return  kUIStyle.scale1PXW(110)+10+40
    }
    
    
}
