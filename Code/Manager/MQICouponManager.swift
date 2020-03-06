//
//  MQICouponManager.swift
//  Reader
//
//  Created by CQSC  on 2017/8/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


let KCOUPONTIME = "KCOUPONTIME"
let couponEventPath = "couponEvent.db"
//是从哪里请求的弹窗
enum CouponType {
    case reader
    case payWebVC
}
class MQICouponManager: NSObject {
    
    fileprivate var window: UIWindow!
    fileprivate var rootVC: UIViewController!
    
    var coupons: [MQIEachCoupon]? //所有的 礼券
    var coupon_ids:[String]?//领过的活动event_id
    var coupon_readerLoading:Bool = false //网络不好的时候阅读器正在请求一个礼包，如果切换下一章就会重复请求服务器
    var updateReaderCoupon_isok:Bool = false//这个账号请求过了
    var readerCoupons = [MQIEachCoupon]()
    var payCoupons = [MQIEachCoupon]()
    var isLocatedReader:Bool = false//是否在阅读器中，操作后会有没释放的，会引起弹窗位置错误
    fileprivate static var coupon_ShowOnlyOne:Bool = true //启动一次应用只弹一次
    
    var couponsPath: String! {
        if MQIUserManager.shared.checkIsLogin() == false {
            return MQIFileManager.getCurrentStoreagePath(couponEventPath)
        }else {
            return usercouponsPath
        }
    }
    //阅读器中弹框记录，弹过的就不弹了（在阅读器中）
    fileprivate var usercouponsPath:String! {
        return MQIFileManager.getCurrentStoreagePath("couponEvent\((MQIUserManager.shared.user!.user_id)).db")
    }
    
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQICouponManager?
    }
    
    fileprivate static var __once: () = {
        Inner.instance = MQICouponManager()
    }()
    
    class var shared: MQICouponManager {
        _ = MQICouponManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        
    }
    
   
    //在阅读器的时候有需要订阅的，每个用户只提示一次大礼包
    func inReaderToPostCouponsView(_ readVC:MQIReadViewController) {
        if MQICouponManager.coupon_ShowOnlyOne == false {
            return
        }
        guard isLocatedReader else {
            return
        }
        MQICouponManager.coupon_ShowOnlyOne = false
        coupon_readerLoading = true
        if MQIFileManager.checkFileIsExist(couponsPath) == true {//领取过的id
            coupon_ids = NSKeyedUnarchiver.unarchiveObject(withFile: couponsPath) as? [String]
        }
        if coupon_ids == nil {
            coupon_ids = [String]()
        }
        //是否请求过优惠券
        guard updateReaderCoupon_isok else {//没请求过
            readerCouponsRequest(readVC)
            return
        }
        //请求过，去弹窗
        payCoupons = readerCoupons
        if payCoupons.count > 0 {
            gd_showReaderCouponView(payCoupons[0],readVC: readVC)
        }
        
    }
    //弹阅读器中的优惠券
    func gd_showReaderCouponView(_ eachcoupon:MQIEachCoupon,readVC:MQIReadViewController) {
        
    }
    
    func readerCouponsRequest(_ readVC:MQIReadViewController) {//进入阅读器就请求礼券
//        GYGetVaildCouponsRequest().requestCollection({ [weak self](request, response, result:[MQIEachCoupon]) in
//            if let weakself = self {
//                weakself.updateReaderCoupon_isok = true
//                weakself.readerCoupons = result
//                weakself.payCoupons = result
//                if result.count > 0 {
//                    weakself.gd_showReaderCouponView(result[0],readVC: readVC)
//                }
//            }
//        }) {[weak self] (msg, code) in
//            if let weakSelf = self{
//                weakSelf.coupon_readerLoading = false
//                weakSelf.updateReaderCoupon_isok = false
//            }
//        }
    }
    
    
    /// 去充值页面，弹窗
    ///
    /// - Parameter completion: 是否领取
    func payRootConfig(completion:(()->())?) {
        //        window = getWindow()
        //        rootVC = (UIApplication.shared.delegate as! AppDelegate).getCurrentVisibleVC()!
        
//        GYGetVaildCouponsRequest().requestCollection({[weak self] (request, response, result:[MQIEachCoupon]) in
//            if let weakSelf = self {
//                weakSelf.payCoupons = result
//            }
//        }) { (msg, code) in
//        }
    }
    /*
     /**
     网络请求获取可用的 coupons
     */
     func getCoupon() {
     GYGetVaildCouponsRequest()
     .requestCollection({[weak self] (request, response, result: [MQIEachCoupon]) in
     MQLog(result.count)
     if let strongSelf = self {
     strongSelf.coupons = result
     strongSelf.saveCoupons()
     strongSelf.recordTime()
     strongSelf.createCouponView()
     }
     }) { (msg, code) in
     MQLog("获取优惠券失败----\(msg)")
     }
     }
     
     /**
     检查 并 找出 未曾显示过 的 coupon
     
     - parameter coupons: 数组
     */
     func createCouponView() {
     guard let coupons = coupons else {
     return
     }
     
     for i in 0..<coupons.count {
     guard coupons[i].alreadyShow == true else {
     addCouponView(i)
     break
     }
     }
     }
     
     /**
     将 index couponView 添加到 rooVC.view 上
     
     - parameter index: coupon 所在 coupons 的位置
     */
     func addCouponView(_ index: Int) {
     
     let conpouView = GYCouponView.init(window.bounds, coupons![index])
     
     conpouView.completion = {[weak self]()->Void in
     if let strongSelf = self {
     conpouView.removeFromSuperview()
     strongSelf.saveAlreadyGetCoupon(index)
     }
     }
     
     conpouView.toCouponVC = {[weak self] in
     if let strongSelf = self {
     if let strongSelf = self {
     strongSelf.saveAlreadyGetCoupon(index)
     }
     strongSelf.pushVC(GYCouponVC())
     }
     }
     
     conpouView.getCouponBlock = {[weak self] (coupon) in
     
     let takeCouponRequest = {
     MQILoadManager.shared.addProgressHUD("请稍等")
     GYTakeVaildCouponsRequest(event_id: coupon.event_id)
     .request({ (request, response, result: MQIBaseModel) in
     MQILoadManager.shared.dismissProgressHUD()
     MQILoadManager.shared.makeToast("成功领取")
     conpouView.showCoupons()
     
     }) { (msg, code) in
     MQILoadManager.shared.dismissProgressHUD()
     
     guard code != "13202" else {
     MQILoadManager.shared.makeToast("您已领取过此优惠券")
     conpouView.showCoupons()
     return
     }
     if code == "200" {
     MQILoadManager.shared.makeToast("成功领取")
     conpouView.showCoupons()
     return
     }
     MQILoadManager.shared.makeToast(msg.length <= 0 ? "领取失败" : msg)
     
     
     }
     }
     
     if let _ = self {
     if MQIUserManager.shared.checkIsLogin() == false {
     MQIloginManager.shared.toLogin(nil) {
     takeCouponRequest()
     }
     
     }else {
     takeCouponRequest()
     }
     }
     }
     
     
     rootVC.view.addSubview(conpouView)
     
     conpouView.show()
     
     }
     
     fileprivate func saveAlreadyGetCoupon(_ index: Int) {
     guard let coupons = coupons else {
     return
     }
     
     guard coupons[index].alreadyShow == false else {
     return
     }
     
     self.coupons![index].alreadyShow = true
     saveCoupons()
     }
     
     fileprivate func todayDate() -> Date {
     let interval = TimeZone(secondsFromGMT: +28800)?.secondsFromGMT(for: Date())
     let today = Date().addingTimeInterval(TimeInterval(interval!))
     return today
     }
     
     /**
     是否允许 弹窗 优惠券
     
     - returns: YES/NO
     */
     fileprivate func checkCoupon() {
     if let time = UserDefaults.standard.object(forKey: KCOUPONTIME) as? Date {
     
     let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
     var result = gregorian?.components(.hour, from: time, to: todayDate(), options: NSCalendar.Options.init(rawValue: 0))
     
     //测试  3分钟
     //            var result = gregorian?.components(.minute, from: time, to: todayDate(), options: NSCalendar.Options.init(rawValue: 0))
     
     
     guard let hour = result?.hour else {
     //            guard let hour = result?.minute else {
     return
     }
     
     if hour >= 6 {
     //            if hour >= 3 {
     getCoupon()
     }else {
     createCouponView()
     }
     }else {
     getCoupon()
     }
     
     }
     
     fileprivate func recordTime() {
     UserDefaults.standard.set(todayDate(), forKey: KCOUPONTIME)
     UserDefaults.standard.synchronize()
     }
     */
    fileprivate func pushVC(_ vc: UIViewController) {
        //        let navigationController = (UIApplication.shared.delegate as! AppDelegate).navigationController
        let navigationController = gd_currentNavigationController()
        navigationController.pushVC(vc)
        //        navigationController?.pushVC(vc)
    }
    
}

extension MQICouponManager {
    
    func saveCoupons() {
        guard let coupons = coupons else {
            return
        }
        
        dispatchArchive(coupons, path: couponsPath)
    }
    func saveCoupons_ids(_ coupon_id:String) {
        guard var coupon_ids = coupon_ids else {
            return
        }
        guard coupon_ids.contains(coupon_id) == false else {
            return
        }
        coupon_ids.append(coupon_id)
        dispatchArchive(coupon_ids, path: couponsPath)
        
    }
    
}

