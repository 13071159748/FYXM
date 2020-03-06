//
//  AAEnterReaderType.swift
//  Reader
//
//  Created by CQSC  on 2018/1/15.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


enum EnterReaderType:String {
    case enterType_0 = "enterType_0"//从首页进来的就要去0页码，不要-1
    case enterType_normal = "enterType_normal"
}

class AAEnterReaderType: NSObject {

    static var shared: AAEnterReaderType {
        struct Static {
            static let instance: AAEnterReaderType = AAEnterReaderType()
        }
        return Static.instance
    }
    public var enterType: EnterReaderType = .enterType_normal
    
}
