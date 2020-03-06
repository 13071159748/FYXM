//
//  GDGoodModel.swift
//  Reader
//
//  Created by CQSC  on 2018/1/22.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit

//精品
class MQIGoodModel: MQIBaseModel {
    
}

class MQIRankRightSaveModel:MQIBaseModel {
    var rank_type:String = "0"
    var books = [MQIMainEachRecommendModel]()
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "books" {
            books = setValueToArray(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        rank_type = decodeStringForKey(aDecoder, key: "rank_type")
        books = decodeObjForKey(aDecoder, key: "books") as! [MQIMainEachRecommendModel]
        
    }
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(rank_type, forKey: "rank_type")
        aCoder.encode(books, forKey: "books")
        
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        fatalError("init(response:representation:) has not been implemented")
    }
    
    required init(jsonDict: [String : Any]) {
        fatalError("init(jsonDict:) has not been implemented")
    }
    
}
