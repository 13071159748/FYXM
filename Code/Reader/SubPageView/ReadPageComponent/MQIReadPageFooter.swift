//
//  MQIReadPageFooter.swift
//  DWMRead
//
//  Created by CQSC  on 2017/8/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadPageFooter: MQIReadPageComponent {
    
    class func footerWithRefreshingBlock(_ tableView: MQITableView, refreshingBlock: @escaping (() -> ())) -> MQIReadPageFooter {
        let cmp = MQIReadPageFooter(tableView)
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    
    override func configUI() {
        super.configUI()
        titleLabel.text = "下一章"
    }
    override func scrollViewContentSizeDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {
        y = gscrollView.contentSize.height
    }
    
    override func scrollViewContentOffsetDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {

    }
    
    override func scrollViewPanStateDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {
        guard let pan = pan else {
            return
        }
        
        if pan.state == .ended {
            if gscrollView.contentOffset.y+gscrollView.height >= gscrollView.contentSize.height+criticalNum {
                refreshingBlock?()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        y = gscrollView.contentSize.height
        stateView.y = 0
    }

}
