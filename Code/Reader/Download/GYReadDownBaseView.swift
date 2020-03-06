//
//  GYReadDownBaseView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadDownBaseView: UIView {
    
    fileprivate var icon: UIImageView?
    fileprivate var deTitleLabel: UILabel!
    
    public var selBtn: UIButton!
    public var titleLabel: UILabel!
    
    fileprivate let titleFont = systemFont(12)
    fileprivate let titleColor = RGBColor(51, g: 51, b: 51)
    
    public var indexPath: IndexPath!
    
    let greenColor = RGBColor(93, g: 179, b: 83)
    let originColor = RGBColor(254, g: 119, b: 60)
    
    public var isSelected: Bool = false {
        didSet {
            selBtn.isSelected = isSelected
        }
    }
    
    public var forceToHiddenSelBtn: Bool = false
    
    var selBlock: ((_ sel: Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        titleLabel = createLabel(CGRect.zero,
                                 font: titleFont,
                                 bacColor: UIColor.clear,
                                 textColor: titleColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .left,
                                 numberOfLines: 1)
        self.addSubview(titleLabel)
        
        deTitleLabel = createLabel(CGRect.zero,
                                   font: systemFont(13),
                                   bacColor: UIColor.clear,
                                   textColor: originColor,
                                   adjustsFontSizeToFitWidth: true,
                                   textAlignment: .left,
                                   numberOfLines: 1)
        self.addSubview(deTitleLabel)
        
        
        selBtn = createButton(CGRect.zero,
                              normalTitle: nil,
                              normalImage: UIImage(named: "reader_protocol_unSel")?.withRenderingMode(.alwaysTemplate),
                              selectedTitle: nil,
                              selectedImage: UIImage(named: "reader_protocol_sel")?.withRenderingMode(.alwaysOriginal),
                              normalTilteColor: nil,
                              selectedTitleColor: nil,
                              bacColor: UIColor.clear,
                              font: nil,
                              target: self,
                              action: #selector(GYReadDownBaseView.selAction(_:)))
        selBtn.tintColor = RGBColor(171, g: 171, b: 171)
        self.addSubview(selBtn)
    }
    
    func addIcon() {
        titleLabel.font = systemFont(14)
        icon = UIImageView(frame: CGRect.zero)
        icon!.image = UIImage(named: "arrow_right")
        self.addSubview(icon!)
    }
    // vip
    func configCoin(_ price: String) {
        selBtn.isHidden = forceToHiddenSelBtn
        
//        deTitleLabel.text = price+COINNAME
        deTitleLabel.text = "未订阅"
        deTitleLabel.textColor = originColor
        deTitleLabel.textAlignment = .right
    }
    
    // 已经 订阅
    func configSubsribe() {
        selBtn.isHidden = forceToHiddenSelBtn
        
        deTitleLabel.text = "已订阅"
        deTitleLabel.textColor = originColor
        deTitleLabel.textAlignment = .right
    }
    
    func configFree() {
        selBtn.isHidden = forceToHiddenSelBtn
        
        deTitleLabel.text = kLocalized("free")
        deTitleLabel.textColor = greenColor
        deTitleLabel.textAlignment = .right
    }
    
    func configDown() {
        selBtn.isHidden = true
        deTitleLabel.textColor = RGBColor(151, g: 151, b: 151)
        deTitleLabel.text = "已下载"
        layoutSubviews()
    }
    
    func transFromIcon(_ spread: Bool) {
        if let icon = icon {
            if spread == true {
                icon.image = UIImage(named: "arrow_down")
            }else {
                icon.image = UIImage(named: "arrow_right")
            }
        }
    }
    
    @objc func selAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        selBlock?(btn.isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnSide: CGFloat = 40
        selBtn.frame = CGRect(x: self.width-btnSide-GYReadDownVC_rightSpace, y: (self.height-btnSide)/2, width: btnSide, height: btnSide)
        
        if selBtn.isHidden == true {
            deTitleLabel.frame = CGRect(x: selBtn.x-20, y: 0, width: 50, height: self.height)
        }else {
            deTitleLabel.frame = CGRect(x: selBtn.x-50, y: 0, width: 50, height: self.height)
        }
        var originX: CGFloat = 40
        if let icon = icon {
            let iconSide: CGFloat = 17
            icon.frame = CGRect(x: GYReadDownVC_leftSpace, y: (self.height-iconSide)/2, width: iconSide, height: iconSide)
            originX = icon.maxX+15
        }
        
        titleLabel.frame = CGRect(x: originX, y: 0, width: deTitleLabel.x-originX, height: self.height)
        
    }
    
    class func getHeight() -> CGFloat {
        return 50
    }
    
}
