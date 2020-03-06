//
//  MQIRewardLogCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIRewardLogCell: MQIUserLogRootCell {

    var eachreward:MQIEachRewardLog! {
        didSet {
            dateLabel.text = eachreward.cost_month2
            timeLabel.text = eachreward.cost_date
            
            titleLabel.text = eachreward.book_name
            coinLabel.text = eachreward.cost_coin+COINNAME
            preiumLabel.text = eachreward.cost_premium+COINNAME_PREIUM
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

}
