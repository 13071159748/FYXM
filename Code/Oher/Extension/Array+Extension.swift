//
//  Array+Extension.swift
//  Reader
//
//  Created by CQSC  on 2017/7/1.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
