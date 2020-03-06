//
//  MQIPayTypeManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

/// 判断
func iSAvailable() -> Bool
{return MQIPayTypeManager.shared.isAvailable()}

enum payType: String {
    case inPurchase = "inPurchase"
    case other = "other"
}
let kPayType = "kPayType"

class MQIPayTypeManager: NSObject {
    fileprivate static var __once: () = {
        Inner.instance = MQIPayTypeManager()
    }()
    
    public var type: payType = .inPurchase {
        didSet {
            UserDefaults.standard.set(type.rawValue, forKey: kPayType)
        }
    }
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIPayTypeManager?
    }
    
    class var shared: MQIPayTypeManager {
        _ = MQIPayTypeManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        config()
        
    }
    func isAvailable() -> Bool {
        return (type == .other) ? true:false
//        return true
    }
    
    func config() {
        if let s = UserDefaults.standard.object(forKey: kPayType) as? String {
            if s == payType.inPurchase.rawValue {
                request()
            }else {
                type = .other
                request()
            }
        }else {
            request()
        }
   
    }
    
    var count: Int = 0
    func request() {
        GYPayTypeRequest().request({[weak self] (request, response, result: MQIPayModel) in
            if let strongSelf = self {
                if result.result == true {
                    strongSelf.type = .inPurchase
                }else {
                    strongSelf.type = .other
                }
            }
        }) {[weak self] (err_msg, err_code) in
            if let strongSelf = self {
                strongSelf.count += 1
                if strongSelf.count <= 3 {
                    strongSelf.request()
                }else {
                }
            }
        }
    }
}

class MQIPayModel: MQIBaseModel {
    
    var result: Bool = false
    
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "result" {
            result = getBoolWithValue(value)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
