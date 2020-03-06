//
//  MQIUserConsumeVC.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh

class MQIUserConsumeViewController: MQIBaseViewController {
    var consumes = [MQICostBookList](){
        didSet(oldValue) {
            if consumes.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
            
        }
    }
    var isRefresh: Bool = false
    
    var limit: Int = 20
    
    var noBookView: MQISearchNoBookView!
    
    override func addNoDataView() {
        super.addNoDataView()
        self.noDataView?.icon.image = UIImage(named: "pay_no_data_img")
        self.noDataView?.titleLabel.text = kLocalized("Empty_no_order")
    }
    
    var isFooterRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("SubscribeToTheRecord")
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.request(offset: "0", limit: "\(strongSelf.limit)")
            }
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isFooterRefresh = true
                strongSelf.request(offset: "\(strongSelf.consumes.count)", limit: "\(strongSelf.limit)")
            }
        })
        
        addPreloadView()
        request(offset: "0", limit: "\(limit)")
    }
    
    func request(offset: String, limit: String) {
        GDUserCostBookListRequest(offset: offset, limit: limit)
            .requestCollection({[weak self] (request, response, result: [MQICostBookList]) in
                
                if let strongSelf = self {
                    strongSelf.dismissWrongView()
                    strongSelf.dismissPreloadView()
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.endRefreshing()
                    if strongSelf.isFooterRefresh == true {
                        strongSelf.isFooterRefresh = false
                        for each in result {
                            strongSelf.consumes.append(each)
                        }
                    }else {
                        strongSelf.consumes = result
                    }
                    if strongSelf.consumes.count <= 0{
                        strongSelf.addnoConsumeInfoRercord()
                    }else{
                        strongSelf.dismissConsumeInfo()
                    }
                    strongSelf.tableView.reloadData()
                }
                }, failureHandler: {[weak self] (msg, code) in
                    if let strongSelf = self {
                        strongSelf.dismissPreloadView()
                        strongSelf.tableView.mj_header.endRefreshing()
                        strongSelf.tableView.mj_footer.endRefreshing()
                        strongSelf.isFooterRefresh = false
                        strongSelf.addWrongView(msg, refresh: {
                            strongSelf.request(offset: offset, limit: limit)
                        })
                    }
            })
    }
    
    func addnoConsumeInfoRercord() {
        if noBookView == nil {
            noBookView = MQISearchNoBookView(frame: contentView.bounds)
            contentView.addSubview(noBookView)
            contentView.bringSubviewToFront(noBookView!)
        }
        
    }
    func dismissConsumeInfo() {
        if noBookView != nil {
            noBookView?.removeFromSuperview()
            noBookView = nil
        }
        
    }
    
    func toInfoVC(index: IndexPath) {
        if consumes[index.row].whole_subscribe == "1"{ return }
        let vc: MQIUserConsumeInfoViewController! = MQIUserConsumeInfoViewController.create() as? MQIUserConsumeInfoViewController
        let model = consumes[index.row]
        let bookOld = model.book
        bookOld.book_id = model.book_id
        bookOld.book_name = model.book_name
        vc.book = bookOld
        pushVC(vc)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
}
private let cellIdentifier = "cellIdentifier"
extension MQIUserConsumeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        MQIUserOperateManager.shared.toBookInfo(consumes[indexPath.row].book_id)
        //        MQIUserOperateManager.shared.toReader(consumes[indexPath.row].book_id)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MQIUserConsumeCell
        cell.consume = consumes[indexPath.row]
        cell.indexPath = indexPath
        cell.clickToReader = { [weak self](index) in
            self?.toInfoVC(index: index)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MQIUserConsumeCell.getHeight(nil)
    }
}
