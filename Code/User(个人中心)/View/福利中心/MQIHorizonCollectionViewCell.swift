//
//  MQIHorizonCollectionViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/12/18.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class MQIHorizonCollectionViewCell: MQICollectionViewCell {
    
    var topBGImageV: UIImageView!
    var bottomTitleLabel: UILabel!
    
    var indexModel: MQIPopupAdsenseListModel? {
        willSet {
            if let model = newValue {
                topBGImageV!.sd_setImage(with:URL(string:  model.image), placeholderImage: UIImage(named: book_PlaceholderImg))
                bottomTitleLabel.text = model.title
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubViews()
    }
    
    func addSubViews() {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "welfare_event_bg")
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.left.equalTo(-5)
            make.right.equalTo(-16)
            make.top.equalTo(-5)
            make.bottom.equalTo(8)
        }

        
        let backgroundView = UIView()
        backgroundView.dsySetCorner(radius: 5)
        contentView.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalTo(-20)
            make.height.equalTo(88)
        }

        topBGImageV = UIImageView()
        backgroundView.addSubview(topBGImageV)
        
        bottomTitleLabel = createLabel(.zero, font: UIFont.systemFont(ofSize: 12), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        backgroundView.addSubview(bottomTitleLabel)
        
        topBGImageV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(62)
        }
        
        bottomTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(topBGImageV.snp.bottom).offset(4)
            make.right.equalTo(topBGImageV.snp.right).offset(-20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        bgImageV.image = MQ_SectionManager.shared.currentSectionType == .Boy ? UIImage(named: "bookstorehorizenBG_boy") :  UIImage(named: "bookstorehorizenBG_girl")
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: 208, height: 88)  //175/340
    }
    
}
