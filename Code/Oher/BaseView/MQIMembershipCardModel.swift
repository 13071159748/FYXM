//
//  MQIMembershipCardModel.swift
//  CHKReader
//
//  Created by moqing on 2019/5/6.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIMembershipCardDataModel: MQIBaseModel{
    
    var cards = [MQIMembershipCardItemModel]()
    
    var data = [MQIMembershipCardItemModel]()
    
    var total:String = ""
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "cards" {
           cards =  setValueToArray(value, key: key)
        }else if key == "data" {
            data =  setValueToArray(value, key: key)
        }else{
           super.setValue(value, forKey: key)
        }
       
    }
    


}


final class  MQIMembershipCardItemModel: MQIBaseModel, ResponseCollectionSerializable{
    
    var product_id: String  = ""
    var currency: String  = ""{
        didSet(oldValue) {
            if currency == "USD" {
                currency_code = "US$"
            }else if currency == "CNY"  {
                currency_code = "CN¥"
            }else{
                currency_code = currency
            }
        }
    }
     var price_value: String  = ""
     var coin: String  = ""
     var premium: String  = ""
     var type: String  = ""
    // 币种 CHN
    var currency_code:String = ""
    
    var desc:String = ""
    /// unreceive待领取  received 已领取
    var status:String = ""
    
    var expired:String = "" {
        didSet(oldValue) {
           expired_str = getTimeStampToString(expired, format: "yyyy-MM-dd")
        }
    }
    var daily_receive:String = ""
    
    var expired_str :String = ""
    
    
    /// 量订阅折扣相关
    var start_chapter_title :String = "" /// 起始章节名称（包含）
    var end_chapter_title :String = "" /// 结束章节名称（包含）
    var count :String = "" /// 章节数
    var price :String = "" /// 原价
    var discount :String = "" /// 折后价
    var discount_desc :String = "" /// 折后价描述
    
     var origin_price :String = "" /// 原价
     var real_price :String = "" /// 实际订阅价格
    
    
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    
}
