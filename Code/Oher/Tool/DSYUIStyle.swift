//
//  DSYUIStyle.swift
//  swift学习
//
//  Created by DSY on 2017/11/20.
//  Copyright © 2017年 DSY. All rights reserved.
//

import UIKit


public class kUIStyle: NSObject {
    
    //MARK:颜色属性定义
    public static  let kDefaultColor  = colorFromRGB(r: 0, g: 0, b: 0, alpha: 1)
    public static  let kClearColor  =  UIColor.clear
    public static  let kRedColor  =  UIColor.red
    public static  let kWhiteColor  =  UIColor.white
    ///  白色
    public static  let kColorfff  = colorFrom16RGB(rgbValue: 0xffffff, alpha: 1)
    /// 粉色
    public static  let kColorEB5  =  colorWithHexString("EB5567")
    /// 黑色
    public static  let kColor333  =  colorWithHexString("#333333")
    
    
    //MARK:间距属性定义
    
    public static  let kScrHeight = maker.scrHeight
    public static  let kScrWidth = maker.scrWidth
    public static  let kLine1px  = maker.line1px
    public static  let kHSpacing30 = scaleH(30)
    public static  let kHSpacing44 = 44
    /// 高度比例 1px
    public static  let kScaleH = maker.dsyDesignScaleH
    /// 宽度比例 1px
    public static  let kScaleW = maker.dsyDesignScaleW
    /// tabbar 高度 ipX 34+49
    public static  let kTabBarHeight:CGFloat = !kISiPhoneX ? 49 : 83
    /// tabbar 安全高度
    public static  let kTabBarSafeBottomHeight:CGFloat = !kISiPhoneX ? 0 : 34  
    /// navbar 高度 ipX 44 +44
    public static  let kNavBarHeight:CGFloat = !kISiPhoneX ? 64 : 88
    /// StatusBarHeigh 高度 ipX 44 +20
    public static  let kStatusBarHeight:CGFloat = !kISiPhoneX ? 20 : 44
    
    //MARK:字体属性定义
    public static  let kSize20px = maker.size20px
    public static  let kSize22px = kSize20px*1.1
    public static  let kSize24px = kSize20px*1.2
    public static  let kSize26px = kSize20px*1.3
    public static  let kSize28px = kSize20px*1.4
    public static  let kSize30px = kSize20px*1.5
    public static  let kSize32px = kSize20px*1.6
    public static  let kSize34px = kSize20px*1.7
    public static  let kSize36px = kSize20px*1.8
    public static  let kSize38px = kSize20px*1.9
    public static  let kSize40px = kSize20px*2.0
    public static  let kSize42px = kSize20px*2.1
    public static  let kSize44px = kSize20px*2.2
    public static  let kSize46px = kSize20px*2.3
    public static  let kSize48px = kSize20px*2.4
    
    
    
    //MARK:公用属性定义
    //    public static  let kISiPhoneX:Bool = kScrHeight == 812 ? true : false
    public static  let kISiPhoneX:Bool = isX()
    public static  let kISiPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    public static  let kISiPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}

/****************    方法定义     **************************/
extension kUIStyle {
    //MARK:字体
    /// 普通字体 传入设计字体 2px
    public static func sysFontDesignSize(size s:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size(s))
    }
    /// 加粗字体 传入设计字体 2px
    public static func boldSystemFontDesignSize(size s:CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:size(s))
    }
    
    /// 斜字体 传入设计字体 2px
    public static func italicSysFontDesignSize(size s:CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize:size(s))
    }
    
    /// 普通字体 传入设计字体 1px
    public static func sysFontDesign1PXSize(size s:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size1PX(s))
    }
    /// 加粗字体 传入设计字体 1px
    public static func boldSystemFont1PXDesignSize(size s:CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:size1PX(s))
    }
    
    /// 斜字体 传入设计字体 1px
    public static func italicSysFont1PXDesignSize(size s:CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize:size1PX(s))
    }
    
    /// ********** 原生字体大小
    /// 普通字体 pt
    public static func sysFont(size s:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: s)
    }
    /// 加粗字体 pt
    public static func boldSystemFont(size s:CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:s)
    }
    /// 斜字体 pt
    public static func italicSysFont(size s:CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize:s)
    }
    
    /// 字体
    public static func size(_ size:CGFloat)->CGFloat {
        return size*maker.size1px
    }
    /// 字体
    public static func size1PX(_ size:CGFloat)->CGFloat {
        return size*maker.dsyDesignScaleW
    }
    
    //MARK:比例
    /// 高比例 传入2PX数据
    public static func scaleH(_ h:CGFloat)->CGFloat {
        return h*khSpacing1
    }
    /// 宽比例 传入2PX数据
    public static func scaleW(_ w:CGFloat)->CGFloat {
        return w*kwSpacing1
    }
    /// 高比例 传入1PX数据
    public static func scale1PXH(_ h:CGFloat)->CGFloat {
        return h*maker.dsyDesignScaleH
    }
    /// 宽比例 传入1PX数据
    public static func scale1PXW(_ w:CGFloat)->CGFloat {
        return w*maker.dsyDesignScaleW
    }
    
    
    ///弧度角度转换
    public static func angle(_ value:CGFloat) -> CGFloat {
        return CGFloat((CGFloat.pi*value) / 180)
        
    }
    //MARK: 颜色
    /// 随机颜色
    public static func randomColor() -> UIColor {
        return colorFromRGB(r: CGFloat(Int(arc4random_uniform(256))), g: CGFloat(Int(arc4random_uniform(256))), b:CGFloat(Int(arc4random_uniform(256))), alpha: 1.0)
    }
    
    /// 16进制转rgb颜色
    public static func colorFrom16RGB(rgbValue r:Int ,alpha:CGFloat) -> UIColor {
        return colorFromRGB(r:((CGFloat((r & 0xFF0000) >> 16))), g: ((CGFloat((r & 0xFF00) >> 8))), b:((CGFloat(r & 0xFF))), alpha: alpha)
    }
    
    
    /// 普通RGB
    public static func colorFromRGB(r red:CGFloat,g green:CGFloat,b blue:CGFloat , alpha: CGFloat = 1) -> UIColor {
        return  UIColor.init( red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    /// 字符串转文字
    public static  func colorWithHexString(_ hex:String,alpha:CGFloat = 1) ->UIColor {
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("0X") {
            cString = String(cString.suffix(from: cString.index(cString.startIndex, offsetBy:2)))
        }
        
        if (cString.hasPrefix("#")) {
            cString = String(cString.suffix(from: cString.index(cString.startIndex, offsetBy:1)))
        }
        
        if (cString.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString.prefix(upTo: rIndex))
        let otherString = String(cString.suffix(from: rIndex))
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = String(otherString.prefix(upTo: gIndex))
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = String(cString.suffix(from: bIndex))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha )
    }
    
    /// 根据颜色创建图片
    public static func  createImageWithColor(_ color:UIColor) -> UIImage {
        let  rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 计算文字大小获取宽度度
    public static func getTextSizeWidth(text: String,font:UIFont ,maxHeight: CGFloat) -> CGFloat{
        return getTextSize(text:text ,font:font, maxSize:CGSize(width:CGFloat(MAXFLOAT), height: maxHeight)).width
    }
    /// 计算文字大小获取高度
    public static func getTextSizeHeight(text: String,font:UIFont ,maxWidth: CGFloat) -> CGFloat{
        return getTextSize(text:text ,font:font, maxSize:CGSize(width:maxWidth, height: CGFloat(MAXFLOAT))).height
    }
    
    /// 计算文字大小 CGFloat(MAXFLOAT)
    public static func getTextSize(text: String,font:UIFont ,maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil).size
    }
    
}

