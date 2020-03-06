//
//  GYReadThemeModel.swift
//  Reader
//
//  Created by CQSC  on 2017/6/24.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadThemeModel: MQIBaseModel {

    fileprivate(set) var titleHexStr: String = ""
    fileprivate(set) var textHexStr: String = ""
    fileprivate(set) var bgHexStr: String = ""
    fileprivate(set) var iconHexStr: String = ""
    fileprivate(set) var statusHexStr: String = ""
    
    var titleColor: UIColor! {
        return hexStringToColor(titleHexStr)
    }
    
    var textColor: UIColor! {
        return hexStringToColor(textHexStr)
    }
    
    var statusColor: UIColor! {
        return hexStringToColor(statusHexStr)
    }
    
    var bgImage: UIImage! {
        return createThemeImage(string: bgHexStr)
    }
    
    var iconImage: UIImage! {
        return createThemeImage(string: iconHexStr)
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
    
    fileprivate func createThemeImage(string: String) -> UIImage {
        if string.hasPrefix("#") {
            return createImageWithColor(hexStringToColor(bgHexStr))
        }else if string.hasPrefix("reader_") {
            var imageSuffix = ""
            if iPhone_4_4s == true {
                imageSuffix = "_4.jpg"
            }else if iPhone_5_5s == true {
                imageSuffix = "_5.jpg"
            }else if iPhone_6 == true {
                imageSuffix = "_6.jpg"
            }else if iPhone_6_plus == true {
                imageSuffix = "_6p.jpg"
            }else if ipad == true {
                imageSuffix = "_ipad.jpg"
            }else {
                imageSuffix = "_6.jpg"
            }
            return UIImage(named: (string+imageSuffix))!
        }else {
            return createImageWithColor(UIColor.white)
        }
    }
    
}
