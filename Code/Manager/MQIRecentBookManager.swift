//
//  MQIRecentBookManager.swift
//  Reader
//
//  Created by _CHK_  on 16/7/15.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

import UIKit


class MQIRecentBookManager: NSObject {
    
    var books: [MQIEachBook] = [MQIEachBook]()
    //阅读记录以手机为单位，不区分用户
    fileprivate var recentPath: String! {
        return MQIFileManager.getCurrentStoreagePath("grecents.db")
    }
    
    fileprivate var tmpPath: String! {
        return recentPath
    }
    
    fileprivate static var __once: () = {
        Inner.instance = MQIRecentBookManager()
    }()
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIRecentBookManager?
    }
    
    class var shared: MQIRecentBookManager {
        _ = MQIRecentBookManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        refershBooks()
    }
    //阅读记录是手机端的，跟用户没关，所以只要一个手机的库，用户库不用
    func refershBooks() {
        //        self.books.removeAll()
        //        if let books = NSKeyedUnarchiver.unarchiveObject(withFile: recentPath) as? [MQIEachBook] {
        //            self.books = books
        //        }
        self.books.removeAll()
        self.books = MQIDataUtil.getdbRecentBooks()
        if self.books.count == 0 {
            self.books =  MQIDataUtil.conversionRecentFileData(recentPath)
        }
        
    }
    
    func checkIsExist(_ bid: String) -> Bool {
        //        for book in books {
        //            if bid == book.book_id {
        //                return true
        //            }
        //        }
        //        return false
        return   (MQIDataUtil.getDBLibraryBook(bid) == nil) ? true:false
    }
    
    
    
    //    @discardableResult func updateRecents(_ books: [MQIEachBook]) -> Bool {
    //        self.books = books
    //        return saveRecents()
    //    }
    
    //    @discardableResult func saveRecents() -> Bool {
    //        if books.count >= 0 {
    //            dispatchArchive(books, path: recentPath)
    //            return true
    //        }
    //        return true
    //    }
    
    @discardableResult func  addRecentReader(_ book: MQIEachBook,chapter:MQIEachChapter?,position:Int) -> Bool {
        let  results =  MQIDataUtil.saveRecentBook(book, atts:  [.chapterId(chapter?.chapter_id.integerValue() ?? 1),.readTime(getCurrentStamp()),.chapterTitle(chapter?.chapter_title ?? ""),.chapterPosition(position)])
        books = MQIDataUtil.getdbRecentBooks()
        ShelfNotifier.postNotification(.refresh_recent)
        return   results
    }
    
    
    @discardableResult   func addRecentReader(_ book:MQIEachBook)  -> Bool{
        let  results =  MQIDataUtil.saveRecentBook(book, atts: [.updateBook(book.updateBook)])
        books = MQIDataUtil.getdbRecentBooks()
        ShelfNotifier.postNotification(.refresh_recent)
        return   results
    }
    
    //    @discardableResult func  addRecentReader(_ book: MQIEachBook,chapter:MQIEachChapter,position:Int) -> Bool {
    //        for i in 0..<books.count {
    //            if books[i].book_id == book.book_id {
    //                books.remove(at: i)
    //                break
    //            }
    //        }
    //        let date = Date()
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .medium
    //        formatter.timeStyle = .short
    //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        let nowStr = formatter.string(from: date)
    //        book.book_last_read_time = nowStr
    //        books.insert(book, at: 0)
    //        return   results
    //    }
    
    @discardableResult   func removeRecentBook(book: MQIEachBook) -> Bool {
        books = books.filter({$0.book_id != book.book_id})
        return MQIDataUtil.saveRecentBook(book, atts:  [.chapterId(0)])
    }
}

