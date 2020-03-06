//
//  GDReadEndGuessLikeCell.swift
//  Reader
//
//  Created by CQSC  on 2018/1/24.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class GDReadEndGuessLikeCell: MQICollectionViewCell {
    
    var eachbookModel:MQIChoicenessListModel? {
        didSet{
            if let model = eachbookModel {
                bookTitleLabel.text = eachbookModel?.title
                bookCover.sd_setImage(with: URL(string:model.cover), placeholderImage: UIImage(named: goodBookPlaceHolderImg))
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 3
                let attStr = NSMutableAttributedString(string: model.desc, attributes:
                    [NSAttributedString.Key.paragraphStyle : paragraph,
                     NSAttributedString.Key.font:systemFont(12),
                     ])
                contentLabel.attributedText = attStr
                contentLabel.lineBreakMode = .byTruncatingTail
                eyeLabel.text = model.read_num + kLocalized("FollowRead")
                layoutSubviews()

            }
            

        }
    }
    
    fileprivate var bookTitleLabel:UILabel!
    fileprivate var bookCover:UIImageView!
    fileprivate var contentLabel:UILabel!
    fileprivate var eyeImageView:UIImageView!
    fileprivate var eyeLabel:UILabel!
    fileprivate var lookDetailLabel:UILabel!
    fileprivate var lookDetailImageView:UIImageView!
    
    fileprivate var bgView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGussLikeView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGussLikeView()
    }
    func addGussLikeView() {
        bgView = UIView(frame: CGRect.zero)
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        contentView.addSubview(bgView)
        
        bookTitleLabel = UILabel(frame: CGRect.zero)
        bookTitleLabel.textColor = UIColor.colorWithHexString("#3c3c3c")
        bookTitleLabel.font = systemFont(14*gd_scale)
        bookTitleLabel.text = "大力出奇迹"
        bgView.addSubview(bookTitleLabel)
        
        bookCover = UIImageView.init(frame: CGRect.zero)
        bookCover.layer.cornerRadius = 8
        bookCover.clipsToBounds = true
        bookCover.image = UIImage(named: goodBookPlaceHolderImg)
        bgView.addSubview(bookCover)
        
        contentLabel = UILabel.init(frame: CGRect.zero)
        contentLabel.textColor = UIColor.colorWithHexString("#999999")
//                contentLabel.font = systemFont(12)
        contentLabel.numberOfLines = 2
        contentLabel.text = "充气娃娃产业背后的黑幕充气娃娃产业背后的黑幕充气娃娃产业背后的黑幕充气娃娃产业背背后的黑幕..."
        bgView.addSubview(contentLabel)
        
        let eyeImg = UIImage.init(named: "reader_goodeye")?.withRenderingMode(.alwaysTemplate)
        eyeImageView = UIImageView.init(frame: CGRect.zero)
        eyeImageView.image = eyeImg
        eyeImageView.tintColor = UIColor.colorWithHexString("#D95F67")
        bgView.addSubview(eyeImageView)
        
        eyeLabel = UILabel.init(frame: CGRect.zero)
        eyeLabel.textColor = UIColor.colorWithHexString("#999999")
        eyeLabel.font = systemFont(11)
        eyeLabel.text = "1000追读"
        bgView.addSubview(eyeLabel)
        
        lookDetailLabel = UILabel.init(frame: CGRect.zero)
        lookDetailLabel.textColor = mainColor
        lookDetailLabel.font = systemFont(11)
        lookDetailLabel.textAlignment = .right
        lookDetailLabel.text = kLocalized("CheckDetail")
        bgView.addSubview(lookDetailLabel)
        
        let image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        lookDetailImageView = UIImageView.init(frame: CGRect.zero)
        lookDetailImageView.image = image
        lookDetailImageView.tintColor = mainColor
        bgView.addSubview(lookDetailImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x: 0, y: 18, width: self.width, height: self.height - 18)
        
        bookTitleLabel.frame = CGRect.init(x: 13*gd_scale, y: 0, width: self.width-26*gd_scale, height: 49*gd_scale)
        
        var currentHeight:CGFloat = 142
        let cellWidth = self.width-25*gd_scale
        if let model = eachbookModel {
            let imgWidth = model.width.CGFloatValue()
            let imgHeight = model.height.CGFloatValue()
            currentHeight = cellWidth * imgHeight / imgWidth
            bookCover.frame = CGRect.init(x: 12.5*gd_scale, y: bookTitleLabel.maxY, width: cellWidth, height: currentHeight)
        }else {
            bookCover.frame = CGRect.init(x: 12.5*gd_scale, y: bookTitleLabel.maxY, width: cellWidth, height: currentHeight)
        }
        contentLabel.frame = CGRect.init(x: bookTitleLabel.x, y: bookCover.maxY, width: bookTitleLabel.width, height: 51.5)
        eyeImageView.frame = CGRect.init(x: bookTitleLabel.x, y: contentLabel.maxY, width: 16, height: 12)

        eyeLabel.frame = CGRect.init(x: eyeImageView.maxX+5, y: eyeImageView.y, width: bookTitleLabel.width - 110, height: 12)
        
        lookDetailImageView.frame = CGRect.init(x: self.width - 10-13, y: eyeLabel.y, width: 10, height: 12)
        lookDetailLabel.frame = CGRect.init(x: self.width - 13 - 7 - 5 - 80, y: lookDetailImageView.y, width: 80, height: 12)
        
    }
    class func getGuessSize(_ width:String="0",height:String="142") ->CGSize {
        var newWidth = width.CGFloatValue()
        if newWidth == 0 {
            newWidth = screenWidth - 49 - 25
        }
        let currentHeight = (screenWidth-74*gd_scale) * height.CGFloatValue() / newWidth
        return CGSize(width: screenWidth-49*gd_scale, height: currentHeight + 18 + 80 + 49*gd_scale)
    }
    
}
