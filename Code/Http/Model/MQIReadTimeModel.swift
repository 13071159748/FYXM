//
//  MQIReadTimeModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/5.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIReadTimeModel: MQIBaseModel,ResponseCollectionSerializable {
    
    var beginTime: NSInteger = 0
    
    var endTime: NSInteger = 0
    
    var today: String = ""
    
    var totalReadTime: NSInteger = 0
    
    var userAccount: String = "NoLogIn"
    
    var isAlreadySend: Bool = false
    
    var allDayReadTime: NSInteger = 0
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key ==  "isAlreadySend"{
            isAlreadySend = getBoolWithValue(value)
        }else if key == "beginTime"{
            beginTime = getIntWithValue(value)
        }else if key == "endTime"{
            endTime = getIntWithValue(value)
        }else if key == "totalReadTime"{
            totalReadTime = getIntWithValue(value)
        }else if key == "allDayReadTime"{
            allDayReadTime = getIntWithValue(value)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        beginTime = decodeIntegerForKey(aDecoder, key: "beginTime")
        endTime = decodeIntegerForKey(aDecoder, key: "endTime")
        today = decodeStringForKey(aDecoder, key: "today")
        totalReadTime = decodeIntegerForKey(aDecoder, key: "totalReadTime")
        userAccount = decodeStringForKey(aDecoder, key: "userAccount")
        isAlreadySend = decodeBoolForKey(aDecoder, key: "isAlreadySend")
        allDayReadTime = decodeIntegerForKey(aDecoder, key: "allDayReadTime")
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(beginTime, forKey: "beginTime")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(today, forKey: "today")
        aCoder.encode(totalReadTime, forKey: "totalReadTime")
        aCoder.encode(userAccount, forKey: "userAccount")
        aCoder.encode(isAlreadySend, forKey: "isAlreadySend")
        aCoder.encode(allDayReadTime, forKey: "allDayReadTime")
    }
}
