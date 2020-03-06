//
//  MQIApplePayDescribeCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/9.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIApplePayDescribeCell:  MQITableViewCell {
    
    var bacView:UIView!
    
    var lineView :UIView!
    var titleLable:UILabel!
    var describeLable:UILabel!

    var data: MQIApplePayItemModel!{
        didSet(oldValue) {
            titleLable.text = data.name
          describeLable.attributedText = setDescribeAttStr(data.describe)
        }
    }
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor =  kUIStyle.colorWithHexString("F8F8F8")
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() -> Void {
        bacView = UIView()
//        bacView.backgroundColor = UIColor.white
        contentView.addSubview(bacView)
        bacView.dsySetCorner(radius: kUIStyle.scaleW(20))
        
        bacView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kUIStyle.scaleW(26))
            make.right.equalTo(contentView).offset(-kUIStyle.scaleW(26))
            make.top.bottom.equalTo(contentView)
        }
        
        
        lineView  = UIView()
        lineView.backgroundColor =  kUIStyle.colorWithHexString("EDEDEF")
        bacView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bacView)
            make.top.equalTo(bacView).offset(kUIStyle.scaleH (54))
            make.height.equalTo(1)
        }
        titleLable = UILabel()
        titleLable.textColor = kUIStyle.colorWithHexString("262A2D")
        titleLable.font = kUIStyle.sysFontDesignSize(size: 30)
        bacView.addSubview(titleLable)

        
        titleLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(bacView)
            make.top.equalTo(lineView.snp.bottom).offset(kUIStyle.scaleH (22))
        }
        
        
        describeLable = UILabel()
        describeLable.textColor = kUIStyle.colorWithHexString("5B5D5E")
        describeLable.font = kUIStyle.sysFontDesignSize(size: 24)
        describeLable.numberOfLines = 0
        bacView.addSubview(describeLable)
        
        describeLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(bacView)
            make.top.equalTo(titleLable.snp.bottom).offset(kUIStyle.scaleH (14))
            make.bottom.equalTo(bacView)
        }
        
    }
    
    
    /// 设置行距
    func setDescribeAttStr(_ str:String? = " ") -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str!)
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = 5
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStye], range: NSRange.init(location: 0, length: str!.count))
        return attributedString as NSAttributedString
    }
}
