
//
//  GYBookManager.swift
//  YH
//
//  Created by _CHK_  on 16/7/15.
//  Copyright (c) 2015年 _xinmo_. All rights reserved.
//

import UIKit
/*
 拉拉
 */
import Reachability

enum GYSubscribeType {
    case book //全本订阅
    case chapter //非全本订阅
}

class GYBookManager: NSObject {
    
    fileprivate static var __once: () = {
        Inner.instance = GYBookManager()
    }()
    
    var chapterIndex: Int = 0
    
    var downloadTmpPath = ""
    
    //    var downloadBooks = [MQIEachBook]()
    
    var dingyueBooks_chapter: [MQIEachBook] = [MQIEachBook]() //非全本订阅 列表
    var dingyueBooks_book: [MQIEachBook] = [MQIEachBook]()  //全本订阅 列表
    
    var dingyueTmpChapterPath: String = ""
    var dingyueTmpBookPath: String = ""
    
    /// 当前书籍订阅章节id
    var buyTids = [String]()
    var isFree_limit_time:Bool {
        get {
            if free_limit_time > 0{
                if free_limit_time >  NSInteger(Date().timeIntervalSince1970){
                    return true
                }
            }
            return false
        }
    }
    ///限时免费
    var free_limit_time:Int = -1
    ///全本订阅
    var whole_subscribe:String?
    
    /// 新订阅接口 缓存数据
    var currentBookChapters: [String: Any]?
    
