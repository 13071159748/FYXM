//
//  GYBookDownloadManager.swift
//  Reader
//
//  Created by _CHK_  on 16/7/15.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

import UIKit



private let sharedInstance = GYBookDownloadManager();

let ALREADY_DOWNLOAD = "ALREADY_DOWNLOAD"
class GYBookDownloadManager: NSObject {
    
    fileprivate static var __once: () = {
        Inner.instance = GYBookDownloadManager()
    }()
    
    //下载杜列
    var downloadQueue = [String]()
    var stopDownload: Bool = false
    
    struct Inner {
        static var token: Int = 0
        static var instance: GYBookDownloadManager?
    }
    
    class var shared: GYBookDownloadManager {
        _ = GYBookDownloadManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        
    }
    
    //MARK: queue
    func checkQueue(_ bid: String) -> Bool {
        return downloadQueue.contains(bid)
    }
    
    func addQueue(_ bid: String) {
        if downloadQueue.contains(bid) == false {
            downloadQueue.append(bid)
        }
    }
    
    func removeQueue(_ bid: String) {
        for i in 0..<downloadQueue.count {
            if downloadQueue[i] == bid {
                downloadQueue.remove(at: i)
            }
        }
    }
    
    fileprivate var currentVipDownloadDict = [String : Int]()
    
