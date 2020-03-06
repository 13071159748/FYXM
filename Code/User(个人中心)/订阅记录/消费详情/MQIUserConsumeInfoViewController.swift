//
//  MQIUserConsumeInfoVC.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh
class MQIUserConsumeInfoViewController: MQIBaseViewController {
    
    var book: MQIEachBook!
    
    var consumes = [MQIEachConsumeInfo]()
    var consumeDict = [String : [MQIEachConsumeInfo]]()
    var consumeDates = [String]()
    
    var isRefresh: Bool = false
    
    var limit: Int = 20
    private var isFirstRequest:Bool = true
    //    var noView: UIView?
    var noBookView: MQISearchNoBookView!
    
    var parent_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = book.book_name
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.request(start_id: "0", limit: "\(strongSelf.limit)",offset: "0")
            }
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                if let last = strongSelf.consumes.last {
                    strongSelf.request(start_id: "\(last.id)", limit: "\(strongSelf.limit)",offset: "\(strongSelf.consumes.count)")
                }else {
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
            }
        })
        addPreloadView()
        request(start_id: "0", limit: "\(limit)",offset: "0")
    }
    
    func request(start_id: String, limit: String,offset:String) {
        
        if  parent_id != nil  {
            
            request_detail(parent_id: parent_id!, offset: offset, limit: limit)
            return
        }
        
        GYUserCostInfoRequest(book_id: book.book_id, start_id: start_id, limit: limit, offset: offset)
            .requestCollection({ [weak self](request, response, result: [MQIEachConsumeInfo]) in
                
                if let weakSelf = self {
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                    weakSelf.tableView.mj_header.endRefreshing()
                    
                    weakSelf.configResult(result: result)
                    weakSelf.tableView.reloadData()
                    
                }
                
                }, failureHandler: { [weak self](msg, code) in
                    if let weakSelf = self  {
                        weakSelf.dismissPreloadView()
                        weakSelf.tableView.mj_header.endRefreshing()
                        weakSelf.tableView.mj_footer.endRefreshing()
                        
                        weakSelf.addWrongView(msg, refresh: {
                            weakSelf.request(start_id: start_id, limit: limit, offset: offset)
                        })
                        
                        
                    }
                    
            })
    }
    
    ///用户.获取作品消费某本书某个批量订阅的
    func request_detail(parent_id: String,offset:String,limit: String) {
        
        MQIUserBatchDetailRequest(book_id: book.book_id, offset: offset, parent_id: parent_id,limit: limit)
            .requestCollection({ [weak self](request, response, result: [MQIEachConsumeInfo]) in
                
                if let weakSelf = self {
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                    weakSelf.tableView.mj_header.endRefreshing()
                    
                    weakSelf.configResult(result: result)
                    weakSelf.tableView.reloadData()
                    
                }
                
                }, failureHandler: { [weak self](msg, code) in
                    if let weakSelf = self  {
                        weakSelf.dismissPreloadView()
                        weakSelf.tableView.mj_header.endRefreshing()
                        weakSelf.tableView.mj_footer.endRefreshing()
                        
                        weakSelf.addWrongView(msg, refresh: {
                            weakSelf.request_detail(parent_id: parent_id,offset: offset, limit: limit)
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
    func configResult(result: [MQIEachConsumeInfo]) {
        
        if result.count < limit {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            tableView.mj_footer.endRefreshing()
        }
        if isRefresh == true {
            isRefresh = false
            consumes.removeAll()
            consumeDates.removeAll()
            consumeDict.removeAll()
        }
        
        consumes.append(contentsOf: result)
        
        for i in 0..<result.count {
            let consume = result[i]
            if consumeDates.contains(consume.cost_month3) == true {
                if let _ = consumeDict[consume.cost_month3] {
                    consumeDict[consume.cost_month3]!.append(consume)
                }
            }else {
                consumeDates.append(consume.cost_month3)
                consumeDict[consume.cost_month3] = [consume]
            }
        }
        
        if consumes.count <= 0 {
            addnoConsumeInfoRercord()
        }else{
            dismissConsumeInfo()
        }
        
        if CGFloat(consumes.count)*MQIUserConsumeInfoCell .getHeight(nil) + CGFloat(consumeDates.count*35) < tableView.height {
            tableView.mj_footer.isHidden = true
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
}


private let cellIdentifier = "cellIdentifier"
extension MQIUserConsumeInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 35))
        view.backgroundColor = tableView.backgroundColor
        
        let label = createLabel(CGRect(x: 15, y: 0, width: view.width-30, height: 35),
                                font: systemFont(16),
                                bacColor: UIColor.clear,
                                textColor: RGBColor(102, g: 102, b: 102),
                                adjustsFontSizeToFitWidth: nil,
                                textAlignment: .left,
                                numberOfLines: 0)
        label.text = consumeDates[section]
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return consumeDates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MQIUserConsumeInfoCell.getHeight(nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        toInfoVC(index: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let model = consumeDict[consumeDates[indexPath.section]]![indexPath.row]
        if model.is_batch == "1"  {
            let vc: MQIUserConsumeInfoViewController! = MQIUserConsumeInfoViewController.create() as? MQIUserConsumeInfoViewController
            vc.book = self.book
            vc.parent_id =  model.id
            pushVC(vc)
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = consumeDict[consumeDates[section]]!
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MQIUserConsumeInfoCell
        let list = consumeDict[consumeDates[indexPath.section]]!
        cell.is_batch = (self.parent_id == nil) ? "":"1"
        cell.consume = list[indexPath.row]
        
        return cell
    }
    
}
