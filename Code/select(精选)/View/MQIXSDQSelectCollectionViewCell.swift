//
//  MQIXSDQSelectCollectionViewCell.swift
//  XSDQReader
//
//  Created by moqing on 2018/12/27.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

class MQIXSDQSelectCollectionViewCell: MQICollectionViewCell {
    var coverImageView:UIImageView?
    
    var book_nameLabel:UILabel?
    
    //连载状态
    var book_StatusLabel:UILabel?
    
    var statusText:String? = "连载" {
        didSet {
            if let text = statusText {
                if text == "" || text == "0" {
                    book_StatusLabel?.isHidden = true
                }else{
                    book_StatusLabel?.isHidden = false
                }
                book_StatusLabel?.text = statusText
               
            }
            layoutSubviews()
        }
        
    }
    
    var class_nameLabel:UILabel?
    
    var classText:String! = "字" {
        didSet{
            if let text = classText {
                if text == "" || text == "0" {
                    class_nameLabel?.isHidden = true
                }else{
                    class_nameLabel?.isHidden = false
                }
                let newN = qiuZhengshu(text) + "字"
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
                paragraph.lineSpacing = 2
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
    
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
//        self.backgroundColor = UIColor.white

        self.layer.shadowColor = UIColor.colorWithHexString("D8D8D8", alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height:2 )
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.clipsToBounds = false
        
        let  bacView = UIView(frame: self.bounds)
        bacView.backgroundColor = UIColor.white
         bacView.layer.cornerRadius = 5
        contentView.addSubview(bacView)
        
        coverImageView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(coverImageView!)
//        coverImageView?.layer.cornerRadius = 2
//        coverImageView?.clipsToBounds = true
        book_nameLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 15), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        contentView.addSubview(book_nameLabel!)
        
        book_StatusLabel = UILabel(frame: CGRect.zero)
        book_StatusLabel?.textColor = mainColor
        book_StatusLabel?.font = UIFont.systemFont(ofSize: 10)
        book_StatusLabel?.textAlignment = .center
        contentView.addSubview(book_StatusLabel!)
        book_StatusLabel?.dsySetCorner(radius: 2)
        book_StatusLabel?.dsySetBorderr(color: book_StatusLabel!.textColor, width: 1)

        
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel?.font = UIFont.systemFont(ofSize: 10)
        class_nameLabel?.textColor = kUIStyle.colorWithHexString("999999")
        class_nameLabel?.textAlignment = .center
        contentView.addSubview(class_nameLabel!)
        class_nameLabel?.dsySetCorner(radius:2)
        class_nameLabel?.dsySetBorderr(color: class_nameLabel!.textColor, width: 1)
        
        
        book_introLabel = UILabel(frame: CGRect.zero)
        book_introLabel?.textColor = UIColor.colorWithHexString("#666666")
        book_introLabel?.font = UIFont.systemFont(ofSize: 12)
        book_introLabel?.numberOfLines = 0
        book_introLabel?.textAlignment = .left
        contentView.addSubview(book_introLabel!)
        
        
    }
    let newWidth:CGFloat = kUIStyle.scale1PXH(78)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView?.frame = CGRect(x: 10, y: 0, width: newWidth, height: newWidth*1.334)
        coverImageView?.centerY = self.height*0.5
        
        book_nameLabel?.frame = CGRect (x: coverImageView!.maxX + 10, y: coverImageView!.y+6, width: self.width-(coverImageView?.maxX)!-17, height: 15*gdscale)
        
     
        let classWidth = getAutoRect(book_StatusLabel!.text, font: (book_StatusLabel?.font)!, maxWidth: 100, maxHeight: 12).size.width
        
        book_StatusLabel?.frame = CGRect (x:book_nameLabel!.x, y: coverImageView!.maxY-6-book_StatusLabel!.font.pointSize-5, width: classWidth + 10, height:  book_StatusLabel!.font.pointSize+5)
        
        
        let newN = qiuZhengshu(classText) + "字"
        let nickWidth = getAutoRect(newN, font:  class_nameLabel!.font, maxWidth: 1000, maxHeight: 15).width+5
        
        class_nameLabel?.frame = CGRect (x:   (book_StatusLabel!.isHidden) ? (book_nameLabel!.x):(book_StatusLabel!.maxX+10) , y: (book_StatusLabel?.y)!, width: nickWidth, height: class_nameLabel!.font.pointSize+5)
        
        
        book_introLabel?.frame = CGRect (x: book_nameLabel!.x, y: book_nameLabel!.maxY+5 , width: self.width-coverImageView!.maxX - 20, height: book_StatusLabel!.y-book_nameLabel!.maxY-10)
        
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth-30, height: kUIStyle.scale1PXH(128))
    }

    
}

