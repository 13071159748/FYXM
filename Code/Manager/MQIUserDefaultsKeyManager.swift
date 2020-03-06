//
//  MQIUserDefaultsKeyManager.swift
//  CQSC
//
//  Created by moqing on 2019/8/30.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

struct MQIUserDefaultsKeyManager {
    static let  shared = MQIUserDefaultsKeyManager()
     /// 版本提示弹框
    static let VersionBouncedView_showKey = "VersionBouncedView_key_show"
     /// 阅读器目录提示缓存
    static let reader_directory_showKey = "reader_directory_show"
    /// 阅读器文字修改按钮提示缓存
    static let reader_AdjusA_showKey = "reader_AdjusA_showKey"
    /// 阅读器文导引缓存
    static let reader_Guide_showKey = "reader_back_guid_imge"
    /// 支付恢复提示
    static let pay_Back_showKey = "pay_Back_showKey"

}

//MARK:  恢复购买
extension MQIUserDefaultsKeyManager {
    
    func pay_Back_isAvailable() -> Bool {
        let show_Value:String? = getValueForKey(MQIUserDefaultsKeyManager.pay_Back_showKey)
        if show_Value == nil {
            return  true
        }
        return false
        
    }
    
    func pay_Back_Save ()  {
        setValueForKey(MQIUserDefaultsKeyManager.pay_Back_showKey, value:"1.4.0")
    }
    
}

//MARK:  阅读导引
extension MQIUserDefaultsKeyManager {
    
    func reader_Guide_isAvailable() -> Bool {
        let show_Value:String? = getValueForKey(MQIUserDefaultsKeyManager.reader_Guide_showKey)
        if show_Value == nil   ||  show_Value != "1.4.0"{
            return true
        }
        return false

    }
    
    func reader_Guide_Save ()  {
        setValueForKey(MQIUserDefaultsKeyManager.reader_Guide_showKey, value:"1.4.0")
    }
    
}
//MARK:  阅读器目录
extension MQIUserDefaultsKeyManager {
    
    func reader_directory_isAvailable() -> Bool {
        let show_Value:String? = getValueForKey(MQIUserDefaultsKeyManager.reader_directory_showKey)
        if show_Value == nil  {
            return  true
        }
        return false
        
    }
    
    func reader_directory_Save ()  {
        setValueForKey(MQIUserDefaultsKeyManager.reader_directory_showKey, value:"1.4.0")
    }
    
}

//MARK:  文字修改按钮
extension MQIUserDefaultsKeyManager {
    
    func reader_AdjusA_isAvailable() -> Bool {
        let show_Value:String? = getValueForKey(MQIUserDefaultsKeyManager.reader_AdjusA_showKey)
        if show_Value == nil  {
            return  true
        }
        return false
    }
    
    func reader_AdjusA_Save ()  {
        setValueForKey(MQIUserDefaultsKeyManager.reader_AdjusA_showKey, value:"1.4.0")
    }
    
}




//MARK:   版本提示弹框
extension MQIUserDefaultsKeyManager {
    
    func version_isAvailable() -> Bool {
        let showTime:Int = getValueForKey(MQIUserDefaultsKeyManager.VersionBouncedView_showKey) ?? 0
        if showTime > 0 && (getDayInterval(timeInterval: showTime)+86400) > getCurrentStamp()
        {
            return false
        }
        return true
    }
    
    func version_Save ()  {
        setValueForKey(MQIUserDefaultsKeyManager.VersionBouncedView_showKey, value: getCurrentStamp())
    }
    
}


extension MQIUserDefaultsKeyManager {

        func getValueForKey<T>(_ key:String) -> T? {
            return UserDefaults.standard.object(forKey: key) as? T
        }
        
        func setValueForKey(_ key:String , value:Any)  {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
    
        
        //获取当天0点时间戳
        @discardableResult  func getDayInterval(timeInterval:NSInteger) -> NSInteger{
            let date = NSDate(timeIntervalSince1970:TimeInterval(timeInterval))
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.year,.month,.day], from: date as Date)
            let timeInterval1:TimeInterval = (calendar.date(from: components)!.timeIntervalSince1970)
            let timeStamp = NSInteger(timeInterval1)
            return timeStamp
        }
        func getCurrentStamp() -> Int{
            return Int(Date().timeIntervalSince1970)
        }

}



