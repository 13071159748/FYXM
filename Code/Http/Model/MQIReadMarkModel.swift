//
//  MQIReadMarkModel.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadMarkModel: MQIBaseModel {
    
    /// 小说ID
    var bookId:String!
    
    /// 章节ID
    var id:String!
    
    /// 章节名称
    var name:String!
    
    /// 内容
    var content:String!
    
    /// 时间
    var time:Date!
    
    /// 位置
    var location:NSNumber!
    
    // MARK: -- init
    
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
    
}
