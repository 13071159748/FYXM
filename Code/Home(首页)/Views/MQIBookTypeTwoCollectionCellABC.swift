//
//  MQIBookTypeTwoCollectionCellABC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

//左边是书  右边是 name  content 等
class MQIBookTypeTwoCollectionCellABC: MQICollectionViewCell {
    var coverImageView:MQIShadowImageView!
    
    var book_nameLabel:UILabel?
    
    //连载状态
    var book_StatusLabel:UILabel?
    
    var statusText:String? = kLocalized("serial") {
        didSet {
            book_StatusLabel?.text = statusText
            if statusText == "" || statusText == nil {
                book_StatusLabel?.isHidden = true
            }
            layoutSubviews()
        }
        
    }
    
    var class_nameLabel:UILabel?
    
    var classText:String! = kLocalized("MQIloading2") {
        didSet{
            if let text = classText {
                let newN = qiuZhengshu(text) + kLocalized("Word")
                self.class_nameLabel?.text = newN
                layoutSubviews()
            }
        }
     
        
    }
    
    var book_introLabel:UILabel?
    var bookcontentText:String? {
        didSet {
            if let text = bookcontentText {
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 4
                let attStr = NSMutableAttributedString(string: MQIEachBook.shortInfo(text), attributes:
                    [NSAttributedString.Key.font : book_introLabel!.font,
                     NSAttributedString.Key.paragraphStyle : paragraph,
                     NSAttributedString.Key.foregroundColor :  book_introLabel!.textColor
                    ])
                book_introLabel?.attributedText = attStr
                book_introLabel?.lineBreakMode = .byTruncatingTail
            }
        }
    }
      var colorS = [kUIStyle.colorWithHexString("EB5567"),kUIStyle.colorWithHexString("F5A623"),kUIStyle.colorWithHexString("5A94FF"),kUIStyle.colorWithHexString("CBCBCB")]
        var sortingBtn:UIButton!
    var sortingText:String = "" {
        didSet(oldValue) {
            sortingBtn.isHidden = false
            if sortingText == "1" {
                sortingBtn.tintColor = colorS[0]
            }else if sortingText == "2" {
                sortingBtn.tintColor = colorS[1]
            }else if sortingText == "3" {
                sortingBtn.tintColor = colorS[2]
            }else if sortingText == ""{
                sortingBtn.isHidden = true
                sortingBtn.tintColor = UIColor.clear
            }else {
                sortingBtn.tintColor = colorS[3]
            }
            sortingBtn.setTitle(sortingText, for: .normal)
        }
        
    }
    var book_authorLabel:UILabel?
    var book_authorText:String? {
        didSet {
            book_authorLabel?.text = book_authorText
            if book_authorText == "" || book_authorText == nil {
                book_authorLabel?.isHidden = true
            }
            layoutSubviews()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.white
        addtypeTwoView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addtypeTwoView() {
        
        coverImageView = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImageView)
        //        coverImageView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        coverImageView?.layer.shadowRadius = 2
        //        coverImageView?.layer.shadowOpacity = 0.5
        
        book_nameLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 16), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        
        book_nameLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(book_nameLabel!)
        
        book_StatusLabel = UILabel(frame: CGRect.zero)
        book_StatusLabel?.layer.cornerRadius = 2
        book_StatusLabel?.clipsToBounds = true
        book_StatusLabel?.layer.borderWidth = 1
        book_StatusLabel?.textColor = mainColor//UIColor.colorWithHexString("#BFBFBF")
        book_StatusLabel?.layer.borderColor = mainColor.cgColor
        //UIColor.colorWithHexString("#D9DADA").cgColor
        book_StatusLabel?.font = UIFont.systemFont(ofSize: 11)
//        book_StatusLabel?.backgroundColor = mainColor
        book_StatusLabel?.text = statusText
        book_StatusLabel?.textAlignment = .center
        contentView.addSubview(book_StatusLabel!)
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel?.layer.cornerRadius = 2
        class_nameLabel?.clipsToBounds = true
        class_nameLabel?.layer.borderWidth = 1
        class_nameLabel?.textColor = UIColor.colorWithHexString("#999999")
        class_nameLabel?.layer.borderColor = UIColor.colorWithHexString("#999999").cgColor
        class_nameLabel?.font = UIFont.systemFont(ofSize: 11)
        class_nameLabel?.textAlignment = .center
        contentView.addSubview(class_nameLabel!)
        
        book_introLabel = UILabel(frame: CGRect.zero)
        book_introLabel?.textColor = UIColor.colorWithHexString("#595B68")
        book_introLabel?.font = UIFont.systemFont(ofSize: 14)
        book_introLabel?.numberOfLines = 0
        contentView.addSubview(book_introLabel!)
        
        sortingBtn =  UIButton()
        sortingBtn.isUserInteractionEnabled = false
        sortingBtn.setBackgroundImage(UIImage(named: "rank_top")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sortingBtn.titleLabel?.font  = kUIStyle.sysFont(size: 12)
        sortingBtn.setTitleColor(UIColor.white, for: .normal)
        contentView.addSubview(sortingBtn)
        sortingText = ""
        
        
        book_authorLabel =  UILabel(frame: CGRect.zero)
        book_authorLabel?.textColor = UIColor.colorWithHexString("#9DA0A9")
        book_authorLabel?.font = UIFont.systemFont(ofSize: 13)
        book_authorLabel?.numberOfLines = 1
        book_authorLabel?.textAlignment = .left
        book_authorLabel?.adjustsFontSizeToFitWidth = true
        contentView.addSubview(book_authorLabel!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(x: 0, y: 0, width: Book_Store_TypeOne_img_w, height: Book_Store_TypeOne_img_h)
        //        coverImageView?.layer.shadowPath = UIBezierPath(rect: coverImageView!.bounds).cgPath
        if sortingBtn.isHidden {
             book_nameLabel?.frame = CGRect (x: coverImageView.maxX + 10, y: 0, width: self.width-(coverImageView?.maxX)!-17, height: 15*gdscale)
        }else{
            sortingBtn.frame = CGRect(x: self.width-15, y: 0, width: 15, height: 15*1.38)
            book_nameLabel?.frame = CGRect (x: coverImageView.maxX + 10, y: 0, width: sortingBtn.x-(coverImageView?.maxX)!-17 , height: 15*gdscale)
        }
        
        
        let classWidth = getAutoRect(statusText, font: (book_StatusLabel?.font)!, maxWidth: 100, maxHeight: 12).size.width
        
        book_StatusLabel?.frame = CGRect (x: book_nameLabel!.x, y:0, width: classWidth + 10, height: 20)
        book_StatusLabel?.maxY = coverImageView.maxY
        
        let newN = qiuZhengshu(classText) + kLocalized("Word")
        let nickWidth = getAutoRect(newN, font:  class_nameLabel!.font, maxWidth: 1000, maxHeight: 15)
        class_nameLabel?.frame = CGRect (x: book_StatusLabel!.maxX + 10, y: (book_StatusLabel?.y)!, width: nickWidth.width+10, height: 20)
        
        class_nameLabel?.maxX = self.width
        book_StatusLabel?.maxX = class_nameLabel!.x-10
        
        book_authorLabel?.frame = CGRect(x: book_nameLabel!.x, y: (book_StatusLabel?.y)!, width:  book_StatusLabel!.x-book_nameLabel!.x-20, height: 20)
        book_introLabel?.frame = CGRect (x: book_nameLabel!.x, y: book_nameLabel!.maxY + 6, width: self.width-coverImageView!.maxX - 10, height:book_StatusLabel!.y-book_nameLabel!.maxY-12)
        
    }
    
    class func getSize() -> CGSize {
        //从header到横线的距离   （设计图）
        return CGSize(width: screenWidth-2*Book_Store_Manger, height: Book_Store_TypeOne_img_h)
        
    }
    class func getSpecialSize() -> CGSize {
        
        return CGSize(width: screenWidth-30*gdscale, height: 132*gdscale)
        
    }
    
}


//左边是书  右边是 name  content 等
class MQIBookTypeTwoCollectionCellABC2: MQICollectionViewCell {
    var coverImageView:MQIShadowImageView!
    
    var book_nameLabel:UILabel?
    
    //连载状态
    var book_StatusLabel:UILabel?
    
    var statusText:String? = kLocalized("serial") {
        didSet {
            book_StatusLabel?.text = statusText
            if statusText == "" || statusText == nil {
                book_StatusLabel?.isHidden = true
            }
            layoutSubviews()
        }
        
    }
    
    var class_nameLabel:UILabel?
    
    var classText:String! = kLocalized("MQIloading2") {
        didSet{
            if let text = classText {
                let newN = qiuZhengshu(text) + kLocalized("Word")
                self.class_nameLabel?.text = newN
                layoutSubviews()
            }
        }
        
        
    }
    
    var book_introLabel:UILabel?
    var bookcontentText:String? {
        didSet {
            if let text = bookcontentText {
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 4
                let attStr = NSMutableAttributedString(string: MQIEachBook.shortInfo(text), attributes:
                    [NSAttributedString.Key.font : book_introLabel!.font,
                     NSAttributedString.Key.paragraphStyle : paragraph,
                     NSAttributedString.Key.foregroundColor :  book_introLabel!.textColor
                    ])
                book_introLabel?.attributedText = attStr
                book_introLabel?.lineBreakMode = .byTruncatingTail
            }
        }
    }

    var book_authorLabel:UILabel?
    var book_authorText:String? {
        didSet {
            book_authorLabel?.text = book_authorText
            if book_authorText == "" || book_authorText == nil {
                book_authorLabel?.isHidden = true
            }
            layoutSubviews()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.white
        addtypeTwoView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addtypeTwoView() {
        
        coverImageView = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImageView)
        //        coverImageView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        coverImageView?.layer.shadowRadius = 2
        //        coverImageView?.layer.shadowOpacity = 0.5
        
        book_nameLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 16), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        
        book_nameLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(book_nameLabel!)
        
        book_StatusLabel = UILabel(frame: CGRect.zero)
        book_StatusLabel?.layer.cornerRadius = 2
        book_StatusLabel?.clipsToBounds = true
        book_StatusLabel?.layer.borderWidth = 1
        book_StatusLabel?.textColor = UIColor.colorWithHexString("#999999")
        book_StatusLabel?.layer.borderColor = UIColor.colorWithHexString("#999999").cgColor
        book_StatusLabel?.font = UIFont.systemFont(ofSize: 11)
        //        book_StatusLabel?.backgroundColor = mainColor
        book_StatusLabel?.text = statusText
        book_StatusLabel?.textAlignment = .center
        contentView.addSubview(book_StatusLabel!)
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel?.layer.cornerRadius = 2
        class_nameLabel?.clipsToBounds = true
        class_nameLabel?.layer.borderWidth = 1
        class_nameLabel?.textColor =  UIColor.colorWithHexString("#7187FF")
        class_nameLabel?.layer.borderColor = UIColor.colorWithHexString("#7187FF").cgColor
        class_nameLabel?.font = UIFont.systemFont(ofSize: 11)
        class_nameLabel?.textAlignment = .center
        contentView.addSubview(class_nameLabel!)
        
        book_introLabel = UILabel(frame: CGRect.zero)
        book_introLabel?.textColor = UIColor.colorWithHexString("#595B68")
        book_introLabel?.font = UIFont.systemFont(ofSize: 14)
        book_introLabel?.numberOfLines = 3
        contentView.addSubview(book_introLabel!)
        
      
        book_authorLabel =  UILabel(frame: CGRect.zero)
        book_authorLabel?.textColor = UIColor.colorWithHexString("#9DA0A9")
        book_authorLabel?.font = UIFont.systemFont(ofSize: 13)
        book_authorLabel?.numberOfLines = 1
        book_authorLabel?.textAlignment = .left
        book_authorLabel?.adjustsFontSizeToFitWidth = true
        contentView.addSubview(book_authorLabel!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(x: 0, y: 0, width: Book_Store_TypeOne_img_w, height: Book_Store_TypeOne_img_h)
       
       book_nameLabel?.frame = CGRect (x: coverImageView.maxX + 10, y: 0, width: self.width-(coverImageView?.maxX)!-17, height: 15*gdscale)
        
        
        let classWidth = getAutoRect(statusText, font: (book_StatusLabel?.font)!, maxWidth: 100, maxHeight: 12).size.width
        
        book_StatusLabel?.frame = CGRect (x: book_nameLabel!.x, y:0, width: classWidth + 10, height: 20)
        book_StatusLabel?.maxY = coverImageView.maxY
        
        let newN = qiuZhengshu(classText) + kLocalized("Word")
        let nickWidth = getAutoRect(newN, font:  class_nameLabel!.font, maxWidth: 1000, maxHeight: 15)
        class_nameLabel?.frame = CGRect (x: coverImageView!.maxX + 10, y: (book_StatusLabel?.y)!, width: nickWidth.width+10, height: 20)
        
//        class_nameLabel?.maxX = self.width
        book_StatusLabel?.x = class_nameLabel!.maxX+10
        
        book_authorLabel?.frame = CGRect(x: book_nameLabel!.x, y: (book_StatusLabel?.y)!, width:  book_StatusLabel!.x-book_nameLabel!.x-20, height: 20)
        book_introLabel?.frame = CGRect (x: book_nameLabel!.x, y: book_nameLabel!.maxY + 6, width: self.width-coverImageView!.maxX - 10, height:book_StatusLabel!.y-book_nameLabel!.maxY-12)
        
    }
    
    class func getSize() -> CGSize {
        //从header到横线的距离   （设计图）
        return CGSize(width: screenWidth-2*Book_Store_Manger, height: Book_Store_TypeOne_img_h)
        
    }
  
    
}
