//
//  YQPHBGoodCollectionViewCellNew.swift
//  Reader
//
//  Created by moqing on 2018/4/18.
//  Copyright © 2018年 _XSSC_. All rights reserved.
//

//
import UIKit

class YQPHBGoodCollectionViewCellNew: MQICollectionViewCell {
    var eachbookModel:MQIChoicenessListModel? {
        didSet{
            if let model = eachbookModel {
                bookTitleLabel.text = eachbookModel?.title
                bookCover.sd_setImage(with: URL(string:model.cover), placeholderImage: UIImage(named: goodBookPlaceHolderImg))
                eyeLabel.text = model.read_num + "追读"
                
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
    fileprivate var likeLabel:UILabel!
    fileprivate var lineView:UIView!
    fileprivate static  var imgScale:CGFloat = 0.45
    
    ///分享
    var share:((_ model:MQIChoicenessListModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTypeSimpleView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    func addTypeSimpleView() {
        XSSCAddTypeSimpleView()
        
    }
    
    func XSSCAddTypeSimpleView(){
        bookTitleLabel = UILabel(frame: CGRect.zero)
        bookTitleLabel.textColor = UIColor.colorWithHexString("#3c3c3c")
        bookTitleLabel.font = boldFont(Float(kUIStyle.size(32)))
        bookTitleLabel.textAlignment = .left
        bookTitleLabel.numberOfLines = 0
        contentView.addSubview(bookTitleLabel)
        
        bookTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(kUIStyle.scaleH(20))
            make.left.right.equalTo(contentView)
        }
        
        
        let img  = UIImage.init(named: "xssc_icon_eyes")?.withRenderingMode(.alwaysTemplate)
        eyeImageView = UIImageView.init(frame: CGRect.zero)
        eyeImageView.image = img
        eyeImageView.tintColor = UIColor.colorWithHexString("#666666")
        contentView.addSubview(eyeImageView)
        
        eyeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(kUIStyle.scaleH(20))
            make.left.equalTo(bookTitleLabel)
        }
        
        
        eyeLabel = UILabel.init(frame: CGRect.zero)
        eyeLabel.textColor = UIColor.colorWithHexString("#333333")
        eyeLabel.font = systemFont(kUIStyle.size(22))
        contentView.addSubview(eyeLabel)
        
        eyeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(eyeImageView)
            make.left.equalTo(eyeImageView.snp.right).offset(kUIStyle.scaleW(10))
        }
        
        bookCover = UIImageView.init(frame: CGRect.zero)
        contentView.addSubview(bookCover)
        bookCover.snp.makeConstraints { (make) in
            make.top.equalTo(eyeImageView.snp.bottom).offset(kUIStyle.scaleH(16))
            make.width.equalTo(contentView)
//            make.bottom.equalTo(contentView).offset(-kUIStyle.scaleH(32))
        }
        
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("#E8E8E8")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(bookCover.snp.bottom).offset(kUIStyle.scaleW(32))
            make.bottom.equalTo(contentView).offset(-1)
            make.left.right.equalTo(bookCover)
            make.height.equalTo(1)
        }
    }
    
    
    
    @objc func share(btn:UIButton) -> Void {
        if  btn.tag == 1001 {
            return
        }
        share?(eachbookModel!)
    }
    
    class func getSize(_ model:MQIChoicenessListModel,lastItem:Bool = false) -> CGSize {
        var newWidth = model.width.CGFloatValue()
        if newWidth == 0 {
            newWidth = 750
        }
        let newHeight = model.height.CGFloatValue()
        var scale = newHeight/newWidth
        if scale == 0{
            scale = 0.47
        }
        let itmeW = screenWidth-kUIStyle.scaleH(72)
//        let H =  getAutoRect(model.desc, font:systemFont(kUIStyle.size(32)) , maxWidth: itmeW, maxHeight: CGFloat(MAXFLOAT)).height+8
        let H:CGFloat  = 0.0
        let itmeH = itmeW * scale
        let currentHeight = itmeH
        return CGSize(width: itmeW, height: kUIStyle.scaleH(120) + currentHeight + kUIStyle.scaleH(34)+H)
        
    }
}