    struct Inner {
        static var token: Int = 0
        static var instance: GYBookManager?
    }
    
    
    class var shared: GYBookManager {
        _ = GYBookManager.__once
        return Inner.instance!
    }
    
    
    override init() {
        super.init()
        UserNotifier.addObserver(self, selector: #selector(GYBookManager.configBooks), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(GYBookManager.userLoginOut), notification: .login_out)
        
        configBooks()
    }
    
    @objc func userLoginOut() {
        downloadTmpPath = MQIFileManager.getCurrentStoreagePath("downloadBooks.db")
        //        downloadBooks.removeAll()
        dingyueBooks_chapter.removeAll()
        dingyueBooks_book.removeAll()
        buyTids.removeAll()
    }
    
    @objc func configBooks() {
        if MQIUserManager.shared.checkIsLogin() == false {
            return
        }
        
        downloadTmpPath = MQIFileManager.getCurrentStoreagePath("downloadBooks_\(MQIUserManager.shared.user!.user_id).db")
        if MQIFileManager.checkFileIsExist(downloadTmpPath) == true {
            if (NSKeyedUnarchiver.unarchiveObject(withFile: downloadTmpPath) as? [MQIEachBook]) != nil {
                //                downloadBooks = books
                MQIDataUtil.conversionFileBookData(downloadTmpPath)
                MQIFileManager.removePath(downloadTmpPath)
            }else {
                let patch = MQIFileManager.getCurrentStoreagePath("downloadBooks.db")
                if MQIFileManager.checkFileIsExist(patch) == true {
                    //                    if let books = NSKeyedUnarchiver.unarchiveObject(withFile: patch) as? [MQIEachBook] {
                    ///                       downloadBooks = books
                    //                       savedownloadBooks()
                    //                    }
                    MQIDataUtil.conversionFileBookData(patch)
                    MQIFileManager.removePath(patch)
                }
            }
        }
        
        dingyueTmpChapterPath = MQIFileManager.getCurrentStoreagePath("dingyueBooks_chapter_\(MQIUserManager.shared.user!.user_id).db")
        if MQIFileManager.checkFileIsExist(dingyueTmpChapterPath) == true {
            MQIDataUtil.conversionFileSubscribeBookData(dingyueTmpChapterPath,conditions: .chapter)
            dingyueBooks_chapter = MQIDataUtil.getdbSubscribeBook(conditions: .chapter)
            //            if let books = NSKeyedUnarchiver.unarchiveObject(withFile: dingyueTmpChapterPath) as? [MQIEachBook] {
            //                dingyueBooks_chapter = books
            //            }
        }
        
        dingyueTmpBookPath = MQIFileManager.getCurrentStoreagePath("dingyueBooks_book_\(MQIUserManager.shared.user!.user_id).db")
        if MQIFileManager.checkFileIsExist(dingyueTmpBookPath) == true {
            MQIDataUtil.conversionFileSubscribeBookData(dingyueTmpBookPath,conditions: .all)
            dingyueBooks_book = MQIDataUtil.getdbSubscribeBook(conditions: .all)
            //            if let books = NSKeyedUnarchiver.unarchiveObject(withFile: dingyueTmpBookPath) as? [MQIEachBook] {
            //                dingyueBooks_book = books
            //
            //            }
        }
    }
    
    func a() {
        
    }
    
    //MARK: 保存书籍到订阅书籍列表
    @discardableResult func addDingyueBook(_ book: MQIEachBook, type: GYSubscribeType? = .chapter) -> Bool {
        for b in (type == .chapter ? dingyueBooks_chapter : dingyueBooks_book) {
            if b.book_id == book.book_id {
                return true
            }
        }
        
        guard type == .chapter else {
            if checkIsSubscriber(book, type: .chapter) == true {
                return true
            }
            
            dingyueBooks_book.append(book)
            return saveDingyueBook(.book)
        }
        
        dingyueBooks_chapter.append(book)
        return self.saveDingyueBook(.chapter)
    }
    
    //MARK: 删除书籍 from 订阅书籍
    func removeDingyueBook(_ book: MQIEachBook) {
        dingyueBooks_chapter = dingyueBooks_chapter.filter({$0.book_id != book.book_id})
        MQIDataUtil.removeSubscribeBook(book.book_id)
        //        saveDingyueBook(.chapter)
        
    }
    //MARK: 删除书籍全部订阅
    func removeBookFromDingyue(_ book: MQIEachBook) {
        dingyueBooks_book = dingyueBooks_book.filter({$0.book_id != book.book_id})
        //        saveDingyueBook(.book)
        MQIDataUtil.removeSubscribeBook(book.book_id)
    }
    
    //检查是否是订阅书籍
    func checkIsSubscriber(_ book: MQIEachBook, type: GYSubscribeType? = .chapter) -> Bool {
        guard type == .chapter else {
            return dingyueBooks_book.filter({$0.book_id == book.book_id}).first != nil
        }
        return dingyueBooks_chapter.filter({$0.book_id == book.book_id}).first != nil
    }
    
    //MARK: 保存订阅书籍
    @discardableResult func saveDingyueBook(_ type: GYSubscribeType? = .chapter) -> Bool {
        guard type == .chapter else {
            //            if dingyueBooks_book.count >= 0 {
            //                dispatchArchive(dingyueBooks_book, path: dingyueTmpBookPath)
            //                return true
            //            }
            for book in dingyueBooks_book {
                MQIDataUtil.saveSubscribeBook(book.book_id, conditions: .all)
            }
            
            return true
        }
        for book in dingyueBooks_chapter {
            MQIDataUtil.saveSubscribeBook(book.book_id, conditions: .chapter)
        }
        
        //        if dingyueBooks_chapter.count >= 0 {
        //            dispatchArchive(dingyueBooks_chapter, path: dingyueTmpChapterPath)
        //            return true
        //        }
        return true
    }
    
    //MARK: -- 下载
    //    @discardableResult func savedownloadBooks() -> Bool {
    //        if downloadBooks.count >= 0 {
    //            if downloadTmpPath == "" {downloadTmpPath = MQIFileManager.getCurrentStoreagePath("downloadBooks.db")}
    //            dispatchArchive(downloadBooks, path: downloadTmpPath)
    //            return true
    //        }
    
    //        return false
    //    }
    
    @discardableResult func updateDownloadBook(_ book: MQIEachBook) -> Bool {
        //        for i in 0..<downloadBooks.count {
        //            if downloadBooks[i].book_id == book.book_id {
        //                downloadBooks.remove(at: i)
        //                break
        //            }
        //        }
        //        downloadBooks.insert(book, at: 0)
        //        return savedownloadBooks()
        
        return  MQIDataUtil.saveBook(book)
    }
    
    @discardableResult func addDownloadBook(_ book: MQIEachBook) -> Bool {
        //        for i in 0..<downloadBooks.count {
        //            if downloadBooks[i].book_id == book.book_id {
        //                return false
        //            }
        //        }
        
        //        return savedownloadBooks()
        
        return   updateDownloadBook(book)
    }
    
    func getDownloadBook(_ bid: String) -> MQIEachBook? {
        return    MQIDataUtil.getdbBook(bid)
    }
    
    //MARK: --
    
    deinit {
        UserNotifier.removeObserver(self, notification: .login_in)
        UserNotifier.removeObserver(self, notification: .login_out)
    }
    
    
    //检查章节内容是否有下载
    func checkChpaterIsDown(_ bid: String, tid: String) -> Bool {
        let bookPath = MQIFileManager.getReaderStoreagePath(bid)
        let chapterPath = NSString(string: bookPath).appending("\(tid).html")
        return MQIFileManager.checkFileIsExist(chapterPath)
    }
    
    //检查某本书的目录是否有下载
    func checkChapterListIsDown(_ bid: String) -> Bool {
        let list = MQIFileManager.getChapterList(bid)
        return list == nil ? false : true
    }
    
    ///获取订阅ids
    func getSubscribeChapterIds(book_id:String,block:((_ err_msg:String?)->())?)  {
        
        
        GYAllSubscribeChapterRequest(book_id: book_id, start_chapter_id: "").request({ (request, response, tModel:MQIBaseModel) in
            
            if let tids = tModel.dict["chapter_ids"] {
                if tids is [String] {
                    self.buyTids = tids as!  [String]
                }else if tids is [NSNumber] {
                    let newIDs = tids as!  [NSNumber]
                    for i in newIDs {
                        self.buyTids.append(i.stringValue)
                    }
                }
            }
            if let free_limit_time = tModel.dict["free_limit_time"] {
                if free_limit_time is String {
                    self.free_limit_time = (free_limit_time as! String).integerValue()
                }else if free_limit_time is NSNumber{
                    self.free_limit_time = (free_limit_time as!  NSNumber).intValue
                }
            }else{
                self.free_limit_time = 0
            }
            if let whole_subscribe = tModel.dict["whole_subscribe"] {
                if whole_subscribe is String {
                    self.whole_subscribe = whole_subscribe as? String
                }else if whole_subscribe is NSNumber {
                    self.whole_subscribe = (whole_subscribe as!  NSNumber).stringValue
                }
            }
            //             let b =   MQIEachBook()
            //            b.book_id = book_id
            //            self.updateChapter(book_id: b.book_id, new_chapters: self.getChapterListFromLocation(b)!, block: { (dic) in
            //
            //                mqLog(dic.debugDescription)
            //            })
            //
            //            self.getTheCurrentBookChapters(b.book_id, block: { (arr:[String : MQIEachRapidChapter]) in
            //                 mqLog(arr)
            //            })
            
            
            block?(nil)
        }, failureHandler: { ( code, msg) in
            self.free_limit_time = 0
            block?(msg)
            
        })
    }
    
    //MARK:获取章节目录
    func getChapterList(_ book: MQIEachBook,
                        forceRefresh: Bool,
                        completion: ((_ list: [MQIEachChapter]) -> ())?,
                        failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        let locationList = getChapterListFromLocation(book)
        //获取本地list 判断是否已经下载过
        if let locationList = locationList {
            
            if Reachability(hostname: hostname).currentReachabilityStatus() == .NotReachable {
                completion?(locationList)
                
            }else {
                if forceRefresh == true {
                    getChapterListFromServer(book, locationList: locationList, completion: { (list) in
                        completion?(list)
                    }, failed: { (err_code, err_msg) in
                        completion?(locationList)
                    })
                }else {
                    getChapterListFromServer(book, locationList: locationList, completion: { (list) in
                        completion?(list)
                    }, failed: { (err_code, err_msg) in
                        completion?(locationList)
                    })
                }
            }
        }else {
            getChapterListFromServer(book, locationList: locationList, completion: { (list) in
                completion?(list)
            }, failed: { (err_code, err_msg) in
                failed?(err_code, err_msg)
            })
        }
    }
    
    func getVipChapter(_ chapter:MQIEachChapter ,book:MQIEachBook) -> Bool {
        
        guard let user  = MQIUserManager.shared.user else {
            if chapter.chapter_vip && !self.isFree_limit_time {
                return true
            }
            return false
        }
        if !user.isVIP {
            if let whole_subscribe =  self.whole_subscribe  {
                if  whole_subscribe == "1"{
                    return false
                }
            }
            if chapter.chapter_vip && !self.isFree_limit_time {
                return true
            }
            return false
        }else{
            //            if let whole_subscribe =  self.whole_subscribe  {
            //                if  whole_subscribe == "1"{
            //                    return false
            //                }
            //            }
            return false
        }
    }
    //MARK: 获取章节内容
    func getChapterContent(_ book: MQIEachBook, chapter: MQIEachChapter,to_index:Int? = nil, completion: ((_ chapter: MQIEachChapter) -> ())?,
                           failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        if to_index == nil {
            if let content = getChapterDataFromLocation(book.book_id, tid: chapter.chapter_id) {
                chapter.isDown = true
                chapter.content = content
            }
        }
        func getContent() {
            if getVipChapter(chapter, book: book) {
                
                if Reachability(hostname: hostname).currentReachabilityStatus() == .NotReachable {
                    if chapter.content.count > 0 {
                        completion?(chapter)
                    }else {
                        failed?("-1", "网络错误，请重试")
                    }
                }else if checkIsSubscriber(book) == true || chapter.isSubscriber == true {
                    if chapter.content.count > 0 {
                        completion?(chapter)
                    }else {
                        getVIPChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, auto_subscribe: true, completion: { (c) in
                            completion?(c)
                        }, failed: { (err_code, err_msg) in
                            failed?(err_code, err_msg)
                        })
                    }
                }else {
                    //
                    if !GYBookManager.shared.buyTids.contains(chapter.chapter_id)  { ///订阅
                        if !book.buyTids.contains(chapter.chapter_id) {
                            failed?("10501", "")
                        }else{
                            getVIPChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, auto_subscribe: true, completion: { (c) in
                                completion?(c)
                            }, failed: { (err_code, err_msg) in
                                failed?(err_code, err_msg)
                            })
                        }
                        
                    }else{
                        getVIPChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, completion: { (c) in
                            completion?(c)
                        }, failed: { (err_code, err_msg) in
                            failed?(err_code, err_msg)
                        })
                    }
                    
                }
            }else {
                if chapter.content.count > 0 {
                    completion?(chapter)
                }else {
                    getChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, completion: { (c) in
                        completion?(c)
                    }, failed: { (err_code, err_msg) in
                        failed?(err_code, err_msg)
                    })
                }
            }
        }
        
        func getContent2() {
            if Reachability(hostname: hostname).currentReachabilityStatus() == .NotReachable {
                if chapter.content.count > 0 {
                    completion?(chapter)
                }else {
                    failed?("-1", "网络错误，请重试")
                }
            }else if checkIsSubscriber(book) == true || chapter.isSubscriber == true {
                getVIPChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, auto_subscribe: true, completion: { (c) in
                    completion?(c)
                }, failed: { (err_code, err_msg) in
                    failed?(err_code, err_msg)
                })
            }else{
                getChapterDataFromServer(book.book_id, tid: chapter.chapter_id,t_title:chapter.chapter_title, completion: { (c) in
                    completion?(c)
                }, failed: { (err_code, err_msg) in
                    failed?(err_code, err_msg)
                })
                
            }
        }
        if  self.free_limit_time < 0 {
            //// 限免<0 证明没有获取到最新的订阅信息 获取一次订阅信息 针对第一次进入
            getContent2()
            GYBookManager.shared.getSubscribeChapterIds(book_id: book.book_id) { (msg) in
                
            }
            
        }else{
            getContent2()
        }
        
    }
    
    
    //MARK: 本地获取 章节列表
    func getChapterListFromLocation(_ book: MQIEachBook) -> [MQIEachChapter]? {
        return MQIFileManager.getChapterList(book.book_id)
    }
    /// 更新订阅信息  更新本地章节列表
    func saveChapterList(_ book: MQIEachBook,list:[MQIEachChapter]? = nil,_ newIDs:[String]? = nil)  {
        
        if newIDs != nil {
            if let chapterListOld   = GYBookManager.shared.getChapterListFromLocation(book){
                for id in newIDs! {
                    chapterListOld.filter({$0.chapter_id == id}).first?.isSubscriber = true
                }
                
                self.saveChapterList(book, list: chapterListOld)
            }
        }
        
        if list != nil {
            MQIFileManager.saveChapterList(book.book_id, list: list!)
        }
    }
    
    //MARK:网络操作
    func getChapterListFromServer(_ book: MQIEachBook,
                                  locationList: [MQIEachChapter]?,
                                  completion: ((_ list: [MQIEachChapter]) -> ())?,
                                  failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        
        let chapter_code = locationList?.last?.chapter_code
        
        
        GYChapterListRequest(book_id: book.book_id, chapter_code: chapter_code)
            .request({ (request, response, resultNew: MQIEachChapterData) in
                let result = resultNew.data
                //                for i in 0..<result.count {
                //                    result[i].isDown = book.downTids.contains(result[i].chapter_id)
                //                }
                //
                //                if let locationList = locationList {
                //                    if locationList.last?.chapter_id == result.first?.chapter_id {
                //                        if locationList.count > 0{
                //                            locationList.removeLast()
                //                        }
                //
                //                    }
                
                if result.count > 0 {
                    let locationListNew = result
                    if let locationList = locationList {
                        /// 为保证 vip标识的准确性需要这样做
                        for i in 0..<locationListNew.count {
                            let c_new =  locationListNew[i]
                            if let c_old = locationList.filter({$0.chapter_id ==  c_new.chapter_id}).first {
                                c_new.isDown =  c_old.isDown
                                c_new.isSubscriber = c_old.isSubscriber
                            }
                            
                        }
                        
                        MQIFileManager.saveChapterList(book.book_id, list: locationListNew)
                        completion?(locationListNew)
                        
                    }else{
                        MQIFileManager.saveChapterList(book.book_id, list: locationListNew)
                        completion?(locationListNew)
                    }
                }else {
                    failed?("-1", "章节列表获取失败")
                }
                
                
            }) { (err_msg, err_code) in
                failed?(err_code, err_msg)
        }
    }
    
    //MARK: 本地获取章节 内容
    func getChapterDataFromLocation(_ bid: String, tid: String) -> String? {
        let content = MQIFileManager.getChapterContent(bid, tid: tid)
        if let content = content {
            if content != "<div><span></span></div>" && content.count > 0 {
                if content.hasPrefix("<div><span>") == true {
                    return GYReadParser.ContentTypesetting(content: content)
                }else {
                    return content
                }
            }
        }
        return nil
    }
    
    //MARK: 获取章节内容
    func getChapterDataFromServer(_ bid: String, tid: String,t_title:String? = "",
                                  completion: ((_ chapter: MQIEachChapter) -> ())?,
                                  failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        
        getNotListNewChapterContent(bid, tid: tid, completion: { (chapter) in
            completion?(chapter)
        }) { (err_msg, err_code) in
            
            failed?(err_code, err_msg)
        }
        
        //        GYEncryptionContentRequest(book_id: bid, chapter_id: tid)
        //            .request({ (request, response, result: MQIEachChapter) in
        //
        //                if result.content.count > 0 {
        //                    result.content =  unlockCntent.getOriginContent(bookId: bid.integerValue(), chapterId:   tid.integerValue(), cryptString: result.chapter_content)
        //                    if t_title != "" && t_title != nil {
        //                        result.chapter_title = t_title!
        //                    }
        //                    result.isDown = true
        //
        //                    MQIFileManager.saveChapterContent(bid, tid: result.chapter_id, content: result.content)
        //                    completion?(result)
        //                }else {
        //                    failed?("-1", "章节获取失败，刷新目录试试")
        //                }
        //            }) { (err_msg, err_code) in
        //                failed?(err_code, err_msg)
        //        }
        
        
    }
    
    //MARK: 获取vip章节内容
    func getVIPChapterDataFromServer(_ bid: String, tid: String,t_title:String? = "",auto_subscribe:Bool = false,
                                     completion: ((_ chapter: MQIEachChapter) -> ())?,
                                     failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        
        
        getNotListNewChapterContent(bid, tid: tid,auto_subscribe: auto_subscribe, completion: { (chapter) in
            completion?(chapter)
        }) { (err_msg, err_code) in
            
            failed?(err_code, err_msg)
        }
        
        //        let ids = [tid]
        //        GYSubscribeBookRequest(book_id: bid, chapter_ids: ids)
        //            .request({ (request, response, result:MQIBaseModel) in
        //
        //                GYBookManager.shared.buyTids.append(contentsOf: ids)
        //                GYEncryptionContentRequest(book_id: bid, chapter_id: tid)
        //                    .request({ (request, response, result: MQIEachChapter) in
        //
        //                        if result.content.count > 0 {
        //                            result.content =  unlockCntent.getOriginContent(bookId: bid.integerValue(), chapterId:   tid.integerValue(), cryptString: result.chapter_content)
        //                            if t_title != "" && t_title != nil {
        //                                result.chapter_title = t_title!
        //                            }
        //                            result.isDown = true
        //
        //                            MQIFileManager.saveChapterContent(bid, tid: result.chapter_id, content: result.content)
        //                            UserNotifier.postNotification(.refresh_coin)
        //                            MQIUserManager.shared.updateUserCoin({ (suc, msg) in
        //                                completion?(result)
        //                            })
        //                        }else {
        //                            failed?("-1", "章节获取失败，刷新目录试试")
        //                        }
        //                    }) { (err_msg, err_code) in
        //                        failed?(err_code, err_msg)
        //                }
        //
        //            }) { (err_msg, err_code) in
        //
        //                failed?(err_code, err_msg)
        //        }
        
        
    }
    
    /// 书籍信息请求
    func requestBookInfo(_ bid:String,isRefresh:Bool = false,callBlock:@escaping ((MQIEachBook?,String?,String?)->())) {
        if isRefresh {
            MQIPlanManager.shared.checkNeedRefresh(.refreshBookInfo, id: bid)
            GYBookInfoRequest(book_id: bid)
                .request({ (request, response, result: MQIEachBook) in
                    self.saveBook(result)
                    callBlock(result,nil,nil)
                }) { (err_msg, err_code) in
                    callBlock(nil,err_msg,err_code)
            }
            return
        }
        let book  =  MQIDataUtil.getdbBook(bid)
        if book == nil {
            MQIPlanManager.shared.checkNeedRefresh(.refreshBookInfo, id: bid)
            GYBookInfoRequest(book_id: bid)
                .request({ (request, response, result: MQIEachBook) in
                    self.saveBook(result)
                    callBlock(result,nil,nil)
                }) { (err_msg, err_code) in
                    callBlock(nil,err_msg,err_code)
            }
        }else{
            if MQIPlanManager.shared.checkNeedRefresh(.refreshBookInfo, id: bid) {
                GYBookInfoRequest(book_id: bid)
                    .request({ (request, response, result: MQIEachBook) in
                        self.saveBook(result)
                        callBlock(result,nil,nil)
                    }) { (err_msg, err_code) in
                        callBlock(nil,err_msg,err_code)
                }
                //                let book  = MQIEachBook()
                //                book.book_id = bid
                //                getChapterListFromServer(book, locationList: getChapterListFromLocation(book), completion: nil, failed: nil)
                
            }else{
                callBlock(book!,nil,nil)
            }
        }
    }
    
    //MARK: 获取章节内容
    func getNotListNewChapterContent(_ bid: String, tid: String = "0",auto_subscribe:Bool  = false,
                                     completion: ((_ chapter: MQIEachChapter) -> ())?,
                                     failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        let tid_new = tid
        
        MQIGetNewChapteContentRequest(book_id: bid, chapter_id: tid_new, auto_subscribe: auto_subscribe ? "1":"2")
            .request({ (request, response, result: MQIEachRapidChapter) in
                
                if result.content.count > 0 {
                    let chapter  = result.current_chapter
                    chapter.content =  unlockCntent.getOriginContent(bookId: bid.integerValue(), chapterId:   result.id.integerValue(), cryptString: result.content)
                    chapter.isDown = true
                    MQIFileManager.saveChapterContent(bid, tid: chapter.chapter_id, content: chapter.content)
                    if result.vip == "1" {
                        GYBookManager.shared.buyTids.append(tid_new)
                        UserNotifier.postNotification(.refresh_coin)
                        MQIUserManager.shared.updateUserCoin(nil)
                    }
                    completion?(chapter)
                    
                }else {
                    failed?("-1", "章节获取失败，刷新目录试试")
                }
            }) { ( err_code,err_msg) in
                failed?(err_code, err_msg)
        }
        
    }
    
    func saveBook(_ book:MQIEachBook)  {
        /// 缓存到数据库
        MQIDataUtil.saveBook(book)
        MQIDataUtil.updateBookEntireSubscribe(book)
    }
    
    
}



