//
//  MQIEventCenterViewController.swift
//  CQSC
//
//  Created by moqing on 2019/12/24.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh
class MQIEventCenterViewController: MQIBaseViewController {

    var gtableView: MQITableView!
    var nextID = "0"

    var taskModel = MQITaskModel() {
        didSet(oldValue) {
            if taskModel.taskList.count == 0 {
                addNoDataView()
            } else {
                dismissNoDataView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("event_center")
        addTableView()
        gtableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.getMsgList(offset: "0", limit: "20")
            }
        })
        gtableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.getMsgList(offset: weakSelf.nextID, limit: "20")
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

    func getMsgList(offset: String, limit: String) {

        MQIChargeTaskListRequest(next_id: offset, limit: limit)
            .request({ [weak self](request, response, result: MQITaskModel) in
                if let weakSelf = self {
                    let resultNew = result

                    if offset == "0" {
                        weakSelf.taskModel = resultNew
                    } else {
                        weakSelf.taskModel.taskList.append(contentsOf: resultNew.taskList)
                    }
                    weakSelf.nextID = resultNew.next_id

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
                    if weakSelf.taskModel.taskList.count == 0 {
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
        gtableView.backgroundColor = .white
        gtableView.tableFooterView = nil
        gtableView.separatorStyle = .none
        gtableView.showsVerticalScrollIndicator = false
        gtableView.gyDelegate = self
        gtableView.registerCell(MQIEventCenterCell.self, xib: false)
        gtableView.frame = contentView.bounds
        gtableView.rowHeight = UITableView.automaticDimension
        gtableView.estimatedRowHeight = kUIStyle.scale1PXH(86)
        gtableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func openLink(_ linkUrl: String?) {
        if let url = URL(string: linkUrl ?? "") {
            mqLog("url \(url.absoluteString)")
            MQIOpenlikeManger.openLike(url)
        }
    }
}

extension MQIEventCenterViewController: MQITableViewDelegate {

    //MARK:  tableView代理
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return taskModel.taskList.count
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
        view.backgroundColor = .clear
        return view
    }

    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIEventCenterCell.self, forIndexPath: indexPath)
        cell.model = taskModel.taskList[indexPath.section]
        return cell
    }

    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let indexModel = taskModel.taskList[indexPath.section]
        if indexModel.event_status == "2" {
            MQILoadManager.shared.makeToast("活动已结束")
            return
        }
        
        if MQIUserManager.shared.checkIsLogin() {
            openLink(indexModel.url)
        } else {
            if indexModel.is_need_login == 1 {
                MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: { [weak self]() -> Void in
                    guard let weakSelf = self else { return }
                    weakSelf.openLink(indexModel.url)
                })
            } else {
                openLink(indexModel.url)
            }
        }
    }
}
