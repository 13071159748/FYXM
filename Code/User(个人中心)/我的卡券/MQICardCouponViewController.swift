//
//  MQICardCouponViewController.swift
//  CQSC
//
//  Created by BigMac on 2019/12/23.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh

fileprivate let cardCouponSelectedColor = UIColor.colorWithHexString("#5A94FF")
fileprivate let cardCouponNormalColor = UIColor.colorWithHexString("#333333")

class MQICardCouponViewController: MQIBaseViewController {

    fileprivate let topChooseViewHeight: CGFloat = 43.0
    
    fileprivate var oldSelectedBtn: UIButton!
    fileprivate var moveLine: UIView!
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var tableView1: MQITableView!
    fileprivate var tableView2: MQITableView!
    
    fileprivate var nodataView1: MQINoDataView?
    fileprivate var nodataView2: MQINoDataView?
    
    /// 有效
    fileprivate var unuseDataArray = [MQICardCouponItemModel]() {
        didSet {
            if unuseDataArray.count == 0 {
                addNoDataView(0)
            } else {
                dismissNoDataView(0)
            }
        }
    }
    /// 无效
    fileprivate var expiredDataArray = [MQICardCouponItemModel]() {
        didSet {
            if expiredDataArray.count == 0 {
                addNoDataView(1)
            } else {
                dismissNoDataView(1)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = kLocalized("CardCouponRecord")
        
        addTopView()
        addContenView()
        addPreloadView()
        
        addTableRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCardData(status: 1, offset: 0)
    }
    
    
    func addNoDataView(_ index: Int) {
        let nodataView = createNodataView()
        if index == 0 {
            tableView1.addSubview(nodataView)
            nodataView1 = nodataView
        } else {
            tableView2.addSubview(nodataView)
            nodataView2 = nodataView
            nodataView2?.icon.image = UIImage(named: "noCard")
            nodataView2?.titleLabel.text = kLocalized("noCardCoupon")
        }
    }
    
    func dismissNoDataView(_ index: Int) {
        if index == 0 {
            nodataView1?.isHidden = true
            nodataView1?.removeFromSuperview()
        } else {
            nodataView2?.isHidden = true
            nodataView2?.removeFromSuperview()
        }
    }
    
    
}

//MARK: - Net
extension MQICardCouponViewController {
    ///status 1：未使用  2：已失效
    fileprivate func loadCardData(status: Int, offset: Int) {
        MQICounponseUserPrize(status: status, offset: offset).request({[weak self] (request, response, result: MQICardCouponModel) in
            guard let weakSelf = self else { return }
            weakSelf.dismissPreloadView()
            mqLog("status \(status), result \(result.data.count)")
            if status == 1 {
                if offset == 0 {
                    weakSelf.unuseDataArray.removeAll()
                }
                weakSelf.unuseDataArray.append(contentsOf: result.data)
                weakSelf.tableView1.reloadData()
                weakSelf.tableView1.mj_header?.endRefreshing()
                weakSelf.tableView1.mj_footer?.endRefreshing()
            } else {
                if offset == 0 {
                    weakSelf.expiredDataArray.removeAll()
                }
                weakSelf.expiredDataArray.append(contentsOf: result.data)
                weakSelf.tableView2.reloadData()
                weakSelf.tableView2.mj_header?.endRefreshing()
                weakSelf.tableView2.mj_footer?.endRefreshing()
            }
        }, failureHandler: {[weak self] (err_code, err_msg) in
            if let strongSelf = self {
                strongSelf.dismissPreloadView()
                strongSelf.tableView1.mj_header?.endRefreshing()
                strongSelf.tableView1.mj_footer?.endRefreshing()
                strongSelf.tableView2.mj_header?.endRefreshing()
                strongSelf.tableView2.mj_footer?.endRefreshing()
                strongSelf.addWrongView(err_msg, refresh: {
                    strongSelf.loadCardData(status: status, offset: offset)
                })
            }
        })
    }
    
    func addTableRefresh() {
        tableView1.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.loadCardData(status: 1, offset: 0)
        })
        tableView2.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.loadCardData(status: 2, offset: 0)
        })
        
        tableView1.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.loadCardData(status: 1, offset: weakSelf.unuseDataArray.count)
        })
        tableView2.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.loadCardData(status: 2, offset: weakSelf.expiredDataArray.count)
        })
    }
    
}


//MARK: - Delegate
extension MQICardCouponViewController: MQITableViewDelegate, UIScrollViewDelegate {

    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQICardCounponTableCell.self, forIndexPath: indexPath)
        if tableView == tableView1 {
            cell.indexModel = unuseDataArray[indexPath.section]
            cell.rechargeBlock = {[weak self] url in
                guard let weakSelf = self else { return }
                weakSelf.pushToCharge(url)
            }
        } else {
            cell.indexModel = expiredDataArray[indexPath.section]
        }
        
        cell.contenChangeBlock = {[weak self](expend) in
            guard let weakSelf = self else { return }
            weakSelf.sectionRefresh(tableView, indexPath.section, expend)
            mqLog("reload section \(indexPath.section)")
        }
        
        return cell
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return 1
    }
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        if tableView == tableView1 {
            return unuseDataArray.count
        } else {
            return expiredDataArray.count
        }
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 18
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / screenWidth)
        if oldSelectedBtn.tag == index + 666 {return}
        
        let button = view.viewWithTag(666+index)
        if let button = button as? UIButton {
            changeAction(button)
        }
    }
    
}


