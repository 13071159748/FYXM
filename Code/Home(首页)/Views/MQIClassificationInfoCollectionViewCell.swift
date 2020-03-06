//
//  MQ_ClassificationInfoCollectionViewCell.swift
//  XSSC
//
//  Created by moqing on 2018/11/9.
//  Copyright © 2018 XSSC. All rights reserved.
//

import UIKit

class MQIClassificationInfoCollectionViewCell: MQICollectionViewCell {
    
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
    
                if text == "1" {
                    book_StatusLabel?.text = kLocalized("serial")
                    book_StatusLabel?.textColor = kUIStyle.colorWithHexString("7ED321")
                    book_StatusLabel?.dsySetBorderr(color: book_StatusLabel!.textColor, width: 1)
                 
                }else{
                    book_StatusLabel?.text = kLocalized("TheEnd")
                    book_StatusLabel?.textColor = kUIStyle.colorWithHexString("F5A623")
                    book_StatusLabel?.dsySetBorderr(color: book_StatusLabel!.textColor, width: 1)
                }
            }
            layoutSubviews()
        }
        
    }
    
    var class_nameLabel:UILabel?
    
    var classText:String! = "加载" {
        didSet{
            if let text = classText {
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
    
    
    
    let newWidth:CGFloat = kUIStyle.scale1PXH(104)*0.75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.white
        addsubView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addsubView() {
        
        coverImageView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(coverImageView!)
        coverImageView?.layer.cornerRadius = 2
        coverImageView?.clipsToBounds = true
        book_nameLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 15), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        contentView.addSubview(book_nameLabel!)
        
        book_StatusLabel = UILabel(frame: CGRect.zero)
        book_StatusLabel?.textColor = mainColor
        book_StatusLabel?.font = UIFont.systemFont(ofSize: 12)
        book_StatusLabel?.text = statusText
        book_StatusLabel?.textAlignment = .center
        contentView.addSubview(book_StatusLabel!)
        book_StatusLabel?.dsySetCorner(radius: 2)
      
        
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel?.font = UIFont.systemFont(ofSize: 12)
        class_nameLabel?.textColor = mainColor
        class_nameLabel?.textAlignment = .center
        contentView.addSubview(class_nameLabel!)
        class_nameLabel?.dsySetCorner(radius:2)
        class_nameLabel?.dsySetBorderr(color: mainColor, width: 1)
        
        
        book_introLabel = UILabel(frame: CGRect.zero)
        book_introLabel?.textColor = UIColor.colorWithHexString("#666666")
        book_introLabel?.font = UIFont.systemFont(ofSize: 12)
        book_introLabel?.numberOfLines = 0
        book_introLabel?.textAlignment = .left
        contentView.addSubview(book_introLabel!)
        
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView?.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.height)
    
        book_nameLabel?.frame = CGRect (x: coverImageView!.maxX + 10, y: 6, width: self.width-(coverImageView?.maxX)!-17, height: 15*gdscale)
        
        let newN = qiuZhengshu(classText) + "字"
        let nickWidth = getAutoRect(newN, font: UIFont.systemFont(ofSize: 13), maxWidth: 1000, maxHeight: 15).width+5
        
        class_nameLabel?.frame = CGRect (x:   book_nameLabel!.x, y: (book_StatusLabel?.y)!, width: nickWidth, height: 20)
        
        
        let classWidth = getAutoRect(book_StatusLabel!.text, font: (book_StatusLabel?.font)!, maxWidth: 100, maxHeight: 12).size.width
        
        book_StatusLabel?.frame = CGRect (x:class_nameLabel!.maxX + 10, y: coverImageView!.maxY-6-20, width: classWidth + 10, height: 20)
        
        
        book_introLabel?.frame = CGRect (x: book_nameLabel!.x, y: book_nameLabel!.maxY+5 , width: self.width-coverImageView!.maxX - 10, height: book_StatusLabel!.y-book_nameLabel!.maxY-10)
        
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth-40, height:kUIStyle.scale1PXH(104))
    }
   
    
}
