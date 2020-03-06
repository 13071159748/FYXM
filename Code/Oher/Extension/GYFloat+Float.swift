//
//  GYFloat+Float.swift
//  Reader
//
//  Created by CQSC  on 16/9/13.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit



extension Float {

    mutating func doubleDecimals() {
        let str = NSString(format: "%.2f", self)
        let num = str.floatValue
        self = num
    }
    
}
