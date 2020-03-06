//
//  GYEachOrder.swift
//  Reader
//
//  Created by CQSC  on 16/9/25.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


class GYEachOrder: MQIBaseModel {
    var id: String = ""
    var order_id: String = ""
    var user_id: String = ""
    var order_fee: String = ""
    var order_coin: String = ""
    var order_premium: String = ""
    var order_create_time: String = ""
    var order_modify_time: String = ""
    var channel_id: String = ""
    var channel_name: String = ""
    var order_status: String = ""
}

class GYWXOrderModel: MQIBaseModel {
    
    var appid: String = ""
    var partnerid: String = ""
    var prepayid: String = ""
    var package: String = ""
    var noncestr: String = ""
    var timestamp: String = ""
    var sign: String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}

class GYAlipayOrderModel: MQIBaseModel {
    var order: String = ""
    var url: String = ""
}

class GYWXHttpOrderModel: MQIBaseModel {
    var value: String = ""
}
