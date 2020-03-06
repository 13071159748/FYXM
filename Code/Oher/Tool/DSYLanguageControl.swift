//
//  DSYLanguageControl.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/29.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

public  func   kCreateLanguage() {
     DSYLanguageControl.createLanguage()
}

/// 获取本地多语言
///
/// - Parameters:
///   - key: 多语言key
///   - describeStr: 设置描述方便记忆
/// - Returns: 对应多语言字符
func kLocalized(_ key:String,describeStr:String = "") -> String {
    return DSYLanguageControl.dsyLocalizedString(key)
}


/// 获取本地多语言
///
/// - Parameters:
///   - key: 多语言key 其中包含 %@ 字符串
///   - replace: 替换字符串用逗号隔开：kLongLocalized("我是%@呵呵%@--%@",replace: "aa","22")
///   - isFirst: 是否在字符串开头替换
///   - describeStr: 设置描述方便记忆
/// - Returns: 对应多语言字符

func kLongLocalized(_ key:String,replace : String...,isFirst:Bool = false,describeStr:String = "") -> String {
    
    let oldStr = kLocalized(key)
    let oldArray = oldStr.components(separatedBy: "%@")
    if replace.count == 0  ||  oldArray.count == 0 { return oldStr }
    var newStr =  ""
    for i  in 0..<oldArray.count {
        
        if i == oldArray.count-1 { /// 最后一个拼接
            newStr += oldArray[i]
            return newStr
        }
        if i >= replace.count {
            newStr += oldArray[i]
        }else{
            if isFirst  && i == 0{
                newStr += replace[i]
                newStr += oldArray[i]
            }else{
                newStr += oldArray[i]
                newStr += replace[i]
            }
        }
        
    }
    
    return newStr
}

enum DSYLanguageType:String {
    case zh_Hans = "zh-Hans"
    case zh_Hant = "zh-Hant"
    case EN = "en"
    
    func conversion()->String {
        switch self {
        case .zh_Hans:  return "简体中文"
        case .zh_Hant: return "繁體中文"
        case .EN: return "English"
        }
    }
    
    
    static  func createType(_ typeStr:String) -> DSYLanguageType {
        switch typeStr {
        case "简体中文" , "zh-Hans" : return .zh_Hans
        case "繁體中文" , "zh-Hant": return .zh_Hant
        case "English" , "en": return .EN
        default:
            return .zh_Hant
        }
    }
}


/* 使用"["]*[\u4E00-\u9FA5]+["\n]*?"搜索全局中文*/

class DSYLanguageControl: NSObject {

    /// 本地语言配置文件真实名称
    static let localLprojNames:[String] = [DSYLanguageType.zh_Hans.rawValue,DSYLanguageType.zh_Hant.rawValue]
    /// 多语言切换 通知名称
    static let SETLANGUAHE:String = "DSYLanguageControlSetUserlanguageCode"
    /// 自定义 Bundle
    static var _bundle:Bundle?
    /// 默认本地语言配置文件真实名称
    static let defaultLprojName:String = DSYLanguageType.zh_Hant.rawValue
    /// 当前语言
    static var currentLanStr:String = "zh-TW"
    
    /// 是否跟随系统
    static var isSystem:Bool {
        get{
            var result = userDefaults().value(forKey: "dsy_isSystem") as? Bool
            if result == nil {
                userDefaults().setValue(true , forKey: "dsy_isSystem")
                userDefaults().synchronize()
                result = true
            }
            return result!
        }
        set{
            userDefaults().setValue(isSystem , forKey: "dsy_isSystem")
            userDefaults().synchronize()
        }
    }

    /// 获取本地多语言
    ///
    /// - Parameters:
    ///   - key: 多语言key
    ///   - describeStr: 设置描述方便记忆
    /// - Returns: 对应多语言字符
    class func dsyLocalizedString (_ key:String,describeStr:String = "") -> String{
        guard let  locStr = dsyBundle()?.localizedString(forKey: key, value: nil, table: "Localizable") else {
             return key
        }
           return locStr
    }
    
    
    
