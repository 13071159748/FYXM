//
//  MQIApplePayModel.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/8/13.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIApplePayModel: MQIBaseModel {
    
    var data: String = ""
    var order_id: String = ""
    var money: String = ""
    var userId: String = ""
     override init() {
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        data = decodeStringForKey(aDecoder, key: "data")
        order_id = decodeStringForKey(aDecoder, key: "order_id")
        money = decodeStringForKey(aDecoder, key: "money")
        userId = decodeStringForKey(aDecoder, key: "userId")
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(data, forKey: "data")
        aCoder.encode(order_id, forKey: "order_id")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(userId, forKey: "userId")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}


class MQIApplePayModelNew: MQIBaseModel {
    
    var recepit: String = ""
    var money: String = ""
    var userId: String = ""
    var product_id: String = ""
    var identifier: String = ""
    var createDateStr:String = ""
    /// 服务器验证次数  超过 3次后永久删除
    var verifyNumber :Int = 1
    
    //// 订单相关
    var order_coin:String = "" ///充值的币
    var order_premium:String = "" ///充值的豆
    var order_create:String = "" ///订单创建时间
    var order_id:String = ""///订单号
    var order_status:String = "" /// 订单状态  0 待支付 1 已支付 3取消 4 退款 100 内购已支付等待服务器验证
    var order_status_desc:String = "" /// 订单状态描述
    var expiry_time:String = "" /// 订单过期时间
    var channel_code:String = "" /// 渠道
    var order_fee:String = "" /// 订单金额
    var currencyStr:String = "" // 币种 CH¥
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
    
    var code:String = ""
    var message:String = ""
    
    
     override init() {
        super.init()
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        recepit = decodeStringForKey(aDecoder, key: "recepit")
        order_id = decodeStringForKey(aDecoder, key: "order_id")
        money = decodeStringForKey(aDecoder, key: "money")
        userId = decodeStringForKey(aDecoder, key: "userId")
        product_id = decodeStringForKey(aDecoder, key: "product_id")
        identifier = decodeStringForKey(aDecoder, key: "identifier")
        createDateStr = decodeStringForKey(aDecoder, key: "createDateStr")
        order_coin = decodeStringForKey(aDecoder, key: "order_coin")
        order_premium = decodeStringForKey(aDecoder, key: "order_premium")
        order_create = decodeStringForKey(aDecoder, key: "order_create")
        order_status = decodeStringForKey(aDecoder, key: "order_status")
        order_status_desc = decodeStringForKey(aDecoder, key: "order_status_desc")
        expiry_time = decodeStringForKey(aDecoder, key: "expiry_time")
        channel_code = decodeStringForKey(aDecoder, key: "channel_code")
        order_fee = decodeStringForKey(aDecoder, key: "order_fee")
        verifyNumber = decodeIntForKey(aDecoder, key: "verifyNumber")
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(recepit, forKey: "recepit")
        aCoder.encode(order_id, forKey: "order_id")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(product_id, forKey: "product_id")
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(createDateStr, forKey: "createDateStr")
        aCoder.encode(order_coin, forKey: "order_coin")
        aCoder.encode(order_premium, forKey: "order_premium")
        aCoder.encode(order_create, forKey: "order_create")
        aCoder.encode(order_status, forKey: "order_status")
        aCoder.encode(order_status_desc, forKey: "order_status_desc")
        aCoder.encode(expiry_time, forKey: "expiry_time")
        aCoder.encode(channel_code, forKey: "channel_code")
        aCoder.encode(order_fee, forKey: "order_fee")
        aCoder.encode(verifyNumber, forKey: "verifyNumber")
        
        
    }
    
    
}



class MQIComplexResultModel: MQIBaseModel {
    
    var code: String = ""
    var desc: String = ""
    var pos_id:String = ""
    var data = MQIResultaDataModel()
    override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setDictToModel(value, key: key)
        }else {
            super.setValue(value, forKey: key)
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
    
    
}

class MQIResultaDataModel: MQIBaseModel {
    
    var result = MQIResultItmeModel()
    var banner = MQIResultItmeModel()
    var tj = MQIResultItmeModel()
    var event = MQIResultItmeModel()
    
    var code: String = ""
    var desc: String = ""
    var pos_id:String = ""
    var name:String = ""
    var type:String = ""
    
    var exists:String = ""
    
    var token:String = ""

    override  init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "result" {
            result = setDictToModel(value, key: key)
        }
        else if key == "banner" {
            banner = setDictToModel(value, key: key)
        }
        else if key == "tj" {
            tj = setDictToModel(value, key: key)
        }
        else if key == "event" {
            event = setDictToModel(value, key: key)
        }
        else {
            super.setValue(value, forKey: key)
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
    
    
}

class MQIResultItmeModel: MQIBaseModel {
    var desc: String = ""
    var url: String = ""
    var title: String = ""
    var image_url: String = ""
    var name: String = ""
    var type: String = ""
    var books = [MQIEachBook]()
    var eventList = [MQICouponsModel]()
    
    required override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "books" {
            books = setValueToArray(value, key: key)
        } else if key == "eventList" {
            eventList = setValueToArray(value, key: key)
        } else {
            super.setValue(value, forKey: key)
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
    
    
}


class MQICouponsModel: MQIBaseModel {
    var prize_id: Int = 0
    var prize_name: String = ""
    var reward_value: Int = 0
    var valid_day: Int = 0
    var prize_status: Int = 0 //1-可领取 2-不可领取(查看)
    var desc: String = ""
    var event_id: Int = 0
    var img: String = ""
    
    required override init() {
        super.init()
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
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
}
