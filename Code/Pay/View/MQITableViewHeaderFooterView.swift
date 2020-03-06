//
//  MQITableViewHeaderFooterView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQITableViewHeaderFooterView: UITableViewHeaderFooterView {
    var titleLabel: UILabel?
    var detitleLabel: UILabel?
    
    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
    let titleColor = RGBColor(136, g: 136, b: 136)
    let space: CGFloat = 15
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        
        layoutIfNeeded()
        layoutSubviews()
    }
    
    func addDetitleLabel() {
        if detitleLabel == nil {
            detitleLabel = UILabel(frame: CGRect.zero)
            self.addSubview(detitleLabel!)
        }
        detitleLabel!.font = titleFont
        detitleLabel!.textColor = titleColor
        detitleLabel!.backgroundColor = UIColor.clear
        detitleLabel!.textAlignment = .right
        
        layoutIfNeeded()
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let titleLabel = titleLabel {
            if let detitleLabel = detitleLabel {
                titleLabel.frame = CGRect(x: space, y: 0, width: self.bounds.width/2, height: self.bounds.height)
                detitleLabel.frame = CGRect(x: titleLabel.bounds.width, y: 0, width: self.bounds.width-titleLabel.bounds.width-space, height: self.bounds.height)
            }else {
                titleLabel.frame = CGRect(x: space, y: 0, width: self.bounds.width, height: self.bounds.height)
            }
        }else if let detitleLabel = detitleLabel {
            detitleLabel.frame = CGRect(x: space, y: 0, width: self.bounds.width, height: self.bounds.height)
        }
    }
    

}
