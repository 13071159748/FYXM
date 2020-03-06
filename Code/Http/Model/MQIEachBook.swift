//
//  MQIEachBook.swift
//  Reader
//
//  Created by CQSC  on 16/7/15.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


final class MQIEachBook: MQIBaseModel, ResponseCollectionSerializable {
    
    var book_id: String = ""
    var book_name: String = ""
    //    var book_cover: String = ""
    var book_status: String = ""
    var book_update: String = ""
    var author_name: String = ""
    var author_id: String = ""
    var class_id: String = ""
    var book_class: String = ""
    var book_intro: String = ""
    var book_vip: String = ""
    var book_price: String = ""
    var book_chapter_count: String = ""
    var book_words_count: String = ""
    var last_chapter_id: String = ""
    var book_last_read_time: String = ""
    
    var book_label: String = ""
    var subclass_id: String = ""
    var site_id: String = ""
    var book_tags: String = ""
    var book_sign_time: String = ""
    var batch_data_id: String = ""
    var outsite: String = ""
    var book_addon_icon: String = ""
    var book_level: String = ""
    var outsite_bid: String = ""
    var book_publication: String = ""
    var book_create_time: String = ""
    var book_short_intro: String = ""
    var book_chapters: String = ""
    var book_extend_intro: String = ""
    var book_signed: String = ""
    var book_vip_time: String = ""
    var sequence: String = ""
    var book_first: String = ""
    var book_words: String = ""
    var book_original: String = ""
    var last_chapter_title: String = ""
    var user_id: String = ""
    var user_nick: String = "" {
        didSet {
            user_nick = user_nick.replacingOccurrences(of: "", with: "|")
        }
    }
    var batch_id: String = ""
    var book_checked: String = ""
    
    var lead_name: String = ""
    var vote_number: String = ""
    var subclass_name: String = ""
    var cover_status: String = ""
    var class_name: String = ""
    var section_id:String = ""
    
    var book_download: Bool = false
    var book_subscribe: Bool = false
    var book_isUpdate: Bool {
        set {
            updateBook = newValue ? 1 : 0
        } get {
            return updateBook == 1
        }
    }
    
    var downTids = [String]()
    var buyTids = [String]()
    
    var book_all_chapters: String = ""
    var book_all_words: String = ""
    var book_time: String = ""
    var chapter_id: String = ""
    
    var whole_subscribe: String?
    
    var free_limit_time: Int = 0
    
    var vipCheckStatus_3_2_0: String?
    
    var read_num :String = ""
    var isVip: Bool! {
        if book_vip == "1" {
            return true
        }else {
            return false
        }
    }
    
