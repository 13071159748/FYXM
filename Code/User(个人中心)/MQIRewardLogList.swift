//
//  MQIRewardLogList.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh

class MQIRewardLogList: MQIRootTableVC {

    var rewards = [MQIEachRewardLog]()
    var rewardsDict = [String:[MQIEachRewardLog]]()
    var rewardDatas = [String]()
    
    var isRefresh: Bool = false
    
    var limit: Int = 20
    var noBookView: MQISearchNoBookView!
    
    var isFooterRefresh = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = kLocalized("ExceptionalRecord")
        contentView.backgroundColor = RGBColor(244, g: 244, b: 244)
        gtableView.backgroundColor = contentView.backgroundColor
        gtableView.separatorInset = UIEdgeInsets.zero
        gtableView.separatorColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        gtableView.registerCell(MQIRewardLogCell.self, xib: false)
        gtableView.tableFooterView = UIView()
        gtableView.separatorStyle = .none
        gtableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.request(start_id: "0", limit: "\(strongSelf.rewards.count)")
            }
        })
        
        gtableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                if let last = strongSelf.rewards.last {
                    strongSelf.request(start_id: "\(last.id)", limit: "\(strongSelf.limit)")
                }else {
                    strongSelf.gtableView.mj_footer.endRefreshing()
                }
            }
        })
        
        addPreloadView()
        request(start_id: "0", limit: "\(limit)")
  
    }
    func request(start_id: String, limit: String) {
        GDUserRewardRequest(start_id: start_id, limit: limit).requestCollection({ [weak self](request, response, result:[MQIEachRewardLog]) in
            if let weakSelf = self {
                weakSelf.dismissWrongView()
                weakSelf.dismissPreloadView()
                weakSelf.gtableView.mj_header.endRefreshing()
                
                weakSelf.configResult(result: result)
                weakSelf.gtableView.reloadData()
                
            }
            
            
        }) { [weak self](msg, code) in
            if let weakSelf = self  {
                weakSelf.dismissPreloadView()
                weakSelf.gtableView.mj_header.endRefreshing()
                weakSelf.gtableView.mj_footer.endRefreshing()
                
                weakSelf.addWrongView(msg, refresh: {
                    weakSelf.request(start_id: start_id, limit: limit)
                })
                
            }
            
        }
        
    }
    func configResult(result: [MQIEachRewardLog]) {
        if result.count < limit {
            gtableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            gtableView.mj_footer.endRefreshing()
        }
        if isRefresh == true {
            isRefresh = false
            rewards.removeAll()
            rewardDatas.removeAll()
            rewardsDict.removeAll()
        }
        rewards.append(contentsOf: result)
        
        for i in 0..<result.count {
            let reward = result[i]
            
            if rewardDatas.contains(reward.cost_month3) == true {
                if let _ = rewardsDict[reward.cost_month3] {
                    rewardsDict[reward.cost_month3]!.append(reward)
                }
                
            }else {
                rewardDatas.append(reward.cost_month3)
                rewardsDict[reward.cost_month3] = [reward]
            }
            
            
        }
        
        if rewards.count <= 0 {
            addnoRewardInfoRercord()
        }else {
            dismissnoRewardInfo()
        }
        if CGFloat(rewards.count)*MQIRewardLogCell.getHeight(nil) + CGFloat(rewardDatas.count*35) < gtableView.height {
            gtableView.mj_footer.isHidden = true
            gtableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    func addnoRewardInfoRercord() {
        if noBookView == nil {
            noBookView = MQISearchNoBookView(frame: contentView.bounds)
            contentView.addSubview(noBookView)
            contentView.bringSubviewToFront(noBookView!)
        }
        
    }
    func dismissnoRewardInfo() {
        if noBookView != nil {
            noBookView?.removeFromSuperview()
            noBookView = nil
        }
        
    }
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return rewardDatas.count
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        let list = rewardsDict[rewardDatas[section]]!
        return list.count
    }
    
    override func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 35))
        view.backgroundColor = tableView.backgroundColor
        
        let label = createLabel(CGRect(x: 15, y: 0, width: view.width-30, height: 35),
                                font: systemFont(16),
                                bacColor: UIColor.clear,
                                textColor: RGBColor(102, g: 102, b: 102),
                                adjustsFontSizeToFitWidth: nil,
                                textAlignment: .left,
                                numberOfLines: 0)
        label.text = rewardDatas[section]
        view.addSubview(label)
        return view
    }
    
    override func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 35
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQIRewardLogCell.getHeight(nil)
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIRewardLogCell.self, forIndexPath: indexPath)
        let list = rewardsDict[rewardDatas[indexPath.section]]!
        cell.eachreward = list[indexPath.row]
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
