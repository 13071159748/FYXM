//
//  MQIDiscountCardInfo.swift
//  CQSC
//
//  Created by moqing on 2019/5/22.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit
///打折卡
class MQIDiscountCardInfo: MQIBaseModel {
    
    var product_id: String = ""
    
    // 币种 CHN
    var currency:String = ""{
        didSet(oldValue) {
            if currency == "USD" {
                currencyStr = "US$"
            }else if currency == "CNY"  {
                currencyStr = "CN¥"
            }else{
                currencyStr = currency
            }
        }
    }
    var currencyStr:String = "" // 币种 CH¥
    
    var price: String = ""{
        didSet(oldValue) {
            priceStr = String.init(format: "%.2f", price.floatValue()/100)
        }
    }
    
    var priceStr:String = ""
    var images: [String] = []
    
    
    /// 单位
    var coin_name:String = ""
    ///平均省钱文案
    var average_reduction:String = ""
    //文案
    var rule_desc:String = ""
    ///省钱榜列表  分页
    var discount_rank = [MQIUserDiscountCardRankModel]()
    ///打折卡的  购买 图片地址
    var buy_image_url:String = ""
    ///打折卡的  购买完成 图片地址
    var bought_image_url:String = ""
    ///打折卡的权益列表
    var privileges = [MQIUserDiscountCardRankModel]()
    ///banner
    var banner = MQIUserDiscountCardRankModel()
    ///tj 推荐
    var tj = MQIUserDiscountCardRankModel()
    
    /* 打折卡信息 */
    //打折 默认80
    var discount:String = ""
    /// 打折介绍
    var discount_desc:String = ""
    /// 是否购买过打折卡 true 、false
    var is_bought:String = ""
    ///打折卡的过期时间
    var expiry_time:String = ""
    ///总节省金额 
    var total_reduction_coin: String = ""
    ///总节省金额 节省的书币优先显示文案  文案为空的情况下   显示total_reduction_coin
    var total_reduction_replace_text: String = ""
    

    
    ///减免的总章节数
    var total_reduction_chapter: String = ""
    ///总页数
    var total:String = ""
    
    var data = [MQIUserDiscountCardRankModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "discount_rank" {
            discount_rank = setValueToArray(value, key: key)
        }else if key == "privileges" {
            privileges = setValueToArray(value, key: key)
        }
        else if key == "banner" {
            banner = setDictToModel(value, key: key)
        }else if key == "tj" {
            tj = setDictToModel(value, key: key)
        }
        else if key == "data" {
            data =  setValueToArray(value, key: key)
        }
        else{
         super.setValue(value, forKey: key)
        }
        
        
    }
}


class MQIUserDiscountCardInfo: MQIBaseModel {
    
    var uid: String?
    ///折扣
    var discount: String = ""
    ///折扣描述
    var desc: String = ""
    ///折扣过期时间
    var expiry_time: String = ""
    /*未开启 0  开启 1*/
    var is_bought:String = ""
    /*是否过期: 0未过期  、1过期、不存在：未开启 */
    var is_expiry:String = ""
    var isVip: Bool {
        return (cardState != "2") ? false:true
    }
    
    let will_expiry_count:Double = 0
    /// 0 未开通 1  过期 2 有效
    var cardState:String{
        if is_expiry == "0" {
            return "2"
        } else if is_expiry == "1" {
            return "1"
        }else{
             return "0"
        }
//        if is_bought == "0" {
//            return "0"
//        }else if expiry_time.doubleValue()-Date().timeIntervalSince1970 <= will_expiry_count {
//            return "1"
//        }else{
//             return "2"
//        }
    
    }
    
    private static var reloadTime: TimeInterval?

    
     private static var p_default: MQIUserDiscountCardInfo?

    static var `default`: MQIUserDiscountCardInfo? {
        get {
            guard let uid = MQIUserManager.shared.user?.user_id else { return nil }
            if p_default != nil && p_default?.uid == uid {
               return p_default!
            }
            if let dic = UserDefaults.standard.object(forKey: "user_discountCard_key_\(uid)") as? [String: Any] {
                let mode = MQIUserDiscountCardInfo(jsonDict: dic)
                p_default = mode
                return p_default
            }
            return nil
        }
        set {
             p_default = newValue
        }
    }

    
    private static let dayBySeconds: TimeInterval = 60 * 60 * 6
    static func reload(isMandatory: Bool = false, complete: (() -> ())? = nil) {

        func cache(udc: [String: Any]) {
            guard let uid = MQIUserManager.shared.user?.user_id else { return }
            let infoKey = "user_discountCard_key_\(uid)"
            var udc_new = udc
            udc_new.updateValue(uid, forKey: "uid")
            UserDefaults.standard.set(udc_new, forKey: infoKey)
            UserDefaults.standard.synchronize()
        }
//
        if !MQIUserManager.shared.checkIsLogin() {complete?();return}
        
        MQIMydiscountsimpleRequest().request({ (_, _, udc: MQIUserDiscountCardInfo) in
            cache(udc: udc.dict)
            MQIUserDiscountCardInfo.default = udc
            complete?()
        }, failureHandler: { (msg, code) in

            guard let uid = MQIUserManager.shared.user?.user_id else {
                MQIUserDiscountCardInfo.default = nil
                return}
            if let dic = UserDefaults.standard.object(forKey: "user_discountCard_key_\(uid)") as? [String: Any] {
                let mode = MQIUserDiscountCardInfo(jsonDict: dic)
                 MQIUserDiscountCardInfo.default = mode
//                if mode.isVip {
//                    MQIUserDiscountCardInfo.default = mode
//                }else{
//                     MQIUserDiscountCardInfo.default = nil
//                    UserDefaults.standard.removeObject(forKey: "user_discountCard_key_\(uid)")
//                }
               
            }else{
              MQIUserDiscountCardInfo.default = nil
            }

            complete?()
        })
    }
    
    
    
}

class MQIUserDiscountCardRankModel: MQIBaseModel {

      var reduction_coin: String = ""
      var reduction_chapter: String = ""
      var date: String = ""
      var user_id: String = ""
      var site_id: String = ""
      var user_nick: String = ""
    
      var image_url: String = ""
      var name:String = ""
      var intro:String = ""
      var title:String = ""
      var url:String = ""
    
      var type:String  = ""
      var limit_time:String  = ""
    
     var books = [MQIEachBook]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "books" {
            books = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
        
        
    }
}
