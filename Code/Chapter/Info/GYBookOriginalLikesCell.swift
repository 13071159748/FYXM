//
//  GYBookOriginalLikesCell.swift
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalLikesCell: MQITableViewCell {
    
    var books: [MQIEachBook] = [MQIEachBook]() {
        didSet {
            if books.count == 1 {
                bookViews[1].isHidden = true
                bookViews[2].isHidden = true
            }else if books.count == 2 {
                bookViews[2].isHidden = true
            }else {
                for i in 0..<3 {
                    bookViews[i].book = books[i]
                }
            }
            
        }
    }
    
    var headerView: UIView!
    var changeBtn: UIButton!
    var titleLabel: UILabel!
    var bookViews = [GYBookOriginalLikesEachBook]()

    var toChange: (() -> ())?
    var clickAction: ((_ cBook: MQIEachBook) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        self.selectionStyle = .none
        
        headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.white
        
        changeBtn = createButton(CGRect.zero,
                               normalTitle: kLocalized("ChangeoOne"),
                               normalImage: UIImage(named: "info_change"),
                               selectedTitle: nil,
                               selectedImage: nil,
                               normalTilteColor: RGBColor(181, g: 181, b: 181),
                               selectedTitleColor: nil,
                               bacColor: nil,
                               font: UIFont.systemFont(ofSize: 13),
                               target: self,
                               action: #selector(GYBookOriginalLikesCell.otherBooksChange))
        headerView.addSubview(changeBtn)
        

        titleLabel = createLabel(CGRect.zero,
                                font: GYBookOriginalInfoVC_headerFont,
                                bacColor: nil,
                                textColor: GYBookOriginalInfoVC_headerColor,
                                adjustsFontSizeToFitWidth: nil,
                                textAlignment: .left,
                                numberOfLines: 1)
        titleLabel.text = kLocalized("GuessYouLike")
        headerView.addLine(10, lineColor: GYBookOriginalInfoVC_lineColor, directions: .bottom)
        headerView.addSubview(titleLabel)
        contentView.addSubview(headerView)
        
        for _ in 0..<3 {
            let view = GYBookOriginalLikesEachBook(frame: CGRect.zero)
            view.isUserInteractionEnabled = true
            addTGR(self, action: #selector(GYBookOriginalLikesCell.bookAction(_:)), view: view)
            bookViews.append(view)
            contentView.addSubview(view)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.width
        let btnWidth: CGFloat = 80
        let labelWidth: CGFloat = 100
        
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: GYBookOriginalInfoVC_headerHeight)
        changeBtn.frame = CGRect(x: width-btnWidth-10, y: 0, width: btnWidth, height: GYBookOriginalInfoVC_headerHeight)
        titleLabel.frame = CGRect(x: 10, y: 0, width: labelWidth, height: GYBookOriginalInfoVC_headerHeight)
        
        let leftSpace: CGFloat = 20
        let space: CGFloat = 40
        let bookViewWidth = (self.bounds.width-2*leftSpace-2*space)/3
        for i in 0..<bookViews.count {
            bookViews[i].frame = CGRect(x: leftSpace+(space+bookViewWidth)*CGFloat(i), y: headerView.frame.maxY+15, width: bookViewWidth, height: self.bounds.height)
        }
    }
    
    @objc func otherBooksChange() {
        toChange?()
    }
    
    @objc func bookAction(_ tgr: UITapGestureRecognizer) {
        if let view = tgr.view {
            if let b = (view as! GYBookOriginalLikesEachBook).book {
                clickAction?(b)
            }
        }
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        let leftSpace: CGFloat = 20
        let space: CGFloat = 60
        let bookViewWidth = (screenWidth-2*leftSpace-2*space)/3
        
        return bookViewWidth*87/62+105
    }

}

class GYBookOriginalLikesEachBook: UIView {
    
    var bookCover: MQIBookImageView!
    var titleLabel: UILabel!
    
    var titleFont = UIFont.systemFont(ofSize: 13)
    var tagFont = UIFont.systemFont(ofSize: 12)
    
    
    var titleColor = RGBColor(132, g: 132, b: 132)
    var tagColor = RGBColor(171, g: 171, b: 171)
    var tagsNormalColor = RGBColor(163, g: 163, b: 163)
    var tagFontHeight: CGFloat = 0
    
    var tagLabels = [UILabel]()
    
    var book: MQIEachBook? {
        didSet {
            if let book = book {
                bookCover.bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
                titleLabel.text = book.book_name
                
                for label in tagLabels {
                    label.removeFromSuperview()
                }
                tagLabels.removeAll()
                
//                let str = book.book_tags.rangeOfString(",") != nil ? "," : " "
//                let keys =  book.book_tags.componentsSeparatedByString(str)
                let keys = [book.class_name]//, book.subclass_name]//不显示sub
                for i in 0..<keys.count {
                    let label = createLabel(nil,
                                            font: tagFont,
                                            bacColor: UIColor.clear,
                                            textColor: tagsNormalColor,
                                            adjustsFontSizeToFitWidth: nil,
                                            textAlignment: .center,
                                            numberOfLines: 1)
                    label.text = keys[i]
                    self.addSubview(label)
                    tagLabels.append(label)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        tagFontHeight = tagFont.lineHeight+3
        bookCover = MQIBookImageView(frame: CGRect.zero)
        self.addSubview(bookCover)
        
        titleLabel = createLabel(CGRect.zero,
                                 font: titleFont,
                                 bacColor: nil,
                                 textColor: titleColor,
                                 adjustsFontSizeToFitWidth: nil,
                                 textAlignment: .left,
                                 numberOfLines: 0)
        self.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width
        let titleWidth = getAutoRect(titleLabel.text, font: titleFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: 21).size.width
        bookCover.frame = CGRect(x: 0, y: 0, width: width, height: self.bounds.width*87/62)
        titleLabel.frame = CGRect(x: bookCover.frame.minX, y: bookCover.frame.maxY+3, width: width, height: titleWidth > width ? 40 : 21)
        
        
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
                if currentIndex >= (titleWidth > width ? 1 : 2) {
                    break
                }
            }
            tagLabels[i].frame = CGRect(x: originX, y: originY, width: width, height: tagFontHeight)
            tagLabels[i].layer.cornerRadius = 2
            tagLabels[i].layer.borderColor = tagLabels[i].textColor.cgColor
            tagLabels[i].layer.borderWidth = 0.7
            tagLabels[i].layer.masksToBounds = true
            
            originX += width+5
        }
        
    }
    
}
