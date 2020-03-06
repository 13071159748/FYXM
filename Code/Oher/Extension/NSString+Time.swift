//
//  NSString+Time.swift
//  YH
//
//  Created by CQSC  on 15/5/7.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//


import Foundation

extension String {
    
    func secondString() -> String {
        let seconds = (self as NSString).doubleValue
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let timeStamp = formatter.string(from: date) as String
        return timeStamp
    }
    
    func secString() -> String {
        let seconds = (self as NSString).doubleValue
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStamp = formatter.string(from: date) as String
        return timeStamp
    }
    
    func formatterDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)!
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func stringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self)
        
        let fromzone = TimeZone.current
        let formainterval = fromzone.secondsFromGMT(for: date!)
        let fromDate = date?.addingTimeInterval(TimeInterval(formainterval))
        return fromDate!
    }
    
    
    func consumeStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.date(from: self)
        
        let fromzone = TimeZone.current
        let formainterval = fromzone.secondsFromGMT(for: date!)
        let fromDate = date?.addingTimeInterval(TimeInterval(formainterval))
        return fromDate!
    }
}
