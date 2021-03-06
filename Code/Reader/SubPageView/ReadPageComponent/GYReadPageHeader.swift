//
//  MQIReadPageHeader.swift
//  DWMRead
//
//  Created by _CHK_  on 2017/8/28.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIReadPageHeader: GYReadPageComponent {
    
    class func headerWithRefreshingBlock(_ tableView: MQITableView, refreshingBlock: @escaping (() -> ())) -> MQIReadPageHeader {
        let cmp = MQIReadPageHeader(tableView)
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    
    override func configUI() {
        super.configUI()
        titleLabel.text = "上一章"
    }
    
    override func scrollViewContentOffsetDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    override func scrollViewPanStateDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {
        guard let pan = pan else {
            return
        }
        
        if pan.state == .ended {
            if gscrollView.contentOffset.y <= -criticalNum {
                refreshingBlock?()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        y = -height
        stateView.y = height-stateView.height
    }
    
}
