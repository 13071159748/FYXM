//
//  MQIUserAutoReaderSetCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserAutoReaderSetCell: MQITableViewCell {

    var s: UISwitch!
    
    var switchBlock: ((_ open: Bool) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        s = UISwitch(frame: CGRect.zero)
        s.isOn = true
        s.addTarget(self, action: #selector(MQIUserAutoReaderSetCell.switchAction(_:)), for: .valueChanged)
        contentView.addSubview(s)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        s.frame = CGRect(x: self.bounds.width-80, y: (self.bounds.height-31)/2, width: 71, height: 31)
        
        if let textLabel = textLabel {
            textLabel.frame = CGRect(x: 10, y: 0, width: s.frame.minX-20, height: self.bounds.height)
        }
        
    }
    
  @objc  func switchAction(_ sw: UISwitch) {
        switchBlock?(sw.isOn)
        
    }
}

