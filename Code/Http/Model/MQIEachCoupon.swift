//
//  MQIEachCoupon.swift
//  Reader
//
//  Created by CQSC  on 2017/8/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


final class MQIEachCoupon: MQIBaseModel, ResponseCollectionSerializable {
    
    var add_time: String = ""
    
    var active_time: String = ""
    
    var expiry_time: String = ""
    
    var items: [GYCouponItem] = [GYCouponItem]()
    
    var event_id: String = ""
    
    var event_name: String = ""
    
    var alreadyShow: Bool = false
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "items" {
            items = setValueToArray(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override init() {
        super.init()
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        add_time = decodeStringForKey(aDecoder, key: "add_time")
        active_time = decodeStringForKey(aDecoder, key: "active_time")
        expiry_time = decodeStringForKey(aDecoder, key: "expiry_time")
        event_id = decodeStringForKey(aDecoder, key: "event_id")
        event_name = decodeStringForKey(aDecoder, key: "event_name")
        alreadyShow = decodeBoolForKey(aDecoder, key: "alreadyShow")
        if let items = decodeObjForKey(aDecoder, key: "items") as? [GYCouponItem] {
            self.items = items
        }
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(add_time, forKey: "add_time")
        aCoder.encode(event_name, forKey: "event_name")
        aCoder.encode(event_id, forKey: "event_id")
        aCoder.encode(expiry_time, forKey: "expiry_time")
        aCoder.encode(active_time, forKey: "active_time")
        aCoder.encode(alreadyShow, forKey: "alreadyShow")
        aCoder.encode(items, forKey: "items")
    }
}

final class MQIQueryFreelimitModel: MQIBaseModel, ResponseCollectionSerializable {
    var limit_free:Bool = false
    var limit_time:String = ""
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
        if key == "limit_free" {
            limit_free = getBoolWithValue(value)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
