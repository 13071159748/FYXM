//
//  MQIResultsPageModel.swift
//  CQSC
//
//  Created by moqing on 2019/7/3.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIResultsPageModel: MQIBaseModel {
    
    var type:ResultsType = .prompt /// 弹框类型
    var prompt_img_name:String = ""/// 弹框图标标识
    var title1:NSAttributedString?///标题
    var title2:NSAttributedString?
    var title3:NSAttributedString?
    var btnTitle:String?///按钮文字
    var lineTitle:String = ""/// 推广文案
    var banner_Img_url:String = ""
    var book_img_url:String = "" /// 书籍封面
    var book_title:String = ""///标题
    var book_id:String = "" /// 书籍id
    var linkStr:String = "" /// banner 跳转链接
    var itmeData = [MQIResultsPageModel]() /// 推荐书籍的数组
    var itemCouponse = [MQICouponsModel]() /// 优惠券数组
    
    override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
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
    
    func setAtts(str:String,atts:[NSAttributedString.Key:Any]? = nil,range: NSRange? = nil) -> NSMutableAttributedString {
        
        guard let range1 = range else {
            guard let atts1 = atts else {
                return  NSMutableAttributedString.init(string: str)
            }
            return  NSMutableAttributedString.init(string: str,attributes:atts1)
        }
        guard let atts1 = atts else {
              return  NSMutableAttributedString.init(string: str)
        }
        let attstr =  NSMutableAttributedString.init(string: str)
       attstr.addAttributes(atts1, range: range1)
        return attstr 
    }
}

class MQIVersionModel: MQIBaseModel {
    var site_name:String = ""
    var version_code:String = ""
    var version:String = ""
    var title:String = ""
    var content:String = ""

   
}