//MARK: - action
extension MQICardCouponViewController {
    
    @objc fileprivate func changeAction(_ btn: UIButton) {
        if btn.tag == oldSelectedBtn.tag {
            return
        }
        oldSelectedBtn.isSelected = false
        btn.isSelected = true
        oldSelectedBtn = btn
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.moveLine.centerX = btn.centerX
        }, completion: nil)
        
        //更換列表操作
        let status = btn.tag - 666 + 1
        loadCardData(status: status, offset: status == 1 ? unuseDataArray.count : expiredDataArray.count)
        scrollView.contentOffset = CGPoint(x: (status - 1) * Int(scrollView.width), y: 0)
        if status == 1 {
            tableView1.mj_header?.beginRefreshing()
        } else {
            tableView2.mj_header?.beginRefreshing()
        }
    }
    
    
    fileprivate func pushToCharge(_ url: String?) {
        MQIOpenlikeManger.openLike(url)
//        MQIUserOperateManager.shared.toPayVC(toPayChannel: .normalToPay, nil)
    }
    
    fileprivate func sectionRefresh(_ tableView: MQITableView, _ secitonIndex: Int, _ expend: Bool) {

        if tableView == tableView1 {
            let model = unuseDataArray[secitonIndex]
            model.expend = expend
        } else {
            let model = expiredDataArray[secitonIndex]
            model.expend = expend
        }
        let indexSet = IndexSet(integer: secitonIndex)
        tableView.reloadSections(indexSet, with: .fade)
    }
    
}



//MARK: - UI
extension MQICardCouponViewController {
    
    fileprivate func addTopView() {
        
        let chooseBgView = UIView()
        chooseBgView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: topChooseViewHeight)
        chooseBgView.backgroundColor = .white
        contentView.addSubview(chooseBgView)
        
        moveLine = UIView()
        moveLine.backgroundColor = cardCouponSelectedColor
        moveLine.frame = CGRect(x: 0, y: chooseBgView.maxY - 2, width: 52, height: 2)
        
        let titleArray = [kLocalized("unUsed"),kLocalized("expired")]
        let width = screenWidth / 2.0
        for index in 0..<2 {
            let button = createBtn(title: titleArray[index])
            button.tag = 666+index
            button.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: chooseBgView.height)
            chooseBgView.addSubview(button)
            chooseBgView.addSubview(moveLine)
            button.addTarget(self, action: #selector(changeAction(_:)), for: .touchUpInside)
            if index == 0 {
                button.isSelected = true
                oldSelectedBtn = button
                moveLine.centerX = button.centerX
            }
        }
        
        let verLine = UIView()
        verLine.backgroundColor = UIColor.colorWithHexString("#DEDEDE")
        verLine.frame = CGRect(x: width, y: 0, width: 1, height: 22)
        verLine.centerY = chooseBgView.height / 2.0
        chooseBgView.addSubview(verLine)
    }
    
    fileprivate func addContenView() {
        
        let width = screenWidth
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: topChooseViewHeight, width: width, height: contentView.height - topChooseViewHeight))
        contentView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        scrollView.contentSize = CGSize(width: width * 2, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.scrollView = scrollView
        
        tableView1 = createTableView()
        tableView1.frame = CGRect(x: 0, y: 0, width: width, height: scrollView.height)
        tableView2 = createTableView()
        tableView2.frame = CGRect(x: width, y: 0, width: width, height: scrollView.height)
        scrollView.addSubview(tableView1)
        scrollView.addSubview(tableView2)
        
        if #available(iOS 11.0, *) {
            tableView1.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            tableView2.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    fileprivate func createTableView() -> MQITableView {
        let tableView = MQITableView(frame: .zero, style: .grouped)
        tableView.gyDelegate = self
        tableView.registerCell(MQICardCounponTableCell.self, xib: true)
        tableView.estimatedRowHeight = 129
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.contentInset = UIEdgeInsetsMake(0, 20, 18, 20)
        tableView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.0001))
        tableView.separatorStyle = .none
        return tableView
    }
    
    fileprivate func createBtn(title: String) -> UIButton {
        
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(cardCouponSelectedColor, for: .selected)
        btn.setTitleColor(cardCouponNormalColor, for: .normal)
        return btn
    }
    
    fileprivate func createNodataView() -> MQINoDataView {
        let nodataView = MQINoDataView(frame: CGRect(x: 0, y: 0, width:screenWidth, height: tableView1.height))
        nodataView.icon.image = UIImage(named: "noCard")
        nodataView.titleLabel.text = kLocalized("noCardCoupon")
        nodataView.icon.snp.remakeConstraints { (make) -> Void in
            make.bottom.equalTo(nodataView.snp.centerY).offset( 10)
            make.width.equalTo(283 * gdscale)
            make.height.equalTo(154 * hdscale)
            make.centerX.equalToSuperview()
        }
        return nodataView
    }
    
}
