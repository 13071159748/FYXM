//
//  MQIApplePayListModel.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/8/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIApplePayListModel: MQIBaseModel {
    
    var data = [MQIApplePayItemModel]()
    /// 测试0
    var is_review:String = ""
    
    var banner = MQIApplePayItemModel()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setValueToArray(value, key: key)
        }else if key == "banner" {
            banner = setDictToModel(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    required override init() {
        super.init()
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
}
class MQIApplePayItemModel: MQIBaseModel {
    
    var id: String = ""
    var name: String = ""
    var price: String = ""
    var priceValue: String = ""
    var premium: String = ""
    var first: String = ""
    var recommend: String = ""
    var discount:String = ""
    var describe:String = ""
    var prize:String = ""
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
    var channel_code:String = ""//支付渠道"
    var type:String = "" // recommend  acvi
    
    var isSelected:Bool = false
    
    
    var image:String  = ""
    ///fuel
    var url: String = ""
    var product_id:String = ""
    var badge_color:String = ""
    var badge_text:String = ""
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    required override init() {
        super.init()
        
    }
    override func encode(with aCoder: NSCoder) {
        
    }
}
