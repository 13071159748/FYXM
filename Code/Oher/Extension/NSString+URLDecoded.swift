//
//  NSString+URLDecoded.swift
//  Reader
//
//  Created by CQSC  on 16/9/25.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import Foundation

extension String {
    
    func urlEncoded()->String {
        let res:NSString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self as NSString, nil,
                                                                   "!*'();:@&=+$,/?%#[]" as CFString?, CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))
        return res as String
    }
    
    func urlDecoded()->String {
        let res:NSString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, self as NSString, "" as CFString?, CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))
        return res as String
    }
    
//    func range()->Range<String.Index> {
//        return Range<String.Index>(startIndex ..< endIndex)
//    }
    
}
