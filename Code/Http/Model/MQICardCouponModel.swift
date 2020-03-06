//
//  MQICardCouponModel.swift
//  CQSC
//
//  Created by BigMac on 2019/12/23.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardCouponModel: MQIBaseModel {
    
    var data = [MQICardCouponItemModel]()
    var total: Int = 0
    
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
        
        if key == "data" {
            data = setValueToArray(value, key: key)
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
    
}


final class MQICardCouponItemModel: MQIBaseModel {
    
    var user_id: Int = -1
    var start_time: Int = -1
    var expiry_time: Int = -1
    var status: Int = -1        ///1：未使用 2已使用
    var prize_id: Int = -1
    var prize_type: Int = -1    ///道具类型 1魔豆卡（充值送豆）  10：充值满X送豆  20：购买打折卡送豆  30：补签卡 31：签到X倍卡
    var prize_name: String = ""
    var reward_value: Int = -1  ///奖励值（豆）
    var reward_title: String = ""   ///单位
    var valid_day: Int = -1     ///有效期，以天位单位，如果是0
    var desc: String = ""
    var img: String = ""
    var url: String = ""        ///跳转地址
    var expend: Bool = false    ///desc是否展开
    
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
