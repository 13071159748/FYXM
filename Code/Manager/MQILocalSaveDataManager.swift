//
//  MQILocalSaveDataManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


let Path_ReaderDirectory = NSHomeDirectory() + "/Library/" + "Caches/" + "Reader/"

let Path_BookStoreCacheDirectory = Path_ReaderDirectory + "BookStore/"

let Path_AdvertisingCacheDirectory = Path_ReaderDirectory + "Advertise/"

let Path_GoodJingpinCacheDirectory = Path_ReaderDirectory + "GoodJingpin/"

class MQILocalSaveDataManager: NSObject {
    //缓存数据，目前先直接把数据write到沙盒，以后有时间再换数据库
    
    //单例
    static var shared: MQILocalSaveDataManager {
        struct Static {
            static let instance: MQILocalSaveDataManager = MQILocalSaveDataManager()
        }
        return Static.instance
    }
    @discardableResult func SaveData_JingpinTitle(array:[MQIRankTypesModel]) -> Bool {//type name
        try? FileManager.default.createDirectory(atPath: Path_GoodJingpinCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        let path = Path_GoodJingpinCacheDirectory + "leftTitle.plist"
        try? FileManager.default.removeItem(atPath: path)
        return NSKeyedArchiver.archiveRootObject(array, toFile: path)
    }
    @discardableResult func SaveData_JingpinContents(array:[MQIRankRightSaveModel]) -> Bool {//rankType  books
        try? FileManager.default.createDirectory(atPath: Path_GoodJingpinCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        let path = Path_GoodJingpinCacheDirectory + "rightContents.plist"
        try? FileManager.default.removeItem(atPath: path)
        return NSKeyedArchiver.archiveRootObject(array, toFile: path)
    }

    //存储广告
    @discardableResult func SaveData_Advertising(_ advertise:MQISplashModel) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_AdvertisingCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        let path = Path_AdvertisingCacheDirectory + "advertise.plist"
        try? FileManager.default.removeItem(atPath: path)
        return NSKeyedArchiver.archiveRootObject(advertise, toFile: path)
    }

    //存储CHK精品书  limit这么多的数据
    @discardableResult func SaveDataCHK_Jingpin_Books(_ goodBooks:[MQIMainRecommendModel]) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let path = Path_BookStoreCacheDirectory + "CHK_goodBooks.plist"
        
        try? FileManager.default.removeItem(atPath: path)
        
        return NSKeyedArchiver.archiveRootObject(goodBooks, toFile: path)
    }
    
    //存储精品书  limit这么多的数据
    @discardableResult func SaveDataJingpin_Books(_ goodBooks:[MQIChoicenessListModel]) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let path = Path_BookStoreCacheDirectory + "goodBooks.plist"
        
        try? FileManager.default.removeItem(atPath: path)
        
