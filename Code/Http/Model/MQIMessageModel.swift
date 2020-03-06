//
//  MQIMessageModel.swift
//  CHKReader
//
//  Created by moqing on 2019/1/24.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

/// 消息中心
final class MQIMessageModel: MQIBaseModel,ResponseCollectionSerializable{
    
    var id:String = "" //id
    var title: String = ""
    var content: String = ""
    var status_code: String = "" /* unread  readed*/
    var add_time:String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
    }
}
