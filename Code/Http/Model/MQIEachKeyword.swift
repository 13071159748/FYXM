//
//  MQIEaMQIeyword.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIEaMQIeyword: MQIBaseModel, ResponseCollectionSerializable {
    
    var key: String = ""
    
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [MQIEaMQIeyword] {
        var array = [MQIEaMQIeyword]()
        if let representation = representation as? [String] {
            for s in representation {
                let obj = MQIEaMQIeyword()
                obj.key = s
                array.append(obj)
            }
        }
        return array
    }
    
}
