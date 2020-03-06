//
//  MQIEndContentCollectionViewCell.swift
//  MoQingInternational
//
//  Created by moqing on 2019/6/19.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIEndContentCollectionViewCell: MQIEndBaseCollectionViewCell {
    
    var title:UILabel!
    var subTitle1:UILabel!
 
   
    var contentText:String = "" {
        didSet(oldValue) {
//            DispatchQueue.global().async {
//                let  attributedText = NSAttributedString.init(string: self.contentText, attributes:  self.readAttribute())
//                DispatchQueue.main.async {
//                    self.subTitle1.attributedText = attributedText
//                }
//            }
            
                self.subTitle1.attributedText = NSAttributedString(string: self.contentText, attributes:  self.readAttribute())
            
        }
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.colorWithHexString("ffffff")
        setupUI()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func setupUI()  {
    
        title = UILabel()
        title.font = kUIStyle.boldSystemFont1PXDesignSize(size: 20)
        title.textColor = kUIStyle.colorWithHexString("333333")
        title.textAlignment = .left
        title.numberOfLines = 1
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(End_Left_Margin)
             make.right.equalToSuperview().offset(-End_Left_Margin)
            make.top.equalToSuperview().offset(10)
        }
      
        subTitle1 = UILabel()
        subTitle1.font = kUIStyle.sysFontDesign1PXSize(size: 18)
        subTitle1.textColor = kUIStyle.colorWithHexString("666666")
        subTitle1.textAlignment = .left
        subTitle1.numberOfLines = 0
        contentView.addSubview(subTitle1)
        subTitle1.snp.makeConstraints { (make) in
            make.left.right.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(14)
            make.bottom.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(1).priority(.high)
        }

    
  
        
    }
    
    
    
    func readAttribute() -> [NSAttributedString.Key: Any]{
        let textColor =  UIColor.colorWithHexString("666666")
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        // 行间距
        paragraphStyle.lineSpacing = 10
        // 段间距
        paragraphStyle.paragraphSpacing =  15
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
//        paragraphStyle.lineHeightMultiple = 8
        // 对齐
        paragraphStyle.alignment = NSTextAlignment.justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        // 首行缩进                                                                                    
//        paragraphStyle.firstLineHeadIndent = subTitle1.font.pointSize*2.2
        // 返回
        return [NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.kern : NSNumber(value: 1)]
    }
    
}
