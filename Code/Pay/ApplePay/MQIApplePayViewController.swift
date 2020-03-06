//
//  MQIApplePayViewController.swift
//  CQSC
//
//  Created by moqing on 2019/2/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//   pt  df  mw  sm/fc  wdd

import UIKit

class MQIApplePayViewController: MQIBaseViewController {
    
    
    ///动画时间
    let paymentAlertViewAnimationInterval: TimeInterval = 0.5
    
    var isShowDicountCardPay = true
    
    var banner: UIImageView?
    
    
    var payModel = MQIApplePayListModel(){
        didSet(oldValue) {
            datas = payModel.data
            bannerModel = payModel.banner
            collectionView.reloadData()
            
            inPurchaseManager.payModel = payModel
            
            addTips1()
        }
    }
    
    var bannerModel = MQIApplePayItemModel()
    var collectionView:MQICollectionView!
    var datas = [MQIApplePayItemModel]()
    
    let payTintColor = kUIStyle.colorWithHexString("EB5567")
    //    var inPurchaseManager: MQIInPurchaseManager!
    var inPurchaseManager = MQIIAPManager.shared
    var compBlock:((_ suc:Bool) -> ())?
    /// 是否其他支付
    var isOtherPay:Bool = false
    
    /// 支付数据模型
    weak var currentModel: MQIApplePayItemModel? {
        didSet {
            inPurchaseManager.currentItemModel = currentModel
        }
    }
    var webUrl:String = ""
    var curCoin: String = "" {
        didSet(oldValue) {
            toPay()
        }
    }
    
    var rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
        title = kLocalized("Recharge")
        addCollectionView()
        //        if isDebug {
        //            addTestView()
        //        }
        //        if MQIPayTypeManager.shared.type != .inPurchase {
        //            let button = addRightBtn(kLocalized("othePay"), imgStr: nil)
        //            button.frame.origin.x -= 20
        //            button.frame.size.width += 20
        //            button.setTitleColor(kUIStyle.colorWithHexString("F8F8F8"), for: .normal)
        //        }
        addPreloadView()
        getApplePayList()
        inPurchaseManager.clean()
        payCallbackFunc()
   
