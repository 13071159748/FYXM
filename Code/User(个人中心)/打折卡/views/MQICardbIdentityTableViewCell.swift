//
//  MQICardbIdentityTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardbIdentityTableViewCell:MQICardBaseTableViewCell {
    
    var title:UILabel!
    var subTitle:UILabel!
    var iconImg:UIImageView!
    var lineView:UIView!
    
    override func setupUI() {
        bacImge.image = UIImage(named: "Card_center_bg")
        
        iconImg = UIImageView()
//        iconImg.backgroundColor = UIColor.gray
        iconImg.contentMode = .scaleAspectFit
        contentView.addSubview(iconImg)
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(bacImge).offset(35)
            make.width.height.equalTo(52)
        }
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("#F1F1F1")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(iconImg)
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.right.equalTo(bacImge).offset(-35)
        }
        
        title  = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor  = UIColor.colorWithHexString("#2C2B40")
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth  = true
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.right.equalTo(lineView)
            make.left.equalTo(iconImg.snp.right).offset(12)
            make.bottom.equalTo(iconImg.snp.centerY)
        }
  
        
        subTitle  = UILabel()
        subTitle.font = UIFont.systemFont(ofSize: 13)
        subTitle.textColor  = UIColor.colorWithHexString("#999999")
        subTitle.textAlignment = .left
        subTitle.adjustsFontSizeToFitWidth  = true
        contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.right.equalTo(title)
            make.left.equalTo(title)
            make.top.equalTo(iconImg.snp.centerY).offset(5)
        }
        
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 80
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
