//
//  MQIChapterListViewConerollerCell.swift
//  Reader
//
//  Created by CQSC  on 16/8/2.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit

class MQIChapterListViewConerollerCell: MQITableViewCell {

    var vipIcon: UIImageView!
    var titleLabel: UILabel!
    var statusLabel: UILabel!

    var titleFont = UIFont.boldSystemFont(ofSize: 13)
    var titleFontSel = UIFont.boldSystemFont(ofSize: 15)
    
    var currentIndex = false {
        didSet {
            titleLabel.font = currentIndex == true ? titleFontSel : titleFont
        }
    }
    
    var titleNormalColor = RGBColor(151, g: 151, b: 151) {
        didSet {
            titleLabel.textColor = titleNormalColor
        }
    }
    var titleSelColor = RGBColor(252, g: 62, b: 62)
    
    var chapter: MQIEachChapter! {
        didSet {
            let color = chapter.isDown == true ? titleSelColor : titleNormalColor
            titleLabel.textColor = color
            titleLabel.text = chapter.chapter_title
            
            statusLabel.textColor = color
            statusLabel.text = chapter.isDown == true ? kLocalized("AlreadyDownLoad") : kLocalized("UnDownLoad")
            vipIcon.isHidden = !chapter.chapter_vip
            layoutSubviews()
            
        }
          
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    
    func configUI() {
        vipIcon = UIImageView()
        vipIcon.image =  UIImage(named: "chapter_vip")
        vipIcon.isHidden = false
        vipIcon.contentMode = .scaleAspectFit
        contentView.addSubview(vipIcon)
        
        titleLabel = createLabel(nil, font: titleFont, bacColor: UIColor.clear, textColor: nil, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: nil)
        contentView.addSubview(titleLabel)
        
        statusLabel = createLabel(nil, font: titleFont, bacColor: UIColor.clear, textColor: nil, adjustsFontSizeToFitWidth: nil, textAlignment: .right, numberOfLines: nil)
        contentView.addSubview(statusLabel)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftSpace: CGFloat = 20
        let rightSpace: CGFloat = 10
        let statusLabelWidth: CGFloat = 60
        statusLabel.frame = CGRect(x: self.bounds.width-rightSpace-statusLabelWidth,
                                   y: 0,
                                   width: statusLabelWidth,
                                   height: self.bounds.height)
        
        var originX: CGFloat = leftSpace
        if vipIcon.isHidden == false {
            let iconSide: CGFloat = 15
            vipIcon.frame = CGRect(x: leftSpace,
                                   y: (self.bounds.height-iconSide)/2,
                                   width: iconSide,
                                   height: iconSide)
            originX = vipIcon.frame.maxX+5
        }else {
            originX = leftSpace
            vipIcon.frame = CGRect.zero
        }
        
        titleLabel.frame = CGRect(x: originX,
                                  y: 0,
                                  width: statusLabel.frame.minX-10-originX,
                                  height: self.bounds.height)
    }
    
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 44
    }
}