        rightBtn = addRightBtn( kLocalized("恢复购买"), imgStr: nil)
        rightBtn.x -= 60
        rightBtn.width += 60
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.setTitleColor(UIColor.colorWithHexString("#7187FF"), for: .normal)
        
        
    }
    
    func addTips1() {
        if !MQIUserDefaultsKeyManager.shared.pay_Back_isAvailable() { return}
        self.view.viewWithTag(1010)?.removeFromSuperview()
             let image = UIImage(named: "reader_pay_img")!
        let tips1 = UIView()
        tips1.layer.contents = image.cgImage
        tips1.tag = 1010
        self.view.addSubview(tips1)
        tips1.dsyAddTap(self, action: #selector(clickTipsView(tap:)))
        
        let  tips1Label = UILabel ()
        tips1Label.font = UIFont.systemFont(ofSize: 12)
        tips1Label.textColor = UIColor.colorWithHexString("ffffff")
        tips1Label.text  = kLocalized("Deducted_but_not_received_Poke_here_to_accelerate_to_account",describeStr: "未到账")
        tips1Label.adjustsFontSizeToFitWidth = true
        tips1.addSubview(tips1Label)
        tips1Label.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-13)
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-31)
        }
        tips1.snp.makeConstraints { (make) in
            make.width.equalTo(image.size.width)
            make.height.equalTo( image.size.height)
            make.top.equalTo(rightBtn.snp.bottom).offset(-10)
            make.right.equalTo(rightBtn)
        }
        
    }
    
    @objc func clickTipsView(tap:UIGestureRecognizer)  {
       MQIUserDefaultsKeyManager.shared.pay_Back_Save()
        tap.view?.removeFromSuperview()
    }
   
    
    deinit {
        inPurchaseManager.clean()
    }
    
    override func rightBtnAction(_ button: UIButton) {
        button.isEnabled = false
        button.setTitleColor(UIColor.gray, for: .normal)
        inPurchaseManager.startReissue()
        if !inPurchaseManager.isTransactioning(){
            MQILoadManager.shared.makeToast("没有可恢复的订单")
            return
        }
        MQILoadManager.shared.makeToast("订单正在恢复，过段时间看看是不是到账了")
        inPurchaseManager.startCompletedTransactions()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    func payCallbackFunc() {
        inPurchaseManager.callbackDataBlock = {[weak self] in /// 首充完成 属性页面
            self?.refreshView()
        }
        inPurchaseManager.callbackPromptBlock = { (model:MQIComplexResultModel) in
            self.getApplePayList()
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
            } else if model.data.event.eventList.count > 0 {
                rmodel.type = .coupons
                rmodel.lineTitle = model.data.event.name
                rmodel.itemCouponse.append(contentsOf: model.data.event.eventList)
                
            } else {
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
        
        inPurchaseManager.callbackBlock = {[weak self] (suc: Bool,  msg: String) in
            self?.getApplePayList()
            MQIUserDiscountCardInfo.reload(isMandatory: true)
            if !suc {
                if  msg.contains("DSYCALLBACK_1") {
                    MQILoadManager.shared.dismissProgressHUD()
                    let msgNEW = msg.replacingOccurrences(of: "DSYCALLBACK_1", with: "")
                    MQILoadManager.shared.makeToast(msgNEW)
                }else{
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.addProgressHUD(msg)
                }
                
            }else {
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg)
                if let model = self?.currentModel ,let user =  MQIUserManager.shared.user {
                    user.user_coin = "\(model.price.integerValue()+user.user_coin.integerValue())"
                    user.user_premium = "\(model.premium.integerValue()+user.user_premium.integerValue())"
                    MQIUserManager.shared.saveUser()
                    ///刷新余额
                }
                if MQIUserOperateManager.shared.userPayChannel == .readerToPay {
                    MQILoadManager.shared.addProgressHUD(kLocalized("BalanceRefresh"))
                    MQIUserOperateManager.shared.paySuccess_UpdateCoin({ [weak self] (suc) in
                        MQILoadManager.shared.dismissProgressHUD()
                        //                    self?.navigationController?.popViewController(animated: true)
                        //                    self?.popBlock?()
                        self?.popVC()
                        self?.compBlock?(suc)
                    })
                }else {
                    //                self?.navigationController?.popViewController(animated: true)
                    //                self?.popBlock?()
                    MQILoadManager.shared.dismissProgressHUD()
                    self?.compBlock?(suc)
                }
            }
            
        }
    }
    
//    override func rightBtnAction(_ button: UIButton) {
//
//        let vc = MQIPayWebVCNew()
//        vc.title = kLocalized("NowPay")
//        vc.url = webUrl
//        //MARK: 只适用微信支付为二级支付
//        //         vc.compBlock = compBlock
//        vc.popBlock = { [unowned self,weak vc]in
//            if vc?.view.window != nil {
//                vc?.navigationController?.popViewController(animated: true)
//                vc?.compBlock = { (sun) in
//                    self.compBlock?(sun)
//                }
//
//                self.popVC()
//            }
//        }
//        pushVC(vc)
//
//    }
 
    func refreshView() {
        if inPurchaseManager.getFirstList() && datas.count > 0  {
            let model = datas.filter({$0.first == "1"}).first
            if model != nil {
                datas.remove(at: datas.index(of: model!)!)
                collectionView.reloadData()
            }
            
        }
    }
    
    //MARK: Request
    func toPay() {
        if payModel.is_review == "1" {
            if MQIUserManager.shared.checkIsLogin() == false {
                MQILoadManager.shared.addProgressHUD("")
                self.requestAutoRegister({ (suc) in
                    MQILoadManager.shared.dismissProgressHUD()
                    if suc == true {
                        self.payAction()
                    }else {
                        MQILoadManager.shared.makeToast(kLocalized("NetworkConnectionFailed"))
                    }
                })
            }else {
                self.payAction()
            }
        }else {
            if MQIUserManager.shared.checkIsLogin() {
                self.payAction()
            }else{
                MQIloginManager.shared.toLogin(nil) { [weak self] in
                    self?.payAction()
                }
            }
        }
        
    }
    
    func payAction() {
        if  currentModel == nil {
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(kLocalized("UnableToObtainProductInformation"))
            return
        }
        MQIEventManager.shared.appendEventData(eventType: .pay_start, additional: ["method":"appstore","product_id":currentModel!.id])
        MQILoadManager.shared.addProgressHUD("")
    
        inPurchaseManager.requestProductId(productId:currentModel!.id)
        
    }
    
    
    var autoCount: Int = 0
    func getApplePayList(){
        GDGetApplePayList()
            .request({ [weak self](request, response, result: MQIApplePayListModel) in
                
                if let weakSelf = self {
                    if result.is_review == "1" {
                        weakSelf.banner?.image = UIImage(named: "discountCardInfoViewImage")
                        weakSelf.isShowDicountCardPay = true
                    } else {
                        if !result.banner.image.isEmpty {
                           
                            if MQIUserDiscountCardInfo.default?.cardState == "0"{
                                 weakSelf.isShowDicountCardPay = false
                            }else{
                                 weakSelf.banner?.sd_setImage(with: URL(string: result.banner.image), placeholderImage: nil, options: [], completed: nil)
                                weakSelf.isShowDicountCardPay = true
                            }
                           
                        } else {
                            weakSelf.banner = nil
                            weakSelf.isShowDicountCardPay = false
                        }
                    }
                    weakSelf.collectionView.reloadData()
                    weakSelf.payModel = result
                    weakSelf.inPurchaseManager.checkRestoreOrder2 {
                        weakSelf.dismissWrongView()
                        weakSelf.dismissPreloadView()
                    }
                    
                }
            }) { [weak self] (err_msg, err_code) in
                self?.dismissPreloadView()
                self?.addWrongView(err_msg, refresh: {
                    self?.getApplePayList()
                })
        }
    }
    func requestAutoRegister(_ completion: ((_ suc: Bool) -> ())?) {
        GYAutoRegisterRequest()
            .request({ (request, response, result: MQIBaseModel) in
                paseUserObject(result)
                MQIUserManager.shared.saveUser()
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: 1001)
                UserNotifier.postNotification(.login_in)
                completion?(true)
            }) {[weak self] (err_msg, err_code) in
                if let strongSelf = self {
                    strongSelf.autoCount += 1
                    if strongSelf.autoCount <= 3 {
                        strongSelf.requestAutoRegister(completion)
                    }else {
                        completion?(false)
                        mqLog("errcode = \(err_code), err_msg = \(err_msg)")
                    }
                }
        }
    }
    
    func addCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        //        layout.minimumLineSpacing = 10
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        collectionView  = MQICollectionView(frame:contentView.bounds,collectionViewLayout: layout)
        collectionView.gyDelegate = self
        collectionView.alwaysBounceVertical = true
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        contentView.addSubview(collectionView)
        
        collectionView.registerCell(MQIApplePayCollectionViewCell.self, xib: false)
        collectionView.registerCell(MQIApplePayBtnCollectionViewCell.self, xib: false)
        
        collectionView.register(MQIApplePayFootCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MQIApplePayFootCollectionReusableView.getIdentifier())
        collectionView.register(MQIApplePayHeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MQIApplePayHeadCollectionReusableView.getIdentifier())
        
        
        contentView.backgroundColor = kUIStyle.colorWithHexString("F6F6F6")
        
    }
    
    @objc func vrestoreBtnClick(btn:UIButton) -> Void {
        pushVC(MQIVrestoreApplePayViewController.create()!)
        
    }
}

