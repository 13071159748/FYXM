//
//  MQIUpLoadModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/26.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUpLoadModel: MQIBaseModel {
    var code: Int = 0
    var url:  String = ""
    var msg:  String = ""
    var desc: String = ""
    var data = MQIUpLoadItemModel()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setDictToModel(value, key: key)
        }else {
             super.setValue(value, forKey: key)
        }
    
    }
    
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
    }
}

class MQIUpLoadItemModel: MQIBaseModel {

    var avatar_url:  String = ""

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
    }
}
