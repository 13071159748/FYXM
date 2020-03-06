//
//  MQIVrestoreApplePayViewController.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/8/21.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIVrestoreApplePayViewController: MQIBaseViewController {
    
    var payTableView:MQITableView!
    /// 验证失败订单
    var verifyFailedOrders :[MQIApplePayModelNew] = [ MQIApplePayModelNew]()
    /// 恢复支付订单
    var backPayOrders :[MQIApplePayModelNew] = [ MQIApplePayModelNew]()
    
    let  inPurchaseManager  = MQIIAPManager.shared
//    lazy var meiyxib: MQIVrestoreApplePayViewmeiyxib = {
//        let v =  UIView.loadNib(MQIVrestoreApplePayViewmeiyxib.self)
//        self.view.addSubview(v)
//        self.view.sendSubview(toBack: v)
//        return v
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        meiyxib.awakeFromNib()
        title = kLocalized("uncredited")
        addTableView()
        inPurchaseManager.clean()
        getData()
        inPurchaseManager.callbackPromptBlock = { (model:MQIComplexResultModel) in
            let rmodel = MQIResultsPageModel()
            if model.data.banner.image_url.count > 0 {
                rmodel.type = .banner
                rmodel.lineTitle = model.data.banner.title
                rmodel.banner_Img_url = model.data.banner.image_url
                rmodel.linkStr = model.data.banner.url
            } else if model.data.tj.books.count > 0 {
                rmodel.type = .recommended
                rmodel.lineTitle = model.data.tj.name
                for itm in model.data.tj.books {
                    let model = MQIResultsPageModel()
                    model.book_img_url = itm.book_cover
                    model.book_title = itm.book_name
                    model.book_id  = itm.book_id
                    rmodel.itmeData.append(model)
                }
                
            }else{
                rmodel.type = .prompt
            }
            rmodel.prompt_img_name = "tk_dh_img"
            rmodel.title1 = rmodel.setAtts(str: kLocalized("TopUpSuccess"))
            if model.data.result.desc.count > 0 {
                rmodel.title2 = MQIOpenlikeManger.getParsingAtts("\(model.data.result.desc)", textAlignment: .center)
            }
            rmodel.btnTitle = kLocalized("I_know_the")
            MQILoadManager.shared.showResultsPageView(rmodel, callbackBlock: { (book_id, link_url) in
                if book_id != nil {
                    MQIUserOperateManager.shared.toReader(book_id!)
                    return
                }
                if link_url != nil {
                    MQIOpenlikeManger.openLike(URL(string: link_url!))
                    return
                }
            })
        }
    }
    
    func getData(_ isFirst:Bool = false ) -> Void {
        backPayOrders = inPurchaseManager.getRestoreOrder()
        //        verifyFailedOrders = inPurchaseManager.getReloadOrder()
        verifyFailedOrders = inPurchaseManager.getCacheVerifyOrder()
        
        var newVerifyFailedOrders = verifyFailedOrders
        for i  in 0..<verifyFailedOrders.count  {
            let ru = backPayOrders.filter({$0.identifier != "" && $0.identifier  == verifyFailedOrders[i].identifier })
            if  ru.count > 0 {
                newVerifyFailedOrders.remove(at: i)
                ru.first?.order_id = verifyFailedOrders[i].order_id
                ru.first?.recepit = verifyFailedOrders[i].recepit
                inPurchaseManager.saveApplePayOrderList(list: newVerifyFailedOrders)
                
            }
        }
        
        verifyFailedOrders =    newVerifyFailedOrders
        
        
        if isFirst {
            self.dismissPreloadView()
            if self.verifyFailedOrders.count == 0 && self.backPayOrders.count == 0 {
                self.addNoDataView()
                self.noDataView?.icon.image = UIImage(named: "searchNoBook")
                self.noDataView?.titleLabel.text = kLocalized("notBeinPaid")
            }else{
                self.dismissNoDataView()
                self.payTableView.reloadData()
            }
        }else{
            addPreloadView()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                self?.dismissPreloadView()
                self?.backPayOrders = self?.inPurchaseManager.getRestoreOrder() ?? [ MQIApplePayModelNew]()
                if self?.verifyFailedOrders.count == 0 && self?.backPayOrders.count == 0 {
                    self?.addNoDataView()
                    self?.noDataView?.icon.image = UIImage(named: "searchNoBook")
                    self?.noDataView?.titleLabel.text = kLocalized("notBeinPaid")
                }else{
                    self?.dismissNoDataView()
                    self?.payTableView.reloadData()
                }
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inPurchaseManager.callbackBlock = nil
    }
    
    func addTableView() -> Void {
        payTableView = MQITableView(frame: CGRect(x: 0, y: kUIStyle.kNavBarHeight+10, width: kUIStyle.kScrWidth, height: kUIStyle.kScrHeight-kUIStyle.kNavBarHeight-10))
        payTableView.separatorStyle = .none
        payTableView.gyDelegate = self
        self.view.addSubview(payTableView)
        payTableView.backgroundColor =  kUIStyle.colorWithHexString("F8F8F8")
        
        payTableView.registerCell(MQIVrestoreApplePayMoneyCellNew.self, xib: false)
        //        payTableView.registerCell(MQIApplePayDescribeCell.self, xib: false)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
}

extension MQIVrestoreApplePayViewController:MQITableViewDelegate {
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 2
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        
        if section == 0 {
            return backPayOrders.count
        }else{
            return verifyFailedOrders.count
        }
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return kUIStyle.scaleH(180)
        
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(MQIVrestoreApplePayMoneyCellNew.self, forIndexPath: indexPath)
            cell.selectionStyle = .none
            //            cell.currencyLable.text = "恢复订单"
            
            let model  = backPayOrders[indexPath.row]
            //MARK:   火热小说是人民币  其他App是美元
            let moneystr1 =    model.product_id.replacingOccurrences(of: productHeader, with: "")
            let moneystr2 =   moneystr1.replacingOccurrences(of: productHeader2, with: "")
            
            let money = moneystr2.floatValue()
            
            if model.product_id.contains("hrxs") {
                cell.moneyLable.text = default_units+"\(money)"
            }else{
                cell.moneyLable.text = default_units+"\(money-0.01)"
            }
            cell.dateLable.text = model.createDateStr
            if model.identifier == "" {
                cell.numberLable.text = ""
            }else{
                cell.numberLable.text = kLocalized("SerialNumber")+model.identifier
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(MQIVrestoreApplePayMoneyCellNew.self, forIndexPath: indexPath)
            cell.selectionStyle = .none
            let model  = verifyFailedOrders[indexPath.row]
            //            cell.moneyLable.text = model.product_id.replacingCharacters(pattern: productHeader, template: default_units)
            
            let moneystr1 =    model.product_id.replacingOccurrences(of: productHeader, with: "")
            let moneystr2 =   moneystr1.replacingOccurrences(of: productHeader2, with: "")
            
            let money = moneystr2.floatValue()
            
            if model.product_id.contains("hrxs") {
                cell.moneyLable.text = default_units+"\(money)"
            }else{
                cell.moneyLable.text = default_units+"\(money-0.01)"
            }
            
            cell.dateLable.text = model.createDateStr
            if model.identifier == "" {
                cell.numberLable.text = ""
            }else{
                cell.numberLable.text = kLocalized("SerialNumber")+model.identifier
            }
            return cell
        }
        
        
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        mqLog("\(indexPath.row)")
        if indexPath.section == 0 { /// 恢复订单
            let model = backPayOrders[indexPath.row]
            MQILoadManager.shared.addProgressHUD("")
            if model.product_id == "" || model.order_id == "" {
                inPurchaseManager.systemRecoveryProcess(model.product_id)
            }else{
                inPurchaseManager.systemRecoveryProcess(model.product_id,model:model)
            }
            
            inPurchaseManager.callbackBlock = {[weak self] (suc: Bool,  msg: String) in
                if let weakSelf = self  {
                    if !suc {
                        if  msg.contains("DSYCALLBACK_1") {
                            MQILoadManager.shared.dismissProgressHUD()
                            let msgNEW = msg.replacingOccurrences(of: "DSYCALLBACK_1", with: "")
                            MQILoadManager.shared.makeToast(msgNEW)
                            weakSelf.getData()
                            
                        }else{
                            MQILoadManager.shared.dismissProgressHUD()
                            MQILoadManager.shared.addProgressHUD(msg)
                            
                        }
                    }else{
                        MQILoadManager.shared.dismissProgressHUD()
                        MQILoadManager.shared.makeToast(msg)
                        weakSelf.getData()
                    }
                    
                }
                
            }
            
        }else{ /// 验证订单
            let model = verifyFailedOrders[indexPath.row]
            MQILoadManager.shared.addProgressHUD("")
            if model.product_id == "" || model.order_id == "" {
                inPurchaseManager.systemRecoveryProcess(model.product_id)
            }else{
                inPurchaseManager.systemRecoveryProcess(model.product_id,model:model)
            }
            inPurchaseManager.callbackBlock = {[weak self] (suc: Bool,  msg: String) in
                if let weakSelf = self  {
                    if !suc {
                        if  msg.contains("DSYCALLBACK_1") {
                            MQILoadManager.shared.dismissProgressHUD()
                            let msgNEW = msg.replacingOccurrences(of: "DSYCALLBACK_1", with: "")
                            MQILoadManager.shared.makeToast(msgNEW)
                            weakSelf.getData()
                            
                        }else{
                            MQILoadManager.shared.dismissProgressHUD()
                            MQILoadManager.shared.addProgressHUD(msg)
                            
                        }
                    }else{
                        MQILoadManager.shared.dismissProgressHUD()
                        MQILoadManager.shared.makeToast(msg)
                        weakSelf.getData()
                    }
                    
                }
                
            }
        }
        
        
    }
    
}

