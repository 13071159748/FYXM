//
//  MQIDataUtil.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/15.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
//import HandyJSON


enum DataUtilType:String {
    case bookInfo = "bookInfo"
    case chapter  = "chapter"
    case user  = "user"
    case ShelfBooks  = "ShelfBooks"
}



struct MQIDataUtil {
    
    func conversionData<T>(type:DataUtilType) -> T? {
        if type == .user {
            return MQIBaseModel() as? T
        }
        else if type == .chapter{
            return MQIBaseModel() as? T
        }
        else if type == .bookInfo{
            return MQIBaseModel() as? T
        }
        return nil
       
    }
    
    func conversionData<T>(type:DataUtilType) -> [T]?  {
        if type == .ShelfBooks {
            return [MQIBaseModel]() as? [T]
        }
        return nil
    }
    
    /// MQIPlanManager 本地书否刷新过书籍信息*
    /// MQICommentManager 点赞 *
    /// MQISearchResultsManager 搜索历史*
    /// MQIUserManager  用户信息*
    /// MQIRecentBookManager 阅读记录
    /// MQIShelfManager 网络书籍本地数据
    /// GYBookManager 这个有book信息  有订阅信息

    /*
        阅读记录  ：「
      1.最后阅读记录  MQILastReaderManager
      2.阅读历史 MQIRecentBookManager
     */

    
}

extension MQIDataUtil {
    
    static  func conversionTokenAndFileData(_ userPath:String , block:((String?)->())?) {
        /// 1新标志位有值，旧的标志位有值
        if  UserDefaults.standard.object(forKey: "xm_conversionToken_new") == nil  &&  UserDefaults.standard.object(forKey: kPayType) !=  nil   {
            MQIRecentBookManager.shared.refershBooks()
            MQIShelfManager.shared.getFileBook()
            /// 2本地是否有用户数据
            if MQIFileManager.checkFileIsExist(userPath) == true {
                let userOld = NSKeyedUnarchiver.unarchiveObject(withFile: userPath) as? MQIUserModel
                /// 3.有用户且不超过重试次数
                if userOld  != nil {
                    /// 4.转换
                    MQIUserManager.shared.user = userOld
                    MQIUserManager.shared.saveUser()
                    MQIFileManager.removePath(userPath)
                    MQIUserManager.shared.user = MQIDataUtil.getdbUser()
                }else {
                    /// 3  没有用户且超过重试次数->退登
                    MQIUserManager.shared.user = MQIDataUtil.getdbUser()
                    if !MQIUserManager.shared.checkIsLogin() {
                        MQIUserManager.shared.user = nil
                        MQIFileManager.removePath(userPath)
                        UserNotifier.postNotification(.login_out)
                        block?(nil)
                    }else{
                        MQIFileManager.removePath(userPath)
                        MQIUserManager.shared.user = MQIDataUtil.getdbUser()
                        block?(nil)
                    }
                    
                }
                UserDefaults.standard.set("new_token", forKey: "xm_conversionToken_new")
                UserDefaults.standard.synchronize()
            }else{
                /// 2 本地没有数据->退登  查看数据库是否有数据 没有没登录 ->退登
                UserDefaults.standard.set("new_token", forKey: "xm_conversionToken_new")
                UserDefaults.standard.synchronize()
                MQIUserManager.shared.user = MQIDataUtil.getdbUser()
                if  !MQIUserManager.shared.checkIsLogin() {
                    MQIUserManager.shared.user = nil
                    MQIFileManager.removePath(userPath)
                    UserNotifier.postNotification(.login_out)
                    block?(nil)
                }
            }
            
        }else{
            /// 1 标志位没值 取本地数据
            UserDefaults.standard.set("new_token", forKey: "xm_conversionToken_new")
            UserDefaults.standard.synchronize()
            MQIFileManager.removePath(userPath)
            MQIUserManager.shared.user = MQIDataUtil.getdbUser()
            block?(nil)
        }
        
    }
    
}

extension MQIDataUtil  {
    
    static   func getdbUser() ->  MQIUserModel?{
        guard  let  userDic = XMDBTool.shared.defaultUser  else {return  nil}
        return  MQIUserModel.init(jsonDict: userDic as! [String : Any])
    }
    
    static func saveDBUser(_ user:MQIUserModel?) {
        do{
            try XMDBTool.shared.insert(user: user)
            MQICouponManager.shared.updateReaderCoupon_isok = false
            mqLog("保存成功")
            //
        }
        catch  {
            mqLog("保存失败")
        }
    }
    
