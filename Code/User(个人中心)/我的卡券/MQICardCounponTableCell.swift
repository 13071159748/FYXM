//
//  MQICardCounponTableCell.swift
//  CQSC
//
//  Created by BigMac on 2019/12/23.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardCounponTableCell: MQITableViewCell {

    var rechargeBlock:((_ url: String?)->())?
    var contenChangeBlock:((_ expend: Bool)->())?
    
    @IBOutlet weak var topBgView: UIView!
    
    @IBOutlet weak var topLeftCardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var cardUseConditionLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var countDownImage: UIImageView!
    
    @IBOutlet weak var useLabel: UILabel!
    
    @IBOutlet weak var explainBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var indexModel: MQICardCouponItemModel? {
        didSet {
            guard let indexModel = indexModel else {return}
            
            let nameText = "\(indexModel.reward_value) \(indexModel.reward_title)"
            let mulAttribute = NSMutableAttributedString(string: nameText)
            mulAttribute.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: NSMakeRange(nameText.length - indexModel.reward_title.length, indexModel.reward_title.length))
            cardNameLabel.attributedText = mulAttribute
            
            cardUseConditionLabel.text = "\(indexModel.prize_name)"
            dateLabel.text = kLongLocalized("ValidUntil", replace:  getTimeStampToString(String(indexModel.expiry_time), format: " yyyy-MM-dd"))//HH:mm:ss
            //说明
            let explainString = indexModel.expend ? "\(indexModel.desc)\n" : ""
            let explainAttribute = NSMutableAttributedString(string: explainString)
            let space = NSMutableParagraphStyle()
            space.lineSpacing = 7.5
            explainAttribute.addAttribute(.paragraphStyle, value: space, range: NSMakeRange(0, explainString.length))
            contentLabel.attributedText = explainAttribute
            explainBtn.isSelected = indexModel.expend
            mqLog("contentLabel.text \(String(describing: contentLabel.text))")
            let timeSpam = (indexModel.expiry_time - getCurrentStamp()) / (3600*24)
            if indexModel.status == 1 && timeSpam > 0 && timeSpam < 7 {
                countDownLabel.text = kLongLocalized("expiredCountTime", replace: String(timeSpam))
                countDownImage.isHidden = false
            } else {
                countDownLabel.isHidden = true
                countDownImage.isHidden = true
            }
            
            
            switch indexModel.status {
            case 1://未使用
                
                line.backgroundColor = UIColor.colorWithHexString("#E9C36C")
                explainBtn.setTitleColor(UIColor.colorWithHexString("#5A94FF"), for: .normal)
                explainBtn.setImage(UIImage(named: "cardcoupon_down_blue"), for: .normal)
                explainBtn.setImage(UIImage(named: "cardcoupon_up_blue"), for: .selected)
                
                useLabel.backgroundColor = UIColor.colorWithHexString("#F8E71C")
                useLabel.textColor = UIColor.colorWithHexString("#333333")
                dateLabel.textColor = UIColor.colorWithHexString("#333333")
                
                useLabel.text = kLocalized("unusedText")
                topBgView.setNeedsDisplay()
                break
                
            case 2, 3://已使用 //已过期
                
                line.backgroundColor = UIColor.colorWithHexString("#D3D3D3")
                explainBtn.setTitleColor(UIColor.colorWithHexString("#999999"), for: .normal)
                explainBtn.setImage(UIImage(named: "cardcoupon_down_gray"), for: .normal)
                explainBtn.setImage(UIImage(named: "cardcoupon_up_gray"), for: .selected)
                
                useLabel.backgroundColor = UIColor.colorWithHexString("#8D8D8D")
                useLabel.textColor = .white
                dateLabel.textColor = UIColor.colorWithHexString("#999999")
                
                if indexModel.status == 2 {
                    useLabel.text = kLocalized("hadusedText")
                } else {
                    useLabel.text = kLocalized("expiredText")
                }
                topBgView.setNeedsDisplay()
                break
                
            default:
                break
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapAction()
        contentView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        cardUseConditionLabel.font = kUIStyle.sysFontDesign1PXSize(size: 14)
//        explainBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 12)
//        dateLabel.font = kUIStyle.sysFontDesign1PXSize(size: 12)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else { return }
            if let status = weakSelf.indexModel?.status {
                if status == 1 {
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.frame = weakSelf.topLeftCardView.frame
                    gradientLayer.colors = [UIColor.colorWithHexString("#EECE79").cgColor, UIColor.colorWithHexString("#D9A043").cgColor]
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                    weakSelf.topLeftCardView.layer.insertSublayer(gradientLayer, at: 0)
                } else {
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.frame = weakSelf.topLeftCardView.frame
                    gradientLayer.colors = [UIColor.colorWithHexString("#E1E1E1").cgColor, UIColor.colorWithHexString("#A1A1A1").cgColor]
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                    weakSelf.topLeftCardView.layer.insertSublayer(gradientLayer, at: 0)
                }
            }
            weakSelf.topBgView.dsySetCorner(byRoundingCorners: [.topLeft, .topRight], radii: 4.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func expendContentClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        contenChangeBlock?(sender.isSelected)
    }
}


extension MQICardCounponTableCell {
    
    func addTapAction() {
        topBgView.dsyAddTap(self, action: #selector(rechargeTap))
    }
    
    @objc fileprivate func rechargeTap() {
        if let status = indexModel?.status {
            if status == 1 {
                rechargeBlock?(indexModel?.url)
            }
        }
    }
    
}
