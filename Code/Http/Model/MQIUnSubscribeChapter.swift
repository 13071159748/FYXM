//
//  MQIUnSubscribeChapter.swift
//  Reader
//
//  Created by CQSC  on 2017/9/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIUnSubscribeChapter: MQIBaseModel {
    
    var title: String = ""
    var price: String = ""
    var whole_subscribe: String = ""
    var summary: String = ""  {
        didSet {
            if summary.hasSuffix("……") == false || summary.hasSuffix("...") == false {
                summary += "……"
            }
        }
    }
    
    
    var chapter_id: String = ""
    /// 9为新书
    var cost_type: String = ""
    var chapter_title: String = ""{
        didSet(oldValue) {
            title = chapter_title
        }
    }
    var original_price: String = ""
    
    var chapter_content: String = ""{
        didSet(oldValue) {
            if chapter_content.hasSuffix("……") == false || chapter_content.hasSuffix("...") == false {
                chapter_content += "……"
            }
            summary = chapter_content
        }
    }
    //    新书提示内容
    var read_tips: String = ""
    
    var is_new_book:String = ""
    /// 是否展示批量订阅按钮
    var showBuyBtn:Bool = false
    ///章节价格（实际支付价格）
    var chapter_price: String = ""{
        didSet(oldValue) {
            if chapter_price.count > 0 {
                price = chapter_price
            }
        }
    }
}


