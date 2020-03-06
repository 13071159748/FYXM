//
//  GYBookOriginalOtherBooksHeaderCell.swift
//  Reader
//
//  Created by CQSC  on 2017/3/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalOtherBooksHeaderCell: MQITableViewCell {
    
    var headerView: GYBookOriginalInfoCellHeaderView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        headerView = GYBookOriginalInfoCellHeaderView(frame: self.bounds)
        headerView.title = kLocalized("TheAuthorAlsoWrote")
        contentView.addSubview(headerView)
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerView.frame = self.bounds
    }

}