    /// 切换语言
    ///
    /// - Parameters:
    ///   - language: 所要切换的语言
    ///   - success: 回调 接收通知
    class func dsySwitchLanguage (_  type:DSYLanguageType,success:((_ result:Bool)->())? = nil) -> Void{
        currentLanStr = serverLanguage(type.rawValue)
        if  dsyUserLanguage() == type.rawValue {
          ///语言相同不用切换
            success?(true)
        }else{
            if dsySetUserlanguage(type) {
                ///语言切换成功
                 success?(true)
                NotificationCenter.default.post(Notification.init(name: Notification.Name.init(SETLANGUAHE)))
            }else{
                ///语言切换失败
                success?(false)
            }
        }
     
    }
    
    ///设置语言
  @discardableResult  class func dsySetUserlanguage (_ type:DSYLanguageType) -> Bool{
       
        let path = Bundle.main.path(forResource: type.rawValue, ofType: "lproj")
        if path != nil {
            _bundle = Bundle(path: path!)
            let def = userDefaults()
            def.setValue(type.rawValue, forKey: "userLanguage")
            return def.synchronize()
        }else{
            return false
        }
     
    }
    
    
    /// 获取自定义的bundle
    class func dsyBundle() -> Bundle? {
        return _bundle
    }
    
    /// 当前语言
    class func dsyUserLanguage () -> String{
        let userLanguage = userDefaults().value(forKey: "userLanguage") as? String
        if userLanguage == nil {
            return ""
        }else{
            return userLanguage!
        }
        
    }
    
    /// 系统语言
    class func dsyAppleLanguage () -> String{
        let languages =  userDefaults().object(forKey: "AppleLanguages") as![String]
        mqLog("\(String(describing: languages))")
        return languages.first!
    }
    /// 服务器语言标识
    class func serverLanguage(_ language:String)->String {
        if (language.hasPrefix(DSYLanguageType.zh_Hans.rawValue)){
            return "zh-CN"
        }else{
           return "zh-TW"
        }
    }

    /// 获取本地语言路径
  @discardableResult  class func createLanguage() -> String  {
    
        /// 语言本地化路径
        var path:String?
        var language:String = ""
        if isSystem {
            language = dsyAppleLanguage()
        }else{
            language = dsyUserLanguage()
        }
    
        if language.count == 0 { ///取系统语言
            //获取系统当前语言版本(中文zh-Hans-CN,英文en_us)
            language = dsyAppleLanguage()
        }
    
        var lprojName:String = ""
        lprojName = getLprojName(language)
        
        if lprojName.count > 0 {
            path = Bundle.main.path(forResource: lprojName, ofType: "lproj")
        }
        if path == nil {
            ///为空设置为默认语言
            path = Bundle.main.path(forResource: defaultLprojName, ofType: "lproj")
            language  = defaultLprojName
        }
        //生成bundle
        _bundle = Bundle(path: path!)
        if _bundle != nil {
            /// 缓存当前语言
            userDefaults().setValue(language, forKey: "userLanguage")
            userDefaults().synchronize()
        }

      currentLanStr = serverLanguage(language)
        return language
    }
    
    private class func getLprojName(_ language:String) ->String {
        var lprojName = " "
        if  language.contains(DSYLanguageType.zh_Hans.rawValue) {
            lprojName = DSYLanguageType.zh_Hans.rawValue
        }else if language.contains(DSYLanguageType.zh_Hant.rawValue) {
             lprojName = DSYLanguageType.zh_Hant.rawValue
        }else{
            lprojName = defaultLprojName
        }

        /// 获取本地多语言列表
//        let localTbles:[String] =  Bundle.main.localizations
//        if !localTbles.contains(language) {
//            if  let lprojNameNew = language.components(separatedBy: "-").first{
//                lprojName = lprojNameNew
//            }
//        }
//
//        if localTbles.contains(language) {
//            lprojName = language
//        }
        
        return lprojName
    }
    /// 获取偏好设置
   private class func userDefaults () -> UserDefaults{
    
        return UserDefaults.standard
    }
}