        return NSKeyedArchiver.archiveRootObject(goodBooks, toFile: path)
    }
    //存储推荐书籍
    @discardableResult func SaveDataBookStore_Recommends(_ recommends:[MQIMainRecommendModel]) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let path = Path_BookStoreCacheDirectory + "recommendsCache.plist"
        
        try? FileManager.default.removeItem(atPath: path)
        
        return NSKeyedArchiver.archiveRootObject(recommends, toFile: path)
    }
    
    //存储Nav
    @discardableResult func SaveDataBookStore_Nav(_ navs:[MQIMainNavModel]) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let path = Path_BookStoreCacheDirectory + "navCache.plist"
        
        try? FileManager.default.removeItem(atPath: path)
        
        return NSKeyedArchiver.archiveRootObject(navs, toFile: path)
    }
    
    //存储banner
    @discardableResult func SaveDataBookStore_Banner(_ banners:[MQIMainBannerModel]) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let path = Path_BookStoreCacheDirectory + "bannerCache.plist"
        
        try? FileManager.default.removeItem(atPath: path)
        
        return NSKeyedArchiver.archiveRootObject(banners, toFile: path)
        
    }
    //存储书架推荐书
    @discardableResult func SaveDataShelf_dailyTip(_ tip:MQIShelfDailyTipsModel) -> Bool {
        try? FileManager.default.createDirectory(atPath: Path_BookStoreCacheDirectory, withIntermediateDirectories: true, attributes: nil)

        let path = Path_BookStoreCacheDirectory + "shelfdailyTips.plist"

        try? FileManager.default.removeItem(atPath: path)

        return NSKeyedArchiver.archiveRootObject(tip, toFile: path)

    }
    //启动页广告
    func readData_advertise() -> MQISplashModel {
        let path = Path_AdvertisingCacheDirectory + "advertise.plist"
        var constraints = MQISplashModel()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! MQISplashModel
        }
        return constraints
    }

    
    //读取
    //leftTitle.plist rightContents.plist
    func readDataJingpin_LeftTitle() -> [MQIRankTypesModel] {
        let path = Path_GoodJingpinCacheDirectory + "leftTitle.plist"
        var constraints = [MQIRankTypesModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIRankTypesModel]
        }
        return constraints
    }
    func readDataJingpin_rightContents() -> [MQIRankRightSaveModel] {
        let path = Path_GoodJingpinCacheDirectory + "rightContents.plist"
        var constraints = [MQIRankRightSaveModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIRankRightSaveModel]
        }
        return constraints
    }
    
    func readDataShelf_dailyTip() -> MQIShelfDailyTipsModel {
        let path = Path_BookStoreCacheDirectory + "shelfdailyTips.plist"
        var constraints = MQIShelfDailyTipsModel()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! MQIShelfDailyTipsModel
        }
        return constraints
    }
    
    //读取CHK精品
    func readDataCHK_Jingpin_books() -> [MQIMainRecommendModel] {
        let path = Path_BookStoreCacheDirectory + "CHK_goodBooks.plist"
        var constraints = [MQIMainRecommendModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIMainRecommendModel]
        }
        return constraints
    }
    
    //读取精品
    func readDataJingpin_books() -> [MQIChoicenessListModel] {
        let path = Path_BookStoreCacheDirectory + "goodBooks.plist"
        var constraints = [MQIChoicenessListModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIChoicenessListModel]
        }
        return constraints
    }
    //读取
    func readDataBookStore_Banner() -> [MQIMainBannerModel] {
        let path = Path_BookStoreCacheDirectory + "bannerCache.plist"
        var constraints: [MQIMainBannerModel] = [MQIMainBannerModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIMainBannerModel]
        }
        return constraints
    }
    //读取
    func readDataBookStore_Nav() -> [MQIMainNavModel] {
        let path = Path_BookStoreCacheDirectory + "navCache.plist"
        var constraints: [MQIMainNavModel] = [MQIMainNavModel]()
        if FileManager.default.fileExists(atPath: path) {
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIMainNavModel]
        }
        return constraints
    }
    //读取
    func readDataBookStore_Recommends() -> [MQIMainRecommendModel] {
        let path = Path_BookStoreCacheDirectory + "recommendsCache.plist"
        //        let path2 = Path_BookStoreCacheDirectory + "recommendsEachCache.plist"
        
        var constraints: [MQIMainRecommendModel] = [MQIMainRecommendModel]()
        /*
         if FileManager.default.fileExists(atPath: path) && FileManager.default.fileExists(atPath: path2){
         
         let array = NSKeyedUnarchiver.unarchiveObject(withFile: path2) as! NSMutableArray
         
         constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [GDMainRecommendModel]
         
         for i in 0...(constraints.count-1) {
         constraints[i].books = array[i] as! [MQIMainEachRecommendModel]
         }
         
         }
         */
        if FileManager.default.fileExists(atPath: path){
            
            constraints = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [MQIMainRecommendModel]
            
        }
        //        for model in constraints {
        //            MQLog(model.books.count)
        //        }
        return constraints
    }
    
    
}