class MQIVrestoreApplePayMoneyCellNew: MQITableViewCell {
    
    var bacView:UIView!
    
    var titleLable:UILabel!
    var dateLable:UILabel!
    var moneyLable:UILabel!
    var clickLable:UILabel!
    var grayView:UIView!
    var numberLable:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor =  kUIStyle.colorWithHexString("F8F8F8")
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    
    func setupUI() -> Void {
        grayView = UIView()
        grayView.backgroundColor = kUIStyle.colorWithHexString("F8F8F8")
        contentView.addSubview(grayView)
        grayView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            
        }
        
        bacView = UIView()
        bacView.backgroundColor = UIColor.white
        contentView.addSubview(bacView)
        bacView.dsySetCorner(radius: kUIStyle.scaleW(20))
        bacView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: kUIStyle.scaleW(26), bottom:  10, right: kUIStyle.scaleW(26)))
            
        }
        
        titleLable = UILabel()
        titleLable.textColor = kUIStyle.colorWithHexString("262A2D")
        titleLable.font = kUIStyle.sysFontDesignSize(size: 32)
        titleLable.text = kLocalized("HaveToPay")
        bacView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(bacView).offset(15)
            make.top.equalTo(bacView) .offset(12)
        }
        
        moneyLable = UILabel()
        moneyLable.textColor = kUIStyle.colorWithHexString("262A2D")
        moneyLable.font = kUIStyle.sysFontDesignSize(size: 32)
        bacView.addSubview(moneyLable)
        moneyLable.textAlignment = .left
        
        moneyLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable)
            make.left.equalTo(titleLable.snp.right)
        }
        
        
        numberLable =  UILabel()
        numberLable.textColor = kUIStyle.colorWithHexString("454545")
        numberLable.font = kUIStyle.sysFontDesignSize(size: 26)
        bacView.addSubview(numberLable)
        numberLable.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(5)
        }
        
        dateLable =  UILabel()
        dateLable.textColor = kUIStyle.colorWithHexString("454545")
        dateLable.font = kUIStyle.sysFontDesignSize(size: 24)
        bacView.addSubview(dateLable)
        dateLable.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.bottom.equalTo(bacView).offset(-5)
        }
        
        
        
        clickLable =  UILabel()
        clickLable.textColor = kUIStyle.colorWithHexString("EB5567")
        clickLable.font = kUIStyle.sysFontDesignSize(size:30)
        clickLable.text = kLocalized("clickRetry")
        bacView.addSubview(clickLable)
        
        clickLable.snp.makeConstraints { (make) in
            make.right.equalTo(bacView.snp.right).offset(-15)
            make.centerY.equalTo(bacView.snp.centerY)
            
        }
        
    }
    
}




