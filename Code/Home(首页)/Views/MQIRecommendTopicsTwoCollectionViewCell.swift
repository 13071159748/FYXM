//
//  MQIRecommendTopicsTwoCollectionViewCell.swift
//  CQSC
//
//  Created by BigMac on 2019/12/18.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

let recommendTopicsTwoWidth = (screenWidth - 2*Book_Store_Manger - 8)/2

class MQIRecommendTopicsTwoCollectionViewCell: MQICollectionViewCell {
    
    var bannerHeight: CGFloat! {
        
        return UIImageView.recommendTopicsBannerRealHeight(recommendTopicsTwoWidth)
    }

    var tapItemBlock: ((_ url: String)->())?
    
    var indexModel: MQIMainRecommendModel? {
        didSet {
            guard let indexModel = indexModel else {return}
            
            if let bannerModel1 = indexModel.banners.first {
                leftImageV.isHidden = false
                leftTitle.isHidden = false
                leftImageV.sd_setImage(with: URL(string: bannerModel1.img), placeholderImage: nil, options: [], completed: nil)
                leftTitle.text = bannerModel1.title
            } else {
                leftImageV.isHidden = true
                leftTitle.isHidden = true
            }
            if indexModel.banners.count > 1 {
                let bannerModel2 = indexModel.banners[1]
                rightTitle.isHidden = false
                rightImageV.isHidden = false
                rightTitle.text = bannerModel2.title
                rightImageV.sd_setImage(with: URL(string: bannerModel2.img), placeholderImage: nil, options: [], completed: nil)
            } else {
                rightTitle.isHidden = true
                rightImageV.isHidden = true
            }
        }
    }
    
    
    
    var leftImageV: UIImageView!
    var leftTitle: UILabel!
    var rightImageV: UIImageView!
    var rightTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addUI()
    }
    
    func addUI() {
        
        
        leftImageV = UIImageView()
        rightImageV = UIImageView()
        leftImageV.tag = 22
        rightImageV.tag = 23
        contentView.addSubview(leftImageV)
        contentView.addSubview(rightImageV)
        
        leftImageV.dsyAddTap(self, action: #selector(tapToUrl(_:)))
        rightImageV.dsyAddTap(self, action: #selector(tapToUrl(_:)))
        
        leftTitle = createLabel(.zero, font: kUIStyle.boldSystemFont1PXDesignSize(size: 12), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        rightTitle = createLabel(.zero, font: kUIStyle.boldSystemFont1PXDesignSize(size: 12), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        contentView.addSubview(leftTitle)
        contentView.addSubview(rightTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageV.frame = CGRect(x: 0, y: 0, width: recommendTopicsTwoWidth, height: bannerHeight)
        rightImageV.frame = CGRect(x: leftImageV.maxX + 8, y: 0, width: recommendTopicsTwoWidth, height: bannerHeight)
        leftTitle.frame = CGRect(x: leftImageV.x, y: leftImageV.maxY + 4, width: recommendTopicsTwoWidth, height: 17)
        rightTitle.frame = CGRect(x: rightImageV.x, y: leftTitle.y, width: recommendTopicsTwoWidth, height: 17)
    }
    
    @objc fileprivate func tapToUrl(_ tap: UITapGestureRecognizer) {
        if let view = tap.view {
            if let count = indexModel?.banners.count {
                if view.tag - 22 >= count {
                    return
                }
                if let bannerModel: MQIMainBannerRecommendModel = indexModel?.banners[view.tag - 22] {
                    tapItemBlock?(bannerModel.app_link)
                }
            }
        }
    }
    
    class func getSize() -> CGSize {
        
        return CGSize(width: screenWidth - 2*Book_Store_Manger, height: UIImageView.recommendTopicsBannerRealHeight(recommendTopicsTwoWidth) + 21)
    }
    
}


extension UIImageView {
    static func recommendTopicsBannerRealHeight(_ realWidth: CGFloat) -> CGFloat {
        return realWidth / (164/49)
    }
}
