//
//  MQIMainBannerModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIMainBannerModel: MQIBaseModel, ResponseCollectionSerializable {

    var id:String=""
    var type: String = ""
    var url: String = ""
    var cover:String = ""
    var desc: String = ""
    var book_id: String = ""
    var book_name: String = ""
    var name: String = ""
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    override init() {
        super.init()
    }
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
}
//MARK:首页导航分类
final class MQIMainNavModel: MQIBaseModel, ResponseCollectionSerializable{
    
    var id:String=""
    var title: String = ""
    var url: String = ""
    var icon:String = ""
    var app_link: String = ""
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
}

class MQIMainBannerRecommendModel: MQIBaseModel {
    
    var id: String = ""
    var data_type: String = ""  ///1：书籍  10：banner  20：topic  30：广告
    var title: String = ""      ///标题
    var desc: String = ""       ///描述
    var app_link: String = ""   ///链接地址
    var img: String = ""        ///图片地址
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    //        mqLog("UndefinedKey \(key) \(String(describing: value))")
        }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        id = decodeStringForKey(aDecoder, key: "id")
        data_type = decodeStringForKey(aDecoder, key: "data_type")
        title = decodeStringForKey(aDecoder, key: "title")
        desc = decodeStringForKey(aDecoder, key: "desc")
        app_link = decodeStringForKey(aDecoder, key: "app_link")
        img = decodeStringForKey(aDecoder, key: "img")
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
}

final class MQIMainRecommendModel: MQIBaseModel, ResponseCollectionSerializable {
    
    var id: String = ""
    var name: String = ""
    var type: String = ""
    var limit_free:Bool = false
    /// 新接口 限时免费只有这么一个字段
    var limit_time:String = ""
    var books = [MQIMainEachRecommendModel]()
    var topics = [MQIMainEachRecommendModel]()
    var banners = [MQIMainBannerRecommendModel]()
    var limitFree:Bool = false
    var limitTime:String = ""
    
    var pos_id:String = ""
    
    ///板块是否显示标题
    var name_display:Bool = false
    
    ///专题描述
    var desc:String = ""
    ///专题跳转链接
    var link:String = ""
    ///专题图片
    var image:String = ""
    
    var title:String = ""
    
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "books" {
            books = setValueToArray(value, key: key)
        }else if key == "topics" {
            topics = setValueToArray(value, key: key)
        } else if key == "banners" {
            banners = setValueToArray(value, key: key)
        } else if key == "limit_free" {
            limit_free = getBoolWithValue(value)
        } else if key == "limitFree" {
            limitFree = getBoolWithValue(value)
        } else {
            super.setValue(value, forKey: key)
        }
    }
    required init(coder aDecoder: NSCoder){
        //        super.init(coder: aDecoder)
        super.init()
        id = decodeStringForKey(aDecoder, key: "id")
        name = decodeStringForKey(aDecoder, key: "name")
        type = decodeStringForKey(aDecoder, key: "type")
        limit_free = decodeBoolForKey(aDecoder, key: "limit_free")
        limit_time = decodeStringForKey(aDecoder, key: "limit_time")
        books = decodeObjForKey(aDecoder, key: "books") as? [MQIMainEachRecommendModel] ?? []
        topics = decodeObjForKey(aDecoder, key: "topics") as? [MQIMainEachRecommendModel] ?? []
        banners = decodeObjForKey(aDecoder, key: "banners") as? [MQIMainBannerRecommendModel] ?? []
        limitFree = decodeBoolForKey(aDecoder, key: "limitFree")
        limitTime = decodeStringForKey(aDecoder, key: "limitTime")
        
        name_display = decodeBoolForKey(aDecoder, key: "name_display")
        desc = decodeStringForKey(aDecoder, key: "desc")
        link = decodeStringForKey(aDecoder, key: "link")
        image = decodeStringForKey(aDecoder, key: "image")
        pos_id = decodeStringForKey(aDecoder, key: "pos_id")
        title = decodeStringForKey(aDecoder, key: "title")
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        //        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(limit_free, forKey: "limit_free")
        aCoder.encode(limit_time, forKey: "limit_time")
        aCoder.encode(books, forKey: "books")
        aCoder.encode(limitFree, forKey: "limitFree")
        aCoder.encode(limitTime, forKey: "limitTime")
        
        
        aCoder.encode(topics, forKey: "topics")
        aCoder.encode(name_display, forKey: "name_display")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(pos_id, forKey: "pos_id")
        aCoder.encode(banners, forKey: "banners")
        aCoder.encode(title, forKey: "title")
    }
    
}

class MQIMainEachRecommendDataModel: MQIBaseModel {
    
