//
//  MQICardBannerCellTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardBannerCellTableViewCell: MQICardBaseTableViewCell {
    
    var bannerImg: UIImageView!
    var clickBlock:(()->())?
    override func setupUI() {
        bacImge.isHidden = true
        let bacView = UIView()
        bacView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        contentView.addSubview(bacView)
        bacView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bannerImg = UIImageView()
//        bannerImg.contentMode = .scaleAspectFit
        contentView.addSubview(bannerImg)
        bannerImg.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: card_LeftMargin2, bottom: 8, right: card_LeftMargin2))
        }
        bannerImg.dsyAddTap(self, action: #selector(clickBanner(tap:)))
        
    }
    @objc func clickBanner(tap:UITapGestureRecognizer) {
        clickBlock?()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 106
    }

}