/// 新逻辑章节缓存更新逻辑
extension GYBookManager {
    
    /// 获取当前目录
    func getTheCurrentBookChapters(_ book_id:String,block:((_ dic:[String:MQIEachRapidChapter])->())?) {
        DispatchQueue.global().async {
            let c_dics = self.getChaptersData(info: self.getChaptersInfotPath(info: self.getInfoFileName(book_id)))
            var datas = [String:MQIEachRapidChapter]()
            for (key,value) in c_dics {
                if let dic = value as? [String:Any] {
                    datas.updateValue( MQIEachRapidChapter(jsonDict: dic), forKey: key)
                }
            }
            DispatchQueue.main.async {
                block?(datas)
            }
        }
        
    }
    /// 获取当前目录
    func getTheCurrentBookChaptersToDic(_ book_id:String)->[String:Any]{
        return self.getChaptersData(info: self.getChaptersInfotPath(info: self.getInfoFileName(book_id)))
    }
    
    
    func getChapterContent2(_ book: MQIEachBook, chapter: MQIEachChapter,auto_subscribe:String? = nil, completion: ((_ chapter: MQIEachChapter) -> ())?,
                            failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        
        if let content = getChapterDataFromLocation(book.book_id, tid: chapter.chapter_id) {
            chapter.isDown = true
            chapter.content = content
            completion?(chapter)
        }else{
            if Reachability(hostname: hostname).currentReachabilityStatus() == .NotReachable {
                if chapter.content.count > 0 {
                    completion?(chapter)
                }else {
                    failed?("-1", "网络错误，请重试")
                }
            }else{
                
                GYBookManager.shared.getNewChapterContent(book.book_id, tid: chapter.chapter_id, currentBookChapters: nil,auto_subscribe:auto_subscribe, completion: { (chapter_new) in
                    chapter_new.isDown = true
                    completion?(chapter_new)
                }){ (err_code,  err_msg) in
                    failed?(err_code, err_msg)
                }
                
            }
        }
    }
    
    
    //MARK: 获取章节内容
    func getNewChapterContent(_ bid: String, tid: String = "0", currentBookChapters: [String: Any]? =  nil,auto_subscribe:String? = nil,
                              completion: ((_ chapter: MQIEachChapter) -> ())?,
                              failed: ((_ err_code: String, _ err_msg: String) -> ())?) {
        let tid_new = (tid == "" || tid  == "0") ? "0":tid
        
        let rapidChapters = currentBookChapters ??  self.getTheCurrentBookChaptersToDic(bid)
        
        let book = MQIEachBook()
        book.book_id = bid
        var auto_subscribe_new = (checkIsSubscriber(book) == true) ? "1":"2"
        if auto_subscribe != nil {auto_subscribe_new = auto_subscribe!}
        
        MQIGetNewChapteContentRequest(book_id: bid, chapter_id: tid_new, auto_subscribe:auto_subscribe_new )
            .request({ (request, response, result: MQIEachRapidChapter) in
                
                if result.content.count > 0 {
                    let chapter  = result.current_chapter
                    chapter.content =  unlockCntent.getOriginContent(bookId: bid.integerValue(), chapterId:   result.id.integerValue(), cryptString: result.content)
                    chapter.isDown = true
                    MQIFileManager.saveChapterContent(bid, tid: chapter.chapter_id, content: chapter.content)
                    if result.vip == "1" {
                        GYBookManager.shared.buyTids.append(tid_new)
                        UserNotifier.postNotification(.refresh_coin)
                        MQIUserManager.shared.updateUserCoin(nil)
                    }
                    result.current_chapter = chapter
                    GYBookManager.shared.updateForRapidChapter(rapidChapters, bid, rapid_chapter: result, block: { (cP) in
                        completion?(chapter)
                    })
                    
                }else {
                    failed?("-1", "章节获取失败，刷新目录试试")
                }
            }) { (err_code,err_msg) in
                failed?(err_code, err_msg)
        }
        
    }
    
