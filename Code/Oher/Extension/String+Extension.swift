//
//  String+Extension.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func GetLocalPathSize() -> CGFloat{
        var size: CGFloat = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! CGFloat
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! CGFloat
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size

    }
    /**
     String 的 length
     
     - returns: Int
     */
    var length:Int {
        get{return (self as NSString).length}
    }
    
    /**
     String 转换 intValue = int32Value
     
     - returns: Int
     */
    func int32Value() ->Int32{
        return NSString(string: self).intValue
    }
    
    /**
     String 转换 boolValue
     
     - returns: Bool
     */
    func boolValue() ->Bool{
        return NSString(string: self).boolValue
    }
    
    /**
     String 转换 integerValue
     
     - returns: Int
     */
    func integerValue() ->Int{
        return NSString(string: self).integerValue
    }
    
    /**
     String 转换 floatValue
     
     - returns: float
     */
    func floatValue() ->Float{
        return NSString(string: self).floatValue
    }
    
    /**
     String 转换 CGFloatValue
     
     - returns: CGFloat
     */
    func CGFloatValue() ->CGFloat{
        return CGFloat(self.floatValue())
    }
    
    /**
     String 转换 doubleValue
     
     - returns: double
     */
    func doubleValue() ->Double{
        return NSString(string: self).doubleValue
    }
    
    /**
     截取字符串
     
     - returns: String
     */
    func substring(_ range:NSRange) ->String {
        let length = NSString(string: self).length - range.location
        if length < range.length {
            return NSString(string: self).substring(with: NSMakeRange(range.location, length))
        }else {
            return NSString(string: self).substring(with: range)
        }
    }
    
    /**
     获得文件的后缀名（不带'.'）
     
     - returns: String
     */
    func pathExtension() ->String {
        
        return NSString(string: self).pathExtension
    }
    
    /**
     从路径中获得完整的文件名（带后缀）
     
     - returns: String
     */
    func lastPathComponent() ->String {
        
        return NSString(string: self).lastPathComponent
    }
    
    /**
     获得文件名（不带后缀）
     
     - returns: String
     */
    func stringByDeletingPathExtension() ->String {
        
        return NSString(string: self).deletingPathExtension
    }
    
    /**
     字符串MD5加密
     
     - returns: MD5加密好的字符串
     */
//    func md5() ->String!{
//        
//        let str = self.cString(using: String.Encoding.utf8)
//        
//        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
//        
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        
//        for i in 0 ..< digestLen {
//            
//            hash.appendFormat("%02x", result[i])
//        }
//        
//        result.deinitialize()
//        
//        return String(format: hash as String)
//    }
    
    /// 计算字符串大小
    func size(font:UIFont,constrainedToSize:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize {
        
        let string:NSString = self as NSString
        
        return string.boundingRect(with: constrainedToSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [.font:font], context: nil).size
    }
    
    /// 正则替换字符
    func replacingCharacters(pattern:String, template:String) ->String {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, length), withTemplate: template)
            
        } catch {return self}
    }
    
    ///返回第一次出现的指定子字符串在此字符串中的索引
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]

            return String(subString)
        } else {
            return self
        }
    }
    
    func has(_ s: String) -> Bool {
        if (self.range(of: s) != nil) {
            return true
        } else {
            return false
        }
    }
    
    /// 替换字符串
    func trimmingSpaceAndReturnWordWithStr(oldStr: String, newStr: String) -> String {
        var str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        str = (str as NSString).replacingOccurrences(of: oldStr, with: newStr)
        return str
    }
    
    func substring(location index:Int, length:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index + length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
}

extension NSAttributedString{
    
    /// 计算多态字符串的size
    func size(constrainedToSize:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize{
        
        return self.boundingRect(with: constrainedToSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], context: nil).size
    }
    
    
    
    
}
