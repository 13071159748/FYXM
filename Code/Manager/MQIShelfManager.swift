//
//    ShelfManager.swift
//  Reader
//
//  Created by _CHK_  on 16/9/27.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

import UIKit


let KRECOMMENDREQUEST = "KRECOMMENDREQUEST"

let Judge_IsFirst_OpenApp = "judge_isfirstOpenapp"

let Judge_recommandsRequestFailed = "judgereconmandsrequesrfauled"

class MQIShelfManager: NSObject {
    
    fileprivate static var __once: () = {
        Inner.instance = MQIShelfManager()
    }()
    
    var books = [MQIEachBook]()
    
    var tmpPath = MQIFileManager.getCurrentStoreagePath("shelf.db")
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIShelfManager?
    }
    
    class var shared: MQIShelfManager {
        _ = MQIShelfManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        //
        //        if MQIFileManager.checkFileIsExist(tmpPath) == true {
        //            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: tmpPath) as? [MQIEachBook] {
        //                books = array
        //            }
        //        }
        getFileBook()
        
    }
    
    func getFileBook() {
        books =  MQIDataUtil.getdbShelfBooks()
        if books.count == 0 {
            books = MQIDataUtil.conversionFileData(tmpPath)
        }
    }
    
    func checkIsExist(_ bid: String) -> Bool {
        for book in books {
            if bid == book.book_id {
                return true
            }
        }
        return false
    }
    
    @discardableResult func updateBooks(_ books: [MQIEachBook]) -> Bool {
        self.books = books
        return saveBooks()
    }
    
    @discardableResult func addToBooks(_ book: MQIEachBook) -> Bool {
        //        if books.map({$0.book_id}).contains(book.book_id) == false {
        //            books.append(book)
        //        }
        //
        //        return saveBooks()
        let results =  MQIDataUtil.saveShelfBook(book)
        books = MQIDataUtil.getdbShelfBooks()
        return results
    }
    
    @discardableResult func saveBooks() -> Bool {
        //        if books.count >= 0 {
        //            dispatchArchive(books, path: tmpPath)
        //            return true
        //        }
        if books.count >= 0 {
            //            var t = 0
            //            for  book in books {
            //                t += 1
            //                 book.
            //            }
            MQIDataUtil.saveShelfBook(books)
            
            return true
        }
        return true
    }
    
    @discardableResult  func delBooks(delIDs:[String]? = nil,delBooks:[MQIEachBook]? = nil) -> Bool {
        var userbooks = books
        if let delIDsNew = delIDs {
            for id in delIDsNew {
                if   let book  = userbooks.filter({$0.book_id == id}).first {
                    MQIDataUtil.saveShelfBook(book, atts: [.favorite(0)])
                }
                userbooks = userbooks.filter({$0.book_id != id})
            }
            return updateBooks(userbooks)
        }
        
        if let delBooksNew = delBooks  {
            for book in delBooksNew {
                userbooks = userbooks.filter({$0.book_id != book.book_id})
                MQIDataUtil.saveShelfBook(book, atts: [.favorite(0)])
            }
            return updateBooks(userbooks)
        }
        return true
        //        return updateBooks(userbooks)
        
    }
    //MARK:判断是否是首次进入app
    @discardableResult func shelf_judgeIsFirstRequestRecommendsBooks()->Bool{
        if let judge = UserDefaults.standard.object(forKey: Judge_IsFirst_OpenApp){
            if (judge as! String) == Judge_IsFirst_OpenApp {
                return false
            }
        }
        return true
    }
    class func shelfManagerFirstOpen() {
        let ud = UserDefaults.standard
        ud.set(Judge_IsFirst_OpenApp, forKey: Judge_IsFirst_OpenApp)
        ud.synchronize()
    }
    func shelf_getRecommands_falied() {
        let ud = UserDefaults.standard
        ud.set(Judge_recommandsRequestFailed, forKey: Judge_IsFirst_OpenApp)
        ud.synchronize()
    }
    func shelfManager_requestRecommends() {
        let aa = UserDefaults.standard.object(forKey: Judge_IsFirst_OpenApp)
        if aa == nil {
            shelf_requestRecommends()
        }
        if let isfailed = UserDefaults.standard.object(forKey: Judge_IsFirst_OpenApp){
            if (isfailed as! String) == Judge_recommandsRequestFailed {
                shelf_requestRecommends()
            }
        }
    }
    func shelf_requestRecommends(completion: ((_ suc: Bool) -> ())? = nil) {
        
        GYBookShelfRecommends()
            .request({[weak self] (request, response, resultNew: MQRecommendInfoModel) in
                if let strongSelf = self {
                    let result = resultNew.data
                    var allbooks = MQIShelfManager.shared.books
                    
                    if result.count > 0{
                        for i in 0..<result.count{
                            allbooks = allbooks.filter({$0.book_id != result[i].book_id})
                            allbooks.append(result[i])
                        }
                    }
                    strongSelf.books = allbooks
                    strongSelf.saveBooks()
                    MQIShelfManager.shelfManagerFirstOpen()
                    //postnotification  刷新shelf
                    ShelfNotifier.postNotification(.refresh_recommends)
                }
            }) {[weak self](err_msg, err_code) in
                if let weakSelf = self {
                    weakSelf.shelf_getRecommands_falied()
                }
        }
    }
    
    ///同步书籍
    func syncShelf(save:[String]?,del:[String]?,callBlock:((_ suc:Bool,_ msg:String)->())?) {
        delBooks(delIDs: del)
        if !MQIUserManager.shared.checkIsLogin() { callBlock?(false,kLocalized("SorryYouHavenLoggedInYet"));return}
        GYBookShelfRequest(ids: save, delete: del)
            .requestCollection({ (request, response, result: [MQIEachBook]) in
                DispatchQueue.global().async {
                    MQIShelfManager.shared.checkBooksUpdate(result)
                    DispatchQueue.main.async {
                        callBlock?(true,kLocalized("TheBookInformationSynchronizationIsSuccessful"))
                    }
                }
            }, failureHandler: {(err_msg, err_code) in
                callBlock?(false,err_msg)
                
            })
    }
    
    func checkBooksUpdate(_ result: [MQIEachBook]) {
        
        
        let ids = books.map({$0.book_id})
        for m in result {if !ids.contains(m.book_id) {books.append(m)}}
        
        for i in 0..<books.count {
            if let book = result.filter({$0.book_id == books[i].book_id}).first {
                books.replaceSubrange(i...i, with: [book])
                if books[i].book_update != book.book_update  &&  book.updateBook == 1 {
                    books[i].updateBook = 1
                }else {
                    books[i].updateBook = 0
                }
                //                books[i].book_update  = "100"
            }
        }
        DispatchQueue.main.async {
            MQIShelfManager.shared.updateBooks(self.books)
        }
        
        
    }
    
    
}

