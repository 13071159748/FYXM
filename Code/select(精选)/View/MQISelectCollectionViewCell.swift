//
//  MQISelectCollectionViewCell.swift
//  XSDQReader
//
//  Created by moqing on 2018/10/16.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

class MQISelectCollectionViewCell: MQICollectionViewCell {
    
    var eachbookModel:MQIChoicenessListModel? {
        didSet{
            if let model = eachbookModel {
                bookTitleLabel.text = model.title
                bookCover.sd_setImage(with: URL(string:model.cover), placeholderImage: UIImage(named: goodBookPlaceHolderImg))
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 6
                let attStr = NSMutableAttributedString(string: model.desc, attributes:
                    [NSAttributedString.Key.paragraphStyle : paragraph,
                     NSAttributedString.Key.font
                        :contentLabel.font,
                     ])
                contentLabel.attributedText = attStr
                contentLabel.lineBreakMode = .byTruncatingTail
                stateLabel.text = model.subclass_name
                lookDetailLabel.text = model.read_num + kLocalized("FollowRead")
                eyeLabel.text = "\(model.like)"
                last_time_read_Label.text = model.last_time_read
                layoutSubviews()
            }
            
        }
    }
    fileprivate var bookTitleLabel:UILabel!
    fileprivate var bookCover:UIImageView!
    fileprivate var contentLabel:UILabel!
    fileprivate var stateLabel:UILabel!
    fileprivate var eyeImageView:UIImageView!
    fileprivate var eyeLabel:UILabel!
    
    fileprivate var lookDetailLabel:UILabel!
    fileprivate var footView:UIView!
    
    fileprivate var last_time_read_Label:UILabel!
    
    var clickLast_time_readBlock:(()->())?
    
