//
//  MQIEachRewardLog.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIEachRewardLog:  MQIBaseModel, ResponseCollectionSerializable {

    var id:String=""
    var cost_coin: String = "" //打赏消耗的魔币
    var cost_premium:String = "" //打赏消耗的魔豆
    var book_id: String = "" //打赏的书籍id
    var book_name: String = "" //打赏的书籍名称
    var cost_time: String = "" {//打赏时间
        didSet {
    
            let dates = getTimeStampToString(cost_time,format: "yyyy-MM-dd hh:mm:ss").components(separatedBy: " ")
            
            if dates.count > 0 {
                cost_month = dates[0]
                cost_date = dates[1]
                
                let months = cost_month.components(separatedBy: "-")
                if months.count > 2 {
                    cost_month2 = months[1]+"-"+months[2]
                    cost_month3 = months[0]+"-"+months[1]
                }
            }
        }
    }
    var cost_month: String = "" //yyyy-mm-dd
    var cost_month2: String = "" //mm-dd
    var cost_month3: String = "" //yyyy-mm
    var cost_date: String = "" //hh:mm:ss
}
//书包购买记录
final class MQIEachPackageLog: MQIBaseModel, ResponseCollectionSerializable {
    
    var id:String=""
    var cost_coin: String = "" //购买消耗的魔币
    var cost_premium:String = "" //购买消耗的魔豆
    var book_id: String = "" //书包id
    var book_name: String = "" //书包的名称
    var cost_time: String = "" {//书包购买时间
        didSet {
            let dates = cost_time.components(separatedBy: " ")
            if dates.count > 0 {
                cost_month = dates[0]
                cost_date = dates[1]
                
                let months = cost_month.components(separatedBy: "-")
                if months.count > 2 {
                    cost_month2 = months[1]+"-"+months[2]
                    cost_month3 = months[0]+"-"+months[1]
                }
            }
        }
    }
    var cost_month: String = "" //yyyy-mm-dd
    var cost_month2: String = "" //mm-dd
    var cost_month3: String = "" //yyyy-mm
    var cost_date: String = "" //hh:mm:ss
}
//单本订阅记录
final class  MQIEachWholeSubscribeList: MQIBaseModel, ResponseCollectionSerializable {
    
    var id:String=""
    var cost_coin: String = "" //订阅消耗的魔币
    var cost_premium:String = "" //订阅消耗的魔豆
    var book_id: String = "" //订阅的书籍id
    var book_name: String = "" //订阅的书籍名称
    var cost_time: String = "" {//订阅时间
        didSet {
            let dates = cost_time.components(separatedBy: " ")
            if dates.count > 0 {
                cost_month = dates[0]
                cost_date = dates[1]
                
                let months = cost_month.components(separatedBy: "-")
                if months.count > 2 {
                    cost_month2 = months[1]+"-"+months[2]
                    cost_month3 = months[0]+"-"+months[1]
                }
            }
        }
    }
    var cost_month: String = "" //yyyy-mm-dd
    var cost_month2: String = "" //mm-dd
    var cost_month3: String = "" //yyyy-mm
    var cost_date: String = "" //hh:mm:ss
}
final class GDQueryFreelimitModel: MQIBaseModel, ResponseCollectionSerializable {
    var limit_free:Bool = false
    var limit_time:String = ""
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
        if key == "limit_free" {
            limit_free = getBoolWithValue(value)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
final class  MQICostBookList:MQIBaseModel,ResponseCollectionSerializable {
    var user_id:String=""
    var book_id:String = ""
    var book_name:String = ""
    var total_cost_coin:String = ""
    var total_cost_premium:String = ""
    var cost_site:String = ""
    var cost_num:String = ""
    var cost_time:String = "" {
        didSet {
            let dates = getTimeStampToString(cost_time,format: "yyyy-MM-dd hh:mm:ss").components(separatedBy: " ")
            if dates.count > 0 {
                cost_month = dates[0]
                cost_date = dates[1]
                
                let months = cost_month.components(separatedBy: "-")
                if months.count > 2 {
                    cost_month2 = months[1]+"-"+months[2]
                    cost_month3 = months[0]+"-"+months[1]
                }
            }
        }
    }
    var cost_month: String = "" //yyyy-mm-dd
    var cost_month2: String = "" //mm-dd
    var cost_month3: String = "" //yyyy-mm
    var cost_date: String = "" //hh:mm:ss
    
    var book: MQIEachBook = MQIEachBook()
    var whole_subscribe:String = ""
    
    
    /// 新接口
    var author_name:String = ""
    var section_id:String = ""
    var coin:String = "0"
    var premium:String = "0"
    var  book_coverModel  = MQICoverMoldel()
    var book_cover: String  {
        get {
            return book_coverModel.vert
        }
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
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "book" {
            book = setDictToModel(value, key: key)
        }else  if key == "book_cover" {
            book_coverModel = setDictToModel(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
