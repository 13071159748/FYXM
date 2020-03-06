//
//  MQIUserReadRecordCollectionViewCell.swift
//  CQSCReader
//
//  Created by moqing on 2019/2/22.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIUserReadRecordCollectionViewCell: MQICollectionViewCell {
    var textLabel: UILabel!
    var progressLabel: UILabel!
    
    let textFont = UIFont.boldSystemFont(ofSize: 15)
    let textColor = RGBColor(51, g: 51, b: 51)
    let detextFont = UIFont.systemFont(ofSize: 13)
    let detextColor = RGBColor(93, g: 93, b: 93)
    
    var coverImage: MQIShadowImageView!
    var recordLabel: UILabel!
    var statusLabel: UILabel!
    
    
    var book: MQIUserReadRecordItemModel! {
        didSet {
            textLabel.text = book.book_name
//            progressLabel.text = "最近阅读时间：" + getTimeStampToString(book.readtime)
//            recordLabel.text = "\(kLocalized("AlreadyRead"))：\(book.chapter_title)"
//            statusLabel.text = (book.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
            mqLog(book.readtime)
            statusLabel.text = "\(kLocalized("AlreadyRead"))：\(book.chapter_title)"
            coverImage.imageView.sd_setImage(with: URL(string:book.book_cover), placeholderImage: bookPlaceHolderImage)
            
        }
    }
    
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()

    }
    
    func configUI() {
        coverImage = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImage)
    
        textLabel = UILabel(frame: CGRect.zero)
        textLabel.textColor = UIColor.colorWithHexString("#425154")
        textLabel.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(textLabel!)
        
        
        progressLabel = UILabel(frame: CGRect.zero)
        progressLabel.textColor = UIColor.colorWithHexString("#868989")
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(progressLabel)
        
        
        recordLabel = UILabel(frame: CGRect.zero)
        recordLabel.textColor = UIColor.colorWithHexString("7187FF")
        recordLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(recordLabel)
        
        statusLabel = UILabel(frame: CGRect.zero)
        statusLabel.textColor = UIColor.colorWithHexString("#868989")
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(statusLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImage.frame = CGRect(x: 15, y: 0, width: self.height*0.75 ,height:self.height )
        
        textLabel.frame = CGRect(x: coverImage.maxX+10, y: coverImage.y+10, width: self.width-coverImage.maxX-20, height: 22)
//
//        progressLabel.frame = CGRect(x: textLabel.x, y: textLabel.maxY+8, width: textLabel.width, height: 20)
//
//        recordLabel.frame = CGRect(x: textLabel.x, y: progressLabel.maxY+3, width: textLabel.width, height: 20)
        
        statusLabel.frame = CGRect(x: textLabel.x, y: coverImage.maxY-statusLabel.font.pointSize-15, width: textLabel.width, height: statusLabel.font.pointSize+5)
        
        
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 100*gdscale)
    }

    
    
  
}
