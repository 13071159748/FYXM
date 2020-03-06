//
//  MQIMessageCenterTableViewCell.swift
//  CHKReader
//
//  Created by moqing on 2019/1/24.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIMessageCenterTableViewCell: UITableViewCell {
    
    var dateLable:UILabel!
    //    var contentLable:UILabel!
    var titleLable:UILabel!
    var pointView:UIView!
    var contentTextView:MQILinkTextView!
    
    var model:MQIMessageModel!{
        didSet(oldValue) {
            titleLable.text = model.title
            //            contentTextView.attributedText = getContentAtt(model.content, font: contentLable.font)
            dateLable.text  = getTimeStampToString(model.add_time, format: "yyyy-MM-dd HH:mm:ss")
            pointView.isHidden = (model.status_code == "readed") ? true : false
            contentTextView.text = model.content
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        setupUI()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        setupUI()
    }
    
    func setupUI() {
        let contentBacView =  UIView()
        contentBacView.dsySetCorner(radius: 4)
        contentBacView.backgroundColor = UIColor.white
        contentView.addSubview(contentBacView)
        contentBacView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
        }
        
        let icon = UIImageView()
        let img = UIImage(named: "apay_radio_Image")?.withRenderingMode(.alwaysTemplate)
        icon.image = img
        icon.tintColor = mainColor
        contentBacView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(14)
            make.width .equalTo(15)
        }
        
        dateLable = UILabel()
        dateLable.font  = kUIStyle.sysFontDesign1PXSize(size: 10)
        dateLable.textColor = kUIStyle.colorWithHexString("999999")
        dateLable.textAlignment = .right
        contentBacView.addSubview(dateLable)
        dateLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(icon)
            make.right.equalToSuperview().offset(-12)
            make.width.greaterThanOrEqualTo(100)
        }
        
        titleLable = UILabel()
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 12)
        titleLable.textColor = mainColor
        titleLable.textAlignment = .left
        contentBacView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(5)
            make.centerY.equalTo(icon)
            make.right.equalTo(dateLable.snp.left).offset(-10)
        }
        
        
        pointView = UIView()
        pointView.backgroundColor = UIColor.red
        pointView.dsySetCorner(radius: 3)
        contentBacView.addSubview(pointView)
        pointView.isHidden = true
        pointView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable.snp.right).offset(1)
            make.bottom.equalTo(titleLable.snp.centerY)
            make.height.width.equalTo(6)
        }
        
        //        contentLable = UILabel()
        //        contentLable.font  = kUIStyle.sysFontDesign1PXSize(size: 12)
        //        contentLable.textColor = UIColor.colorWithHexString("333333")
        //        contentLable.textAlignment = .left
        //        contentLable.numberOfLines = 0
        //        contentBacView.addSubview(contentLable)
        //        contentLable.snp.makeConstraints { (make) in
        //            make.left.equalTo(titleLable)
        //            make.right.equalTo(dateLable)
        //            make.top.equalTo(titleLable.snp.bottom).offset(6)
        ////            make.bottom.greaterThanOrEqualToSuperview().offset(-14)
        //            make.bottom.equalToSuperview().offset(-14)
        //        }
        
        contentTextView = MQILinkTextView()
        contentTextView.font  = kUIStyle.sysFontDesign1PXSize(size: 12)
        contentTextView.textColor = UIColor.colorWithHexString("333333")
        contentTextView.textAlignment = .left
        contentBacView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.right.equalTo(dateLable)
            make.top.equalTo(titleLable.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(-14)
        }
        contentTextView.call_URL_Block = { (url) in
            MQIOpenlikeManger.openLike(url)
        }
        
    }
    
    func getContentAtt(_ text:String,font:UIFont) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineSpacing = 3
        let att = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : font,NSAttributedString.Key.paragraphStyle:paragraphStyle])
        return att
    }
}
