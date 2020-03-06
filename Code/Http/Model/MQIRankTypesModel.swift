//
//  MQIRankTypesModel.swift
//  Reader
//
//  Created by CQSC  on 2017/11/1.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

//精品排行
final class MQIRankTypesModel: MQIBaseModel,ResponseCollectionSerializable {
    
    var type:String = ""
    var name:String = ""
    
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
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    
}

/// 推荐模型
class MQRecommendInfoModel: MQIBaseModel {
    
    var type:String = "" ///类型
    var name: String = "" ///名称
    var data =  [MQIEachBook]() //itme
    var total: String = "" ///名称
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data" {
            data = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
        
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
        
    }
    
}

class MQ_ClassificationModel: MQIBaseModel{
    
    var data = [MQIClassificationItemModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}
final class MQIClassificationItemModel: MQIBaseModel,ResponseCollectionSerializable{
    
    var id:String = ""
    var name:String = ""
    var class_id:String = "" //分类类型  1一级分类 2二级分类
    var books = [MQIClassificationItemModel]()
    
    var target_class_id:String = ""
    var class_type:String = ""
    
    var book_id:String = ""
    var book_name:String = ""
    var cover:String = ""
    var image_url:String = ""
    
    var book_status:String = ""
    var book_intro:String = ""// 简介
    var book_label:String = ""// 标签
    var book_words:String = ""// 字数
    //    var book_cover:String = ""//封面
    /// 新接口
    var  book_coverModel  = MQICoverMoldel()
    
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "books" {
            books = setValueToArray(value, key: key)
        } else if key == "book_cover" {
            book_coverModel = setDictToModel(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}



/// 网络阅读记录
class MQIUserReadRecordModel: MQIBaseModel {
    
    var type:String = "" ///类型
    var name: String = "" ///名称
    var data =  [MQIUserReadRecordItemModel]() //itme
    var total: String = "" ///名称
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data" {
            data = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
        
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
        
    }
    
}


/// 推荐模型
class MQIUserReadRecordItemModel: MQIBaseModel {
    
    var book_id:String = ""
    var book_name:String = ""
    var chapter_id:String = ""
    var chapter_title:String = ""
    var chapter_code:String = ""
    var position:String = ""
    
    var readtime:String = ""
    var book_intro:String = ""// 简介
    var book_label:String = ""// 标签
    var book_words:String = ""// 字数
    var book_status:String = ""
    /// 新接口
    var  book_coverModel  = MQICoverMoldel()
    
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "book_cover" {
            book_coverModel = setDictToModel(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}
