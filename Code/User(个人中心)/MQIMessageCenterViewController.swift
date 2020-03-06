//
//  MQIMessageCenterViewController.swift
//  XSDQ
//
//  Created by moqing on 2019/3/19.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh
class MQIMessageCenterViewController: MQIBaseViewController {
    
    var gtableView:MQITableView!
    var  messageArr = [MQIMessageModel](){
        didSet(oldValue) {
            if messageArr.count == 0 {
                addNoDataView()
            }else{
                dismissNoDataView()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("Msg_Centre")
        addTableView()
        gtableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.getMsgList(offset: "0", limit: "20")
            }
        })
        gtableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.getMsgList(offset: "\(weakSelf.messageArr.count)", limit: "20")
            }
        })
        addPreloadView()
        getMsgList(offset: "0", limit: "20")
        
        
    }
    
    override func addNoDataView() {
        super.addNoDataView()
        self.noDataView?.icon.image = UIImage(named: "searchNoBook")
        self.noDataView?.titleLabel.text = kLocalized("No_boos_message")
    }
    
    func getMsgList(offset:String,limit:String) {
        
        MQIGetMsglistRequest(offset: offset, limit: limit)
            .requestCollection({[weak self](request, response, result:[MQIMessageModel]) in
                if let weakSelf = self {
                    var resultNew = result
//                    let Mesg  = MQIMessageModel()
//                    Mesg.id = "10"
//                    Mesg.title = "测试数据"
//                    Mesg.content = "亲爱的读者，我们帮您选了一本好书：<a:legendnovelapp://navigator/reader/14184>《阅读器》</a>, 这是专属于您的限免书籍，有效期<c:#FF0000>7天</c>\n亲爱的读者，我们帮您选了一本好书：<a:legendnovelapp://navigator/book/14184>《详情页》</a>, 这是专属于您的限免书籍，有效期 < c : #999999>7天</c>\n亲爱的读者，我们帮您选了一本好书：<a: https://hrxsh5cdn.weiyanqing.com/v1/main/term>chakan><<站内数据>></a>, 这是专属于您的限免书籍，有效期<c:#999999>7天</c>\n亲爱的读者，我们帮您选了一本好书：< a : https://www.baidu.com >《站外链接》</a>, 这是专属于您的限免书籍，有效期<c:#999999>7天</c>\n亲爱的读者，我们帮您选了一本好书：<a: legendnovelapp://navigator/pay >《支付》</a>, 这是专属于您的限免书籍，有效期<c:#999999>7天</c>\n亲爱的读者，我们帮您选了一本好书：<a: legendnovelapp://navigator/lottery>《签到》</a>"
//                    Mesg.add_time = "\(getCurrentStamp())"
//                    resultNew = [Mesg]
                    if offset == "0"{
                        weakSelf.messageArr = resultNew
                    }else{
                        weakSelf.messageArr.append(contentsOf: resultNew)
                    }
                    
                    weakSelf.gtableView.reloadData()
                    weakSelf.gtableView.mj_header.endRefreshing()
                    weakSelf.gtableView.mj_footer.endRefreshing()
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                }
                
            }) { [weak self](err_msg, err_code) in
                if let weakSelf = self {
                    weakSelf.gtableView.mj_header.endRefreshing()
                    weakSelf.gtableView.mj_footer.endRefreshing()
                    weakSelf.dismissPreloadView()
                    if weakSelf.messageArr.count == 0 {
                        weakSelf.addWrongView(err_msg, refresh: {
                            weakSelf.getMsgList(offset: offset, limit: limit)
                        })
                    }
                }
        }
    }
    
    func addTableView() -> Void {
        gtableView = MQITableView()
        contentView.addSubview(gtableView)
        gtableView.backgroundColor = kUIStyle.colorWithHexString("#F2F2F2")
        gtableView.tableFooterView = nil
        gtableView.separatorStyle = .none
        gtableView.showsVerticalScrollIndicator = false
        gtableView.gyDelegate = self
        gtableView.registerCell(MQIMessageCenterTableViewCell.self, xib: false)
        gtableView.frame = contentView.bounds
        gtableView.rowHeight = UITableView.automaticDimension
        gtableView.estimatedRowHeight = kUIStyle.scale1PXH(86)
    }
}
extension MQIMessageCenterViewController: MQITableViewDelegate {
    
    //MARK:  tableView代理
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return messageArr.count
    }
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        
        return 1
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 12
    }
    func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
        view.backgroundColor = kUIStyle.colorWithHexString("#F2F2F2")
        return view
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(MQIMessageCenterTableViewCell.self, forIndexPath: indexPath)
        cell.model =  messageArr[indexPath.section]
        return cell
    }
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
