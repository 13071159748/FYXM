//
//  MQICouponVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh

class MQICouponVC: MQIRootTableVC {

    fileprivate var coupons = [GYEachUserCoupon]()
    
    fileprivate var isRefresh: Bool = false
    fileprivate var limit: Int = DEFAULT_PER_PAGE
    
    public var valid: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gtableView.registerCell(MQICouponCell.self, xib: false)
        gtableView.separatorStyle = .none
        
        gtableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.request(offset: "0", limit: "\(strongSelf.coupons.count)")
            }
        })
        
        if valid == false {  //无效券状态
            title = kLocalized("MyCoupon")
            
            gtableView.mj_footer = GYCouponUnValidRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
                if let strongSelf = self {
                    strongSelf.request(offset: "\(strongSelf.coupons.count)", limit: "\(strongSelf.limit)")
                }
            })
        }else {
            title = kLocalized("MyCoupon")
            
            gtableView.mj_footer = GYCouponRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
                if let strongSelf = self {
                    strongSelf.request(offset: "\(strongSelf.coupons.count)", limit: "\(strongSelf.limit)")
                }
            })
            
            (gtableView.mj_footer as! GYCouponRefreshAutoNormalFooter).pushUnvaildCouponVC = { [weak self] in
                if let strongSelf = self {
                    strongSelf.toUnvaildCouponVC()
                }
            }
//            if GYPayTypeManager.shared.type != .inPurchase{
//                addRightBtn("充值", imgStr: nil)
//            }
            addRightBtn(kLocalized("Recharge"), imgStr: nil)
            
        }
        
        addPreloadView()
        request(offset: "0", limit: "\(limit)")
    }
    
    func request(offset: String, limit: String) {
        GYGetUserVaildCouponsRequest(offset: offset, limit: limit, valid: valid)
            .requestCollection({[weak self] (request, response, result: [GYEachUserCoupon]) in
                if let strongSelf = self {
                    if strongSelf.isRefresh == true {
                        strongSelf.coupons = result
                    }else {
                        strongSelf.coupons.append(contentsOf: result)
                    }
                    strongSelf.isRefresh = false
                    strongSelf.dismissWrongView()
                    
                    strongSelf.endRequest(result)
                    
                    strongSelf.gtableView.reloadData()
                }
            }) {[weak self] (msg, code) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.isRefresh = false
                    strongSelf.gtableView.mj_header.endRefreshing()
                    strongSelf.gtableView.mj_footer.endRefreshing()
                    strongSelf.addWrongView(msg, refresh: {
                        strongSelf.request(offset: offset, limit: limit)
                    })
                }
        }
    }
    
    func endRequest(_ results: [GYEachUserCoupon]) {
        dismissPreloadView()
        gtableView.mj_header.endRefreshing()
        gtableView.mj_footer.isHidden = coupons.count <= 0
        
        if results.count <= 0 || coupons.count < limit {
            
            gtableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            gtableView.mj_footer.endRefreshing()
        }
        
        if coupons.count <= 0 {
            addNoDataView()
        }else {
            removeNoDataView()
        }
    }
    
    override func rightBtnAction(_ button: UIButton) {
        MQIUserOperateManager.shared.toPayVC(nil)
    }
    
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return coupons.count
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQICouponCell.getHeight(nil)
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQICouponCell.self, forIndexPath: indexPath)
        cell.eachCouponView.eachUserCoupon = coupons[indexPath.row]
        if valid == false {
            cell.eachCouponView.addStatusView(coupons[indexPath.row].status_name)
        }
        return cell
    }
    
    fileprivate var nothingView: GYCouponNoDataView?
    override func addNoDataView() {
        if nothingView == nil {
            nothingView = UIView.loadNib(GYCouponNoDataView.self)
            nothingView!.frame = contentView.bounds
            contentView.addSubview(nothingView!)
            contentView.bringSubviewToFront(nothingView!)
            
            
            guard valid == false else{
                nothingView!.deTitleLabel.text = kLocalized("ThereAreNoMoreValidCouponsIsTheInvalidCoupon")
                nothingView!.pushUnvaildCouponVC = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.toUnvaildCouponVC()
                    }
                }
                return
            }
            
            nothingView!.deTitleLabel.text = kLocalized("ThereAreNoMoreInvalidCoupo")
        }
    }
    
    func removeNoDataView() {
        if let _ = noDataView {
            noDataView = nil
            noDataView!.removeFromSuperview()
        }
    }
    
    func toUnvaildCouponVC() {
        guard valid == true else {
            return
        }
        
        let vc = MQICouponVC()
        vc.valid = false
        pushVC(vc)
    }
}

class GYCouponRefreshAutoNormalFooter: MJRefreshAutoNormalFooter {
    
    open var pushUnvaildCouponVC: (() -> ())?
    
    open override func setTitle(_ title: String!, for state: MJRefreshState) {
        guard state == .noMoreData else {
            stateLabel.textColor = RGBColor(91, g: 91, b: 91)
            super.setTitle(title, for: state)
            return
        }
        stateLabel.textColor = RGBColor(151, g: 151, b: 151)
        super.setTitle(kLocalized("ThereAreNoMoreValidCouponsIsTheInvalidCoupon"), for: state)
    }
    
    //    open override func stateLabelClick() {
    open func stateLabelClick() {
        
        if state == .noMoreData {
            pushUnvaildCouponVC?()
        }
    }
    
}

class GYCouponUnValidRefreshAutoNormalFooter: MJRefreshAutoNormalFooter {
    
    open override func setTitle(_ title: String!, for state: MJRefreshState) {
        guard state == .noMoreData else {
            stateLabel.textColor = RGBColor(91, g: 91, b: 91)
            super.setTitle(title, for: state)
            return
        }
        stateLabel.textColor = RGBColor(151, g: 151, b: 151)
        super.setTitle(kLocalized("ThereAreNoMoreInvalidCoupo"), for: state)
    }
    
    
}

