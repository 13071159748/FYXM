//
//  GYReadStyleModel.swift
//  Reader
//
//  Created by CQSC  on 2017/6/24.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadStyleModel: MQIBaseModel {
    
    var bookFontSize: Float = 0 //字体大小
    var bookThemeIndex: Int = 0 //背景类型
    var bookFontWeight: Int = 1 //字体粗细 1 / 2
    var bookPageMode: Bool = false //横屏 false / 竖屏 true
    var bookLightMode: Bool = false //是否是黑夜模式
    
//    var effectType: GYReadEffectType = .translation  //翻书样式
    var effectType: GYReadEffectType = .translation  //翻书样式

    var simpleFontStyle: GYReadFontStyle = .zh_hans // 中文简体/繁体
    var bookLineStyle: GYReadLineStyle = .mid //排版样式
    var readFontStyle: GYReadFontType = .system //字体

    var maxBookBrightness: Float = 0.7
    var bookBrightness: Float = 0 { //亮度
        didSet {
            bookBrightness.doubleDecimals()
        }
    }
    var bookLineHeight: Float = 0.0 { //行间距
        didSet {
            bookLineHeight.doubleDecimals()
        }
    }
    var bookLetterSpace: Float = 0 {//文字间距
        didSet {
            bookLetterSpace.doubleDecimals()
        }
    }
    var bookParagraphHeight: Float = 0 { //段间距
        didSet {
            bookParagraphHeight.doubleDecimals()
        }
    }
    //获取到每个背景下的字体等配置颜色
    lazy var bookThemeList: [GYReadThemeModel]! = {
        var array = [GYReadThemeModel]()
        let path = Bundle.main.path(forResource: "theme", ofType: "plist")
        if let list = NSArray(contentsOfFile: path!) {
            for i in 0..<list.count {
                if list[i] is [String : Any] {
                    let model = GYReadThemeModel(jsonDict: list[i] as! [String : Any])
                    array.append(model)
                }
            }
        }
        return array
    }()
    
    var themeModel: GYReadThemeModel! {
        if bookThemeIndex < bookThemeList.count {
            return bookThemeList[bookThemeIndex]
        }
        return bookThemeList[DEFAULT_THEMEINDEX]
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
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        bookFontSize = decodeFloatForKey(aDecoder, key: "bookFontSize")
        bookThemeIndex = decodeIntForKey(aDecoder, key: "bookThemeIndex")
        bookBrightness = decodeFloatForKey(aDecoder, key: "bookBrightness")
        bookLineHeight = decodeFloatForKey(aDecoder, key: "bookLineHeight")
        bookLetterSpace = decodeFloatForKey(aDecoder, key: "bookLetterSpace")
        bookFontWeight = decodeIntForKey(aDecoder, key: "bookFontWeight")
        bookParagraphHeight = decodeFloatForKey(aDecoder, key: "bookParagraphHeight")
        
        //解决兼容问题
        if var style = GYReadLineStyle(rawValue: decodeFloatForKey(aDecoder, key: "bookLineStyle")) {
            if style == .custom{
                style = .min
            }
            bookLineStyle = style
        }
        
        if let type = GYReadEffectType(rawValue: decodeStringForKey(aDecoder, key: "effectType")) {
            effectType = type
        }
        
        if let style = GYReadFontStyle(rawValue: decodeStringForKey(aDecoder, key: "simpleFontStyle")) {
            simpleFontStyle = style
        }
        
        if let style = GYReadFontType(rawValue: decodeStringForKey(aDecoder, key: "readFontStyle")) {
            readFontStyle = style
        }
        
        bookLightMode = decodeBoolForKey(aDecoder, key: "bookLightMode")
        bookPageMode = decodeBoolForKey(aDecoder, key: "bookPageMode")
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(bookFontSize, forKey: "bookFontSize")
        aCoder.encode(bookThemeIndex, forKey: "bookThemeIndex")
        aCoder.encode(bookBrightness, forKey: "bookBrightness")
        aCoder.encode(bookLineHeight, forKey: "bookLineHeight")
        aCoder.encode(bookLetterSpace, forKey: "bookLetterSpace")
        aCoder.encode(bookFontWeight, forKey: "bookFontWeight")
        aCoder.encode(bookLineStyle.rawValue, forKey: "bookLineStyle")
        aCoder.encode(readFontStyle.rawValue, forKey: "readFontStyle")
        
        aCoder.encode(bookParagraphHeight, forKey: "bookParagraphHeight")
        aCoder.encode(effectType.rawValue, forKey: "effectType")
        aCoder.encode(simpleFontStyle.rawValue, forKey: "simpleFontStyle")
        aCoder.encode(bookLightMode, forKey: "bookLightMode")
        aCoder.encode(bookPageMode, forKey: "bookPageMode")
    }

}

extension GYReadStyleModel {
    func defaultModel() {
        effectType = .translation
        simpleFontStyle = .zh_hans
        readFontStyle = .system
        
        bookFontSize = DEFAULT_FONT
        bookThemeIndex = DEFAULT_THEMEINDEX
        bookLightMode = DEFAULT_FONTMODEL
        bookBrightness = DEFAULT_BRIGHTNESS
        bookLineStyle = DEFAULT_LINESTYLE
        bookLineHeight = DEFAULT_LINESTYLE.rawValue
        bookLetterSpace = 0
        bookFontWeight = DEFAULT_FONTWEIGHT
        bookParagraphHeight = DEFAULT_PARAGRAPHHEIGHT //0.9倍
        bookPageMode = false
        
        //TODO:  初始化设置简体繁体
        if let language = NSLocale.preferredLanguages.first {
            if language.hasPrefix("zh-Hant"){
                simpleFontStyle = .zh_hant
            }else{
                simpleFontStyle = .zh_hans
            }
        }else{
            simpleFontStyle = .zh_hans
        }
        
    }
    
    //TODO: 新添加主题是更改这个值  用于日间夜间
    func reloadThemeIndexWithLightMode() {
        bookThemeIndex = bookLightMode == true ? 1 : 6
    }

    
}