/****************    私有属性定义    **************************/
private extension kUIStyle {
    /// 以设计图 iPhone6为主
    static  let maker = DSYUIStyleMaker(s:2.0, w: 375.0, h: 667.0,scale: 1.0)
    static  let khSpacing1  = maker.spacingH1
    static  let kwSpacing1  = maker.spacingW1
    static  let kSize1px = maker.size1px
    static func isX () -> Bool {
        
        if #available(iOS 11.0, *) {
            if  let mainWindow = UIApplication.shared.delegate?.window {
                if (mainWindow?.safeAreaInsets.bottom)! > CGFloat(0.0) {
                    return true
                }
            }
        }
        return false
    }
}


private class DSYUIStyleMaker: NSObject {
    //MARK: 定义属性
    /// 屏幕宽度
    var scrWidth: CGFloat = 0.0
    /// 屏幕高度
    var scrHeight: CGFloat = 0.0
    /// 文字缩放比例高度
    var fontScale: CGFloat = 0.0
    
    //MARK: 重写init 定义固定变量
    init(s:CGFloat ,w: CGFloat,h:CGFloat, scale:CGFloat) {
        super.init()
        dsyScale = s ///默认屏幕比例
        dsyDesignW  = w ///设计宽度
        dsyDesignH  = h///设计高度
        fontScale = scale ///默认字体比例
        scrWidth = UIScreen.main.bounds.size.width
        scrHeight = UIScreen.main.bounds.size.height
        
    }
    
    
    lazy var line1px: CGFloat =  1.0/self.dsyScale
    lazy var size20px :CGFloat = self.dsySizeFunc(20)
    lazy var size1px :CGFloat = self.dsySizeFunc(1)
    lazy var spacingW1 :CGFloat = self.dsyDesignWFunc(1)
    lazy var spacingH1 :CGFloat = self.dsyDesignHFunc(1)
    
    /****************    私有属性   **************************/
    //MARK: 私有属性
    /// 缩放比例
    var dsyScale: CGFloat = 1.0
    /// 真实尺寸W比例
    var dsyDesignW: CGFloat = 1.0
    /// 真实尺寸H比例
    var dsyDesignH: CGFloat = 1.0
    
    var dsyDesignScaleW: CGFloat {
        get {
            var w = self.scrWidth/self.dsyDesignW
            if w > 1.5 { w = 1.5}
            return w
        }
    }
    
    var dsyDesignScaleH: CGFloat {
        get {
            var h = self.scrHeight/self.dsyDesignH
            if h > 1.5 {h = 1.5}
            return  h
        }
    }
    
}

//MARK: 私有方法
private extension DSYUIStyleMaker {
    
    ///计算字体方法
    func dsySizeFunc(_ w:CGFloat) -> CGFloat {
        var F =  dsyDesignWFunc(w)
        if F > 1 {F = 0.8}
        return F*self.fontScale
    }
    ///计算比例宽度
    func dsyDesignWFunc(_ w:CGFloat) -> CGFloat {
        return w*self.dsyDesignScaleW/dsyScale
    }
    ///计算比例高度
    func dsyDesignHFunc(_ h:CGFloat) -> CGFloat {
        return h*self.dsyDesignScaleH/dsyScale
    }
    
}
