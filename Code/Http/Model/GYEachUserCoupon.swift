//
//  GYEachUserCoupon.swift
//  Reader
//
//  Created by CQSC  on 2017/8/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


enum GYCouponStatus: Int {
    case unEnable = 0 //"未激活"
    case enable = 1 //"激活"
    case used = 2 //"已使用"
    case outDate = 4 //"已过期"
    
}

final class GYEachUserCoupon: GYCouponItem, ResponseCollectionSerializable {

    var id: String = ""
    
    var coupon_type: String = ""

    var event_item_id: String = ""
    
    var event_name: String = ""
    
    var user_id: String = ""
    
    var coupon_id: String = ""
    
    var order_id: String = ""
    
    var status_name: String = ""
    
    var expiry_time: String = ""
    
    var event_id: String = ""
    
    var status: GYCouponStatus = .unEnable
    
    var add_time: String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "status" {
            if let value = value {
                if let s = GYCouponStatus.init(rawValue: "\(value)".integerValue()) {
                    status = s
                }
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
class GYCouponItem: MQIBaseModel {
    
    var product_id: String = ""
    
    var valid_day: String = ""
    
    var item_type: String = ""
    
    var valid_desc: String = ""
    
    var item_id: String = ""
    
    var coupon_name: String = ""
    
    var coupon_type_bgcolor: String = ""
    
    var coupon_value: String = ""
    
    var conpon_value_split: (String, String) {
        var index: Int = 0
        for c in coupon_value.unicodeScalars {
            if c.value > 57 {
                break
            }
            index += 1
        }
        let stringIndex = coupon_value.index(coupon_value.startIndex, offsetBy: index)
        return(coupon_value.substring(to: stringIndex), coupon_value.substring(from: stringIndex))
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        product_id = decodeStringForKey(aDecoder, key: "product_id")
        valid_day = decodeStringForKey(aDecoder, key: "valid_day")
        item_type = decodeStringForKey(aDecoder, key: "item_type")
        valid_desc = decodeStringForKey(aDecoder, key: "valid_desc")
        item_id = decodeStringForKey(aDecoder, key: "item_id")
        coupon_name = decodeStringForKey(aDecoder, key: "coupon_name")
        coupon_type_bgcolor = decodeStringForKey(aDecoder, key: "coupon_type_bgcolor")
        coupon_value = decodeStringForKey(aDecoder, key: "coupon_value")
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(product_id, forKey: "product_id")
        aCoder.encode(valid_day, forKey: "valid_day")
        aCoder.encode(item_type, forKey: "item_type")
        aCoder.encode(valid_desc, forKey: "valid_desc")
        aCoder.encode(item_id, forKey: "item_id")
        aCoder.encode(coupon_name, forKey: "coupon_name")
        aCoder.encode(coupon_type_bgcolor, forKey: "coupon_type_bgcolor")
        aCoder.encode(coupon_value, forKey: "coupon_value")
    }
}
class GYEachCoin: MQIBaseModel {
    
    var coin: String = ""
    var premium: String = ""
    
}