    /// 转换
    func conversionDic(_ datas:[String:MQIEachRapidChapter],block:((_ dic:[String:Any])->())?) {
        DispatchQueue.global().async {
            var currentDic = [String:Any]()
            for (key,value) in datas {
                currentDic.updateValue(self.assemblyChapterDic(value), forKey: key)
            }
            DispatchQueue.main.async {
                block?(currentDic)
            }
        }
        
    }
    
    ///更新当前章节目录
    func updateForRapidChapter(_ file_Chapters:[String:Any] = [String:Any]() ,_ book_id:String,rapid_chapter:MQIEachRapidChapter,block:((_ dic:[String:Any])->())?)  {
        var chapters = file_Chapters
        chapters.updateValue( assemblyChapterDic(rapid_chapter), forKey: rapid_chapter.id)
        self.saveChapters(self.getChaptersInfotPath(info: self.getInfoFileName(book_id)), chapters)
        DispatchQueue.main.async {
            block?(chapters)
        }
        
        
    }
    
    /// 根据章节目录接口获取的目录信息->更新缓存目录信息
    func updateChapter(file_Chapters:[String:Any] = [String:Any](),book_id:String,new_chapters:[MQIEachChapter],block:((_ dic:[String:Any])->())?) {
        
        DispatchQueue.global().async {
            var chapters = file_Chapters
            let count = new_chapters.count
            if count > 1 {
                for i in 0..<count {
                    let current_chapter = new_chapters[i]
                    if i == 0 {
                        chapters.updateValue( self.assemblyChapterDic(current_chapter: current_chapter,next_chapter: new_chapters[i+1]), forKey: current_chapter.chapter_id)
                    }else if i == count-1{
                        chapters.updateValue(self.assemblyChapterDic(current_chapter: current_chapter, prev_chapter: new_chapters[i-1]), forKey:  current_chapter.chapter_id)
                    }else{
                        chapters.updateValue(self.assemblyChapterDic(current_chapter: current_chapter, prev_chapter: new_chapters[i-1], next_chapter: new_chapters[i+1]), forKey: current_chapter.chapter_id)
                    }
                }
                
            }
            
            self.saveChapters(self.getChaptersInfotPath(info: self.getInfoFileName(book_id)), chapters)
            DispatchQueue.main.async {
                block?(chapters)
            }
            
        }
        
        
    }
    
    
    ///组装数据 符合新接口返回的数据
    func assemblyChapterDic(_ chapter:MQIEachRapidChapter)  -> [String:Any] {
        
        var  currentDic =  assemblyChapterDic(current_chapter: chapter.current_chapter, prev_chapter: chapter.prev_chapter, next_chapter: chapter.next_chapter)
        currentDic.updateValue( chapter.offline, forKey: "offline")
        currentDic.updateValue(chapter.hash_c, forKey: "hash")
        currentDic.updateValue(chapter.content, forKey: "content")
        
        return currentDic
    }
    
