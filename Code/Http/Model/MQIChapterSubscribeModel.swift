//
//  GYChapterSubscribeModel.swift
//  Reader
//
//  Created by CQSC  on 16/10/11.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


final class MQIChapterSubscribeModel: MQIBaseModel, ResponseCollectionSerializable {
    
    var chapter_id: String = ""
    
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
    
}