extension MQIApplePayViewController:MQICollectionViewDelegate{
    
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(_ collectionView:MQICollectionView, section: Int) -> Int {
        return  datas.count
    }
    
    func sizeForItem(_ collectionView:MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return MQIApplePayBtnCollectionViewCell.getSize()
        }
        return MQIApplePayCollectionViewCell.getPaySize()
    }
    //    //横向距离   每个cell的
    func minimumInteritemSpacingForSection(_ collectionView:MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 10
    }
    
    //section四周边距
    func insetForSection(_ collectionView:MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 20, bottom: 0,right: 20)
        
    }
    
    //设置footer header View
    func viewForSupplementaryElement(_ collectionView:MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MQIApplePayFootCollectionReusableView.getIdentifier(), for: indexPath) as! MQIApplePayFootCollectionReusableView
            footer.titleText = kLocalized("TopupInstructions")
            
            if payModel.is_review != "1"{
                
                let text = kLongLocalized("payPreferential", replace: COINNAME_PREIUM,COINNAME_PREIUM,COINNAME,COINNAME_PREIUM,COINNAME,COINNAME_PREIUM)
                let att1 = NSMutableAttributedString(string: text)
                let sye = NSMutableParagraphStyle()
                sye.lineSpacing = 5
                att1.addAttributes([NSAttributedString.Key.paragraphStyle:sye], range: NSRange.init(location: 0, length: text.count))
                att1.append(NSMutableAttributedString.init(string: kLocalized("payPreferential2"), attributes: [NSAttributedString.Key.paragraphStyle:sye,.underlineStyle:1,.foregroundColor:mainColor]))
            
                footer.countText = att1
                
                footer.clickBlock = {
                    
                    if MQIUserManager.shared.checkIsLogin() {
                       MQIOpenlikeManger.toQIYU()
                    }else{
                        MQIloginManager.shared.toLogin(nil) {
                              MQIOpenlikeManger.toQIYU() 
                        }
                    }
                }
            }else{
                let text = "1、充值越多，送的越多 \n2、充值书币为虚拟物品，不支持退款 \n3、充值阅读权限仅限本站使用 \n4、1书券=1书币，消费时优先扣除书券 \n"
                let att1 = NSMutableAttributedString(string: text)
                let sye = NSMutableParagraphStyle()
                sye.lineSpacing = 5
                att1.addAttributes([NSAttributedString.Key.paragraphStyle:sye], range: NSRange.init(location: 0, length: text.count))

                footer.countText = att1
            }
            return footer
        }else {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MQIApplePayHeadCollectionReusableView.getIdentifier(), for: indexPath) as! MQIApplePayHeadCollectionReusableView
            head.isUserInteractionEnabled = true
            banner = head.bannerImageView
            head.clickBanner = { [weak self] in
                guard MQIPayTypeManager.shared.isAvailable() else {
                    self?.pay_discount_card()
                    return
                }
                self?.pushVC(MQIDiscountCardViewController2())
                
            }
            return head
            
        }
    }
    
    func sizeForHeader(_ collectionView:MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        return  isShowDicountCardPay ? CGSize(width: collectionView.width, height: 66 + ((screenWidth - 40) * 109 / 335)) :
                                        CGSize(width: collectionView.width, height: 66)
    }
    func sizeForFooter(_ collectionView:MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        return  CGSize(width: collectionView.width, height: 300)
    }
    
    
    func cellForRow(_ collectionView:MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MQIApplePayCollectionViewCell.self, forIndexPath: indexPath)
        let model = datas[indexPath.item]
        cell.model =  model
        
        return cell
    }
    
    func didSelectRowAtIndexPath(_ collectionView:MQICollectionView, indexPath: IndexPath) {
            if let model = datas.filter({$0.isSelected == true}).first {
                mqLog(" \(model.id)")
                currentModel = model
                toPay()
            }
        currentModel = datas[indexPath.item]
        toPay()
    }
    
    
    func pay_discount_card() {
        if payModel.is_review == "1" {
            currentModel = bannerModel
            currentModel?.id = bannerModel.product_id
            toPay()
        }else{
            if bannerModel.url.hasPrefix("http"){
                let vc = MQIWebVC()
                vc.url = bannerModel.url
                pushVC(vc)
            }else if bannerModel.url == "fuel" {
                let vc = MQIDiscountCardViewController()
                self.pushVC(vc)
            }
        }
    }
    
    
    
}

