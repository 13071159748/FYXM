//
//  MQIRecommendTopicsCollectionViewCell.swift
//  CQSC
//
//  Created by BigMac on 2019/12/18.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
enum MQIRecommendBannerType {
    case bookIdType
    case appLinkType
}

class MQIRecommendTopicsCollectionViewCell: MQICollectionViewCell {
    
    let leftImageWidth = 145*gdscale
    let leftImageWHRatio = 145/154
    
    var leftBGImageV: UIImageView!
    var leftTitleLabel: UILabel!
    var leftImageV: UIImageView!
    
    var topTitleLabel: UILabel!
    var topImageV: UIImageView!
    var bottomTitleLabel: UILabel!
    var bottomImageV: UIImageView!

    var indexModel: MQIMainRecommendModel? {
        didSet {
            guard let indexModel = indexModel else {return}
            if let bookModel = indexModel.books.first {
                leftTitleLabel.text = bookModel.book_name
                leftImageV.sd_setImage(with: URL(string: bookModel.book_cover), placeholderImage: bookPlaceHolderImage, options: [], completed: nil)
            } else {
                leftImageV.image = bookPlaceHolderImage
                leftTitleLabel.text = ""
            }
            
            if let bannerModel1 = indexModel.banners.first {
                topTitleLabel.isHidden = false
                topImageV.isHidden = false
                topTitleLabel.text = bannerModel1.title
                topImageV.sd_setImage(with: URL(string: bannerModel1.img), placeholderImage: nil, options: [], completed: nil)
            } else {
                topTitleLabel.isHidden = true
                topImageV.isHidden = true
            }
            if indexModel.banners.count > 1 {
                bottomTitleLabel.isHidden = false
                bottomImageV.isHidden = false
                let bannerModel2 = indexModel.banners[1]
                bottomTitleLabel.text = bannerModel2.title
                bottomImageV.sd_setImage(with: URL(string: bannerModel2.img), placeholderImage: nil, options: [], completed: nil)
            } else {
                bottomTitleLabel.isHidden = true
                bottomImageV.isHidden = true
            }
        }
    }
    
    var tapItemBlock: ((_ type: MQIRecommendBannerType,_ url: String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addUI()
    }
    
    func addUI() {
        
        leftBGImageV = UIImageView()
        leftBGImageV.image = UIImage(named: "homeReccmmendBg")
        contentView.addSubview(leftBGImageV)
        
        leftTitleLabel = createLabel(.zero, font: kUIStyle.boldSystemFont1PXDesignSize(size: 14), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .center, numberOfLines: 1)
        contentView.addSubview(leftTitleLabel)
        
        leftImageV = UIImageView()
        contentView.addSubview(leftImageV)
        
        topTitleLabel = createLabel(.zero, font: kUIStyle.boldSystemFont1PXDesignSize(size: 13), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        contentView.addSubview(topTitleLabel)
        
        topImageV = UIImageView()
        topImageV.tag = 1234
        contentView.addSubview(topImageV)
        
        bottomTitleLabel = createLabel(.zero, font: kUIStyle.boldSystemFont1PXDesignSize(size: 13), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        contentView.addSubview(bottomTitleLabel)
        
        bottomImageV = UIImageView()
        bottomImageV.tag = 1235
        contentView.addSubview(bottomImageV)
        
        leftImageV.dsyAddTap(self, action: #selector(tapBookAction))
        topImageV.dsyAddTap(self, action: #selector(tapBannerAction))
        bottomImageV.dsyAddTap(self, action: #selector(tapBannerAction))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalHeight = 154*gdscale
        let bookHeight = totalHeight*119/154
        
        leftBGImageV.frame = CGRect(x: 0, y: 0, width: leftImageWidth, height: totalHeight)
        leftTitleLabel.frame = CGRect(x: 0, y: 0, width: leftImageWidth, height: totalHeight - bookHeight)
        leftImageV.frame = CGRect(x: 0, y: leftTitleLabel.maxY, width: leftBGImageV.width*88/145, height: bookHeight)
        leftImageV.centerX = leftBGImageV.centerX
        
        let space = 20*gdscale
        let rightWidth = screenWidth - 2*Book_Store_Manger - leftBGImageV.width - space
        let rightX = leftBGImageV.maxX + space
        let imageHeight = rightWidth/170*51
        
        topImageV.frame = CGRect(x: rightX, y: totalHeight/2 - imageHeight, width: rightWidth, height: imageHeight)
        topTitleLabel.frame = CGRect(x: rightX, y: 0, width: rightWidth, height: topImageV.y)
        
        bottomTitleLabel.frame = CGRect(x: rightX, y: topImageV.maxY, width: rightWidth, height: topTitleLabel.height)
        bottomImageV.frame = CGRect(x: rightX, y: bottomTitleLabel.maxY, width: rightWidth, height: topImageV.height)
    }
    
    @objc fileprivate func tapBookAction() {
        if let bookId = indexModel?.books.first?.book_id {
            tapItemBlock?(.bookIdType, bookId)
        }
    }
    
    @objc fileprivate func tapBannerAction(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            if let count = indexModel?.banners.count {
                if view.tag - 1234 >= count {
                    return
                }
                if let url = indexModel?.banners[view.tag - 1234].app_link {
                    tapItemBlock?(.appLinkType, url)
                }
            }
            
        }
    }
    
    
    class func getSize() -> CGSize {
        
        return CGSize(width: screenWidth - 2*Book_Store_Manger, height: 154*gdscale)
    }
    
    
    
}
