//
//  GYSearchResultCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/8.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYSearchResultCell: MQICollectionViewCell {

    @IBOutlet weak var icon: MQIBookImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    @IBOutlet weak var classNameLabel: UILabel!
    var tagLabels = [UILabel]()
   
    let textFont = UIFont.boldSystemFont(ofSize: 15)
    let textColor = RGBColor(51, g: 51, b: 51)
    
    let detextFont = UIFont.systemFont(ofSize: 13)
    let detextColor = RGBColor(151, g: 151, b: 151)
    
    var book: MQIEachBook! {
        didSet {
            textLabel.text = book.book_name
//             = book.book_status
//            summaryLabel.text = book.book_intro
            
            if book.book_status == "1" {
              authorLabel.text = kLocalized("SerialWorks")
            }else {
                authorLabel.text = kLocalized("FinishedWork")
            }
//            textLabel.backgroundColor = UIColor.black
//            
//            authorLabel.backgroundColor = UIColor.gray
//            
//            summaryLabel.backgroundColor = UIColor.yellow
            
            
            
            icon.bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
            
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .justified
            paragraph.lineSpacing = 2
            if screenWidth > 320 {
                paragraph.lineSpacing = 3
            }
            let attStr = NSMutableAttributedString(string: MQIEachBook.shortInfo(book.book_intro), attributes:
                [.font : UIFont.systemFont(ofSize: 12),
                 .paragraphStyle : paragraph,
                .foregroundColor : UIColor.colorWithHexString("#999999"),
               .backgroundColor : UIColor.clear])
            summaryLabel?.attributedText = attStr

            
            
//            let width = getAutoRect(book.subclass_name, font: detextFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: 20)
            
            if book.subclass_name.length == 4 {
                classNameLabel.text = book.subclass_name.substring(NSMakeRange(2, 2))
            }else{
                classNameLabel.text = book.subclass_name
                
            }
            
            classNameLabel.layer.cornerRadius = 2
            classNameLabel.layer.borderColor = detextColor.cgColor
            classNameLabel.layer.borderWidth = 1.0

            
            
            
//            var originX: CGFloat = 0
//            let originY: CGFloat = 0
//            
//            let tagFontHeight = detextFont.lineHeight+3
//
//            for label in tagLabels {
//                label.removeFromSuperview()
//                tagLabels.removeAll()
//            }
            
            /*
            let keys = [book.class_name, book.subclass_name]
            for i in 0..<keys.count {
                if keys[i].count <= 0 {
                    continue
                }
                
                let width = getAutoRect(keys[i], font: detextFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: tagFontHeight).size.width+6
                
                let label = createLabel(CGRect(x: originX, y: originY, width: width, height: tagFontHeight),
                                        font: detextFont,
                                        bacColor: UIColor.clear,
                                        textColor: detextColor,
                                        adjustsFontSizeToFitWidth: nil,
                                        textAlignment: .center,
                                        numberOfLines: 1)
                
                originX += width+5
                
                label.text = keys[i]
                label.layer.cornerRadius = 2
                label.layer.borderColor = detextColor.cgColor
                label.layer.borderWidth = 1.0
                label.layer.masksToBounds = true
                tagView.addSubview(label)
                tagLabels.append(label)
            }
            */
        }
    }
//    override func layoutSubviews() {
//        MQLog("1111111")
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.textColor = textColor
        textLabel.font = textFont
        
        authorLabel.textColor = detextColor
        authorLabel.font = detextFont
        
        summaryLabel.textColor = detextColor
        summaryLabel.font = detextFont
        
        classNameLabel.textColor = detextColor
        classNameLabel.font = detextFont
        addLine(0, lineColor: RGBColor(244, g: 244, b: 244), directions: .bottom)
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 118)
    }

}
