//
//  MQILastReaderManager.swift
//  YH
//
//  Created by È´òÁé• on 15/5/28.
//  Copyright (c) 2015Âπ¥ _xinmo_. All rights reserved.
//

import UIKit


class MQILastReaderManager: NSObject {
    
    var readPath = MQIFileManager.getCurrentStoreagePath("readRecord.db")
    
    fileprivate static var __once: () = {
        Inner.instance = MQILastReaderManager()
    }()
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQILastReaderManager?
    }
    
    
    class var shared: MQILastReaderManager {
        _ = MQILastReaderManager.__once
        return Inner.instance!
    }
    
    var recordDict = [String : MQIReadRecordModel](){
        didSet(oldValue) {
            
        }
    }
    
    override init() {
        super.init()
        
        //把以前 readerModel 的字典转移到  recordModel 的字典 方便 阅读器的使用
        let lastPath = MQIFileManager.getCurrentStoreagePath("reader.db")
        if let readerDict = NSKeyedUnarchiver.unarchiveObject(withFile: lastPath) as? NSDictionary {
            for (key, value) in readerDict {
                if value is MQIReaderModel && key is String {
                    recordDict[key as! String] = copyReaderModelToRecordModel(value as! MQIReaderModel)
                }
            }
            saveLastReader()
            MQIFileManager.removePath(lastPath)
        }
        
        if let dict = NSKeyedUnarchiver.unarchiveObject(withFile: readPath) as? [String : MQIReadRecordModel] {
            recordDict = dict
        }
        
    }
    
    //mdoel 转移
    func copyReaderModelToRecordModel(_ readerModel: MQIReaderModel) -> MQIReadRecordModel {
        let recordModel = MQIReadRecordModel()
        recordModel.bookId = readerModel.bid
        recordModel.chapterIndex = NSNumber(value: readerModel.bookChapterIndex)
        
        let chapter = MQIEachChapter()
        chapter.chapter_title = readerModel.bookChapterTitle
        
        recordModel.readChapterModel = chapter
        return recordModel
    }
    
    //MARK: 获取最后阅读
    func getLastReader(_ bid: String) -> MQIReadRecordModel? {
        return recordDict[bid]
    }
    
    //MARK: 保存最后阅读的字典 bookID和章节
    func saveLastReader() {
        dispatchArchive(recordDict, path: readPath)
    }
    
    //MARK: 添加readerModel到最后阅读字典中
    func addLastReader(_ recordModel: MQIReadRecordModel, book: MQIEachBook) {
        recordDict[book.book_id] = recordModel
        saveLastReader()
    }
    
    func nowtimeDate(_ oldTime:TimeInterval) -> String {
        var timeString = "" 
        let oldDate =  Date(timeIntervalSince1970: oldTime)
        let time = Date().timeIntervalSince(oldDate)
        if time < 60 {
            timeString = kLocalized("just_date")
        }else if time/60 < 60 {
            timeString = kLongLocalized("MinutesAgo", replace: "\(Int(time/60))", isFirst: true)
        }else if time/(60*60) < 24 {
            timeString =  kLongLocalized("HoursBefore", replace: "\(Int(time/(60*60)))", isFirst: true)
        }else if time/(24*60*60) < 30 {
            timeString = kLongLocalized("DaysAgo", replace: "\(Int(time/(24*60*60)))", isFirst: true)
        }else if time/(24*60*60*30) < 12 {
            timeString =  kLongLocalized("MonthAgo", replace: "\(Int(time/(24*60*60*30)))", isFirst: true)
        }else {
            timeString = kLongLocalized("YearsAgo", replace: "\(Int(time/(24*60*60*30*12)))", isFirst: true)
        }
        return timeString
        
    }
  
}