    /// 新接口
    var  book_coverModel  = MQICoverMoldel()
    
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
    }
    /// 阅读a章节id >   阅读记录
    var chapterId: Int = 0
    /// 阅读位置
    var chapterPosition: Int = 0
    /// 阅读标题
    var chapterTitle: String = ""
    /// 阅读时间
    var readTime: Int = 0
    /// 1 书架
    var favorite: Int = -1
    /// 1 自动订阅 0 非自定订阅
    var autoSubscribe: Int = -1
    ///  更新
    var updateBook: Int = 0
    
    func compareWithTime(_ book: MQIEachBook) -> ComparisonResult {
        if book.book_update == "" || self.book_update == "" {
            return .orderedSame
        }
        return (book.book_update as NSString).compare(self.book_update)
    }
    
    func addTidToDownTids(_ tid: String) {
        if downTids.contains(tid) == false {
            downTids.append(tid)
        }
    }
    
    /// 末页
    var chapters = [MQIEachChapter]()
    var total_rows:String = ""
    var pos_id:String = ""
    var continue_chapter_id:String = ""
    var badge_text:String = ""
    var recommend_text:String = ""
    /// 末页
    
    required override init() {
        super.init()
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        mqLog("UndefinedKey \(key) \(String(describing: value))")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "class" {
            if value is String {
                book_class = value as! String
            }else {
                super.setValue(value, forKey: key)
            }
        }else if key == "buyTids" {
            if value is [MQIChapterSubscribeModel] {
                for i in 0..<(value as! [MQIChapterSubscribeModel]).count {
                    buyTids.append((value as! [MQIChapterSubscribeModel])[i].chapter_id)
                }
            }else {
                super.setValue(value, forKey: key)
            }
        }else if key == "book_download" {
            book_download = getBoolWithValue(value)
        }else if key == "book_subscribe" {
            book_subscribe = getBoolWithValue(value)
        }else if key == "book_isUpdate" {
            book_isUpdate = getBoolWithValue(value)
        }else if key == "book_cover" {
            if let dic =  value as? [String:Any] {
                book_coverModel = setDictToModel(dic, key: key)
            }else{
                book_coverModel.vert = value as! String
            }
        }else if key == "chapters" {
            chapters =  setValueToArray(value, key: key)
        }
        else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        book_id = decodeStringForKey(aDecoder, key: "book_id")
        book_name = decodeStringForKey(aDecoder, key: "book_name")
//        book_cover = decodeStringForKey(aDecoder, key: "book_cover")
        book_status = decodeStringForKey(aDecoder, key: "book_status")
        book_update = decodeStringForKey(aDecoder, key: "book_update")
        author_name = decodeStringForKey(aDecoder, key: "author_name")
        author_id = decodeStringForKey(aDecoder, key: "author_id")
        class_id = decodeStringForKey(aDecoder, key: "class_id")
        book_class = decodeStringForKey(aDecoder, key: "book_class")
        book_intro = decodeStringForKey(aDecoder, key: "book_intro")
        book_vip = decodeStringForKey(aDecoder, key: "book_vip")
        book_price = decodeStringForKey(aDecoder, key: "book_price")
        book_chapter_count = decodeStringForKey(aDecoder, key: "book_chapter_count")
        book_words_count = decodeStringForKey(aDecoder, key: "book_words_count")
        book_subscribe = decodeBoolForKey(aDecoder, key: "book_subscribe_new")
        book_last_read_time = decodeStringForKey(aDecoder, key: "book_last_read_time")
        book_download = decodeBoolForKey(aDecoder, key: "book_download_new")
        last_chapter_id = decodeStringForKey(aDecoder, key: "last_chapter_id")
        last_chapter_title = decodeStringForKey(aDecoder, key: "last_chapter_title")
        class_name = decodeStringForKey(aDecoder, key: "class_name")
        subclass_name = decodeStringForKey(aDecoder, key: "subclass_name")
        book_words = decodeStringForKey(aDecoder, key: "book_words")
        
        book_isUpdate = decodeBoolForKey(aDecoder, key: "book_isUpdate")
        
        whole_subscribe = decodeStringForKey(aDecoder, key: "whole_subscribe")
        
        if let a = aDecoder.decodeObject(forKey: "vipCheckStatus_3_2_0") as? String {
            vipCheckStatus_3_2_0 = a
        }
        
        if let d = decodeObjForKey(aDecoder, key: "downTids") as? [String] {
            downTids = d
        }
        
        if let b = decodeObjForKey(aDecoder, key: "buyTids") as? [String] {
            buyTids = b
        }
        if let coverModel = decodeObjForKey(aDecoder, key: "book_coverModel") {
            book_coverModel = coverModel as! MQICoverMoldel
        }
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(book_name, forKey: "book_name")
//        aCoder.encode(book_cover, forKey: "book_cover")
        aCoder.encode(book_status, forKey: "book_status")
        aCoder.encode(book_update, forKey: "book_update")
        aCoder.encode(author_name, forKey: "author_name")
        aCoder.encode(author_id, forKey: "author_id")
        aCoder.encode(class_id, forKey: "class_id")
        aCoder.encode(book_class, forKey: "book_class")
        aCoder.encode(book_intro, forKey: "book_intro")
        aCoder.encode(book_vip, forKey: "book_vip")
        aCoder.encode(book_price, forKey: "book_price")
        aCoder.encode(book_chapter_count, forKey: "book_chapter_count")
        aCoder.encode(book_words_count, forKey: "book_words_count")
        aCoder.encode(book_subscribe, forKey: "book_subscribe_new")
        aCoder.encode(book_last_read_time, forKey: "book_last_read_time")
        aCoder.encode(book_download, forKey: "book_download_new")
        aCoder.encode(last_chapter_id, forKey: "last_chapter_id")
        aCoder.encode(downTids, forKey: "downTids")
        aCoder.encode(buyTids, forKey: "buyTids")
        aCoder.encode(last_chapter_title, forKey: "last_chapter_title")
        aCoder.encode(class_name, forKey: "class_name")
        aCoder.encode(subclass_name, forKey: "subclass_name")
        
        aCoder.encode(book_words, forKey: "book_words")
        
        if let whole_subscribe = whole_subscribe {
            aCoder.encode(whole_subscribe, forKey: "whole_subscribe")
        }
        
        if let vipCheckStatus_3_2_0 = vipCheckStatus_3_2_0 {
            aCoder.encode(vipCheckStatus_3_2_0, forKey: "vipCheckStatus_3_2_0")
        }
        
        aCoder.encode(book_isUpdate, forKey: "book_isUpdate")
        
        aCoder.encode(book_coverModel, forKey: "book_coverModel")

        
    }
    
    public func checkIsWholdSubscribe() -> Bool {
        guard let whole_subscribe = whole_subscribe, whole_subscribe == "1" else {
            return false
        }
        
        guard MQIUserManager.shared.checkIsLogin() == true else {
            return false
        }

        if MQIUserManager.shared.user!.isVIP == true {
            return false
        }
        
        if buyTids.count > 0 {
            return false
        }else {
            return true
        }
    }
    
    class func shortInfo(_ info: String) -> String {
        var str = info
        str = str.replacingOccurrences(of: "\n", with: "")
        str = str.replacingOccurrences(of: "　", with: "")
        str = str.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\r", with: "")
        return str
    }
    public func showSubscribe() -> Bool {
        guard let whole_subscribe = whole_subscribe else {
            return false
        }
        if whole_subscribe == "1" {
            return true
        }else{
            return false
        }
    }
}
extension MQIEachBook :XMDBBookProtocol {
    var cover: String {
        get {
            return book_cover
        }
        set {
            book_coverModel.vert = newValue
        }
    }
    
