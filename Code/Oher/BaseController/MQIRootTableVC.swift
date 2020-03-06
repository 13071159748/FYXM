//
//  MQIRootTableVC.swift
//  UXinyong
//
//  Created by CQSC  on 15/3/17.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit


let noData_cell = "noData_cell"

class MQIRootTableVC: MQIBaseViewController, MQITableViewDelegate {
    
    var gtableView: MQITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gtableView = MQITableView(frame: contentView.bounds)
        gtableView.gyDelegate = self
        gtableView.backgroundColor = UIColor.white
        gtableView.register(GYNoDataCell.classForCoder(), forCellReuseIdentifier: noData_cell)
        contentView.addSubview(gtableView)
    }
    
    //MARK:MQITableViewDelegate
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return 0
    }
    
    func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        return nil
    }
    
    func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        return nil
    }
    
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 0
    }
    
    func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 0
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
}
