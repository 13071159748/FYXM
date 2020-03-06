//
//  MQICollectionReusableView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQICollectionReusableView: UICollectionReusableView {
    var titleLabel: UILabel?
    
    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
    let titleColor = RGBColor(136, g: 136, b: 136)
    var space: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func addTitleLabel() {
        if titleLabel == nil {
            titleLabel = UILabel(frame: CGRect.zero)
            self.addSubview(titleLabel!)
        }
        titleLabel!.font = titleFont
        titleLabel!.textColor = titleColor
        titleLabel!.backgroundColor = UIColor.clear
        
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(space)
            make.right.equalTo(-space)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