    /// 本地数据转化
    static func conversionFileUserData(_ path:String) ->MQIUserModel? {
        if let userOld = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? MQIUserModel {
            saveDBUser(userOld)
            MQIFileManager.removePath(path)
            return userOld
        }else{
            return nil
        }
        
    }
    
}

//MARK: 阅读记录
extension MQIDataUtil {
    
    /// 获取阅读记录书籍
    static func  getDBLibraryBook(_ bookid:String) ->MQIEachBook?{
        
        do {
            guard   let  dic = try XMDBTool.shared.query(readLog: bookid.integerValue()) as? [String:Any] else {
                return nil
            }
            return  MQIEachBook(jsonDict: dic)
            
        } catch  {
            return  nil
        }
        
        
    }
    static   func getdbRecentBooks() -> [MQIEachBook]{
        var books =  [MQIEachBook]()
        do {
            guard   let  recentBooks = try XMDBTool.shared.queryReadLog() as? [[String:Any]] else {
                return books
            }
            for dic in recentBooks {
                let book = MQIEachBook(jsonDict: dic)
                books.append(book)
            }
            return books
            
        } catch {
            mqLog(error)
            return books
            
        }
        
    }
    
    @discardableResult static func saveRecentBook(_ book:MQIEachBook,atts:[XMLibraryAttribute]) -> Bool {
        do{
            var  attsNew = atts
            attsNew.append(.readTime(getCurrentStamp()))
            try XMDBTool.shared.insert(lib: book, attrs: attsNew)
            return true
        }
        catch  {
            mqLog("保存失败")
            return false
        }
    }
    
    /// 转换数据使用
    @discardableResult static func saveRecentBook(_ book:MQIEachBook,chapter_Id:String, time:Int = 0 ) -> Bool{
        do{
            try XMDBTool.shared.insert(book: book )
            try XMDBTool.shared.insert(lib: book, attrs: [.readTime(getCurrentStamp()-time),.chapterId(chapter_Id.integerValue())])
            return true
        }
        catch  {
            mqLog("保存失败")
            return false
        }
    }
    /// 本地数据转化
    static func conversionRecentFileData(_ recentPath:String) -> [MQIEachBook] {
        
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: recentPath) as? [MQIEachBook] {
            var t = 0
            for book in array {
                t  += 1
                saveRecentBook(book, chapter_Id: "\(t)", time: t)
            }
            MQIFileManager.removePath(recentPath)
            if  array.count == 0 {
                return getdbRecentBooks()
            }
            return [MQIEachBook] ()
        }else{
            return getdbRecentBooks()
        }
        
    }
    
    
}

//MARK: 书架操作
extension MQIDataUtil {
    
    static func getdbShelfBooks() -> [MQIEachBook]{
        var books =  [MQIEachBook]()
        do {
            guard   let  shelfBooks = try XMDBTool.shared.queryShelfList() as? [[String:Any]] else {
                return books
            }
            for dic in shelfBooks {
                let book = MQIEachBook(jsonDict: dic)
                books.append(book)
            }
            return books
            
        } catch {
            mqLog(error)
            return books
            
        }
        
    }
    
    ///添加阅读记录
    @discardableResult static  func saveShelfBook(_ book:MQIEachBook,atts:[XMLibraryAttribute]) -> Bool {
        do{
            var  attsNew = atts
            attsNew.append(.readTime(getCurrentStamp()))
            try XMDBTool.shared.insert(lib: book, attrs: attsNew)
            return true
        }
        catch  {
            mqLog("保存失败")
            return false
        }
    }
    
    @discardableResult static func saveShelfBook(_ book:MQIEachBook, time:Int = 0 ) -> Bool{
        do{
            try XMDBTool.shared.insert(book: book )
            try XMDBTool.shared.insert(lib: book, attrs: [.favorite(1),.readTime(getCurrentStamp()-time),.updateBook(book.updateBook)])
            return true
        }
        catch  {
            mqLog("保存失败")
            return false
        }
    }
    @discardableResult static func saveShelfBook(_ books: [MQIEachBook], time:Int = 0 ) -> Bool{
        do{
            try XMDBTool.shared.insert(books: books)
            var index = 0
            let libs: [(XMDBLibraryProtocol, [XMLibraryAttribute])] = books.map{
                index += 1
                return ($0,
                        [.favorite(1),.readTime(getCurrentStamp()-index),.updateBook($0.updateBook)])
            }
            try XMDBTool.shared.insert(libs: libs)
            return true
        }
        catch  {
            mqLog("保存失败")
            return false
        }
    }
    /// 本地数据转化
    static  func conversionFileData(_ shelfPath:String) -> [MQIEachBook] {
        
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: shelfPath) as? [MQIEachBook] {
            var t = 0
            for book in array {
                t  += 1
                saveShelfBook(book,time:t)
            }
            MQIFileManager.removePath(shelfPath)
            if  array.count == 0 {
                return getdbShelfBooks()
            }
            return [MQIEachBook] ()
        }else{
            
            return getdbShelfBooks()
        }
        
    }
    
    
}


