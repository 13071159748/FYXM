//
//  GDGoodCollectionViewCell.swift
//  Reader
//
//  Created by CQSC  on 2018/1/10.
//  Copyright © 2018年  CQSC. All rights reserved.
//
//全能道士详情-阅读-详情（点击继续阅读返回上个阅读器） - 都市狂徒详情 --免费试读 -详情
import UIKit


class MQIGoodCollectionViewCell: MQICollectionViewCell {
    var refreshBlock:(() -> ())?
    var isOpenRefresh:Bool = false {
        didSet{
            if isOpenRefresh != true{
                refreshView.isHidden = true
            }else{
                refreshView.isHidden = false
            }
        }
    }
    var isAd:Bool = false {
        didSet{
            if isAd != true{
                eyeImageView.isHidden = false
                eyeLabel.isHidden = false
                lookDetailLabel.isHidden = false
                lookDetailImageView.isHidden = false
            }else{
                eyeImageView.isHidden = true
                eyeLabel.isHidden = true
                lookDetailLabel.isHidden = true
                lookDetailImageView.isHidden = true
            }
        }
    }
    var eachbookModel:MQIChoicenessListModel? {
        didSet{
            if let model = eachbookModel {
                bookTitleLabel.text = eachbookModel?.title
                bookCover.sd_setImage(with: URL(string:model.cover), placeholderImage: UIImage(named: goodBookPlaceHolderImg))
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 6
                let attStr = NSMutableAttributedString(string: model.desc, attributes:
                    [NSAttributedString.Key.paragraphStyle : paragraph,
                     NSAttributedString.Key.font
                        :systemFont(13),
                     ])
                contentLabel.attributedText = attStr
                contentLabel.lineBreakMode = .byTruncatingTail
                
                //                contentLabel.backgroundColor = UIColor.yellow
                //                contentLabel.text = model.desc
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
    fileprivate var refreshView:UIView!
    fileprivate var refreshLabel:UILabel!
    fileprivate var refreshImg:UIImageView!
    
    //    func boundingRectWithWith
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTypeSimpleView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addTypeSimpleView() {
        bookTitleLabel = UILabel(frame: CGRect.zero)
        bookTitleLabel.textColor = UIColor.colorWithHexString("#3c3c3c")
        bookTitleLabel.font = systemFont(18*gd_scale)
        contentView.addSubview(bookTitleLabel)
        
        bookCover = UIImageView.init(frame: CGRect.zero)
        bookCover.layer.cornerRadius = 8
        bookCover.clipsToBounds = true
        contentView.addSubview(bookCover)
        
        contentLabel = UILabel.init(frame: CGRect.zero)
        contentLabel.textColor = UIColor.colorWithHexString("#999999")
        //        contentLabel.font = systemFont(12)
        contentLabel.numberOfLines = 2
        contentView.addSubview(contentLabel)
        
        let eyeImg = UIImage.init(named: "reader_goodeye")?.withRenderingMode(.alwaysTemplate)
        eyeImageView = UIImageView.init(frame: CGRect.zero)
        eyeImageView.image = eyeImg
        eyeImageView.tintColor = UIColor.colorWithHexString("#D95F67")
        contentView.addSubview(eyeImageView)
        
        eyeLabel = UILabel.init(frame: CGRect.zero)
        eyeLabel.textColor = UIColor.colorWithHexString("#999999")
        eyeLabel.font = systemFont(12)
        contentView.addSubview(eyeLabel)
        
        lookDetailLabel = UILabel.init(frame: CGRect.zero)
        lookDetailLabel.textColor = mainColor
        lookDetailLabel.font = systemFont(12)
        lookDetailLabel.textAlignment = .right
        lookDetailLabel.text = kLocalized("CheckDetail")
        contentView.addSubview(lookDetailLabel)
        
        
        
        let image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        lookDetailImageView = UIImageView.init(frame: CGRect.zero)
        lookDetailImageView.image = image
        lookDetailImageView.tintColor = mainColor
        contentView.addSubview(lookDetailImageView)
        
        //
        refreshView = UIView.init(frame: CGRect.zero)
        refreshView.backgroundColor = UIColor.colorWithHexString("#F6F6F6")
        contentView.addSubview(refreshView)
        
        refreshLabel = UILabel.init(frame: CGRect.zero)
        refreshLabel.textColor = mainColor
        refreshLabel.font = systemFont(13)
        refreshLabel.textAlignment = .center
        refreshLabel.text = kLocalized("IJustSawItHere")
        refreshView.addSubview(refreshLabel)
        refreshLabel.adjustsFontSizeToFitWidth = true
        refreshLabel.minimumScaleFactor = 0.8
        
        
        let refreshmg = UIImage.init(named: "recommended_refresh")?.withRenderingMode(.alwaysTemplate)
        refreshImg = UIImageView.init(frame: CGRect.zero)
        refreshImg.image = refreshmg
        refreshView.addSubview(refreshImg)
        refreshImg.tintColor = mainColor
        
        refreshView.isUserInteractionEnabled = true
        addTGR(self, action: #selector(MQIGoodCollectionViewCell.tapRefresh), view: refreshView)
        refreshView.isHidden = true
        
    }
    
    @objc  func tapRefresh(){
        refreshBlock?()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bookTitleLabel.frame = CGRect.init(x: 0, y: 20, width: self.width, height: 18*gd_scale)
//        //-6.5
//        if let model = eachbookModel {
//            let imgWidth = model.width.CGFloatValue()
//            let imgHeight = model.height.CGFloatValue()
//
//            let currentHeight = self.width * imgHeight / imgWidth
//            bookCover.frame = CGRect.init(x: 0, y: bookTitleLabel.maxY + 13.5, width: self.width, height: currentHeight)
//        }else {
//            bookCover.frame = CGRect.init(x: 0, y: bookTitleLabel.maxY, width: self.width, height: 0)
//        }
//
//        contentLabel.frame = CGRect.init(x: 0, y: bookCover.maxY, width: self.width, height: 73)
//        eyeImageView.frame = CGRect.init(x: 0, y: contentLabel.maxY, width: 16, height: 12)
//
//
//        eyeLabel.frame = CGRect.init(x: eyeImageView.maxX+5, y: eyeImageView.y, width: self.width - 110, height: 12)
//
//        lookDetailImageView.frame = CGRect.init(x: self.width - 10, y: eyeLabel.y, width: 10, height: 12)
//        lookDetailLabel.frame = CGRect.init(x: self.width - 7 - 5 - 80, y: lookDetailImageView.y, width: 80, height: 12)
        
//
        
        if isOpenRefresh == true {
            refreshView.frame = CGRect.init(x: -18 * gdscale, y: 10 * hdscale, width: screenWidth, height: 32 * hdscale)
            refreshLabel.frame = CGRect.init(x: 107 * gdscale, y: 7 * hdscale, width: 145 * gdscale, height: 18 * hdscale)
            refreshImg.frame = CGRect.init(x: refreshLabel.maxX+5, y: 11 * hdscale, width: 12 * gdscale, height: 12 * gdscale)
            if let model = eachbookModel {
                let imgWidth = model.width.CGFloatValue()
                let imgHeight = model.height.CGFloatValue()
                
                let currentHeight = self.width * imgHeight / imgWidth
                //            bookCover.frame = CGRect.init(x: 0, y: 14 * hdscale, width: self.width, height: currentHeight)
                bookCover.frame = CGRect.init(x: 0, y: 56 * hdscale, width: self.width, height: currentHeight)
            }else {
                //            bookCover.frame = CGRect.init(x: 0, y: 14 * hdscale, width: self.width, height: 0)
                bookCover.frame = CGRect.init(x: 0, y: 56 * hdscale, width: self.width, height: 0)
            }
        }else{
            if let model = eachbookModel {
                let imgWidth = model.width.CGFloatValue()
                let imgHeight = model.height.CGFloatValue()
                let currentHeight = self.width * imgHeight / imgWidth
                bookCover.frame = CGRect.init(x: 0, y: 14 * hdscale, width: self.width, height: currentHeight)
            }else {
                bookCover.frame = CGRect.init(x: 0, y: 14 * hdscale, width: self.width, height: 0)
            }
        }
        bookTitleLabel.frame = CGRect.init(x: 0, y: bookCover.maxY + 14 * hdscale, width: self.width, height: 22*hdscale)
        let size = contentLabel.text?.size(font: systemFont(13), constrainedToSize: CGSize(width: self.width, height: 36 * hdscale))
        contentLabel.frame = CGRect.init(x: 0, y: bookTitleLabel.maxY + 9 * hdscale, width: self.width, height: (size?.height)! + 8 * hdscale)
        eyeImageView.frame = CGRect.init(x: 0, y: contentLabel.maxY + 14 * hdscale, width: 16, height: 12)
        
        
        eyeLabel.frame = CGRect.init(x: eyeImageView.maxX+5, y: eyeImageView.y, width: self.width - 110, height: 12)
        lookDetailImageView.frame = CGRect.init(x: self.width - 10, y: eyeLabel.y, width: 10, height: 12)
        lookDetailLabel.frame = CGRect.init(x: self.width - 7 - 5 - 80, y: lookDetailImageView.y, width: 80, height: 12)
    }
    class func getSize(_ width:String,height:String,lastItem:Bool = false,model:MQIChoicenessListModel) -> CGSize {
        
        //分母不能为0
        var newWidth = width.CGFloatValue()
        if newWidth == 0 {
            newWidth = 750
        }
        let size = model.desc.size(font: systemFont(13), constrainedToSize: CGSize(width: screenWidth - 40 * gdscale, height: 36 * hdscale))
        var height = 260 * hdscale
        if model.isOpenRereesh == "1" {
            if size.height >= 20{
                height = height + 57 * hdscale
            }else{
                height = height + 42 * hdscale
            }
        }else{
            if size.height >= 20{
                height = height + 15 * hdscale
            }
        }
        if model.type == "ad" {
            height = height - 20 * hdscale
        }
        return CGSize(width: screenWidth - 36*gdscale, height: height+20*hdscale)
    }
}
