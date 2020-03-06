//
//  GYReadModel.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadModel: MQIBaseModel {
    
    /// 小说ID
    var bookId:String = ""
    
    /// 是否为本地小说
    var isLocalBook:NSNumber = NSNumber(value: 0)
    
    /// 章节列表数组
    var chapterList = [MQIEachChapter]()
    
    /// 阅读记录
    var readRecordModel: MQIReadRecordModel!
    
    /// 书签列表
    private(set) var readMarkModels:[MQIReadMarkModel] = [MQIReadMarkModel]()
    
    /// 当前书签(用于记录使用)
    private(set) var readMarkModel:MQIReadMarkModel?
    
    override init() {
        super.init()
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    // MARK: -- 操作
    
    /// 修改阅读记录为 指定章节ID 指定页码
    func modifyReadRecordModel(chapter: MQIEachChapter, toPage:NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false, isForce: Bool = false) {
        readRecordModel.modify(chapter: chapter, toPage: toPage, isUpdateFont: isUpdateFont, isSave: isSave, isForce: isForce)
    }
    
    /// 修改阅读记录到书签模型
    func modifyReadRecordModel(readMarkModel:MQIReadMarkModel, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        readRecordModel.modify(readMarkModel: readMarkModel, isUpdateFont: isUpdateFont, isSave: isSave)
    }
    
    /// 保存
    func save() {
        
        // 阅读记录
        readRecordModel.save()
    }
    
    // MARK: -- 操作 - 书签
    
    /// 添加书签 默认使用当前阅读记录作为书签
    func addMark(readRecordModel:MQIReadRecordModel? = nil) {
        
        let readRecordModel = (readRecordModel != nil ? readRecordModel : self.readRecordModel)!
        
        let readMarkModel = MQIReadMarkModel()
        
        readMarkModel.bookId = readRecordModel.readChapterModel!.bookId
        
        //        readMarkModel.id = readRecordModel.readChapterModel!.id
        
        readMarkModel.name = readRecordModel.readChapterModel!.chapter_title
        
        readMarkModel.location = NSNumber(value: readRecordModel.readChapterModel!.rangeArray[readRecordModel.page.intValue].location)
        
        readMarkModel.content = readRecordModel.readChapterModel!.string(page: readRecordModel.page.intValue)
        
        readMarkModel.time = Date()
        
        readMarkModels.append(readMarkModel)
        
        save()
    }
    
    /// 删除书签 默认使用当前存在的书签
    func removeMark(readMarkModel:MQIReadMarkModel? = nil, index:NSInteger? = nil) ->Bool {
        
        if index != nil {
            
            readMarkModels.remove(at: index!)
            
            save()
            
            return true
            
        }else{
            
            let readMarkModel = (readMarkModel != nil ? readMarkModel : self.readMarkModel)
            
            if readMarkModel != nil && readMarkModels.contains(readMarkModel!) {
                
                readMarkModels.remove(at: readMarkModels.index(of: readMarkModel!)!)
                
                save()
                
                return true
            }
        }
        
        return false
    }
    
    /// 检查当前页面是否存在书签 默认使用当前阅读记录作为检查对象
    func checkMark(readRecordModel:MQIReadRecordModel? = nil) ->Bool {
        
        
        
        return false
    }
    
    
}