    //    func boundingRectWithWith
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTypeSimpleView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addTypeSimpleView() {
 
        
        bookCover = UIImageView.init(frame: CGRect.zero)
        bookCover.layer.cornerRadius = 8
        bookCover.clipsToBounds = true
        contentView.addSubview(bookCover)
        
        stateLabel =  UILabel(frame: CGRect.zero)
        stateLabel.textColor = UIColor.colorWithHexString("#ffffff")
        stateLabel.font = systemFont(12*gd_scale)
        stateLabel.textAlignment = .center
        stateLabel.dsySetCorner(radius: stateLabel.font.pointSize*0.5+5)
        stateLabel.backgroundColor = UIColor.colorWithHexString("FF4E5E")
        contentView.addSubview(stateLabel)
        
        bookTitleLabel = UILabel(frame: CGRect.zero)
        bookTitleLabel.textColor = UIColor.colorWithHexString("#1C1C1E")
        bookTitleLabel.font = UIFont.boldSystemFont(ofSize: 12*gd_scale)
        contentView.addSubview(bookTitleLabel)
        
        
        contentLabel = UILabel.init(frame: CGRect.zero)
        contentLabel.textColor = UIColor.colorWithHexString("#717B7D")
        contentLabel.font = systemFont(14*gd_scale)
        contentLabel.text = " "
        contentLabel.numberOfLines = 3
        contentView.addSubview(contentLabel)
        
        let eyeImg = UIImage.init(named: "read_num_image")?.withRenderingMode(.alwaysTemplate)
        eyeImageView = UIImageView.init(frame: CGRect.zero)
        eyeImageView.image = eyeImg
        eyeImageView.contentMode = .scaleAspectFit
        eyeImageView.tintColor = UIColor.colorWithHexString("#ABB5B7")
        contentView.addSubview(eyeImageView)
        
        eyeLabel = UILabel.init(frame: CGRect.zero)
        eyeLabel.textColor = UIColor.colorWithHexString("#ABB5B7")
        eyeLabel.font = systemFont(12*gd_scale)
        eyeLabel.textAlignment = .right
        contentView.addSubview(eyeLabel)
        

        lookDetailLabel = UILabel.init(frame: CGRect.zero)
        lookDetailLabel.textColor = UIColor.colorWithHexString("#ABB5B7")
        lookDetailLabel.font = systemFont(12*gd_scale)
        lookDetailLabel.textAlignment = .left
        contentView.addSubview(lookDetailLabel)
        
        footView = UIView()
        footView.backgroundColor = UIColor.colorWithHexString("F3F4F4")
        contentView.addSubview(footView)
        
        last_time_read_Label = UILabel.init(frame: CGRect.zero)
        last_time_read_Label.textColor = UIColor.colorWithHexString("#339AFF")
        last_time_read_Label.font = systemFont(13*gd_scale)
        last_time_read_Label.text = " "
        last_time_read_Label.textAlignment = .center
        last_time_read_Label.backgroundColor = UIColor.colorWithHexString("F4F7FA")
        contentView.addSubview(last_time_read_Label)
        last_time_read_Label.isHidden = true
        last_time_read_Label.dsyAddTap(self, action: #selector(clickLast_time_read))
    }
    
    @objc func clickLast_time_read()  {
        clickLast_time_readBlock?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w:CGFloat = self.width-36*gdscale
        if let model = eachbookModel {
            
            let imgWidth = model.width.CGFloatValue()
            let imgHeight = model.height.CGFloatValue()
            var than = imgHeight/imgWidth
            if imgWidth == 1 || imgHeight == 0.5 {
                than = 0.4264 /// 默认
            }
            let currentHeight = w*than
          
            bookCover.frame = CGRect.init(x: 18*gdscale, y:10, width: w, height: currentHeight)
            if model.subclass_name == "" {
                  stateLabel.frame =  CGRect.init(x: 0, y: bookCover.maxY+10, width:0, height: 0)
            }else{
             var  stateW = kUIStyle.getTextSizeWidth(text: model.subclass_name, font: stateLabel.font, maxHeight: 26*gd_scale)+15
                if stateW <= 60 {
                    stateW = 60
                }
                stateLabel.frame =  CGRect.init(x: bookCover.x, y: bookCover.maxY+10, width:stateW, height:stateLabel.font.pointSize+10)
            
            
            }
        }else {
            bookCover.frame = CGRect.init(x:18*gdscale, y: 14 * hdscale, width: w, height: 0)
            stateLabel.frame =  CGRect.init(x: 0, y: bookCover.maxY+10, width:0, height: 0)
        }
        if stateLabel.x == 0 {
            bookTitleLabel.frame = CGRect.init(x: bookCover.x, y:stateLabel.y, width: w-stateLabel.maxX-10, height: bookTitleLabel.font.pointSize)
        }else{
            bookTitleLabel.frame = CGRect.init(x: stateLabel.maxX+5, y:0, width: w-stateLabel.maxX-10, height: bookTitleLabel.font.pointSize)
              bookTitleLabel.centerY = stateLabel.centerY
        }
       
        var height = kUIStyle.getTextSizeHeight(text: contentLabel.text!, font: contentLabel.font, maxWidth: w)
        
        if height > (contentLabel.font.pointSize*3+30){
            height = contentLabel.font.pointSize*3+30
        }
        contentLabel.frame = CGRect.init(x:bookCover.x, y: bookTitleLabel.maxY + 10 , width: w, height: height)
        
        lookDetailLabel.frame = CGRect.init(x: bookCover.x, y: contentLabel.maxY+5, width: 200*gd_scale, height: lookDetailLabel.font.pointSize)
        
        eyeLabel.frame = CGRect.init(x: contentLabel.maxX-200*gd_scale-16*gd_scale, y: lookDetailLabel.y, width: 200*gd_scale, height: eyeLabel.font.pointSize)
        
        eyeImageView.frame = CGRect.init(x: eyeLabel.maxX, y: 0, width: 16*gd_scale, height: 12*gd_scale)
        eyeImageView.centerY = eyeLabel.centerY
        
        if last_time_read_Label.text != "" {
            last_time_read_Label.frame = CGRect(x: 0, y:  self.height-44, width: self.width, height: 44)
            last_time_read_Label.isHidden = false
            footView.isHidden = true
        }else{
            last_time_read_Label.isHidden = true
            footView.isHidden = false
            footView.frame = CGRect(x: 0, y: self.height-8*gd_scale, width:self.width, height: 8*gd_scale)
        }

    }
    class func getSize(lastItem:Bool = false,model:MQIChoicenessListModel) -> CGSize {
        
        let newWidth = model.width.CGFloatValue()
        let newHeight  =  model.height.CGFloatValue()
        var than = newHeight/newWidth
        
        if newWidth == 1 || newHeight == 0.5 {
            than = 0.4264 /// 默认
        }
        var textHeight = kUIStyle.getTextSizeHeight(text:model.desc, font: systemFont(14*gd_scale), maxWidth: screenWidth - 36*gdscale)
        if textHeight > (14*gd_scale*3+30){
            textHeight = 14*gd_scale*3+30
        }
        let width = screenWidth - 36*gdscale
        var height = width*than + textHeight + 80*hdscale
        if model.last_time_read != "" {
            height += 36
        }
        return CGSize(width: screenWidth, height:height)
    }
    
   
}

