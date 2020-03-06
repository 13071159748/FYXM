//
//  GYReadStyle.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit



let KBOOKFONTSIZE = "bookFontSize"
let KBOOKTHEMEINDEX = "bookThemeIndex"
let KBOOKREADERMODEL = "bookReaderModel"
let KBOOKFONTSTYLE = "bookFontStyle"
let KBOOKBRIGHTNESS = "bookBrightness"
let KBOOKLINEHEIGHT = "bookLineHeight"
let KBOOKLETTERSPACE = "bookLetterSpace"
let KBOOKFONTWEIGHT = "bookFontWeight"
let KBOOKPARAGRAPHHEIGHT = "bookParagraphHeight"
let KBOOKPAGEMODE = "bookPageMode"

class GYReadStyle: NSObject {
    
    
    var styleModel: GYReadStyleModel!
    
    lazy var tmpPath: String = {
        var uid = ""
        if MQIUserManager.shared.checkIsLogin() == true {
            uid = MQIUserManager.shared.user!.user_id+"_"
        }
       return MQIFileManager.getCurrentStoreagePath("\(uid)readStyle.db")
    }()
    
    fileprivate static var __once: () = {
        Inner.instance = GYReadStyle()
    }()
    struct Inner {
        static var token: Int = 0
        static var instance: GYReadStyle?
    }
    
    
    class var shared: GYReadStyle {
        _ = GYReadStyle.__once
        return Inner.instance!
    }

    override init() {
        super.init()
        
        if MQIFileManager.checkFileIsExist(tmpPath) == true {
            
            if let model = NSKeyedUnarchiver.unarchiveObject(withFile: tmpPath) as? GYReadStyleModel {
                styleModel = model
            }else if UserDefaults.standard.object(forKey: KBOOKFONTSTYLE) != nil {
                styleModel = GYReadStyleModel()
                styleModel.defaultModel()
                
                styleModel.bookThemeIndex = UserDefaults.standard.integer(forKey: KBOOKTHEMEINDEX)
                
                if (styleModel.bookThemeIndex < 0 || styleModel.bookThemeIndex > 6) {
                    styleModel.bookThemeIndex = 1
                }
                
                styleModel.bookFontSize = Float(UserDefaults.standard.integer(forKey: KBOOKFONTSIZE))
                if (styleModel.bookFontSize == 0) {
                    styleModel.bookFontSize = DEFAULT_FONT
                }
                
                styleModel.bookBrightness = 1-UserDefaults.standard.float(forKey: KBOOKBRIGHTNESS)//高亮
                if (styleModel.bookBrightness == 0.0) {
                    styleModel.bookBrightness = DEFAULT_BRIGHTNESS
                }
                
                if let str = UserDefaults.standard.object(forKey: KBOOKFONTSTYLE) as? String {
                    if let style = GYReadFontStyle(rawValue: str) {
                        styleModel.simpleFontStyle = style
                    }else {
                       styleModel.simpleFontStyle = .zh_hans
                    }
                }
                
                styleModel.bookLineHeight = UserDefaults.standard.float(forKey: KBOOKLINEHEIGHT)
                if styleModel.bookLineHeight == 0.0 {
                    styleModel.bookLineHeight = DEFAULT_LINESTYLE.rawValue
                }
                
                styleModel.bookParagraphHeight = UserDefaults.standard.float(forKey: KBOOKPARAGRAPHHEIGHT)
                styleModel.bookLetterSpace = UserDefaults.standard.float(forKey: KBOOKLETTERSPACE)
                styleModel.bookFontWeight = UserDefaults.standard.integer(forKey: KBOOKFONTWEIGHT)/100 == 6 ? 2 : 1
            }else {
                styleModel = GYReadStyleModel()
                styleModel.defaultModel()
                
            }
        }
        
    }
    
    @discardableResult func saveStyleModel() -> Bool {
        dispatchArchive(styleModel, path: tmpPath)
        return true
    }
    
    //MARK: ---------------------------------line---------------------------------
    
    /// 获得文字属性字典
    func readAttribute() ->[NSAttributedString.Key: NSObject] {
        let textColor = styleModel.themeModel.textColor
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 行间距
//        paragraphStyle.lineSpacing = CGFloat(GYReadStyle.shared.styleModel.bookLineHeight)
        
        // 段间距
        paragraphStyle.paragraphSpacing = CGFloat(GYReadStyle.shared.styleModel.bookParagraphHeight)*20
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = CGFloat(styleModel.bookLineHeight)
        
        // 对其
        paragraphStyle.alignment = NSTextAlignment.justified
        
        // 返回
        return [NSAttributedString.Key.foregroundColor : textColor!,
                NSAttributedString.Key.font : readFont(isTitle: false),
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.kern : NSNumber(value: (GYReadStyle.shared.styleModel.bookLetterSpace*5))]
    }
    
    /// 获得标题文字属性字典
    func readTitleAttribute() ->[NSAttributedString.Key: NSObject] {
        let titleColor = styleModel.themeModel.titleColor
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 段间距
        paragraphStyle.paragraphSpacing = CGFloat(GYReadStyle.shared.styleModel.bookParagraphHeight)*20+20
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        // 对其
        paragraphStyle.alignment = NSTextAlignment.justified
        
        // 返回
        return [NSAttributedString.Key.foregroundColor: titleColor!,NSAttributedString.Key.font: readFont(isTitle: true),NSAttributedString.Key.paragraphStyle: paragraphStyle]
    }
    
    /// 获得文字Font
    func readFont(isTitle: Bool) -> UIFont {
        
        var fontName = ""
        
        if styleModel.readFontStyle == GYReadFontType.one { // 黑体
            fontName = "EuphemiaUCAS-Italic"
        }else if styleModel.readFontStyle == GYReadFontType.two { // 楷体
            fontName = "AmericanTypewriter-Light"
        }else if styleModel.readFontStyle == GYReadFontType.three { // 宋体
            fontName = "Papyrus"
        }else{ // 系统
            fontName = "STHeiti SC"
        }
        let fontSize = CGFloat(styleModel.bookFontSize)
        if isTitle == true {
            return UIFont.boldSystemFont(ofSize: fontSize+8)
        }
        if styleModel.bookFontWeight == 1 {
            if let font = UIFont(name: fontName, size: fontSize) {
                return font
            }else {
                return UIFont.systemFont(ofSize: fontSize)
            }
        }else {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
    
}



