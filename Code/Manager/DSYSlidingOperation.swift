//
//  DSYSlidingOperation.swift
//  DSY
//
//  Created by DSY on 2018/6/13.
//  Copyright © 2018年 DSY. All rights reserved.
//

import UIKit


class DSYSlidingOperation: NSObject {
    /// 开始吸顶的高度
    var changeTopY:CGFloat = 0 {
        didSet(oldValue) {
            if changeTopMaxY  == 0 {
                 changeTopMaxY = changeTopY
            }
        }
    }
    /// 吸顶的高度
    var changeTopMaxY:CGFloat = 0
    /// 需要在滑动视图以为要展示的视图
    var headerView:UIView!
    /// 下滑时是否固定视图
    var fixedHeader:Bool = false
    /// 下滑时是否固定Table
    var fixedTable:Bool = false
    
    /// 左右滑动视图
    var scrView:UIScrollView!
    /// 用来判断是都需把头部视图放在最前还是最后
    weak var superView: UIView?
    /// 当前选中的视图标识
    var selectedIndex:Int = 0
    /// 子视图集合
    var scrSubViews:[UITableView] = [UITableView](){
        didSet(oldValue) {
            let headView = UIView()
            headView.bounds = headerView.bounds
            for table in scrSubViews{
                table.tableHeaderView = headView
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    deinit {
        mqLog("我销毁")
        headerView = nil
        scrView = nil
        scrSubViews.removeAll()
    }
    
    /// 开始调整视图位置
    func adjustScroll(scr:UIScrollView) -> Void {
        
        //        mqLog("contentOffset.Y\(scr.contentOffset.y)")
        
        let offsetY:CGFloat      = scr.contentOffset.y
        var originY:CGFloat       = 0
        var otherOffsetY:CGFloat  = 0
        let changeTopY = self.changeTopY
        let changeTopMaxY = self.changeTopMaxY
        
        if fixedTable && offsetY < 0{
            scr.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            return
        }
        
        if (offsetY <= changeTopY) {
            originY              = -offsetY;
            if (offsetY < 0) {
                otherOffsetY         = 0
            } else {
                otherOffsetY         = offsetY
            }
        } else {
            originY              = -changeTopMaxY;
            otherOffsetY         = changeTopMaxY;
           
        }
        
        
        if superView  !=  nil {
            if originY <= -changeTopY{
                superView?.bringSubviewToFront(headerView)
            }else{
                superView?.sendSubviewToBack(headerView)
             
            }
        }
       
        if fixedHeader {
            if offsetY <= 0 &&  headerView.frame.origin.y >= 0 {
                headerView.frame.origin.y = 0
            }else{
                headerView.frame.origin.y = originY
            }
            
        }else{
            headerView.frame.origin.y = originY
        }
        
        mqLog("\(originY)otherOffsetY\(otherOffsetY)")
        
        for i  in 0..<scrSubViews.count {
             let contentView = scrSubViews[i]
            if i != selectedIndex && contentView.tag !=  scr.tag {
                let offset: CGPoint  = CGPoint(x: 0, y: otherOffsetY)
                if (contentView.contentOffset.y < changeTopY || offset.y < changeTopY) {
                    contentView.setContentOffset(offset, animated: false)
                }

            }
        }
        
    }
    /// 高度不足补充高度
    func supplementHeight(_ table:UITableView) -> Void {
        let adjusH = getTableContentSizeH(table) - table.bounds.height-changeTopY
        if  adjusH < 0{///高度不够补高
            table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.bounds.width, height:-adjusH))
        }else{
            table.tableFooterView = UIView()
        }
    }
    
    /// 获取高度
   private func getTableContentSizeH(_ scrView:UIScrollView) -> CGFloat {
        scrView.layoutIfNeeded()
        return scrView.contentSize.height
    }
    
}


