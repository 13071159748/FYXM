//
//  MQIEachChapter.swift
//  Reader
//
//  Created by _CHK_  on 16/7/15.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

import UIKit

import Base64
import GZIP

class MQIEachChapterData: MQIBaseModel {
    var data = [MQIEachChapter]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            data = setValueToArray(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
class MQIEachRapidChapter: MQIBaseModel {
    var id:String = ""
    var name:String = ""
    ///是否是vip，0 免费 1 付费
    var vip: String = ""
    var content:String = ""
    ///是否允许离线阅读
    var offline: Bool = false
    var hash_c:Int = 0
    var prev_chapter = MQIEachChapter()
    var next_chapter = MQIEachChapter()
    
    var chapter_title:String = "" {
        didSet(oldValue) {
            name = chapter_title
        }
    }
    var  chapter_id:String = "" {
        didSet(oldValue) {
            id = chapter_id
        }
    }
    var  chapter_vip: Bool = false {
        didSet(oldValue) {
            vip = (chapter_vip == true) ? "1":"0"
        }
    }
    var current_chapter:MQIEachChapter {
        set {
            id =   newValue.chapter_id
            vip =   newValue.vip
            name =   newValue.chapter_title
            content =   newValue.content
        }
        get {
            let current_chapter = MQIEachChapter()
            current_chapter.chapter_id = id
            current_chapter.vip = vip
            current_chapter.chapter_title = name
            return  current_chapter
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "prev_chapter" {
            
            prev_chapter =  setDictToModel(value, key: key)
        }
        else  if key == "next_chapter" {
            next_chapter =  setDictToModel(value, key: key)
        }
        else  if key == "hash" {
            hash_c = getIntWithValue(value)
        }
        else  if key == "offline" {
            offline = getBoolWithValue(value)
        }
        else  if key == "chapter_vip" {
            chapter_vip = getBoolWithValue(value)
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
}

final class MQIEachChapter: MQIBaseModel, ResponseCollectionSerializable {
    
    var volume_name: String = ""
    var volume_id: String = ""
    var chapter_checked: String = ""
    var chapter_type: String = ""
    var chapter_pubtime: String = ""
    var chapter_modtime: String = ""
    var chapter_note: String = ""
    var chapter_words: String = ""
    var chapter_sequence: String = "" //顺序
    
    var chapter_code: String = ""
    var chapter_id: String = ""
    var book_id: String = ""
    var chapter_title: String = ""
    var chapter_vip: Bool = false
    var isDown: Bool = false
    var isSubscriber: Bool = false
    
    //MARK:  --  暂时未用到
    var outsite_id: String = ""
    var volume_sequence: String = ""
    var chapter_ext_title: String = ""
    var chapter_addtime: String = ""
    var content_gzip: String = ""
    var with_content: String = ""
    var only_pub: String = ""
    //MARK: --
    var content: String = ""
    {
        didSet {
            let decodeData = Data(base64Encoded: content, options: .ignoreUnknownCharacters)
            
            if let decodeData = decodeData {
                if (decodeData as NSData).length <= 0 {
                    return
                }
                if isDown == true {
                    return
                }
                
                let data = (decodeData as NSData).gunzipped()
                if let data = data {
                    if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        content = str as String
                    }
                }
                
            }
            
        }
        
    }
    
    //MARK: --
    var chapter_content: String = ""{
        didSet(oldValue) {
            content = chapter_content
        }
    }
    
    
    var bookId: String = ""
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    /// 本章有多少页
    var pageCount:NSNumber = NSNumber(value: 0)
    
    /// 每一章的Range数组
    var rangeArray:[NSRange] = [NSRange]()
    
    var id: String = ""{
        didSet(oldValue) {
            chapter_id = id
        }
    }
    var title: String = ""{
        didSet(oldValue) {
            chapter_title = title
        }
    }
    var vip: String = "" {
        didSet(oldValue) {
            chapter_vip = (vip == "1") ? true:false
        }
    }
    var price: String = ""
    
    @nonobjc var frameRefs = [CTFrame]()
    
    var readAttribute = [NSAttributedString.Key : NSObject]()
    
    
    var chapter_htmlContent: String! {
        var newContent = GYReadParser.ContentTypesetting(content: content)
        if GYReadStyle.shared.styleModel.simpleFontStyle == .zh_hant {
            newContent = OBCConvertor.getInstance().s2t(newContent)
        }
        return newContent
    }
    var chapter_htmlTitle: String! {
        var newTitle = GYReadParser.TitleTypesetting(title: chapter_title)
        if GYReadStyle.shared.styleModel.simpleFontStyle == .zh_hant {
            newTitle = OBCConvertor.getInstance().s2t(newTitle)
        }
        return newTitle
    }
    
    required override init() {
        super.init()
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    public var noNeedSaveKeys = ["noNeedSaveKeys", "readAttribute", "rangeArray", "frameRefs", "priority", "content", "chapter_htmlContent", "chapter_htmlTitle"]
    //    required init(coder aDecoder: NSCoder) {
    //        super.init()
    //        for key in allPropertyNames() {
    //            if noNeedSaveKeys.contains(key) == false {
    //                if let value = aDecoder.decodeObject(forKey: key) {
    //                    setValue(value, forKey: key)
    //                }
    //            }
    //        }
    //    }
    //
    //    override func encode(with aCoder: NSCoder) {
    //        for (key, value) in allPropertys() {
    //            if noNeedSaveKeys.contains(key) == false {
    //                if let value = value {
    //                    aCoder.encode(value, forKey: key)
    //                }
    //            }
    //        }
    //    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "chapter_vip" {
            chapter_vip = getBoolWithValue(value)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    
    /// 更新字体
    func updateFont(isSave: Bool = false, chapterIndex: Int) {
        
        let readAttribute = GYReadStyle.shared.readAttribute()
        
        if self.readAttribute != readAttribute {
            
            self.readAttribute = readAttribute
            
            let array = GYReadParser.ParserPageRange(title: chapter_htmlTitle,
                                                          string: chapter_htmlContent,
                                                          rect: GetReadViewFrame(),
                                                          titleAttrs: GYReadStyle.shared.readTitleAttribute(),
                                                          attrs: readAttribute)
            
            rangeArray = array.1
            frameRefs = array.0
            
            pageCount = NSNumber(value: rangeArray.count)
        }
        if isSave {save()}
    }
    
    func forceUpdateFont(isSave: Bool = false, chapterIndex: Int) {
        readAttribute.removeAll()
        updateFont(isSave: isSave, chapterIndex: chapterIndex)
        
    }
    
    // MARK: -- 操作
    
    func chapterPrice(_ book: MQIEachBook) -> Int {
        let price = book.book_price.floatValue()/1000
        
        if chapter_words.floatValue() < 1000 {
            return Int(1000*price)
        }else {
            let coin = chapter_words.integerValue() / 1000
            return Int(coin) * 5
            //        return Int(chapter_words.floatValue()*price)
        }
        
    }
    //购买vip章节自动扣钱，估算
    func customChapterPrice()->Int {
        let price = 5.0/1000
        
        if chapter_words.floatValue() < 1000 {
            return Int(1000*price)
        }else {
            let coin = chapter_words.integerValue() / 1000
            return Int(coin) * 5
        }
    }
    /// 通过 Page 获得字符串
    func string(page:NSInteger) ->String {
        return chapter_htmlContent.substring(rangeArray[page])
        
        //        var str = ""
        //        for _ in 0..<chapter_title.count {
        //            let char = Character(UnicodeScalar(" "))
        //            str.append(char)
        //        }
        //        return (content+str).substring(rangeArray[page])
    }
    
    /// 通过 Location 获得 Page
    func page(location:NSInteger) ->NSInteger {
        
        let count = rangeArray.count
        
        for i in 0..<count {
            
            let range = rangeArray[i]
            
            if location < (range.location + range.length) {
                
                return i
            }
        }
        
        return 0
    }
    
    
    func save() {
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        chapter_id = decodeStringForKey(aDecoder, key: "chapter_id")
        chapter_title = decodeStringForKey(aDecoder, key: "chapter_title")
        
        chapter_words = decodeStringForKey(aDecoder, key: "chapter_words")
        volume_name = decodeStringForKey(aDecoder, key: "volume_name")
        volume_id = decodeStringForKey(aDecoder, key: "volume_id")
        chapter_checked = decodeStringForKey(aDecoder, key: "chapter_checked")
        chapter_code = decodeStringForKey(aDecoder, key: "chapter_code")
        chapter_pubtime = decodeStringForKey(aDecoder, key: "chapter_pubtime")
        chapter_modtime = decodeStringForKey(aDecoder, key: "chapter_modtime")
        chapter_note = decodeStringForKey(aDecoder, key: "chapter_note")
        chapter_sequence = decodeStringForKey(aDecoder, key: "chapter_sequence")
        book_id = decodeStringForKey(aDecoder, key: "book_id")
        chapter_type = decodeStringForKey(aDecoder, key: "chapter_type")
        
        chapter_vip = decodeBoolForKey(aDecoder, key: "chapter_vip_new")
        isDown = decodeBoolForKey(aDecoder, key: "isDown_new")
        isSubscriber = decodeBoolForKey(aDecoder, key: "isSubscriber_new")
        chapter_content = decodeStringForKey(aDecoder, key: "chapter_content")
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(chapter_id, forKey: "chapter_id")
        aCoder.encode(chapter_title, forKey: "chapter_title")
        
        aCoder.encode(chapter_words, forKey: "chapter_words")
        aCoder.encode(volume_name, forKey: "volume_name")
        aCoder.encode(volume_id, forKey: "volume_id")
        aCoder.encode(chapter_checked, forKey: "chapter_checked")
        aCoder.encode(chapter_code, forKey: "chapter_code")
        aCoder.encode(chapter_pubtime, forKey: "chapter_pubtime")
        aCoder.encode(chapter_modtime, forKey: "chapter_modtime")
        aCoder.encode(chapter_note, forKey: "chapter_note")
        aCoder.encode(chapter_sequence, forKey: "chapter_sequence")
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(chapter_type, forKey: "chapter_type")
        
        aCoder.encode(chapter_vip, forKey: "chapter_vip_new")
        aCoder.encode(isDown, forKey: "isDown_new")
        aCoder.encode(isSubscriber, forKey: "isSubscriber_new")
        aCoder.encode(chapter_content, forKey: "chapter_content")
        
    }
    
}
import Foundation
private let BASE_64_STANDARD:[UInt8] = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47, 61]
private let LOOK_UP_TABLE:[UInt8] = [81, 87, 105, 74, 111, 115, 113, 66, 103, 114, 47, 53, 82, 72, 77, 108, 54, 88, 102, 43, 76, 67, 119, 99, 121, 50, 117, 73, 84, 98, 104, 97, 78, 65, 120, 70, 57, 49, 122, 101, 75, 85, 106, 61, 89, 118, 55, 107, 86, 116, 83, 51, 48, 71, 110, 112, 52, 69, 90, 56, 100, 80, 109, 79, 68]

class unlockCntent: NSObject {
    
    
    // 加密转换字符
    
    class func decodeChapterContent(origin: String) -> String? {
        if (origin.isEmpty){return nil}
        ///转换成 base6
        let decodeData = Data(base64Encoded: origin, options: .ignoreUnknownCharacters)
        if let decodeData = decodeData {
            if (decodeData as NSData).length <= 0 {
                
                return nil
            }
            
            let data = (decodeData as NSData).gunzipped()
            if let dataNew = data {
                if let str = String(data: dataNew, encoding: .utf8) {
                    return str
                }
            }
            
        }
        return nil
    }
    
    class  func getOriginContent(bookId: Int, chapterId: Int, cryptString: String)->String {
        if cryptString == "" {return ""}
        mqLog("bookId =\(bookId) == chapterId=\(chapterId)")
        mqLog("cryptString =\(cryptString)")
        guard let decodeData =  cryptString.data(using: String.Encoding.utf8) else {
            return ""
        }
        let bias = (bookId + chapterId) % 65 + 1
        let length = BASE_64_STANDARD.count
        var table = [UInt8:UInt8]()
        let window = length / bias
        var splitPosition = Array<Int>.init(repeating: 0, count: window+1)
        
        for i in 0...window {
            splitPosition[i] = i*bias
        }
        
        var splitIndex = splitPosition.count - 1
        var end: Int = length
        var resultIndex = 0
        
        while  splitIndex >= 0 {
            let start = splitPosition[splitIndex]
            var index = 0
            while (start + index < end) {
                table[LOOK_UP_TABLE[start + index]] = BASE_64_STANDARD[resultIndex]
                index += 1
                resultIndex += 1
            }
            end = start
            splitIndex -= 1
        }
        
        var result =  Array<UInt8>.init(repeating: 0 , count: decodeData.count)
        let cryptStringArr = Array.init(decodeData)
        for i in 0..<result.count {
            result[i] =  table[cryptStringArr[i]] ?? 0
        }
        
        let resultStr =  String.init(data:  Data.init(bytes: result), encoding: .utf8)
        //        mqLog("\(resultStr)")
        return resultStr ?? ""
    }
    
    
    class  func getOriginConten2(bookId: Int, chapterId: Int, cryptString: String)->String {
        if cryptString == "" {return ""}
        let tab = "QWiJosqBgr/5RHMl6Xf+LCwcy2uITbhaNAxF91zeKUj=Yv7kVtS30Gnp4EZ8dPmOD"
        let base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        
        var BASE_64_STANDARD = [Character]()
        base64.forEach { (c) in
            BASE_64_STANDARD.append(c)
        }
        var LOOK_UP_TABLE = [Character]()
        tab.forEach { (c) in
            LOOK_UP_TABLE.append(c)
        }
        
        
        let bias = (bookId + chapterId) % 65 + 1
        let length = BASE_64_STANDARD.count
        var table = [Character:Character]()
        let window = length / bias
        var splitPosition = Array<Int>.init(repeating: 0, count: window+1)
        
        for i in 0...window {
            splitPosition[i] = i*bias
        }
        
        var splitIndex = splitPosition.count - 1
        var end: Int = length
        var resultIndex = 0
        
        var tempArr = [Character]()
        while  splitIndex >= 0 {
            let start = splitPosition[splitIndex]
            var index = 0
            while (start + index < end) {
                table[LOOK_UP_TABLE[start + index]] = BASE_64_STANDARD[resultIndex]
                tempArr.append(LOOK_UP_TABLE[start + index])
                index += 1
                resultIndex += 1
            }
            end = start
            splitIndex -= 1
        }
        
        mqLog("\(tempArr.description)")
        var cryptStringArr = [Character]()
        cryptString.forEach { (c) in
            cryptStringArr.append(c)
        }
        var result =  Array<Character>.init(repeating: "0" , count: cryptStringArr.count)
        
        for i in 0..<result.count {
            result[i] = table[cryptStringArr[i]] ?? "0"
        }
        
        mqLog("\(result)")
        let resultStr =  String.init(result)
        mqLog("\(resultStr)")
        
        return resultStr
    }
    
    
    
    
}