//MARK:   书籍操作
extension MQIDataUtil {
    
    
    static func getdbBook(_ book_id:String)   -> MQIEachBook?{
        do {
            guard   let book_dic =  try XMDBTool.shared.fetch(book: book_id.integerValue()) else {
                return  nil
            }
            return MQIEachBook(jsonDict: book_dic as! [String : Any] )
        } catch let error {
            mqLog( "\(error)")
            return  nil
        }
        
    }
    
    @discardableResult  static  func saveBook(_ book:MQIEachBook) -> Bool {
        do {
            try  XMDBTool.shared.insert(book: book)
            return true
        } catch let error {
            mqLog( "\(error)")
            return  false
        }
        
    }
    @discardableResult static func updateBookEntireSubscribe(_ book:MQIEachBook) -> Bool {
        do {
            try  XMDBTool.shared.update(book: book.bookId, values: [.entireSubscribe(book.entireSubscribe)])
            return true
        } catch {
            mqLog("\(error)")
            return  false
        }
    }
    
    /// 本地数据转化
    static  func conversionFileBookData(_ bookPath:String)  {
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: bookPath) as? [MQIEachBook] {
            for book in array {
                saveBook(book)
            }
            MQIFileManager.removePath(bookPath)
        }
        
    }
    
    /// 订阅本地数据转化
    static  func conversionFileSubscribeBookData(_ bookPath:String,conditions:XMDBSubscribeScreenConditions)  {
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: bookPath) as? [MQIEachBook] {
            for book in array {
                saveSubscribeBook(book.book_id, conditions: conditions)
            }
            MQIFileManager.removePath(bookPath)
        }
    }
    
    ///   获取订阅信息
    static func getdbSubscribeBook(conditions:XMDBSubscribeScreenConditions)  -> [MQIEachBook]{
        var books =  [MQIEachBook]()
        if  !MQIUserManager.shared.checkIsLogin() { return books}
        if let user = MQIUserManager.shared.user {
            do {
                guard   let  sbBooks = try  XMDBTool.shared.querySubscribe(uid:   user.user_id.integerValue(), conditions: conditions)as? [[String:Any]] else {
                    return books
                }
                for dic in sbBooks {
                    let book = MQIEachBook(jsonDict: dic)
                    books.append(book)
                }
                return books
                
            } catch {
                mqLog(error)
                return books
            }
            
        }
        
        return books
    }
    /// 缓存
    @discardableResult static func  saveSubscribeBook(_ book_id:String, conditions:XMDBSubscribeScreenConditions) -> Bool {
        
        guard  MQIUserManager.shared.checkIsLogin() == true else {
            return false
        }
        
        do {
            let sbData = MQISubscribeData(bookId: book_id.integerValue(), userId:  MQIUserManager.shared.user!.user_id.integerValue())
            var  attrs = [XMSubscribeAttribute]()
            attrs.append(.userId(sbData.userId))
            attrs.append(.bookId(sbData.bookId))
            
            if conditions == .all {
                attrs.append(.entire(1))
            }
            if  conditions == .chapter {
                attrs.append(.chapterId(10))
            }
            try XMDBTool.shared.insert(sb: sbData, attrs: attrs)
            return true
        } catch  {
            mqLog(error)
            return false
        }
        
    }
    
    /// 移除订阅信息
    @discardableResult  static func removeSubscribeBook(_ book_id:String) -> Bool{
        guard  MQIUserManager.shared.checkIsLogin() == true else { return false}
        
        do {
            let sbData = MQISubscribeData(bookId: book_id.integerValue(), userId:  MQIUserManager.shared.user!.user_id.integerValue())
            var  attrs = [XMSubscribeAttribute]()
            attrs.append(.userId(sbData.userId))
            attrs.append(.bookId(sbData.bookId))
            try  XMDBTool.shared.remove(sb: sbData)
            return true
        } catch  {
            mqLog(error)
            return false
        }
        
    }
    
    
    
}

struct MQISubscribeData: XMDBSubscribeProtocol{
    var bookId: Int
    var userId: Int
}


