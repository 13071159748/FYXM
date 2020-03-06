//
//  MQIUserOperateManager.swift
//  SShopping
//
//  Created by CQSC  on 16/3/23.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit

enum PayChannelType {
    case normalToPay//普通的
    case readerToPay//从阅读器跳到支付界面
}
class MQIUserOperateManager: NSObject, WXApiDelegate {
    
    fileprivate static var __once: () = {
        Inner.instance = MQIUserOperateManager()
    }()
    
    //    var rootVC: GYNavigationViewController!
    
    
    var rootVC:MQINavigationViewController! {
        return gd_currentNavigationController()
    }
    /// 是否其他支付
    var isOtherPay:Bool = false
    
    var nId: String = ""
    var m: AnyObject?
    var userPayChannel:PayChannelType = .normalToPay
    var completionBlock: ((_ suc: Bool) -> ())?
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIUserOperateManager?
    }
    
    class var shared: MQIUserOperateManager {
        _ = MQIUserOperateManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        //        rootVC = (UIApplication.shared.delegate as! AppDelegate).navigationController
        //        rootVC = gd_currentTabbarController()
    }
    
    
    func toReader(_ bid: String, book: MQIEachBook? = nil, toIndex: Int? = nil,chapter_id:String? = nil) {
        let readVC = MQIReadViewController()
        let listVC = MQIChapterListViewController()
        readVC.listVC = listVC
        listVC.readVC = readVC
        /// 恢复默认值
        GYBookManager.shared.whole_subscribe = nil
        GYBookManager.shared.free_limit_time = -1
        GYBookManager.shared.buyTids.removeAll()
        if  GYBookManager.shared.dingyueBooks_book.filter({$0.book_id == bid}).first != nil {
            GYBookManager.shared.whole_subscribe = "1"
        }
        readVC.to_index = toIndex
        readVC.to_chapter_id = chapter_id
        readVC.bid = bid
        let pvc = MQIReaderICSDrawerViewController(leftViewController: listVC , center: readVC)!
        pvc.allowPan = false
        pvc.navigationController?.isNavigationBarHidden = true
        pvc.fd_interactivePopDisabled = true
        pvc.hidesBottomBarWhenPushed = true
        self.rootVC.pushVC(pvc)
    }
    
    func toEvent(){
        let eventVC = MQIEventCenterViewController()
        eventVC.hidesBottomBarWhenPushed = true
        self.rootVC.pushVC(eventVC)
    }
    
    func toRecommend(_ bid: String) {
        let readVC = MQIReadViewController()

        readVC.hidesBottomBarWhenPushed = true
        self.rootVC.pushVC(readVC)
    }
    
    func paySuccess_UpdateCoin(_ completion:((_ suc:Bool)->())?) {
        GYUserCoinRequest().request({ (request, response, result: GYEachCoin) in
            MQIUserManager.shared.user!.user_coin = result.coin
            MQIUserManager.shared.user!.user_premium = result.premium
            MQIUserManager.shared.saveUser()
            completion?(true)
        }) {(err_msg, err_code) in
            completion?(false)
        }
        
    }
    func toPayVC(toPayChannel:PayChannelType = .normalToPay,_ popBlock: ((_ suc:Bool) -> ())?) {
           MQIUserOperateManager.shared.userPayChannel = toPayChannel
        
        if isOtherPay {
            let vc = MQIPayWebVCNew()
            vc.title = kLocalized("NowPay")
            vc.url = payHttpURL()
            vc.compBlock = popBlock
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {[weak self]() in
                    if let weakSelf = self {
                        weakSelf.rootVC.pushVC(vc)
                    }
                })
            }else {
                rootVC.pushVC(vc)
            }
        }else{
            let vc = MQIApplePayViewController()
            vc.compBlock = popBlock
            MQIIAPManager.shared.clean()
            vc.hidesBottomBarWhenPushed = true
            vc.webUrl = payHttpURL()
            rootVC.pushVC(vc)
            
        }
        
