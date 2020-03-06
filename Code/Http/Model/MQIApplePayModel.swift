//
//  MQIApplePayModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/8/13.
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
    var order_id: String = ""
    var money: String = ""
    var userId: String = ""
    var product_id: String = ""
    var identifier: String = ""
    var createDateStr:String = ""
    
    override init() {
        super.init()
        
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
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(recepit, forKey: "recepit")
        aCoder.encode(order_id, forKey: "order_id")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(product_id, forKey: "product_id")
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(createDateStr, forKey: "createDateStr")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}
