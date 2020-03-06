//
//  GYNoDataCell.swift
//  YH
//
//  Created by CQSC  on 15/6/3.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit


let noData_cellHeight: CGFloat = ipad == true ? 60 : 44

class GYNoDataCell: MQITableViewCell {
    
    var fontSize: CGFloat = ipad == true ? 17 : 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.textLabel?.text = kLocalized("ThereNoMore")
        self.textLabel?.textAlignment = NSTextAlignment.center
        self.textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        let line = UIView(frame: CGRect(x: 0, y: noData_cellHeight-1, width: screenWidth, height: 1))
        line.backgroundColor = lineColor
        contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configText(_ text: String) {
        self.textLabel?.text = text
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
