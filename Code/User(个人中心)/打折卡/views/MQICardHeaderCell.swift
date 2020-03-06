//
//  MQICardHeaderCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/12.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardHeaderCell: MQICardBaseTableViewCell {
    
    var cardHeader:MQICardHeaderView!
    override func setupUI() {
        bacImge.isHidden = true
        cardHeader  = MQICardHeaderView(frame: CGRect(x: 0, y:0, width: contentView.width, height: MQICardHeaderView.getDefaultHeight()))
        contentView.addSubview(cardHeader)
    
    }
    
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return MQICardHeaderView.getDefaultHeight()-40
    }

}
