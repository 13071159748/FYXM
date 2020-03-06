//
//  GYEachComment.swift
//  Reader
//
//  Created by CQSC  on 2017/3/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

import Spring
final class GYEachComment: MQIBaseModel, ResponseCollectionSerializable {
    
    var comment_id: String = ""
    var user_id: String = ""
    var user_avatar: String = ""
    var comment_time: String = "" {
        didSet{
            let dates = comment_time.components(separatedBy: " ")
            if dates.count > 0 {
                comment_month = dates[0]
                let months = comment_month.components(separatedBy: "-")
                if months.count > 2 {
                    comment_month2 = months[1]+"月"+months[2]+"日"
                }
            }
            
        }
    }
    var comment_month: String = "" //yyyy-mm-dd
    var comment_month2: String = "" //mm-dd
    
    var comment_good: String = ""
    var comment_top: String = ""
    var user_nick: String = "" {
        didSet {
            //            user_nick = user_nick.replacingOccurrences(of: "", with: "|")
            //            user_nick = user_nick.substring(NSMakeRange(0, user_nick.length > 1 ? 2 : 1))+"*"
        }
    }
    var user_vip_level: String = ""
    
    var user_coin_total: String = ""
    var is_author: String = ""
    var vote_num: String = ""
    //    var chapter: String = ""
    var comment_target: String = ""
    var is_vip: String = ""
    
    var good: Bool = false
    var top: Bool = false
    
    var chapter = MQIEachChapter()
    var reply = [GYEachCommentReply]()
    
    var content_textColor: UIColor! {
        return UIColor(hex: "666666")
    }
    
    var comment_content: String = "" {
        didSet {
            DispatchQueue.main.async {
                if let data = self.comment_content.data(using: String.Encoding.unicode) {
                    do {
                        let paragraph = NSMutableParagraphStyle()
                        paragraph.alignment = .left
                        
                        let attStr = try NSMutableAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                        attStr.addAttributes([NSAttributedString.Key.font : systemFont(13), NSAttributedString.Key.paragraphStyle : paragraph,
                                              NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#666666")],
                                             range: NSMakeRange(0, attStr.string.length))
                        
                        self.content_attstr = attStr
                    }catch {
                        self.content_attstr = NSMutableAttributedString(string: self.comment_content)
                    }
                }else {
                    self.content_attstr = NSMutableAttributedString(string: self.comment_content)
                }
            }
        }
    }
    
    var content_attstr: NSMutableAttributedString!
    
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
        //        MQLog("---\(value)  \(key)")
        if key == "reply" {
            reply = setValueToArray(value, key: key)
        }else if key == "good" {
            good = getBoolWithValue(value)
        }else if key == "top" {
            top = getBoolWithValue(value)
        }else if key == "chapter" {
            chapter = setDictToModel(value, key: key)
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    func configAttstrContent()  {
        
    }
    
}

class GYEachCommentReply: MQIBaseModel {
    
    var comment_id: String = ""
    var user_id: String = ""
    var comment_content: String = ""
    var comment_time: String = ""
    var comment_good: String = ""
    var comment_top: String = ""
    var user_nick: String = ""
    var user_vip_level: String = ""
    
}
class GDCommentCountModel:MQIBaseModel {
    var comment_count:String = ""
}
