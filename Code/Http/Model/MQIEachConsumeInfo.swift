//
//  MQIEachConsumeInfo.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


final class MQIEachConsumeInfo: MQIBaseModel,ResponseCollectionSerializable
{
    var id: String = ""
    var user_id: String = ""
    var cost_type: String = ""
    var cost_target: String = ""
    var cost_item: String = ""
    //    var cost_time: String = ""
    var cost_coin: String = ""
    var cost_premium: String = ""
    var cost_from: String = ""
    var cost_channel: String = ""
    var cost_site: String = ""
    var book_id: String = ""
    var chapter_id: String = ""
    var book_name: String = ""
    var chapter_code: String = ""
    var chapter_title: String = ""
    var outsite_id: String = ""
    var author_name: String = ""
    
    var book_time: String = "" {
        didSet {
            let dates = getTimeStampToString(book_time,format: "yyyy-MM-dd hh:mm:ss").components(separatedBy: " ")
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
    
    var coin: String = "0"
    var premium: String = "0"
    ///是否属于批量订阅 1是 0不是 ，当为1的时候可以展开查看详细的批量订阅的信息 接口：user.batch_detail
    var  is_batch:String = ""
    var reduction_coin:String = ""
    required override init() {
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
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
}
