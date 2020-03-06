//
//  MQICardbBtnTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardbBtnTableViewCell: MQICardBaseTableViewCell {

    var moneyLabel:UILabel!
    var clickBlick:(()->())?
    override func setupUI() {
        bacImge.image = UIImage(named: "Card_bottom_bg")
        bacImge.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
        }
        
        let openBtn = contentView.addCustomButton(CGRect.zero, title: kLocalized("Open_immediately")) { [weak self](btn) in
            self?.clickBlick?()}
        openBtn.setTitleColor(UIColor.white, for: .normal)
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        openBtn.dsySetCorner(radius: 6)
        openBtn.backgroundColor = mainColor
        
        openBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalTo(128)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
        }
        
        
        moneyLabel = UILabel()
        moneyLabel.font = UIFont.systemFont(ofSize: 16)
        moneyLabel.textAlignment = .center
        moneyLabel.textColor  =  UIColor.colorWithHexString("#2C2B40")
        contentView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bacImge).offset(10)
            make.right.equalTo(bacImge).offset(-10)
            make.bottom.equalTo(openBtn.snp.top).offset(-5)
        }
        
     
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 85
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