    var bookId: Int {
        get {
            return book_id.integerValue()
        }
        set {
            book_id = "\(newValue)"
        }
        
    }
    
    var name: String {
        get {
            return book_name
        }
        set {
            book_name = newValue
        }
    }
    
    var chapterCount: Int {
        get {
            return book_chapter_count.integerValue()
        }
        set {
            book_chapter_count = "\(newValue)"
        }
    }
    
    var authorName: String {
        get {
            return author_name
        }
        set {
            author_name = newValue
        }
    }
    
    var authorId: Int {
        get {
            return author_id.integerValue()
        }
        set {
            author_id = "\(newValue)"
        }
    }
    
    var caption: String {
        get {
            return book_name
        }
        set {
            book_name = newValue
        }
    }
    
    var shortCaption: String {
        get {
            return book_short_intro
        }
        set {
            book_short_intro = newValue
        }
    }
    
    var category: String {
        get {
            return book_class
        }
        set {
            book_class = newValue
        }
    }
    
    var subcategory: String {
        get {
            return subclass_name
        }
        set {
            subclass_name = newValue
        }
    }
    
    var lastChapterId: Int {
        get {
            return last_chapter_id.integerValue()
        }
        set {
            last_chapter_id = "\(newValue)"
        }
    }
    
    var lastChapterTitle: String {
        get {
            return last_chapter_title
        }
        set {
            last_chapter_title = newValue
        }
    }
    var voteNumber: Int {
        get {
            return vote_number.integerValue()
        }
        set {
            vote_number = "\(newValue)"
        }
    }
    
    var readNumber: Int {
        get {
            return read_num.integerValue()
        }
        set {
            read_num = "\(newValue)"
        }
    }
    
    var status: Int {
        get {
            return book_status.integerValue()
        }
        set {
            book_status = "\(newValue)"
        }
    }
    
    var label: String {
        get {
            return book_label
        }
        set {
            book_label = "\(newValue)"
        }
    }
    
    var tags: String {
        get {
            return book_tags
        }
        set {
            book_tags = newValue
        }
    }
    
    var wordCount: Int {
        get {
            return book_words_count.integerValue()
        }
        set {
            book_words_count = "\(newValue)"
        }
    }
    
    var sectionId: Int {
        get {
            return section_id.integerValue()
        }
        set {
            section_id = "\(newValue)"
        }
    }
    
    var bookUpdateTime: Int {
        get {
            return book_update.integerValue()
        }
        set {
            book_update = "\(newValue)"
        }
    }
    
    var entireSubscribe: Int {
        get {
            return whole_subscribe?.integerValue() ?? 0
        }
        set {
            whole_subscribe = "\(newValue)"
        }
    }
    
    
    
}

extension MQIEachBook :XMDBLibraryProtocol {}