    func assemblyChapterToModel(_ data:Any?) -> MQIEachRapidChapter? {
        if let dic = data as? [String:Any] {
            
            return MQIEachRapidChapter(jsonDict: dic)
        }
        
        return nil
    }
    
    ///组装数据
    func assemblyChapterDic(current_chapter:MQIEachChapter, prev_chapter:MQIEachChapter? = nil  ,next_chapter:MQIEachChapter? = nil) -> [String:Any] {
        var  currentDic =  [String : Any]()
        currentDic.updateValue( current_chapter.chapter_id, forKey: "chapter_id")
        currentDic.updateValue( current_chapter.chapter_title, forKey: "chapter_title")
        currentDic.updateValue( current_chapter.chapter_vip, forKey:"chapter_vip")
        //        currentDic.updateValue( true, forKey: "offline")
        //        currentDic.updateValue(1233333, forKey: "hash")
        //        currentDic.updateValue("", forKey: "content")
        if let prev_New = prev_chapter , prev_New.chapter_id != ""{
            var p_dic =  [String : Any]()
            p_dic.updateValue( prev_New.chapter_id, forKey: "chapter_id")
            p_dic.updateValue( prev_New.chapter_title, forKey: "chapter_title")
            p_dic.updateValue( prev_New.chapter_vip, forKey:"chapter_vip")
            currentDic.updateValue(p_dic, forKey: "prev_chapter")
        }
        if let next_New = next_chapter , next_New.chapter_id != "" {
            var next_dic =  [String : Any]()
            next_dic.updateValue( next_New.chapter_id, forKey: "chapter_id")
            next_dic.updateValue( next_New.chapter_title, forKey: "chapter_title")
            next_dic.updateValue( next_New.chapter_vip, forKey:"chapter_vip")
            currentDic.updateValue(next_dic, forKey: "next_chapter")
        }
        
        return currentDic
    }
    
    
    
