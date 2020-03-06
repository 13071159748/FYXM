//
//  MQIReadProgressModel.swift
//  Reader
//
//  Created by CQSC  on 2018/1/26.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class MQIReadProgressModel: MQIBaseModel {
    
    var book_id :String = ""
    var book_name:String = ""
    var chapter_id :String = ""
    var chapter_title:String = ""
    var chapter_code:String = ""
    var position:String = ""
    var readtime:String = ""
    
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