    var type:String = "" ///类型
    var name: String = "" ///名称
    var data1 =  [MQIMainEachRecommendModel]() //itme
    var total: String = "" ///名称
    var books = [MQIMainEachRecommendModel]()
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data" {
            data1 = setValueToArray(value, key: key)
        }
        if key == "books" {
            books = setValueToArray(value, key: key)
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
        super.encode(with: aCoder)
    }
    
}

final class MQIMainEachRecommendModel: MQIBaseModel,ResponseCollectionSerializable{
    
    var book_id:String=""
    var book_name:String = ""

    var book_intro: String = ""
    var author_name:String = ""
    var book_status:String = ""
    var book_label:String = ""
    var subclass_name:String = ""
    var book_words:String = ""
    var book_short_intro:String = ""
    var read_num:String = "0"
    var vote_num: String = "0"
    
    //排行榜
    var subclass_id:String = ""
    var outsite_bid:String = ""
    var outsite:String = ""
    var class_name:String = ""
    
    
    ///专题名称
    var name:String = ""
    ///专题描述
    var desc:String = ""
    ///专题跳转链接
    var link:String = ""
    ///专题图片
    var image:String = ""
    
    var image_url:String = ""
    var url:String = ""
   
    
    var cover:String = ""
    var title:String = ""
    var add_time :String = ""
    var width:String = "1"
    var height:String = "0.42"
    var isOpenRereesh = "0"
    var type:String = ""
    var ad_type:String = ""
    var ad_link:String = ""
    
    var section_id:String = ""
    /// 新接口
    var  book_coverModel  = MQICoverMoldel()
    
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
//        mqLog("setValue \(key) \(String(describing: value))")
        if key == "book_cover" {
              book_coverModel = setDictToModel(value, key: key)
        }else{
           super.setValue(value, forKey: key)
        }
        
       
    }
    required init(coder aDecoder: NSCoder){
                super.init(coder: aDecoder)

        book_id = decodeStringForKey(aDecoder, key: "book_id")
        book_name = decodeStringForKey(aDecoder, key: "book_name")
//        book_cover = decodeStringForKey(aDecoder, key: "book_cover")
        book_intro = decodeStringForKey(aDecoder, key: "book_intro")
        author_name = decodeStringForKey(aDecoder, key: "author_name")
        book_status = decodeStringForKey(aDecoder, key: "book_status")
        book_label = decodeStringForKey(aDecoder, key: "book_label")
        subclass_name = decodeStringForKey(aDecoder, key: "subclass_name")
        book_words = decodeStringForKey(aDecoder, key: "book_words")
        book_short_intro = decodeStringForKey(aDecoder, key: "book_short_intro")
        read_num = decodeStringForKey(aDecoder, key: "read_num")
        //        subclass_id = decodeStringForKey(aDecoder, key: "subclass_id")
        //        outsite_bid = decodeStringForKey(aDecoder, key: "outsite_bid")
        //        outsite = decodeStringForKey(aDecoder, key: "outsite")
        desc = decodeStringForKey(aDecoder, key: "desc")
        link = decodeStringForKey(aDecoder, key: "link")
        image = decodeStringForKey(aDecoder, key: "image")
        name = decodeStringForKey(aDecoder, key: "name")
        
        cover = decodeStringForKey(aDecoder, key: "cover")
        title = decodeStringForKey(aDecoder, key: "title")
        add_time = decodeStringForKey(aDecoder, key: "add_time")
        width = decodeStringForKey(aDecoder, key: "width")
        height = decodeStringForKey(aDecoder, key: "height")
        type = decodeStringForKey(aDecoder, key: "type")
//        isOpenRereesh = decodeStringForKey(aDecoder, key: "isOpenRereesh")
//        ad_type = decodeStringForKey(aDecoder, key: "ad_type")
//        ad_link = decodeStringForKey(aDecoder, key: "ad_link")
        
        image_url = decodeStringForKey(aDecoder, key: "image_url")
        url = decodeStringForKey(aDecoder, key: "image_url")
  
        if let coverModel = decodeObjForKey(aDecoder, key: "book_coverModel") {
          book_coverModel = coverModel as! MQICoverMoldel
        }
        
  
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func encode(with aCoder: NSCoder) {
        //        super.encode(with: aCoder)
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(book_name, forKey: "book_name")
        aCoder.encode(book_cover, forKey: "book_cover")
        aCoder.encode(book_intro, forKey: "book_intro")
        aCoder.encode(author_name, forKey: "author_name")
        aCoder.encode(book_status, forKey: "book_status")
        aCoder.encode(book_label, forKey: "book_label")
        aCoder.encode(subclass_name, forKey: "subclass_name")
        aCoder.encode(book_words, forKey: "book_words")
        aCoder.encode(book_short_intro, forKey: "book_short_intro")
        aCoder.encode(read_num, forKey: "read_num")
        //        aCoder.encode(subclass_id, forKey: "subclass_id")
        //        aCoder.encode(outsite_bid, forKey: "outsite_bid")
        //        aCoder.encode(outsite, forKey: "outsite")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(name, forKey: "name")
        
        aCoder.encode(cover, forKey: "cover")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(add_time, forKey: "add_time")
        aCoder.encode(width, forKey: "width")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(book_coverModel, forKey: "book_coverModel")
        aCoder.encode(image_url, forKey: "image_url")
        aCoder.encode(url, forKey: "url")
    }
    
}