    //MARK: -- 下载已经订阅的 章节 tids
    //MARK:   我去这个坑爹的名称+逻辑，搞了一下午才知道tids特么是个订阅过的VIP章节集合我擦泪中。。。。。
    func toDownloadAllSubscribe(_ book: MQIEachBook, allList: [MQIEachChapter], tids: [String],less:Bool = false) {
        
        guard self.checkQueue(book.book_id) == false else {
            DispatchQueue.main.async(execute: { () -> Void in
                MQILoadManager.shared.makeToast("\(book.book_name) \(kLocalized("AlreadyAddDown"))")
            })
            return
        }
        
        var allTids = [[String]]()
        var freeChaptrs = [MQIEachChapter]()
        if less {
            freeChaptrs = allList.filter({$0.chapter_vip == false && $0.isDown == false})
        }else{
            freeChaptrs = allList.filter({$0.chapter_vip == false})
        }
        
        allTids.append(tids)
        
        if freeChaptrs.count > 0 {
            
            toDownloadFreeBooks(book, list: allList, freeList: freeChaptrs, continueDown: allTids.count > 0,less: less, completion: {[weak self] in
                if let strongSelf = self {
                    strongSelf.requestDownloadList(book, allList: allList, allTids: allTids)
                }
                }, failed: { [weak self] (code, msg) in
                    //免费下载失败
                    if code == ALREADY_DOWNLOAD {
                        DispatchQueue.main.async(execute: { () -> Void in
                            MQILoadManager.shared.makeToast(msg)
                        })
                        
                        if let strongSelf = self {
                            strongSelf.requestDownloadList(book, allList: allList, allTids: allTids)
                        }
                    }
            })
        }else {
            requestDownloadList(book, allList: allList, allTids: allTids)
        }
    }
    //MARK: -- 下载 章节 分 VIP Free
    func downloadBooks(_ book: MQIEachBook, allList: [MQIEachChapter], freeDownList: [MQIEachChapter]?, VIPDownList: [MQIEachChapter]?) {
        
        var downloadList = [MQIEachChapter]()
        if let freeDownList = freeDownList {
            downloadList.append(contentsOf: freeDownList)
        }
        if let VIPDownList = VIPDownList {
            downloadList.append(contentsOf: VIPDownList)
        }
        
        if checkNetStatus() == false {
            
            DispatchQueue.main.async(execute: { () -> Void in
                MQILoadManager.shared.makeToast("请检查您的网络环境")
            })
            return
        }
        
        var allTids = [[String]]()
        var nTids = [String]()
        var index: Int = 0
        for i in 0..<downloadList.count {
            nTids.append(downloadList[i].chapter_id)
            if index >= 49 {
                index = 0
                allTids.append(nTids)
                nTids.removeAll()
            }else if i == downloadList.count-1 {
                allTids.append(nTids)
            }
            index += 1
        }
        
        if let VIPDownList = VIPDownList {
            if VIPDownList.count > 0 {
                
                let ids = VIPDownList.map({$0.chapter_id})
                GYSubscribeBookRequest(book_id: book.book_id, chapter_ids: ids)
                    .request({[weak self] (request, response, result: MQIEachSubscribe) in
                        if let strongSelf = self {
                            UserNotifier.postNotification(.refresh_coin)
                            MQIUserManager.shared.updateUserCoin({ (suc, str) in
                                strongSelf.addQueue(book.book_id)
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    MQILoadManager.shared.makeToast("您已成功订阅 \(VIPDownList.count) 章，即将下载")
                                })
                                strongSelf.requestDownloadList(book, allList: allList, allTids: allTids)
                            })
                            
                        }
                    }) {[weak self] (err_msg, err_code) in
                        if let strongSelf = self {
                            strongSelf.removeQueue(book.book_id)
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                MQILoadManager.shared.makeToast(err_msg)
                            })
                            
                            
                        }
                }
                
                return
            }
        }
        
        self.addQueue(book.book_id)
        
        DispatchQueue.main.async(execute: { () -> Void in
            MQILoadManager.shared.makeToast("\(book.book_name) \(kLocalized("AlreadyAddDown"))")
        })
        
        requestDownloadList(book, allList: allList, allTids: allTids)
        
        
    }
    
    //MARK: 下载 章节内容
    func requestDownloadList(_ book: MQIEachBook, allList: [MQIEachChapter], allTids: [[String]]) {
        
        
        var index: Int = 0
        if let cIndex = currentVipDownloadDict[book.book_id] {
            index = cIndex
        }else {
            currentVipDownloadDict[book.book_id] = index
        }
        
        var ids = [String]()
        for i in allTids {
            for j in i {
                ids.append(j)
            }
        }
        
        if ids.count == 0 {
            self.currentVipDownloadDict.removeValue(forKey: book.book_id)
            GYBookManager.shared.updateDownloadBook(book)
            self.removeQueue(book.book_id)
            
            DispatchQueue.main.async(execute: { () -> Void in
                MQILoadManager.shared.makeToast(kLocalized("YouBookDownDon"))
                let dict = ["list" : allList, "book" : book] as [String : Any]
                DownNotifier.postNotification(.download_finish, object: nil, userInfo: dict)
            })
            
            
            return
        }
        var  downcount = 0
        DispatchQueue.global().async { () -> Void in
            for i in 0..<ids.count {
                let chapter_id = ids[i]
                self.downChapter(book: book, chapter_id: chapter_id, list: allList, completion: { [weak self] in
                    downcount += 1
                    if downcount == ids.count {
                        if let strongSelf = self {
                            DispatchQueue.main.async(execute: { () -> Void in
                                strongSelf.currentVipDownloadDict.removeValue(forKey: book.book_id)
                                GYBookManager.shared.updateDownloadBook(book)
                                strongSelf.removeQueue(book.book_id)
                                MQILoadManager.shared.makeToast(kLocalized("YouBookDownDon"))
                                let dict = ["list" : allList, "book" : book] as [String : Any]
                                DownNotifier.postNotification(.download_finish, object: nil, userInfo: dict)
                                
                            })
                        }
                        
                    }
                }) {[weak self](err_msg, err_code) in
                    downcount += 1
                    if downcount == allList.count {
                        if let strongSelf = self {
                            strongSelf.currentVipDownloadDict.removeValue(forKey: book.book_id)
                            strongSelf.removeQueue(book.book_id)
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            MQILoadManager.shared.makeToast(err_msg)
                        })
                        
                        
                    }
                }
                
            }
        }
        
    }
    
    
    func downChapter (book:MQIEachBook, chapter_id:String,list: [MQIEachChapter],completion: (() -> ())?, failed: ((_ code: String, _ msg: String) -> ())?) {
        GYEncryptionContentRequest(book_id: book.book_id,chapter_id:chapter_id,cdn:false)
            .request({ (request, response, result:MQIEachChapter) in
                if result.content.count > 0 {
                    result.content =  unlockCntent.getOriginContent(bookId: book.book_id.integerValue(), chapterId:chapter_id.integerValue(), cryptString: result.chapter_content)
                    result.isDown = true
                    MQIFileManager.saveChapterContent(book.book_id, tid: chapter_id, content: result.content)
                    book.downTids.append(chapter_id)
                    let tids =  book.downTids
                    for i in 0..<list.count {
                        if tids.contains(list[i].chapter_id) {
                            list[i].isDown = true
                            list[i].content = result.content
                        }
                    }
                    MQIFileManager.saveChapterList(book.book_id, list: list)
                }
                completion?()
                
                
            }) { (err_msg, err_code) in
                //                self.removeQueue(book.book_id)
                //                MQILoadManager.shared.makeToast(err_msg)
                failed?(err_code, err_msg)
        }
    }
    
    
    //MARK: --  --- -- -- - -- - -
    func toDownloadFreeBooks(_ book: MQIEachBook, list: [MQIEachChapter], freeList: [MQIEachChapter]?, continueDown: Bool = false,less:Bool = false, completion: (() -> ())?, failed: ((_ code: String, _ msg: String) -> ())?) {
        if checkNetStatus() == false {
            DispatchQueue.main.async(execute: { () -> Void in
                MQILoadManager.shared.makeToast(kLocalized("CheckI"))
            })
            
            return
        }
        
        if self.checkQueue(book.book_id) == true {
            DispatchQueue.main.async(execute: { () -> Void in
                MQILoadManager.shared.makeToast("\(book.book_name) \(kLocalized("AlreadyAddDown"))")
            })
            
            return
        }
        
        let array = freeList == nil ? list : freeList!
        var freeChapters = [MQIEachChapter]()
        if less {
            freeChapters = array.filter({$0.chapter_vip == false && $0.isDown == false})
        }else{
            freeChapters = array.filter({$0.chapter_vip == false})
        }
        if freeChapters.count <= 0 {
            self.removeQueue(book.book_id)
            failed?(ALREADY_DOWNLOAD, "免费章节已经全部下载完成")
            return
        }
        DispatchQueue.main.async(execute: { () -> Void in
            MQILoadManager.shared.makeToast("\(book.book_name) 成功加入下载队列")
        })
        
        self.addQueue(book.book_id)
        var  downcount = 0
        
        DispatchQueue.global().async { () -> Void in
            
            for i in 0..<freeChapters.count {
                let chapter = freeChapters[i]
                self.downChapter(book: book, chapter_id: chapter.chapter_id, list: list, completion: {
                    downcount += 1
                    if downcount == freeChapters.count {
                        DispatchQueue.main.async(execute: { () -> Void in
                            GYBookManager.shared.updateDownloadBook(book)
                            if continueDown == false {
                                MQILoadManager.shared.makeToast("所有免费章节已经下载成功")
                            }
                            completion?()
                        })
                    }
                }) {(err_msg, err_code) in
                    downcount += 1
                    if downcount == freeChapters.count {
                        self.removeQueue(book.book_id)
                        //                    MQILoadManager.shared.makeToast(err_msg)
                        failed?(err_code, err_msg)
                    }
                }
                
            }
            
        }
        
        
    }
    
}

