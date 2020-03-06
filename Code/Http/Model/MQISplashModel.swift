//
//  MQISplashModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQISplashModel: MQIBaseModel {

    var id:String = ""
    var title:String = ""
    var type:String = ""
    var start_time:String = ""
    var end_time:String = ""
    var url:String = ""
    var desc:String = ""
    var book_id:String = ""
    var image:String = ""
    
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    

}

class MQIShelfDailyTipsModel: MQIBaseModel {
    //    var id: String = ""
    //    var book_id: String = ""
    var desc: String = ""
    //    var author:String = ""
    var add_time:String = ""
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
}
