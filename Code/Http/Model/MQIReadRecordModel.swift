//
//  MQIReadRecordModel.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


let GYReadLastPageValue:NSInteger = -1
class MQIReadRecordModel: MQIBaseModel {
    
    /// 小说ID
    var bookId:String = ""
    
    /// 当前阅读到的章节临时模型 不 保存 于 model 中 理由：包含 content 而 content 要单独存储
    var readChapterModel: MQIEachChapter?
    
    /// 当前章节阅读到的页码
    var page = NSNumber(value: 0)
    
    /// 当前章节所在数组中的位置
    var chapterIndex = NSNumber(value: 0)
    
    /// 是否为本地小说
    var isLocalBook:NSNumber = NSNumber(value: 0)
    
    /// 章节列表数组
    var chapterList = [MQIEachChapter]()
    
    /// 书签列表
    private(set) var readMarkModels:[MQIReadMarkModel] = [MQIReadMarkModel]()
    
    /// 当前书签(用于记录使用)
    private(set) var readMarkModel:MQIReadMarkModel?
    
    /// 最后阅读时间
    var lastReadTime:TimeInterval = 0
    
    override init() {
        super.init()
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        for key in allPropertyNames() {
            if key != "chapterList" {
                if let value = aDecoder.decodeObject(forKey: key) {
                    setValue(value, forKey: key)
                }
            }
        }
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        for (key, value) in allPropertys() {
            if let value = value {
                if key != "chapterList" {
                    aCoder.encode(value, forKey: key)
                }
            }
        }
    }
    
    // MARK: -- 操作
    
    /// 保存
    
    /// 修改阅读记录为指定章节ID 指定页码 (toPage: -1 为最后一页 也可以使用 GYReadLastPageValue)
    func modify(chapter: MQIEachChapter, toPage: NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false, isForce: Bool = false) {
        if isForce == true {
            chapter.forceUpdateFont(chapterIndex: chapterIndex.intValue)
        }else if isUpdateFont == true {
            chapter.updateFont(chapterIndex: chapterIndex.intValue)
        }
        var shouldPage = toPage
        if (chapter.pageCount.intValue > 0) &&
            (chapter.pageCount.intValue - 1 < toPage) {
            shouldPage = chapter.pageCount.intValue - 1
        }
        readChapterModel = chapter
        
        page = (toPage == GYReadLastPageValue) ? NSNumber(value: readChapterModel!.pageCount.intValue - 1) : NSNumber(value: shouldPage)
        if isSave {save()}
    }
    
    /// 修改阅读记录为指定书签记录
    func modify(readMarkModel:MQIReadMarkModel, isUpdateFont: Bool = false, isSave: Bool = false) {
        //
        //        if MQIEachChapter.IsExistReadChapterModel(bookId: readMarkModel.bookId, chapterId: readMarkModel.id) {
        //
        //            readChapterModel = MQIEachChapter.readChapterModel(bookId: bookId, chapterId: readMarkModel.id, isUpdateFont: isUpdateFont)
        //
        //            page = NSNumber(value: readChapterModel!.page(location: readMarkModel.location.intValue))
        //
        //            if isSave {save()}
        //        }
    }
    
    func save() {
        self.lastReadTime = getNowTime()
        MQILastReaderManager.shared.recordDict[bookId] = self
        MQILastReaderManager.shared.saveLastReader()
    }
    
    private func getNowTime() -> TimeInterval{
        return Date().timeIntervalSince1970
    }
    
    /// 刷新字体
    func updateFont(isSave:Bool = false) {
        if let readChapterModel = readChapterModel {
            
            var location: Int = 0
            if readChapterModel.rangeArray.count > page.intValue {
                location = readChapterModel.rangeArray[page.intValue].location
            }
            
            readChapterModel.updateFont(chapterIndex: chapterIndex.intValue)
            page = NSNumber(value: readChapterModel.page(location: location))
            //            readChapterModel.save()
            
            //            if isSave {save()}
        }
    }
    
    // MARK: -- 拷贝
    func copySelf() -> MQIReadRecordModel {
        
        let readRecordModel = MQIReadRecordModel()
        
        readRecordModel.bookId = bookId
        
        readRecordModel.readChapterModel = readChapterModel
        
        readRecordModel.page = page
        
        readRecordModel.chapterIndex = chapterIndex
        
        return readRecordModel
    }
    
}
