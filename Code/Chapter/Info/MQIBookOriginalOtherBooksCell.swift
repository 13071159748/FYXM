//
//  GYBookOriginalOtherBooksCell.swift
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIBookOriginalOtherBooksCell: MQITableViewCell {
    
    var bookCover: MQIBookImageView!
    var titleLabel: UILabel!
    var infoLabel: GYLabel!
    
    let titleFont = UIFont.systemFont(ofSize: 14)
    let infoFont = UIFont.systemFont(ofSize: 13)
    
    let titleColor = blackColor
    let infoColor = RGBColor(113, g: 113, b: 113)
    
    let tagsColors = [RGBColor(0, g: 161, b: 193), RGBColor(50, g: 78, b: 255)]
    let tagsNormalColor = RGBColor(163, g: 163, b: 163)
    let tagFont = UIFont.systemFont(ofSize: 12)
    var tagFontHeight: CGFloat = 0
    
    var indexPath: IndexPath!
    
    var tagLabels = [UILabel]()
    var book: MQIEachBook? {
        didSet {
            if let book = book {
                bookCover.bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
                titleLabel.text = book.book_name
                if book.book_short_intro == "" {
                    infoLabel.text = kLocalized("NoIntroduction")
                }else {
                    infoLabel.text = book.book_short_intro
                }
                
                for label in tagLabels {
                    label.removeFromSuperview()
                }
                tagLabels.removeAll()
                
//                let str = book.book_tags.rangeOfString(",") != nil ? "," : " "
//                let keys =  book.book_tags.componentsSeparatedByString(str)
                let keys = [book.class_name, book.subclass_name]
                for i in 0..<keys.count {
                    if keys[i].count <= 0 {
                        continue
                    }
                    let color = i == 0 ? tagsColors[indexPath.row%2 == 0 ? 0 : 1] : tagsNormalColor
                    let label = createLabel(nil,
                                            font: tagFont,
                                            bacColor: UIColor.clear,
                                            textColor: color,
                                            adjustsFontSizeToFitWidth: nil,
                                            textAlignment: .center,
                                            numberOfLines: 1)
                    label.text = keys[i]
                    contentView.addSubview(label)
                    tagLabels.append(label)
                }
                self.layoutIfNeeded()
            }
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
        tagFontHeight = tagFont.lineHeight+3
        
        bookCover = MQIBookImageView(frame: CGRect.zero)
        contentView.addSubview(bookCover)
        
        titleLabel = createLabel(CGRect.zero,
                                 font: titleFont,
                                 bacColor: nil,
                                 textColor: titleColor,
                                 adjustsFontSizeToFitWidth: nil,
                                 textAlignment: .left,
                                 numberOfLines: 1)
        contentView.addSubview(titleLabel)
        
        infoLabel = GYLabel(frame: CGRect.zero)
        infoLabel.textColor = infoColor
        infoLabel.font = infoFont
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        contentView.addSubview(infoLabel)
//        infoLabel.backgroundColor = UIColor.gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bookCover.frame = CGRect(x: 20, y: 10, width: (self.bounds.height-20)*62/87, height: self.bounds.height-20)
        
        titleLabel.frame = CGRect(x: bookCover.frame.maxX+10,
                                      y: bookCover.frame.minY,
                                      width: self.bounds.width-bookCover.frame.maxX-10,
                                      height: 21)
        
        var originX: CGFloat = titleLabel.frame.minX
        var originY: CGFloat = titleLabel.frame.maxY+5
        let tagsSpace: CGFloat = 5
        var currentIndex: Int = 0
        for i in 0..<tagLabels.count {
            
            let text = tagLabels[i].text
            let width = getAutoRect(text, font: tagFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: tagFontHeight).size.width+6
            if originX+width+tagsSpace > self.bounds.width {
                originX = titleLabel.frame.minX
                originY += tagsSpace+tagFontHeight
                currentIndex += 1
                if currentIndex >= 2 {
                    break
                }
            }
            tagLabels[i].frame = CGRect(x: originX, y: originY, width: width, height: tagFontHeight)
            tagLabels[i].layer.cornerRadius = 2
            tagLabels[i].layer.borderColor = tagLabels[i].textColor.cgColor
            tagLabels[i].layer.borderWidth = i == 0 ? 1.0 : 0.7
            tagLabels[i].layer.masksToBounds = true
            
            originX += width+5
        }
//        infoLabel.backgroundColor = UIColor.yellow
        infoLabel.frame = CGRect(x: titleLabel.frame.minX,
                                     y: originY+5+tagFontHeight,
                                     width: titleLabel.frame.width,
                                     height: bookCover.frame.maxY-originY-5-tagFontHeight)
//        infoLabel.verticalAlignment = VerticalAlignmentBottom
    }

}
