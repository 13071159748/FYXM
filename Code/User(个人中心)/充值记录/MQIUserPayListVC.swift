//
//  MQIUserPayListVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
import SnapKit

import MJRefresh
private let cellIdentifier = "cellIdentifier"
class MQIUserPayListViewController: MQIBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var orderLogs = [MQIEachOrderLog](){
        didSet(oldValue) {
            if orderLogs.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
        }
    }
    var isRefresh: Bool = false
    var limit: Int = 20
    //    var noView:UIView?
    var noBookView: MQISearchNoBookView!
    var toPay:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("PrepaidPhoneRecords")
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        tableView.register(UINib(nibName: "GYUserPayListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.request(start_id: "0", limit:"\(strongSelf.limit)")
            }
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.request(start_id: "\(strongSelf.orderLogs.count)", limit: "\(strongSelf.limit)")
            }
        })
        
        tableView.backgroundColor = UIColor.colorWithHexString("F6F6F6")
        
        addPreloadView()
        request(start_id: "0", limit: "\(limit)")
        
      let rightBtn = addRightBtn(kLongLocalized("How_to_get_book_money", replace: COINNAME), imgStr: nil)
        rightBtn.x -= 60
        rightBtn.width += 60
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.setTitleColor(mainColor, for: .normal)
        
    }
    override func rightBtnAction(_ button: UIButton) {
          toPay = true
        MQIUserOperateManager.shared.toPayVC(nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if toPay {
           tableView.mj_header.beginRefreshing()
            toPay = false
        }
    }
    
    
    override func addNoDataView() {
        super.addNoDataView()
        self.noDataView?.icon.image = UIImage(named: "pay_no_data_img")
        self.noDataView?.titleLabel.text = kLocalized("Empty_no_order", describeStr: "没有订单")
    }
    func addnoPayInfoRercord() {
        if noBookView == nil {
            noBookView = MQISearchNoBookView(frame: contentView.bounds)
            contentView.addSubview(noBookView)
            contentView.bringSubviewToFront(noBookView!)
        }
        
    }
    func dismisspayInfo() {
        if noBookView != nil {
            noBookView?.removeFromSuperview()
            noBookView = nil
        }
        
    }
    func request(start_id: String, limit: String) {
        GYUserOrderListRequest(start_id: start_id, limit: limit)
            .requestCollection({[weak self] (request, response, result: [MQIEachOrderLog]) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.dismissWrongView()
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.endRefreshing()
                    if strongSelf.isRefresh == true {
                        strongSelf.isRefresh = false
                        strongSelf.orderLogs = result
                    }else{
                        strongSelf.orderLogs.append(contentsOf: result)
                    }
                    
                    if strongSelf.orderLogs.count<=0 {
                        strongSelf.addnoPayInfoRercord()
                    }else{
                        strongSelf.dismisspayInfo()
                    }
                    strongSelf.tableView.reloadData()
                }
            }) {[weak self] (msg, code) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.endRefreshing()
                    strongSelf.addWrongView(msg, refresh: {
                        strongSelf.request(start_id: start_id, limit: limit)
                    })
                }
        }
    }

}


extension MQIUserPayListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GYUserPayListCell 
        cell.orderLog = orderLogs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GYUserPayListCell.getHeight(nil)
    }
    
    
}
