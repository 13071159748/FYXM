//
//  MQIUserManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let user_path = "user.db"

class MQIUserManager: NSObject {
    
    var loginBegin: (() -> ())?
    fileprivate static var __once: () = {
        Inner.instance = MQIUserManager()
    }()
    var user: MQIUserModel?
    var userPath = MQIFileManager.getCurrentStoreagePath(user_path)
    
    
    var historyLogData = [MQIUserModel]()
    var historyLogPath = MQIFileManager.getCurrentStoreagePath("userHistoryLogPath.db")
    
    override init() {
        super.init()
        if MQIFileManager.checkFileIsExist(userPath) == true {
            user = NSKeyedUnarchiver.unarchiveObject(withFile: userPath) as? MQIUserModel
        }
        getHistoryLogDataFunc()
    }
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIUserManager?
    }
    
    class var shared: MQIUserManager {
        _ = MQIUserManager.__once
        return Inner.instance!
    }

    func checkIsLogin() -> Bool {
        return user == nil ? false : true
    }
    
    
    func saveUser() {
//        if let userNew = user  {
//            let suc = NSKeyedArchiver.archiveRootObject(userNew, toFile: userPath)
//            if suc == true {
//                MQICouponManager.shared.updateReaderCoupon_isok = false
//                mqLog("保存成功")
//            }
//        }else{
//            mqLog("保存失败 没有登录")
//        }
        MQIDataUtil.saveDBUser(user)
      
    }
    
    func loginOut(_ text: String?, finish: (_ suc: Bool) -> ()) {
        if checkIsLogin() == false {
            return
        }
        updateUserState(checkedIn: 0)
        MQIUserManager.shared.user = nil
        MQIFileManager.removePath(userPath)
        UserNotifier.postNotification(.login_out)
        finish(true)
    }
    
    func updateUserState(checkedIn:Int? ,lastLoginType:Int? = nil)  {
        var state:[XMUserAttribute] = [XMUserAttribute]()
        if let checkedIn = checkedIn {
            MQIUserManager.shared.user?.checkedIn = checkedIn
            state.append(.checkedIn(checkedIn))
        }
        if let  lastLoginType = lastLoginType {
            MQIUserManager.shared.user?.lastLoginType = lastLoginType
            state.append(.lastLoginType(lastLoginType))
        }
        //        MQIUserManager.shared.user?.checkedIn = 1
        ////        state.append(.checkedIn(1))
        let lastLoginTime = "\(getCurrentStamp())"
        MQIUserManager.shared.user?.lastLoginTime = lastLoginTime
        state.append(.lastLoginTime(lastLoginTime))
        
        if let user = MQIUserManager.shared.user {
            do {
                try XMDBTool.shared.update(user:  user.user_id.integerValue(), values: state)
            }
            catch {
                
            }
            
        }
        
    }
    
    /// 更新账户金额
    func updateUserCoin(_ completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        if !checkIsLogin() {completion?(false, kLocalized("UserHasQuit"))}
        
        GYUserCoinRequest().request({(request, response, result: GYEachCoin) in
            if  MQIUserManager.shared.checkIsLogin(){
                MQIUserManager.shared.user!.user_coin = result.coin
                MQIUserManager.shared.user!.user_premium = result.premium
                MQIUserManager.shared.saveUser()
                completion?(true,  kLocalized("BalanceHasBeenUpdated"))
            }else{
                completion?(false, kLocalized("UserHasQuit"))
            }
            
        }) { (err_msg, err_code) in
            completion?(false, err_msg)
        }
    }
    
    /// 更新账户信息
    func updateUserInfo(_ completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        if !checkIsLogin() {completion?(false, kLocalized("UserHasQuit"))}
        Update_userInfoRequest().request({(request, response, result: MQIBaseModel) in
            if  MQIUserManager.shared.checkIsLogin(){
                paseUserObject(result)
                MQIUserManager.shared.saveUser()
               
                completion?(true,  kLocalized("AccountInformationHasBeenUpdated"))
            }else{
                completion?(false, kLocalized("UserHasQuit"))
            }
            
        }) { (err_msg, err_code) in
            completion?(false, err_msg)
        }
    }
    
    /// 计算剩余的钱
    func remainingMoney(_ coin:Int) -> Void {
        if let user = self.user{
            if user.user_premium.integerValue() > coin{
                let residue = user.user_premium.integerValue() - coin
                user.user_premium = "\(residue)"
            }else if (user.user_premium.integerValue() + user.user_coin.integerValue())>coin {
                //豆=0， 币 = 币-（coin-豆）
                user.user_premium = "0"
                let usercoin = user.user_coin.integerValue()-(coin-user.user_premium.integerValue())
                user.user_coin = "\(usercoin)"
            }
            else if user.user_coin.integerValue() > coin {
                let residue = user.user_coin.integerValue() - coin
                user.user_coin = "\(residue)"
            }
            
        }
        saveUser()
    }
    
    func getTodayMatter(timeStamp:Int) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 hh:mm:ss"
        return dformatter.string(from: date)
    }
    func getTodayMatterWithOutSec(timeStamp:Int) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd hh:mm"
        return dformatter.string(from: date)
    }
    func userInfo_RequestCoin(_ completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        GYUserCoinRequest().request({(request, response, result: GYEachCoin) in
            
            if  MQIUserManager.shared.checkIsLogin(){
                MQIUserManager.shared.user!.user_coin = result.coin
                MQIUserManager.shared.user!.user_premium = result.premium
                MQIUserManager.shared.saveUser()
                completion?(true, kLocalized("BalanceHasBeenUpdated"))
            }else{
                completion?(false, kLocalized("UserHasQuit"))
            }
        }) { (err_msg, err_code) in
            completion?(false, err_msg)
        }
    }
    var lock = NSLock()
    var need: Bool = true
    func toLogin(_ text: String?, finish: @escaping () -> ()) {
        if MQIPayTypeManager.shared.type == .inPurchase {
            MQILoadManager.shared.makeToast(kLocalized("SorryYouHavenLoggedInYet"))
        }else {
            lock.lock()
            if need == true {
                self.need = false
                MQILoadManager.shared.addAlert(msg: text == nil ? kLocalized("PleaseLoginFirst") : text!, type: .custom, block: { [weak self]()->Void in
                    if let strongSelf = self {
                        strongSelf.loginBegin?()
                        
                        strongSelf.need = true
                    }
                    
                    }, cancelBlock: {[weak self]()->Void in
                        if let strongSelf = self {
                            strongSelf.need = true
                        }
                })
            }
            lock.unlock()
        }
    }
    
    
    
    func getHistoryLogDataFunc(){
//        if MQIFileManager.checkFileIsExist(historyLogPath) {
//            historyLogData = (NSKeyedUnarchiver.unarchiveObject(withFile: historyLogPath) as? [MQIUserModel]) ?? []
//        }
//        
        
        let us = XMDBTool.shared.allUser().map { return  MQIUserModel(jsonDict: $0 as? [String : Any] ?? [:]) }
        historyLogData = us
    }
    
    func saveHistoryLogData() {
        guard let modelNEW =  MQIUserManager.shared.user else {
            return
        }
        if MQIloginManager.shared.type != .other {
             modelNEW.loginType = MQIloginManager.shared.type.conversion()
        }
        historyLogData = historyLogData.filter({$0.user_id != modelNEW.user_id})
        historyLogData.insert(modelNEW, at: 0)
        let suc = NSKeyedArchiver.archiveRootObject(historyLogData, toFile: historyLogPath)
        if suc == true {
            mqLog("保存成功")
        }
    }
    
}