    /// 缓存
    fileprivate   func saveChapters(_ path:String,_ datas:[String:Any]) {
        let new_datas = datas as NSDictionary
        let results  =  new_datas.write(toFile: path, atomically: true)
        if  !results  {
            new_datas.write(toFile: path, atomically: true)
        }
    }
    
    ///获取章节数据
    fileprivate   func getChaptersData(info:String ) -> [String:Any] {
        if FileManager.default.fileExists(atPath: info as String) {
            if let c = NSDictionary(contentsOfFile: info) as? [String:Any] {
                return c
            }
        }
        return [String:Any]()
    }
    
    /// 获取一个章节路径
    fileprivate   func getInfoFileName(_ book_id:String) -> String {
        return String(format: "_%@_.plist", book_id)
    }
    
    //记录目录
    fileprivate    func getChaptersInfotPath(info:String) -> String{
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent("dChapter/")
        MQIFileManager.creatPathIfNecessary(sPath)
        let infoPath = NSString(string:sPath).appendingPathComponent(info)
        return infoPath
    }
    
    
    
    
}

/*
 1 第一次进入阅读器 -> c_id = 0 -> 获取内容(此时没有目录) ->更新本地节点-> 适当时机更新目录 -> 走老的逻辑
 2 本地有记录没有目录 -> c_id !=0 -> 获取内容-> 更新本地节点 -> 适当时机更新目录 -> 走老的逻辑
 
 2.1 跳章看 ->必须有目录（没有c_id） -> 逻辑不变
 2.2 跳章看 -> 有c_id -> 新逻辑
 
 3.1 目录一直为空 -> 新逻辑
 4.1 新逻辑c_id问题时 -> 跳转到第一章 -> 强制用户刷新目录 -> 映射当前本地数据数据
 
 */
