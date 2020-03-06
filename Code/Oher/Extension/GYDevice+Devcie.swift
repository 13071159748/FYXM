//
//  GYDevice+Devcie.swift
//  Reader
//
//  Created by CQSC  on 16/9/23.
//  Copyright © 2016年  CQSC. All rights reserved.
//


public extension UIDevice {
    
    var modelStr:String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return "\(identifier) Mobile"
    }
    
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5 Mobile"
        case "iPod7,1":                                 return "iPod Touch 6 Mobile"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4 Mobile"
        case "iPhone4,1":                               return "iPhone 4s Mobile"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5 Mobile"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c Mobile"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s Mobile"
        case "iPhone7,2":                               return "iPhone 6 Mobile"
        case "iPhone7,1":                               return "iPhone 6 Plus Mobile"
        case "iPhone8,1":                               return "iPhone 6s Mobile"
        case "iPhone8,2":                               return "iPhone 6s Plus Mobile"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7 Mobile"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus Mobile"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X Mobile"
        case "iPhone11,2":                              return "iPhone XS Mobile"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max Mobile"
        case "iPhone11,8":                              return "iPhone XR Mobile"
        case "iPhone10,1","iPhone10,4":                 return "iPhone 8 Mobile"
        case "iPhone10,2","iPhone10,5":                 return "iPhone 8 plus Mobile"
        case "iPhone8,4":                               return "iPhone SE Mobile"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2 Mobile"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3 Mobile"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4 Mobile"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air Mobile"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2 Mobile"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini Mobile"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2 Mobile"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3 Mobile"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4 Mobile"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro Mobile"
        case "AppleTV5,3":                              return "Apple TV Mobile"
        //        case "i386", "x86_64":                          return "Simulator Mobile"
        case "i386", "x86_64":                          return "iPhone Mobile"
        default:                                        return "\(identifier) Mobile"
        }
    }
}