class MQIChoicenessDataModel: MQIBaseModel{
    var data = [MQIMainRecommendModel]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}

final class MQISelectDataModel: MQIBaseModel,ResponseCollectionSerializable{
    var books = [MQIChoicenessListModel]()
    var type:String = ""
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "books" {
            books = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}
final class MQIChoicenessListModel: MQIBaseModel,ResponseCollectionSerializable{
    
    var book_id:String = ""
    var cover:String = ""
    var title:String = ""
    var desc:String = ""
    var add_time :String = ""
    var width:String = "1"
    var height:String = "0.5"
    var read_num:String = "1"
    var isOpenRereesh = "0"
    var type:String = ""
    var ad_type:String = ""
    var ad_link:String = ""
    var like: Int = 0
    
    var book_name: String = ""
    var last_chapter_title: String = ""
    var lead_name: String = ""
    var vote_number: String = "0"
    var subclass_name: String = ""
    var cover_status: String = ""
    var class_name: String = ""
    var book_status:String = ""
    var book_intro:String = ""// 简介
    var book_label:String = ""// 标签
    var book_words:String = ""// 字数
    
    var last_time_read:String = "" ///上次阅读到
    
    /// 新接口
    var  book_coverModel  = MQICoverMoldel()
    
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "book_cover" {
            book_coverModel = setDictToModel(value, key: key)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    required init(coder aDecoder: NSCoder){
        super.init()
        book_id = decodeStringForKey(aDecoder, key: "book_id")
        cover = decodeStringForKey(aDecoder, key: "cover")
        title = decodeStringForKey(aDecoder, key: "title")
        desc = decodeStringForKey(aDecoder, key: "desc")
        add_time = decodeStringForKey(aDecoder, key: "add_time")
        width = decodeStringForKey(aDecoder, key: "width")
        height = decodeStringForKey(aDecoder, key: "height")
        read_num = decodeStringForKey(aDecoder, key: "read_num")
        
        lead_name = decodeStringForKey(aDecoder, key: "lead_name")
        vote_number = decodeStringForKey(aDecoder, key: "vote_number")
        subclass_name = decodeStringForKey(aDecoder, key: "subclass_name")
        cover_status = decodeStringForKey(aDecoder, key: "cover_status")
        book_intro = decodeStringForKey(aDecoder, key: "book_intro")
        class_name = decodeStringForKey(aDecoder, key: "class_name")
        book_label = decodeStringForKey(aDecoder, key: "book_label")
        book_words = decodeStringForKey(aDecoder, key: "book_words")
        book_name = decodeStringForKey(aDecoder, key: "book_name")
        
        like = decodeIntForKey(aDecoder, key: "like")
        if let coverModel = decodeObjForKey(aDecoder, key: "book_coverModel") {
            book_coverModel = coverModel as! MQICoverMoldel
        }

    }
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(cover, forKey: "cover")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(add_time, forKey: "add_time")
        aCoder.encode(width, forKey: "width")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(read_num, forKey: "read_num")
        
        aCoder.encode(lead_name, forKey: "lead_name")
        aCoder.encode(vote_number, forKey: "vote_number")
        aCoder.encode(subclass_name, forKey: "subclass_name")
        aCoder.encode(cover_status, forKey: "cover_status")
        aCoder.encode(book_intro, forKey: "book_intro")
        aCoder.encode(class_name, forKey: "class_name")
        aCoder.encode(book_label, forKey: "book_label")
        aCoder.encode(book_words, forKey: "book_words")
        aCoder.encode(book_coverModel, forKey: "book_coverModel")
        aCoder.encode(book_name, forKey: "book_name")
        aCoder.encode(like, forKey: "like")
        
    }
}


class MQICoverMoldel: MQIBaseModel {
    var vert:String = ""
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder){
        super.init()
        vert = decodeStringForKey(aDecoder, key: "vert")
    
    }
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(vert, forKey: "vert")
      
    }
}

class MQISearchDataModel: MQIBaseModel{
    var total:String = ""
    var data = [MQIEachBook]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setValueToArray(value, key: key)
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}



/// 二级推荐页面
class MQIRecommendSecondItemModel: MQIBaseModel {
    
    var title:String = "" ///标题
    var data =  [MQIMainRecommendModel]() //itme
    
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data" {
            data = setValueToArray(value, key: key)
        } else {
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
        super.encode(with: aCoder)
    }
    
}
