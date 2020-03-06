//
//  MQIListItemTableViewCell.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIListItemTableViewCell: MQITableViewCell {
    
    var icon: UIImageView!
    var titleLabel: UILabel!
    
    var lineView:UIView! /// 灰线
    
    var redNofityView:UIView!//签到红色提醒圆点
    
    var redCount: UILabel!
    
    
    let titleFont = UIFont.systemFont(ofSize: (16*mqscale > 18 ? 18 : 16*mqscale))
    //    let titleColor = RGBColor(131, g: 131, b: 131)
    let titleColor = UIColor.colorWithHexString("#2E2F35")
    
    let deTitleFont = UIFont.boldSystemFont(ofSize: 13)
    var deTitleColor = RGBColor(181, g: 181, b: 181)
    
    var  contentlabel:UILabel?
    
    var userInfoBlockToPay:(()->())?
    
    var noticeView:UIView? /// 反馈中心提醒
    
    func setRedCount(num: String) {
        guard let num = Int(num) else { return }
        redCount.text = (num > 99) ? "99" : "\(num)"
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.clear
        
        icon = createImageView(nil, image: nil, contentMode: nil)
        contentView.addSubview(icon)
        
        titleLabel = createLabel(CGRect.zero, font: titleFont, bacColor: nil, textColor: titleColor, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: nil)
        
        contentView.addSubview(titleLabel)
        
        lineView = UIView()
        lineView.backgroundColor = kUIStyle.colorWithHexString("#EDEDEF")
        contentView.addSubview(lineView)
        addRedCount()
    }
    
    //右边label
    func addContentLabel(_ title:String) {
        
        if contentlabel == nil {
            let  rightlabel = UILabel(frame: CGRect (x: titleLabel.maxX+40, y: 0, width:self.width-titleLabel.maxX-40-30, height: self.height))
            rightlabel.textColor = UIColor.colorWithHexString("F65F59")
            rightlabel.font = systemFont(13)
            rightlabel.adjustsFontSizeToFitWidth = true
            rightlabel.minimumScaleFactor = 0.8
            rightlabel.textAlignment = .right
            contentView.addSubview(rightlabel)
            contentlabel = rightlabel
            contentlabel!.text = title
            
        }else{
            contentlabel!.text = title
        }
        
    }
    //next image
    func addUserInfoNext() {
        //        arrow_right
        let nextImg = UIImageView(frame: CGRect (x: self.width - 30, y: 17.5, width: 12, height: 15))
        nextImg.image = UIImage.init(named: "arrow_right")
        contentView.addSubview(nextImg)
    }
    //红色提醒
    func addredNofity() {
        guard redNofityView == nil else {
            return
        }
        let width = getAutoRect(titleLabel.text, font: titleFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: 21).size.width
        let originX = 15+23+15+width+10
        redNofityView = UIView(frame: CGRect (x: originX, y: (self.bounds.height-20)/2, width: 8, height: 8))
        redNofityView.layer.cornerRadius = 4;
        redNofityView.clipsToBounds = true
        redNofityView.backgroundColor = UIColor.red
        contentView.addSubview(redNofityView)
    }
    
    func addRedCount() {
        guard redCount == nil else { return }
        redCount = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 12), bacColor: nil, textColor: .white, adjustsFontSizeToFitWidth: nil, textAlignment: .center, numberOfLines: nil)
        redCount.layer.cornerRadius = 10;
        redCount.clipsToBounds = true
        redCount.backgroundColor = UIColor.red
        redCount.isHidden = true
        contentView.addSubview(redCount)
        redCount.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    var coinlabel:UILabel!
    var payLabel:UILabel!
    func adduserInfoMoney(_ coin:String,premium:String) {
        //        cell.coin = (user.user_coin, user.user_premium)
        if coinlabel == nil {
            coinlabel = UILabel(frame: CGRect (x: 125, y: 0, width: self.width - 125 - 60, height: self.height))
            coinlabel.font = UIFont.systemFont(ofSize: (12*gdscale < 12 ? 12 : 12*gdscale))
            coinlabel.textColor = UIColor.colorWithHexString("#DF3B20")
            contentView.addSubview(coinlabel)
        }
        coinlabel.text = COINNAME+"：" + (coin == "" ? "0" : coin) + "  " + COINNAME_PREIUM+"：" + (premium == "" ? "0" : premium)
        
        addPayLabel()
        
    }
    ///
    func addNoticeView() {
        
        if noticeView == nil {
            noticeView = UIView()
            noticeView?.frame = CGRect(x: -1, y: 0, width: 6, height: 6)
            noticeView?.backgroundColor = UIColor.colorWithHexString("F65F59")
            noticeView?.centerY = contentView.centerY-6
            contentView.addSubview(noticeView!)
        }else{
            noticeView?.centerY = contentView.centerY-6
        }
        noticeView?.dsySetCorner(radius: 3)
        
    }
    
    func removeUserInfoMoney() {
        if coinlabel != nil {
            coinlabel.removeFromSuperview()
            coinlabel = nil
        }
        addPayLabel()
    }
    func addPayLabel() {
        if payLabel == nil {
            payLabel = UILabel(frame: CGRect (x: self.width - 60, y: 0, width: 30, height: self.height))
            payLabel.text = kLocalized("Recharge")
            payLabel.font = UIFont.systemFont(ofSize: (12*gdscale < 12 ? 12 : 12*gdscale))
            payLabel.textColor = UIColor.colorWithHexString("#DF3B20")
            contentView.addSubview(payLabel)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 15
        let iconSide: CGFloat = 23
        
        icon.frame = CGRect(x: space, y: (self.bounds.height-iconSide)/2, width: iconSide, height: iconSide)
        titleLabel.frame = CGRect(x: icon.frame.maxX+space, y: 0, width: self.bounds.width, height: self.bounds.height)
        lineView.frame = CGRect(x: titleLabel.x, y: self.bounds.height-1, width: self.bounds.width-titleLabel.x, height: 1)
        
        if noticeView != nil {
            if noticeView!.x <= CGFloat(0.0) {
                let x =   kUIStyle.getTextSizeWidth(text: titleLabel.text!, font:titleLabel.font, maxHeight: titleLabel.height) + titleLabel.x
                noticeView!.x = x
            }
        }
        
        
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 50
    }
}
