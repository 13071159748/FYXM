//
//  MQIUserConsumeCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserConsumeCell: MQITableViewCell {

    var iconImgView:UIImageView!
    var titleLabel:UILabel!
    var alreadySubscribeLabel:UILabel!
    var payLabel:UILabel!
    var timeLabel:UILabel!
    var detailLabel: UILabel?
    var clickToReader:((_ indexPath:IndexPath)->())?
    var indexPath:IndexPath?
    var consume:MQICostBookList! {
        didSet {
            if consume.whole_subscribe == "1" {
                detailLabel?.isHidden = true
                alreadySubscribeLabel.text = kLocalized("SubscribeToComplete")
            }else {
                detailLabel?.isHidden = false
                alreadySubscribeLabel.text =  kLongLocalized("SubscribedToTheChapter", replace: "\(consume.cost_num)")
            }
            iconImgView.sd_setImage(with: URL(string: consume.book_cover), placeholderImage: bookPlaceHolderImage)
            titleLabel.text = consume.book_name
            timeLabel.text = consume.cost_month
            
            var coinText:String = ""
            var premiumText:String = ""
            if consume.coin.integerValue() > 0 {
                coinText = "\(consume.coin.integerValue())"+COINNAME
            }
            if consume.premium.integerValue() > 0 {
                premiumText = "\(consume.premium.integerValue())" + COINNAME_PREIUM
            }
            if coinText.count > 0 && premiumText.count > 0 {
                payLabel.attributedText = payLabelDifferentColor(payLabel.font, message: coinText + "+" + premiumText)
            }else {
                if coinText.count != 0 || premiumText.count != 0 {
                    payLabel.attributedText = payLabelDifferentColor(payLabel.font, message: coinText + premiumText)
                }else{
                    payLabel.attributedText = NSAttributedString()
                }
            }
            
        }
    }
    func payLabelDifferentColor(_ font:UIFont,message:String) -> NSMutableAttributedString{
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        let attStr1 = NSMutableAttributedString(string: kLocalized("ATotalOf"), attributes:
            [.font : font,
             .paragraphStyle : paragraph,
             .foregroundColor: UIColor.colorWithHexString("#999999"),
             .backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: message, attributes:
            [.font : font,
             .paragraphStyle : paragraph,
             .foregroundColor : UIColor.colorWithHexString("#41B6D6"),
             .backgroundColor : UIColor.clear])
        
        attStr1.append(attStr2)
        //        coinLabel.attributedText = attStr1
        return attStr1
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUserConsumeCell()
    }
    override func configSelectedBac() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addUserConsumeCell()
        
    }
    func addUserConsumeCell() {
        iconImgView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(iconImgView)
        
        detailLabel = UILabel(frame: CGRect.zero)
        detailLabel?.layer.cornerRadius = 3
        detailLabel?.clipsToBounds = true
        detailLabel?.layer.borderWidth = 0.5
        detailLabel?.layer.borderColor = UIColor.colorWithHexString("#999999").cgColor
        detailLabel?.textColor = UIColor.colorWithHexString("#999999")
        detailLabel?.textAlignment = .center
        contentView.addSubview(detailLabel!)
        detailLabel?.text = "消费详情"
        detailLabel?.font = UIFont.systemFont(ofSize: 10)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.colorWithHexString("#23252C")
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        alreadySubscribeLabel = UILabel(frame: CGRect.zero)
        alreadySubscribeLabel.textColor = UIColor.colorWithHexString("#666666")
        alreadySubscribeLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(alreadySubscribeLabel)
        
        payLabel = UILabel(frame: CGRect.zero)
        payLabel.textColor = mainColor
        payLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(payLabel)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.colorWithHexString("#999999")
        contentView.addSubview(timeLabel)
        
        let  clickView =  UIView()
        contentView.addSubview(clickView)
     
        clickView.dsyAddTap(self, action: #selector(MQIUserConsumeCell.clickViewFunc))
        clickView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(timeLabel)
        }
    }
    
    @objc  func clickViewFunc()  {
        guard let indexP = self.indexPath else {
            return
        }
        clickToReader?(indexP)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImgView.frame =  CGRect (x: 21, y: 6, width: 44, height: 64)
        
        detailLabel?.frame = CGRect (x: self.width - 50 - 21, y:iconImgView.y+6, width: 50, height: 18)
        
        titleLabel.frame =  CGRect (x: iconImgView.maxX + 11.5, y: iconImgView.y+6, width: self.width - iconImgView.maxX - 11.5 - 50 - 21, height: 14)
        
        alreadySubscribeLabel.frame = CGRect (x: iconImgView.maxX + 11.5, y: titleLabel.maxY + 8.5, width: titleLabel.width, height: 12)
        
        payLabel.frame = CGRect (x: iconImgView.maxX + 11.5, y: alreadySubscribeLabel.maxY + 10, width: titleLabel.width, height: 10)
        
        timeLabel.frame = CGRect (x: self.width - 50 - 21, y: payLabel.y, width: 50+21, height: 10)
        
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 78
    }
    

}
