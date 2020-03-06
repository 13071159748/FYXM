//
//  MQIRegisterManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

public func isMobileNumber(yourNum:String) -> Bool{
    if yourNum.length >= 2 {
        let numberString = (yourNum as NSString).substring(with: NSMakeRange(0, 2))
        let number = Int(numberString)
        if number==13 || number == 14 || number == 15 || number == 17 || number == 18 {
            return true
        }
    }
    
    return false
}
class MQIRegisterManager: NSObject {
    fileprivate static var __once: () = {
        Inner.instance = MQIRegisterManager()
    }()
    
    var timer: Timer!
    var allow: Bool = true
    
    var change: ((_ count: Int) -> ())?
    var changeEnd: (() -> ())?
    
    var mobile_Number:String = ""
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIRegisterManager?
    }
    
    class var shared: MQIRegisterManager {
        _ = MQIRegisterManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MQIRegisterManager.timeAction), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
    }
    
    func begin() {
        allow = false
        timer.fireDate = Date.distantPast
    }
    
    var count: Int = 0
    @objc func timeAction() {
        count += 1
        change?(120-count)
        if count > 120 {
            changeEnd?()
            timer.fireDate = Date.distantFuture
            count = 0
            allow = true
        }
    }

}
