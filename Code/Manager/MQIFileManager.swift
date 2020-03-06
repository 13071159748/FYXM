//
//  MQIFileManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import SDWebImage

let gServiceName = "gReaderService"
let gReaderName = "gReader"
let applePayPath = "applePay.plist"
let applePayPathNew = "applePayNew.plist"

class MQIFileManager: NSObject {
    var appPayPath = MQIFileManager.getCurrentStoreagePath(applePayPath)
    @discardableResult class func creatPathIfNecessary(_ path: String) -> Bool {
        var suc = true
        let fm = FileManager.default
        if fm.fileExists(atPath: path) == false {
            if (NSString(string: path)).pathExtension != "" {
                suc = fm.createFile(atPath: path, contents: nil, attributes: nil)
            }else {
                do {
                    try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    suc = true
                } catch _ {
                    suc = false
                }
            }
        }
        return suc
    }
    static var lock = NSLock()
    class func saveChapterContent(_ bid: String, tid: String, content: String) {
        lock.lock()
        let path = MQIFileManager.getReaderStoreagePath(bid)
        let chapterPath = NSString(string: path).appendingPathComponent("\(tid).html")
        var suc: Bool
        do {
            try content.write(toFile: chapterPath, atomically: true, encoding: String.Encoding.utf8)
            suc = true
        } catch _ {
            suc = false
        }
        
        if suc == false {
        }
        lock.unlock()
    }
    class func getSupportPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        
        let supportPath = paths[0] as! String
        MQIFileManager.creatPathIfNecessary(supportPath)
        return supportPath
    }
    class func getChapterContent(_ bid: String, tid: String) -> String? {
        let bookPath = MQIFileManager.getReaderStoreagePath(bid)
        let chapterPath = NSString(string: bookPath).appendingPathComponent("\(tid).html")
        //判断本地文件是否存在
        if !FileManager.default.fileExists(atPath: chapterPath) {
            return nil
        }
        let content = try? NSString(contentsOfFile: chapterPath, encoding: String.Encoding.utf8.rawValue)
        if content != nil {
            if content!.length > 0 {
                return content! as String
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    class func getReaderStoreagePath(_ filename: String) -> String {
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string: path).appendingPathComponent(gReaderName)
        MQIFileManager.creatPathIfNecessary(sPath)
        let fPath = NSString(string: sPath).appendingPathComponent(filename) as String
        MQIFileManager.creatPathIfNecessary(fPath)
        return fPath
    }
    class func getCachesPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let cachesPath = paths[0]
        MQIFileManager.creatPathIfNecessary(cachesPath)
        return cachesPath
    }
    class func getChapterList(_ bid: String) -> [MQIEachChapter]? {
        let bookPath = MQIFileManager.getCurrentStoreagePath(bid)
        let chapterPath = NSString(string: bookPath).appendingPathComponent("readChapter.plist")
        removeLastVersonChapterList(bid)
        return MQIFileManager.getObject(chapterPath) as? [MQIEachChapter]
    }
    class func saveChapterList(_ bid: String, list: [MQIEachChapter]) {
        let path = MQIFileManager.getCurrentStoreagePath(bid)
        let chapterPath = NSString(string: path).appendingPathComponent("readChapter.plist")
        dispatchArchive(list, path: chapterPath)
    }
    
    
    
    //储存支付列表
    class func saveApplePayList(list: [MQIApplePayModel]) {
        lock.lock()
        NSKeyedArchiver.archiveRootObject(list, toFile:MQIFileManager.getCurrentStoreagePath(applePayPath))
        lock.unlock()
    }
    //读取支付列表
    class func readApplePayList()-> [MQIApplePayModel]{
        lock.lock()
        let infoPath = MQIFileManager.getCurrentStoreagePath(applePayPath)
        if FileManager.default.fileExists(atPath: infoPath) {
            if let bookPathsInfo = NSKeyedUnarchiver.unarchiveObject(withFile: infoPath) as? [MQIApplePayModel]{
                lock.unlock()
                return bookPathsInfo
            }else{
                lock.unlock()
                return [MQIApplePayModel]()
            }
            
        }else{
            lock.unlock()
            return [MQIApplePayModel]()
        }
    }
    
    
    
    //储存支付列表
    class func saveApplePayListNew(list: [MQIApplePayModelNew]) {
        lock.lock()
        NSKeyedArchiver.archiveRootObject(list, toFile:MQIFileManager.getCurrentStoreagePath(applePayPathNew))
        lock.unlock()
    }
    //读取支付列表
    class func readApplePayListNew()-> [MQIApplePayModelNew]{
        lock.lock()
        let infoPath = MQIFileManager.getCurrentStoreagePath(applePayPathNew)
        if FileManager.default.fileExists(atPath: infoPath) {
            if let bookPathsInfo = NSKeyedUnarchiver.unarchiveObject(withFile: infoPath) as? [MQIApplePayModelNew]{
                lock.unlock()
                return bookPathsInfo
            }else{
                lock.unlock()
                return [MQIApplePayModelNew]()
            }
            
        }else{
            lock.unlock()
            return [MQIApplePayModelNew]()
        }
    }
    class func removeLastVersonChapterList(_ bid: String) {
        /*
         由于之前的 存储存在问题 删掉之前的 重新保存
         */
        let bookPath = MQIFileManager.getCurrentStoreagePath(bid)
        let chapterPath = NSString(string: bookPath).appendingPathComponent("chapter.plist")
        if MQIFileManager.checkFileIsExist(chapterPath) {
            MQIFileManager.removePath(chapterPath)
        }
    }
    //MARK: --
    @discardableResult class func getObject(_ path: String) -> AnyObject? {
        if MQIFileManager.checkFileIsExist(path) == true {
            let obj: AnyObject? = NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject
            if obj != nil{
                return obj
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    @discardableResult class func getCurrentStoreagePath(_ filename: String) -> String {
        let path = MQIFileManager.getSupportPath()
        let sPath = (NSString(string: path)).appendingPathComponent(gServiceName)
        MQIFileManager.creatPathIfNecessary(sPath)
        let fPath = (NSString(string: sPath)).appendingPathComponent(filename) as String
        MQIFileManager.creatPathIfNecessary(fPath)
        return fPath
    }
    
    @discardableResult class func checkFileIsExist(_ path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path, isDirectory: nil) == true {
            return true
        }else {
            return false
        }
    }
    
    @discardableResult class func removePath(_ path: String) -> Bool {
        if MQIFileManager.checkFileIsExist(path) == true {
            var suc: Bool
            do {
                try FileManager.default.removeItem(atPath: path)
                suc = true
            } catch _ {
                suc = false
            }
            return suc
        }else {
            return true
        }
    }
    
    class func removeChapterContent(_ bid: String) {
        let list = self.getChapterList(bid)
        if list != nil {
            for i in 0..<list!.count {
                let chapter = list![i]
                //                let path = GYFileManager.getReaderStoreagePath(bid)
                //                let chapterPath = NSString(string: path).appendingPathComponent("\(chapter.chapter_id).html")
                //                let suc = GYFileManager.removePath(chapterPath)
                //                if suc == true {
                chapter.isDown = false
                //                }
            }
            MQIFileManager.saveChapterList(bid, list: list!)
        }
    }
    
}
