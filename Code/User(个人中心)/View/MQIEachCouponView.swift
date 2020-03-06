//
//  MQIEachCouponView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIEachCouponView: UIView {

    public var titleLabel: UILabel!
    public var deTitleLabel: UILabel!
    public var coinLabel: UILabel!
    
    public var eachCoupon: GYCouponItem! {
        didSet {
            titleLabel.font = boldFont(13)
            deTitleLabel.font = systemFont(12)
            
            layer.contents = bgImage(eachCoupon.coupon_type_bgcolor)?.cgImage
            titleLabel.text = eachCoupon.coupon_name
            deTitleLabel.text = eachCoupon.valid_desc
            configCoinlabelAttstrCoin(eachCoupon.conpon_value_split, boldFont(18), boldFont(10))
        }
    }
    
    public var eachUserCoupon: GYEachUserCoupon! {
        didSet {
            layer.contents = bgImage(eachUserCoupon.coupon_type_bgcolor)?.cgImage
            titleLabel.text = eachUserCoupon.coupon_name
            deTitleLabel.text = kLocalized("WillBeValidUntil")+eachUserCoupon.expiry_time.formatterDate()
            configCoinlabelAttstrCoin(eachUserCoupon.conpon_value_split, boldFont(22), boldFont(13))
        }
    }
    
    fileprivate func configCoinlabelAttstrCoin(_ coin: (String, String), _ titleFont: UIFont, _ deTitleFont: UIFont) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attStr1 = NSMutableAttributedString(string: coin.0, attributes:
            [.font : titleFont,
             .paragraphStyle: paragraph,
             .foregroundColor : coinLabel.textColor,
             .backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: coin.1, attributes:
            [.font : deTitleFont,
             .paragraphStyle : paragraph,
             .foregroundColor : coinLabel.textColor,
              .backgroundColor : UIColor.clear])
        
        attStr1.append(attStr2)
        coinLabel.attributedText = attStr1
    }
    
    fileprivate func bgImage(_ name: String) -> UIImage? {
        guard name == "money" else {
            return UIImage(named: "couponBac_red")
        }
        return UIImage(named: "couponBac_green")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        titleLabel = createLabel(CGRect(),
                                 font: boldFont(15),
                                 bacColor: UIColor.clear,
                                 textColor: blackColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .left,
                                 numberOfLines: 1)
        addSubview(titleLabel)
        
        deTitleLabel = createLabel(CGRect(),
                                   font: systemFont(13),
                                   bacColor: UIColor.clear,
                                   textColor: RGBColor(191, g: 191, b: 191),
                                   adjustsFontSizeToFitWidth: false,
                                   textAlignment: .left,
                                   numberOfLines: 1)
        addSubview(deTitleLabel)
        
        coinLabel = createLabel(CGRect(),
                                font: systemFont(20),
                                bacColor: UIColor.clear,
                                textColor: RGBColor(249, g: 91, b: 80),
                                adjustsFontSizeToFitWidth: true,
                                textAlignment: .right,
                                numberOfLines: 1)
        addSubview(coinLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = width*20/215
        let labelHeight: CGFloat = (height*30/60)/2
        titleLabel.frame = CGRect(x: space, y: (height-labelHeight*2)/2, width: width*111/215, height: labelHeight)
        deTitleLabel.frame = CGRect(x: space, y: titleLabel.maxY+1, width: titleLabel.width, height: labelHeight)
        
        coinLabel.frame = CGRect(x: width*145/215, y: titleLabel.y, width: width*55/215, height: labelHeight*2)
        //        if let statusView = statusView {
        //            let sHeight = height*0.9/2
        //            statusView.frame = CGRect(x: width-sHeight-width*5/215,
        //                                      y: height*2.5/57,
        //                                      width: sHeight,
        //                                      height: sHeight)
        //        }
        if let statusLabel = statusLabel {
            let sHeight = height*0.9/2
            statusLabel.frame = CGRect(x: width-sHeight-width*5/215, y: height*10/57, width: sHeight, height: 20)
        }
        
    }
    
    class func getEachCouponViewSize(_ width: CGFloat) -> CGSize {
        return CGSize(width: width, height: width*115/426)
    }
    
    //MARK: --
    fileprivate var statusView: UIImageView?
    fileprivate var statusLabel:UILabel?
    func addStatusView(_ status: String) {
        layer.contents = UIImage(named: "couponBac_unValid")?.cgImage
        
        
        if statusLabel == nil {
            statusLabel = UILabel(frame: CGRect.zero)
            addSubview(statusLabel!)
            statusLabel?.transform = statusLabel!.transform.rotated(by: CGFloat(Double.pi/4))
            
            statusLabel?.font = UIFont.systemFont(ofSize: 10)
            statusLabel?.layer.cornerRadius = 2
            statusLabel?.clipsToBounds = true
            statusLabel?.layer.borderColor = UIColor.black.cgColor
            statusLabel?.layer.borderWidth = 1
            statusLabel?.textAlignment = .center
            statusLabel?.layer.shadowPath = UIBezierPath(rect: statusLabel!.bounds).cgPath
            
        }
        statusLabel?.text = status
        
        let color = RGBColor(149, g: 149, b: 149)
        coinLabel.textColor = color
        deTitleLabel.textColor = color
        
        //        if statusView == nil {
        //            statusView = UIImageView(frame: CGRect.zero)
        //            addSubview(statusView!)
        //        }
        
        
        //        var imageName: String!
        //        switch status {
        //        case .used:
        //            imageName = "coupon_used"
        //        case .outDate:
        //            imageName = "coupon_outDate"
        //        default:
        //            imageName = "coupon_used"
        //        }
        //
        //        let image = UIImage(named: imageName)
        //        statusView?.image = image
        layoutIfNeeded()
    }
}