//        if !MQIPayTypeManager.shared.isAvailable() {
//            if isOtherPay {
//                let vc = MQIPayWebVCNew()
//                vc.title = kLocalized("NowPay")
//                vc.url = payHttpURL()
//                vc.compBlock = popBlock
//               rootVC.pushVC(vc)
//            }else{
//                let vc = MQIApplePayViewController()
//                //            vc.popBlock = popBlock
//                vc.compBlock = popBlock
//                vc.hidesBottomBarWhenPushed = true
//                rootVC.pushVC(vc)
//            }
//
//        }else {
//            if isOtherPay {
//                let vc = MQIPayWebVCNew()
//                vc.title = kLocalized("NowPay")
//                vc.url = payHttpURL()
//                vc.compBlock = popBlock
//                if MQIUserManager.shared.checkIsLogin() == false {
//                    MQIloginManager.shared.toLogin(nil, finish: {[weak self]() in
//                        if let weakSelf = self {
//                            weakSelf.rootVC.pushVC(vc)
//                        }
//                    })
//                }else {
//                    rootVC.pushVC(vc)
//                }
//            }else{
//                let vc = MQIApplePayViewController()
//                vc.compBlock = popBlock
//                vc.hidesBottomBarWhenPushed = true
//                vc.webUrl = payHttpURL()
//                if MQIUserManager.shared.checkIsLogin() == false {
//                    MQIloginManager.shared.toLogin(nil, finish: {[weak self]() in
//                        if let weakSelf = self {
//                            weakSelf.rootVC.pushVC(vc)
//                        }
//                    })
//                }else {
//                    rootVC.pushVC(vc)
//                }
//            }
//
//        }
        
        
//        if MQIPayTypeManager.shared.type == .inPurchase {
//            let vc = MQIApplePayVCNew()
//            vc.popBlock = popBlock
//            vc.hidesBottomBarWhenPushed = true
//            rootVC.pushVC(vc)
//
//
//        }else {
//            MQIUserOperateManager.shared.userPayChannel = toPayChannel
//            let vc = MQIPayRootVC()
//            vc.title = kLocalized("NowPay")
//            vc.url = payHttpURL()
//            vc.popBlock = popBlock
//            vc.hidesBottomBarWhenPushed = true
//            if MQIUserManager.shared.checkIsLogin() == false {
//                MQIloginManager.shared.toLogin(nil, finish: {[weak self]() in
//                    if let weakSelf = self {
//                        weakSelf.rootVC.pushVC(vc)
//                    }
//                })
//            }else {
//                rootVC.pushVC(vc)
//            }
//        }
    }
    
    func toLoginVC(_ popBlock: (() -> ())?) {
        let vc = MQILoginViewController.create() as! MQILoginViewController
        vc.hidesBottomBarWhenPushed = true
        vc.finishBlock = {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rootVC.popViewController(animated: true, completion: {
                    popBlock?()
                })
            }
        }
    
        rootVC.pushVC(vc)
    }
    
    //MARK: 添加书架
    func addShelf(_ book: MQIEachBook, completion: (() -> ())?) {
        //书架是本地的，等不登录都能添加
        if MQIShelfManager.shared.checkIsExist(book.book_id) == true {
            MQILoadManager.shared.makeToast(kLocalized("AlreadyAddBook"))
            return
        }
        MQIEventManager.shared.appendEventData(eventType: .favorite_book, additional: ["book_id":book.book_id])
        let addShelfRequest = {() -> Void in
            
//            MQILoadManager.shared.addProgressHUD(kLocalized("ShelfAdding"))
               MQILoadManager.shared.makeToast(kLocalized("ShelfAdding"))
            GYBookShelfAddRequest(book_id: book.book_id)
                .request({ (request, response, result: MQIBaseModel) in
                    MQIShelfManager.shared.addToBooks(book)
                    ShelfNotifier.postNotification(.refresh_shelf, object: nil, userInfo: ["book" : book])
                    
//                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(kLocalized("ShelfAddSuccess"))
                    completion?()
                }) { (err_msg, err_code) in
//                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(err_msg)
            }
        }
        
        if MQIUserManager.shared.checkIsLogin() == false {
            
            MQIShelfManager.shared.addToBooks(book)
            ShelfNotifier.postNotification(.refresh_shelf, object: nil, userInfo: ["book" : book])
            MQILoadManager.shared.makeToast(kLocalized("ShelfAddSuccess"))
            completion?()
        }else {
            addShelfRequest()
        }
        
    }
    
    //MARK: --
    var sCompletion: (() -> ())?
    func wxLogin(_ complettion: (() -> ())?) {
        if WXApi.isWXAppInstalled() == false {
            MQILoadManager.shared.makeToast(kLocalized("WeChatIsNoInstalledOnYourPhone"))
            return
        }
        sCompletion = complettion
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = KWXSTATE
        WXApi.send(req)
    }
    
    func qqLogin(_ complettion: (() -> ())?) {
        //改为 web qq  登录了
    }
    
    //MARK: 充值
    func userPay(_ type: String, order_fee: String, channel_id: String, user_coupon_id:String, completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        MQILoadManager.shared.addProgressHUD(kLocalized("GetTheOrder"))
        GYOrderRequest(type: type, order_fee: order_fee, channel_id: channel_id,user_coupon_id:user_coupon_id)
            .request({[weak self] (request, response, result: GYEachOrder) in
                
                if let strongSelf = self {
                    
                    if channel_id == "17" || channel_id == "19" {
                        strongSelf.wxPay(result.order_id, c: { (suc, msg) in
                            strongSelf.paySuc(suc, msg: msg)
                            completion?(suc, msg)
//                            MQIEventManager.shared.appendEventData(eventType: .pay_start, additional: ["uid" : MQIUserManager.shared.user?.user_id ?? "-1","method":"wechat","product_id":result.order_id])
                        })
                    }else if channel_id == "20" || channel_id == "21" || channel_id == "16" {
                        strongSelf.zfbao(result.order_id, c: { (suc, msg) in
                            strongSelf.paySuc(suc, msg: msg)
                            completion?(suc, msg)
//                            MQIEventManager.shared.appendEventData(eventType: .pay_start, additional: ["uid" : MQIUserManager.shared.user?.user_id ?? "-1","method":"alipay","product_id":result.order_id])
                        })
                    }else if channel_id == "13"  {
                        strongSelf.wxHttpPay(result.order_id, c: { (suc, msg) in
                            MQILoadManager.shared.dismissProgressHUD()
                            
                            MQILoadManager.shared.makeToast(suc == true ? kLocalized("successful") : msg)
//                               MQIEventManager.shared.appendEventData(eventType: .pay_start, additional: ["uid" : MQIUserManager.shared.user?.user_id ?? "-1","method":"wechat","product_id":result.order_id])
                        })
                    }else {
                        MQILoadManager.shared.dismissProgressHUD()
                    }
                }
                
            }) { (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
        }
    }
    
    func wxPay(_ order_id: String, c: ((_ suc: Bool, _ msg: String) -> ())?) {
        
        c?(false, "失败") /// "11002"
        
//        if !WXApi.isWXAppInstalled(){
//            MQILoadManager.shared.dismissProgressHUD()
//            MQILoadManager.shared.makeToast(kLocalized("WeChatIsNoInstalledOnYourPhone"))
//            return
//        }
//        GYWXPayOrderRequest(order_id: order_id).request({ (request, response, result: GYWXOrderModel) in
//            let req = PayReq()
//            req.openID = result.appid
//            req.partnerId = result.partnerid
//            req.prepayId = result.prepayid
//            req.nonceStr = result.noncestr
//            req.timeStamp = UInt32(Int(result.timestamp)!)
//            req.package = result.package
//            req.sign = result.sign
//            
//            MQIAliPayCallBackManger.shared.wxCallBack = {(resp) -> Void in
//                if resp?.errCode == WXSuccess.rawValue {
//                    c?(true, kLocalized("TopUpSuccess"))
//                }else {
//                    c?(false, resp?.errStr == nil ? kLocalized("TopUpFailure") : resp!.errStr)
//                }
//            }
//            MQILoadManager.shared.dismissProgressHUD()
//            MQILoadManager.shared.makeToast(kLocalized("OrderSuccessful"))
//            WXApi.send(req)
//            
//        }, failureHandler: { (err_msg, err_code) in
//            c?(false, err_msg) /// "11002"
//        })
    }
    
    fileprivate func wxHttpPay(_ order_id: String, c: ((_ suc: Bool, _ msg: String) -> ())?) {
        GYWXOrderWebRequest(order_id: order_id)
            .request({ [weak self](request, response, result: GYAlipayOrderModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("OrderSuccessful"))
                
                
                let vc = MQIPayWebVC()
                vc.payType = .wx
                vc.title = kLocalized("WeChatPay")
                let url = result.url
                vc.url = url.urlDecoded()
                if let weakSelf = self {
                    //                    (weakSelf.rootVC.selectedViewController as! GYNavigationViewController).pushVC(vc)
                    weakSelf.rootVC.pushVC(vc)
                }
                
                //UIApplication.shared.openURL(URL(string: vc.url)!)
                
            }) { (err_msg, err_code) in
                c?(false, err_msg)
        }
    }
    
    func zfbao(_ order_id: String, c: ((_ suc: Bool, _ msg: String) -> ())?) {
        
        GYAlipayOrderWebRequest(order_id: order_id)
            .request({ [weak self](request, response, result: GYAlipayOrderModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("OrderSuccessful"))
                //                MQLog(result.url)
                
                let vc = MQIPayWebVC()
                vc.payType = .zfbao
                vc.title = kLocalized("AlilPay")
                vc.url = result.url
                vc.payWebcompletion = {() -> Void in
                    //                    MQLog("🍎从支付宝网页会到支付")
                    c?(true,"")//从上一页回来，刷新券 reload webview
                }
                if let weakSelf = self {
                    //                    (weakSelf.rootVC.selectedViewController as! GYNavigationViewController).pushVC(vc)
                    weakSelf.rootVC.pushVC(vc)
                }
                
                
            }) { (err_msg, err_code) in
                c?(false, err_msg)
        }
    }
    
    func paySuc(_ suc: Bool, msg: String) {
        if suc == true {
            UserNotifier.postNotification(.refresh_coin)
        }else {
            MQILoadManager.shared.dismissProgressHUD()
        }
        guard msg != "" else {
            return
        }
        MQILoadManager.shared.makeToast(msg)
    }
    
    
    /// 详情页
    func toBookInfo(_ book_id:String? = nil)  {
        if book_id != nil {
            let bookInfoVC = GDBookInfoVC()
            bookInfoVC.bookId = book_id!
            bookInfoVC.hidesBottomBarWhenPushed = true
            rootVC.pushVC(bookInfoVC)
            return
        }
        
    }
    
    /// 签到
    func toSignVC()  {
//        let sign = MQISignVC()
        let sign = MQIWelfareCentreViewController()
        sign.hidesBottomBarWhenPushed = true
        rootVC.pushVC(sign)
    }
    
    /// WebVC
    func toWebVC(_ url:String,_ isAc:Bool = false)  {
        let vc = MQIWebVC()
        vc.url = url
        vc.isAc = isAc
        vc.hidesBottomBarWhenPushed = true
        rootVC.pushVC(vc)
    }
    
    /// 打折卡
    func toDCVC() {
        let dc = MQIDiscountCardViewController2()
        dc.hidesBottomBarWhenPushed = true
        rootVC.pushVC(dc)
        
    }
    
    /// 推荐二级页面
    func toRecommendSecondVC(type: Int) {
        let vc = MQIRecommendTopicsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.id = type
        rootVC.pushVC(vc)
    }
    
    /// 我的卡券
    func toCardCounponVC() {
        let vc = MQICardCouponViewController()
        vc.hidesBottomBarWhenPushed = true
        rootVC.pushVC(vc)
    }
    
}
