//
//  MQICardFooterView.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardFooterView: UIView {

    var contentText:String = "" {
        didSet(oldValue) {
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = 5
            contentLabel.attributedText = NSAttributedString.init(string: contentText, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStye])
        }
    }
    var contentLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.white
        let lineView = UIView()
        lineView.backgroundColor = mainColor
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(card_LeftMargin)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(2)
            make.height.equalTo(15)
        }
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.colorWithHexString("#2C2B40")
        title.textAlignment = .left
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(2)
            make.right.equalToSuperview().offset(-card_LeftMargin)
            make.centerY.equalTo(lineView)
        }
        title.text = "打折卡规则："
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textColor = UIColor.colorWithHexString("#666666")
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView)
            make.right.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(15)
            make.bottom.greaterThanOrEqualToSuperview().offset(-7).priority(.low)
        }
        
    }
    class func  getDefaultHeight() -> CGFloat {
        return  450
    }
}
