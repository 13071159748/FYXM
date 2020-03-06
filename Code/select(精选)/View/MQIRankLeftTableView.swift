//
//  GDRankLeftTableView.swift
//  Reader
//
//  Created by _CHK_  on 2018/1/19.
//  Copyright © 2018年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIRankLeftTableView: UIView ,MQITableViewDelegate{
    //model数据
    var rankLeftDatas:[MQIRankTypesModel] = [MQIRankTypesModel]() {
        didSet{
            //刷新
            if leftTableView != nil {
                leftTableView.reloadData()
            }
        }
    }
    //选中返回的model
    var rankSelected:((_ model:MQIRankTypesModel)->())?
    //选中的cell 转换背景
    var currentSelCell:Int = 0
    
    
    fileprivate var leftTableView:MQITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configMainUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configMainUI() {
        leftTableView = MQITableView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        leftTableView.gyDelegate = self
        leftTableView.backgroundColor = UIColor.colorWithHexString("#F7F4F8")
        leftTableView.registerCell(MQIRankLeftCell.self, xib: false)
        leftTableView.tableFooterView = UIView()
        leftTableView.separatorStyle = .none
        self.addSubview(leftTableView)
        if #available(iOS 11.0, *) {
            leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
    }
}
extension MQIRankLeftTableView{
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return rankLeftDatas.count
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIRankLeftCell.self, forIndexPath: indexPath)
        
        if indexPath.row == currentSelCell {
            cell.celltitleLabel.backgroundColor = UIColor.white
        }else {
            cell.celltitleLabel.backgroundColor = UIColor.colorWithHexString("#F7F4F8")
        }
        cell.celltitleLabel.text = rankLeftDatas[indexPath.row].name
        
        return cell
        
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        currentSelCell = indexPath.row
        rankSelected?(rankLeftDatas[indexPath.row])
        tableView.reloadData()
    }
    
    
    
    
    
    
    
}
