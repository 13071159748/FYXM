//
//  MQIEachOrderLog.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIEachOrderLog: MQIBaseModel,ResponseCollectionSerializable {
    
    var id: String = ""
    var order_id: String = ""
    var order_type: String = ""
    var user_id: String = ""
    var order_fee: String = ""
    var order_coin: String = ""
    var order_premium: String = ""
    var order_subject_num: String = ""
    var order_create: String = ""
    var order_modify: String = ""
    var channel_id: String = ""
    var order_status: String = ""
    var out_channel: String = ""
    var notify_id: String = ""
    var order_from: String = ""
    var site: String = ""
    var out_channel_2: String = ""
    var book_id: String = ""
    var channel_code: String = ""
    var channel_name: String = ""
    var channel_info: String = ""
    var channel_scale: String = ""
    var channel_account: String = ""
    ///名称说明
    var product_name: String = ""
    // 币种 CHN
    var currency_code:String = ""{
        didSet(oldValue) {
            if currency_code == "USD" {
                currencyStr = "US$"
            }else if currency_code == "CNY"  {
                currencyStr = "CN¥"
            }else{
                currencyStr = currency_code
            }
        }
    }
    var currencyStr:String = "" // 币种 CH¥
    override init() {
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    

}
