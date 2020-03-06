//
//  MQISignManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit



let KSIGNTIME = "KSIGNTIME"
let Today_SignToast = "toady_SignToast"//今天是否弹窗了
class MQISignManager: NSObject {
    
    fileprivate static var __once: () = {
        Inner.instance = MQISignManager()
    }()
    
    var window: UIWindow!
    var sucView: MQISignSucView!
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQISignManager?
    }
    
    class var shared: MQISignManager {
        _ = MQISignManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        window = getWindow()
        
        sucView = MQISignSucView()
        sucView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    func sign(_ completion: ((_ suc: Bool) -> ())?) {
        MQILoadManager.shared.addProgressHUD("正在签到...")
        GYUserSignRequest().request({[weak self] (request, response, result: MQISignModel) in
            MQILoadManager.shared.dismissProgressHUD()
            if result.premium.count > 0 {
                //                MQILoadManager.shared.makeToast("签到成功，您获得\(premium)\(COINNAME_PREIUM)")
                MQIUserManager.shared.user!.user_premium = "\(result.premium)"
                
                if let strongSelf = self {
                    strongSelf.sucView.title = "恭喜获得\(result.premium)\(COINNAME_PREIUM)\n(赠送的\(COINNAME_PREIUM)请在30日有效期内使用)"
                    strongSelf.window.addSubview(strongSelf.sucView)
                }
            }else {
                MQILoadManager.shared.makeToast("签到成功")
            }
            MQISignManager.shared.recordTime()
            completion?(true)
            
            }, failureHandler: { (err_msg, err_code) in
                if err_code == "11900" {
                    MQISignManager.shared.recordTime()
                }
                completion?(false)
                mqLog("\(err_msg)    \(err_code)")
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
        })
    }
    
    
    //MARK: --
    func refresh() {
        if let user = MQIUserManager.shared.user {
            if user.sign_in == true {
                recordTime()
            }else {
                UserDefaults.standard.removeObject(forKey: KSIGNTIME)
                UserDefaults.standard.synchronize()
            }
        }else {
            UserDefaults.standard.removeObject(forKey: KSIGNTIME)
            UserDefaults.standard.synchronize()
        }
    }
    
    let KTODAY = "TODAYKEY"
    func todayDate() -> Date {
        let interval = TimeZone(secondsFromGMT: +28800)?.secondsFromGMT(for: Date())
        let today = Date().addingTimeInterval(TimeInterval(interval!))
        return today
    }
    
    func checkIsSign() -> Bool {
        if MQIUserManager.shared.checkIsLogin() == false {
            return false
        }
        
        let today = todayDate()
        let secondsPerDay: TimeInterval = 24*60*60
        
        let yesterday: Date = today.addingTimeInterval(-secondsPerDay)
        let todayStr = NSString(string: today.description).substring(to: 10)
        let yesterdayStr = NSString(string: yesterday.description).substring(to: 10)
        
        if let time = UserDefaults.standard.object(forKey: KSIGNTIME) as? Date {
            
            let t = NSString(string: time.description).substring(to: 10)
            //            mqLogr("\(todayStr)   \(yesterdayStr)   \(t)")
            if t == yesterdayStr {
                //这个存储是昨天 清空 KDATE KTODAY 重新计入新的 KTODAY KDATE
                return false
            }else if t == todayStr {
                //这个存储是今天的 那就判断 存储的时间 距离现在的时间 是否过去了一个小时？
                
                return true
            }else {
                //这个存储是明天 不可能！ 但是可能是以前
                return false
            }
        }else {
            return false
        }
    }
    
    func recordTime() {
        UserDefaults.standard.set(todayDate(), forKey: KSIGNTIME)
        UserDefaults.standard.synchronize()
    }
    
    
    func gd_newsign(_ position:String ,completion: ((_ suc: Bool,_ model:MQISignModel? ,_ err_code:String?) -> ())?) {
        MQILoadManager.shared.addProgressHUD("努力翻牌中...")
       GDUserSignRequest(position: position).request({ (request, response, result: MQISignModel) in
            MQILoadManager.shared.dismissProgressHUD()
            
            MQISignManager.shared.recordTime()
            completion?(true,result,nil)
            
        }, failureHandler: { (err_msg, err_code) in
            MQILoadManager.shared.dismissProgressHUD()
            if err_code == "11900" {
                MQISignManager.shared.recordTime()
                MQILoadManager.shared.makeToast("已经签过到了")
                completion?(false,nil,err_code)
                return
            }
            completion?(false,nil,nil)
            mqLog("\(err_msg)    \(err_code)")
        })
    }
    
    
    //签到
    func SignJudgeToday_IsSign(_ completeion: ((_ suc:Bool)->())?) {
        
        MQIUserManager.shared.updateUserInfo { (suc, msg) in
            if suc {
                if let user = MQIUserManager.shared.user {
                    completeion?(user.sign_in)
                }
            }else{
                completeion?(false)
            }
        }
    }
    
}

class MQISignModel:MQIBaseModel {
    var premium: String = ""
    var lottery_list=NSMutableArray()
    var double:String = ""
}

class MQISignSucView: UIView {
    var titleFont = UIFont.systemFont(ofSize: 14)
    var titleColor = UIColor.white
    var titleLabel:UILabel!
    var  image:UIImageView!
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        image = UIImageView()
        self.addSubview(image)
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addTGR(self, action: #selector(MQISignSucView.dismiss), view: self)
    }
    

   @objc func dismiss() {
        if let _ = self.superview {
            self.removeFromSuperview()
        }
    }
    

    
  
    
}

