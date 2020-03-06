//
//  MQIUserModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserModel: MQIBaseModel {
    
    var loginType:String = ""
    var iconData: Data?
    var user_avatar: String = ""
    var user_password: String = ""
    var refresh_token: String = ""
    var access_token: String = ""
    var user_level: String = ""
    var user_ticket: String = ""
    var user_point: String = "0"
    var user_premium: String = "0"
    var user_nick: String? = "" {
        didSet {
            if let _ = user_nick {
                user_nick = user_nick!.replacingOccurrences(of: "", with: "|")
            }
        }
    }
    var user_id: String = ""
    var user_mobile_verify: Bool = false
    var user_mobile: String?
    var user_coin: String = ""
    var user_vip_level: String = ""
    var user_vip_expiry: String = ""
    var sign_in: Bool = false
    
    var user_nick_time: String = ""
    var user_income: String = ""
    var user_vip_time: String = ""
    var user_status: String = ""
    var user_coin_total: String = ""
    var device_id: String = ""
    var user_email: String = ""
    var user_referer: String = ""
    var user_reg_time: String = ""
    var user_site: String = ""
    var user_channel: String = ""
    var user_info_complete: String = ""
    var user_email_verify: String = ""
    var user_last_ip: String = ""
    var user_login_ip: String = ""
    var user_income_total: String = ""
    var user_last_time: String = ""
    var vip_state: Bool = false
    
    var user_last_vip_date: String {
//        let times = user_last_time.components(separatedBy: " ")
//        if times.count > 0 {
//            return times[0]
//        }
//        return user_last_time
        let date = Date.init(timeIntervalSince1970: TimeInterval(user_vip_expiry.integerValue()))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var isVIP: Bool {
        return false
//        if user_vip_level == "9" {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//
//            var oldDate = formatter.date(from: user_vip_expiry)
//            var newDate = formatter.date(from: formatter.string(from: Date()))!
//            if let oldDate = oldDate {
//                if newDate.timeIntervalSince(oldDate) < 0 {
//                    return true
//                }else {
//                    return false
//                }
//            }else {
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                oldDate = Date.init(timeIntervalSince1970: TimeInterval(user_vip_expiry.integerValue()))
//                newDate = formatter.date(from: formatter.string(from: Date()))!
//                if let oldDate = oldDate {
//                    if newDate.timeIntervalSince(oldDate) < 0 {
//                        return true
//                    }else {
//                        return false
//                    }
//                }else {
//                    return true
//                }
//            }
//        }else {
//            return false
//        }
    }
    
    
    var isNewEmail:String {
        var email = user_email
        if user_email_verify == "0" && email.count > 1 {
            email = ""
        }
        return email
    }
    
    override init() {
        super.init()
        
    }
    
    var checkedIn:Int = 0
    var lastLoginTime:String = ""
    var lastLoginType:Int {
        set {
            loginType = "\(newValue)"
        } get {
            return loginType.integerValue()
        }
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user_mobile_verify" {
            user_mobile_verify = getBoolWithValue(value)
        }else if key == "sign_in" {
            sign_in = getBoolWithValue(value)
        }
      
        else if key == "vip_state" {
            vip_state = getBoolWithValue(value)
        }
        else {
            mqLog("\(key)  :  \(String(describing: value))")
            super.setValue(value, forKey: key)
        }
    }
    
}

class MQIAuthorizationModel: MQIBaseModel {
    var refresh_token: String = ""
    var access_token: String = ""
}
func paseUserObject(_ result: MQIBaseModel) {
 
    if let userDict = result.dict["user"] {
        if userDict is [String : Any] {
            MQIUserManager.shared.user = MQIUserModel(jsonDict: userDict as! [String : Any])
        }
    }else{
        
        if  MQIUserManager.shared.checkIsLogin() {
            if result.dict.keys.count > 0 {
                let userNew = MQIUserModel(jsonDict: result.dict)
                 MQIUserManager.shared.user!.user_email = userNew.user_email
                 MQIUserManager.shared.user!.user_email_verify = userNew.user_email_verify
                 MQIUserManager.shared.user!.user_vip_expiry =  userNew.user_vip_expiry
                 MQIUserManager.shared.user!.vip_state =  userNew.vip_state
                 MQIUserManager.shared.user!.sign_in = userNew.sign_in
                if  userNew.user_vip_level != "" {
                    MQIUserManager.shared.user!.user_vip_level = userNew.user_vip_level
                }
                if  userNew.user_avatar != "" {
                    MQIUserManager.shared.user!.user_avatar = userNew.user_avatar
                }
                if  userNew.user_premium != "" {
                    MQIUserManager.shared.user!.user_premium = userNew.user_premium
                }
                if  userNew.user_coin != "" {
                    MQIUserManager.shared.user!.user_coin = userNew.user_coin
                }
                
            }
        }
        
    }
    
    
    if let token = result.dict["token"] {
        if token is String {
            MQIUserManager.shared.user?.access_token = token as! String
        }
    }
    
    if let user = MQIUserManager.shared.user {
        if let authorizationDict = result.dict["authorization"] {
            if authorizationDict is [String : Any] {
                let model = MQIAuthorizationModel(jsonDict: authorizationDict as! [String : Any])
                user.refresh_token = model.refresh_token
                user.access_token = model.access_token
            }
        }
        
    }
}
extension MQIUserModel:XMDBUserProtocol {
    
    var email: String {
        set {
            user_email = newValue
        }
        get {
            return (user_email.count > 0) ? user_email: " "
        }
    }
    
    var avatar: String {
        set {
            user_avatar = "\(newValue)"
        }
        get {
            return user_avatar
        }
    }
    
    var uid: Int {
        set {
            user_id = "\(newValue)"
        }
        get {
            return user_id.integerValue()
        }
        
    }
    
    var nick: String {
        set {
            user_nick = newValue
        }
        get {
            return user_nick ?? ""
        }
    }
    
    var mobile: String {
        set {
            user_mobile = newValue
        }
        get {
            return user_mobile ?? ""
        }
        
    }
    
    var regTime: String {
        set {
            user_reg_time = newValue
        }
        get {
            return user_reg_time
        }
        
    }
    
    var vipLevel: Int {
        set {
            user_vip_level = "\(newValue)"
        }
        get {
            return  user_vip_level.integerValue()
        }
        
        
    }
    
    var vipTime: Int {
        set {
            user_vip_time = "\(newValue)"
        }
        get {
            return  user_vip_time.integerValue()
        }
        
    }
    
    var vipExpiredTime: Int {
        set {
            user_vip_expiry = "\(newValue)"
        }
        get {
            return user_vip_expiry.integerValue()
        }
    }
    
    var coin: Int {
        set {
            user_coin = "\(newValue)"
        }
        get {
            return user_coin.integerValue()
        }
        
    }
    
    var premium: Int {
        set {
            user_premium = "\(newValue)"
        }
        get {
            return user_premium.integerValue()
        }
        
    }
    
    var vipState: Int {
        set {
            vip_state = (newValue == 1) ? true:false
        }
        get {
            return vip_state ? 1:0
        }
        
        
    }
    
    var token: String {
        set {
            access_token = newValue
        }
        get {
            return access_token
        }
        
    }
    
    //    var lastLoginType: Int {
    //        return  1
    //    }
    //
    //    var lastLoginTime: String {
    //        return ""
    //    }
    //
    //    var checkedIn: Int {
    //        return 1
    //    }
    
    
    
}