//MARK:   添加测视图
extension  MQIApplePayViewController  {
    ///   添加测视图
    func addTestView() {
        let view  =  UIView ()
        view.backgroundColor = UIColor.red
        self.view.addSubview(view)
        view.frame = CGRect(x: 0, y: kUIStyle.kScrHeight-135, width: kUIStyle.kScrWidth, height: 135)
        let w =  kUIStyle.kScrWidth*0.5-5
        let btn = UIButton()
        btn.backgroundColor = kUIStyle.randomColor()
        btn.frame = CGRect(x: 0, y: 5, width: w, height: 60)
        btn.setTitle("正常恢复提示", for: .normal)
        btn.setTitle("模拟没有恢复提示", for: .selected)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.yellow, for: .selected)
        btn.tag = 101
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        let btn2 = UIButton()
        btn2.backgroundColor = kUIStyle.randomColor()
        btn2.frame = CGRect(x: w+10, y: 5, width: w, height: 60)
        btn2.setTitle("正常支付数据", for: .normal)
        btn2.setTitle("模拟恢复支付数据", for: .selected)
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.setTitleColor(UIColor.yellow, for: .selected)
        btn2.tag = 102
        btn2.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        let btn3 = UIButton()
        btn3.backgroundColor = kUIStyle.randomColor()
        btn3.frame = CGRect(x: 0, y: btn.maxY+5, width: kUIStyle.kScrWidth, height: 60)
        btn3.setTitle("正常验证支付", for: .normal)
        btn3.setTitle("模拟服务器验证支付失败", for: .selected)
        btn3.setTitleColor(UIColor.white, for: .normal)
        btn3.setTitleColor(UIColor.yellow, for: .selected)
        btn3.tag = 103
        btn3.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(btn)
        view.addSubview(btn2)
        view.addSubview(btn3)
    }
    
    
    @objc func btnClick(btn:UIButton) -> Void {
        btn.isSelected = !btn.isSelected
        switch btn.tag {
            
        case 101:
            inPurchaseManager.isDebugFirstStart = btn.isSelected
            return
        case 102:
            inPurchaseManager.isDebugRestore = btn.isSelected
            return
        case 103:
            inPurchaseManager.isDebugPayFailure = btn.isSelected
            return
        default:
            return
        }
        
    }
}







