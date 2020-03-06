//
//  Header.swift
//  Audio
//
//  Created by CQSC  on 2018/5/22.
//  Copyright © 2018年 moqing. All rights reserved.
//

import UIKit

import Reachability


let DEVICEID = "\(OpenUDID.value() ?? " ")"

let KGOOGLEKey = "65269544290-f28amda9hamqsudg0vguo0sbgr3ns3fm.apps.googleusercontent.com"
let KGOOGLEServerKey = "65269544290-0h7k8m7j912p4119l082j6j7udbdfsut.apps.googleusercontent.com"

let LINEKey =  "1646354605"

let KWXAppID = "wx68c1a75aeff4debc"
let KWXAPPKEY = "nil"
let KWXSTATE = "MQI_123"
let DEFAULT_PER_PAGE: Int = 10

let TWITTER_APIkey = "lran9vOUIglaprUmKeS4IxwQh"
let TWITTER_Secretkey = "zBdyurbSSqHDh0UleuZchyrqI0pF5TcqwTNyfPGvILoU4lLbHC"

let BUNDLE_ID = "reader.cqsc.app"

let QYSDK_AppId = "b398cb69e2e4b12b1e29566e9eed3998"

let KQQCRASH_ID = ""
let KQQAPPLE_ID = "101474823"
let KQQAPPLE_KEY = "5efa0e621072d1dad440dd97f66cd051"


let JSBRIDGEHEADER = "legendnovelapp://"
let TARGET_NAME_EN = "legendnovelapp"

var COINNAME = kLocalized("MoB") /// "书币";
var COINNAME_PREIUM = kLocalized("MoD")///"书卷"
var COINNAME_MERGER = kLocalized("MoBD")///"书币/卷"


let tragetImageName = "CQSC"
let TARGET = "CQSCReader"
/// 埋点使用
let bufName = "CQSC"

//var TARGET_NAME = kLocalized("app_Name")
var COPYRIGHTNAME = kLocalized("app_Name")

var  APP_Ownership_AD_Text = "2019 \(COPYRIGHTNAME)All Right Reserved"
/// 关于使用
var  APP_Ownership_Text = "©2019 \(COPYRIGHTNAME) All Right Reserved"


let targetIcon = UIImage(named: "\(tragetImageName)_icon")


let shelfTiledUnEditSelImage = UIImage(named: "\(tragetImageName)_shelfEdit_tiled_unSel")

let um_jingxuan_item_click = "jingxuan_item_click"
let um_jingxuanrank_item_click = "jingxuanrank_item_click"

/// 默认icon
let Placehold_icon = UIImage(named: "audio_icon")
let bookPlaceHolderImage = UIImage(named: "\(tragetImageName)_book_placeHolder")
let About_IconName =  "\(tragetImageName)_icon"
let goodBookPlaceHolderImg = "\(tragetImageName)_goodBookPlaceHolderImg"
let book_PlaceholderImg = "\(tragetImageName)_bookStore_bookplaceholder"
let pay_userPayListRightImage = UIImage(named: "\(tragetImageName)_userPayListRightImage")
let banner_PlaceholderImg = "\(tragetImageName)_bookStore_bannerplaceholder"
let nav_PlaceholderImg = "\(tragetImageName)_bookStore_navplaceholder"
let Sign_closeBtnName = "\(tragetImageName)_Sign_closeBtn"
let shelfEditSelImage = UIImage(named: "\(tragetImageName)_shelfEdit_sel")

/// 闪屏图
let app_welfare_bottomlogoImage =  UIImage(named: "\(tragetImageName)_welfare_bottomlogo")

/// 服务条款
let The_Terms_Of_Service = BASEHTTPURL_CDN+"main/term"
/// 隐私协议
let Privacy_Agreement =  BASEHTTPURL_CDN+"main/privacy_agreement"

let  productHeader:String = "coin.cqsc."
///月卡
let  productHeader2:String = "discount.cqsc."
///  深度链接
let  deepLinkStr = TARGET_NAME_EN + "://navigator"

let  default_units = "$"


var itunes_url = "https://itunes.apple.com/us/app/id1454202392"

func getInPurchaseId(money: Int) -> String {
    return productHeader+"\(money)"
}
var  FC_Str:String?

 
//TODO: 默认阅读
let DEFAULT_FONT: Float = 20 //字体大小 16原始
let DEFAULT_BRIGHTNESS: Float = 0 //
let DEFAULT_LINESTYLE: GYReadLineStyle = .original //行间距
let DEFAULT_FONTWEIGHT: Int = 1 //字体粗细 1 2
let DEFAULT_THEMEINDEX: NSInteger = 1 //默认是第二个 01
let DEFAULT_FONTMODEL: Bool = false //黑夜模式
let DEFAULT_READFONT: Bool = true
let DEFAULT_PARAGRAPHHEIGHT: Float = 0.9 //段落间距
let bookRefreshInterval:Int = 2 // 同一本书刷新间隔 单位小时
/// 缺省图定义



var ipad: Bool = UIDevice.current.userInterfaceIdiom == .pad
let screenWidth: CGFloat = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let x_StatusBarHeight:CGFloat = is_iPhone_X ? 44.0 : 20.0
let x_TabbarHeight:CGFloat = is_iPhone_X ? (49.0+34.0) : 49.0
let x_TabbatSafeBottomMargin:CGFloat = is_iPhone_X ? 34 : 0
let x_statusBarAndNavBarHeight:CGFloat = is_iPhone_X ? 88.0 : 64
//let is_iPhone_X:Bool! = (screenWidth == 375.0 && screenHeight == 812 ? true : false)
let is_iPhone_X:Bool! = kUIStyle.kISiPhoneX


let layerColor = kUIStyle.colorWithHexString("ffffff")
let mainColor = kUIStyle.colorWithHexString("7187FF")


let tabbarDefultColor = colorWithHexString("#425154")
let tabbarSelectColor = colorWithHexString("#425154")
let MQITintColor = RGBColor(102, g: 102, b: 102)
let backColor = colorWithHexString("#ffffff")
let gdscale:CGFloat = screenWidth/375
let mqscale:CGFloat = gdscale < 1 ? 1 :gdscale
let hdscale:CGFloat = screenHeight/640
let gd_scale:CGFloat = mqscale > 1.2 ? mqscale : mqscale
let topicalColor = colorWithHexString("#EB5567")
let btnTag: Int = 1000


let lineColor = RGBColor(200, g: 200, b: 200)
let darkColor = RGBColor(215, g: 215, b: 215)
let lightGrayColor = RGBColor(246, g: 246, b: 246)
let navColor =  RGBColor(21, g: 163, b: 193)
let tableViewBacColor = RGBColor(239, g: 239, b: 239)
let tableViewSelColor = RGBColor(240, g: 240, b: 240)
let lightTextColor = RGBColor(153, g: 153, b: 153)
let blackColor = RGBColor(37, g: 37, b: 37)
let yellowBacColor = RGBColor(255, g: 229, b: 26)
let gCollectionViewBacColor = RGBColor(242, g: 242, b: 242)
let GYBookOriginalInfoVC_lineColor = RGBColor(242, g: 242, b: 242)


let TYPE_INIT_BOOKSHELF = "init_bookshelf"/// 初始推荐
let TYPE_BOOKSHELF = "bookshelf" /// 书架banner
let TYPE_SEARCH = "search" /// 搜索
let TYPE_BOOK_DETAIL = "book_detail" /// 书籍详情
let TYPE_SIGN = "lottery" /// 签到
let TYPE_STOER_DAILY = "store_daily" /// 今日推荐


/// 切换语言是更改固定标识
func changeLogo(){
    COINNAME = kLocalized("MoB") /// "书币";
    COINNAME_PREIUM = kLocalized("MoD")///"书卷"
    COINNAME_MERGER = kLocalized("MoBD")///"书币/卷"
//    TARGET_NAME = kLocalized("app_Name")
    COPYRIGHTNAME = kLocalized("app_Name")
    APP_Ownership_AD_Text = "2019 \(COPYRIGHTNAME)All Right Reserved"
    APP_Ownership_Text = "©2019 \(COPYRIGHTNAME) All Right Reserved"
}
/// Log信息
func mqLog <T>(_ message : T, file : String = #file, method: String = #function, lineNumber : Int = #line) {
    if isDebug{
        print("[\((file as NSString).lastPathComponent):\(lineNumber):[\(method)]**\n \(message)\n")
    }
}

///是否为debug模式
var isDebug: Bool {
    get {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
enum lineDirection {
    case left
    case right
    case bottom
    case top
}

public func RGBColor(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha:1)
}

public func systemFont(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: CGFloat(size))
}

public func systemBoldFont(_ size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: CGFloat(size))
}

let iPhone_4_4s: Bool! = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode!.size) : false // iPhone4及4s
let iPhone_5_5s: Bool! = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode!.size) : false // iPhone5及5s
let iPhone_6: Bool! = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode!.size) : false // iPhone6
let iPhone_6_plus: Bool! = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode!.size) : false //iPhone6+
let iphone_x: Bool! = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode!.size) : false //

let buildVersion: Int = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1// build号

public func hexStringToColor(_ hexString: String) -> UIColor {
    var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  
    if cString.count < 6 { return UIColor.black }
    
    if cString.hasPrefix("0X") { cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2)) }
    if cString.hasPrefix("#") { cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1)) }
    if cString.count != 6 { return UIColor.black }
    
    var range: NSRange = NSMakeRange(0, 2)
    
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    
    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    Scanner.init(string: rString).scanHexInt32(&r)
    Scanner.init(string: gString).scanHexInt32(&g)
    Scanner.init(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
public func CATransform3DPerspect(_ t: CATransform3D, center: CGPoint, disZ: CGFloat) -> CATransform3D {
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ: disZ))
}
public func CATransform3DMakePerspective(_ center: CGPoint, disZ: CGFloat) -> CATransform3D{
    let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
    let transBack = CATransform3DMakeTranslation(center.x, center.y, 0)
    var scale = CATransform3DIdentity
    scale.m34 = -1.0 / disZ
    
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
}
public func checkNetStatus() -> Bool {
    if let r = Reachability(hostname: hostname) {
        switch r.currentReachabilityStatus() {
        case .NotReachable:
            return false
        case .ReachableViaWiFi:
            return true
        case .ReachableViaWWAN:
            return true
        }
    }else {
        return false
    }
}
/*
 图片渲染颜色
 */
public func imageWithColor(_ image: UIImage, color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()!
    context.translateBy(x: 0, y: image.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(.normal)
    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    context.clip(to: rect, mask: image.cgImage!)
    color.setFill()
    context.fill(rect);
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!;
}

public func boldFont(_ size: Float) -> UIFont  {
    return UIFont.boldSystemFont(ofSize: CGFloat(size))
}


public func createLabel(_ frame: CGRect?,
                        font: UIFont?,
                        bacColor: UIColor?,
                        textColor: UIColor?,
                        adjustsFontSizeToFitWidth: Bool?,
                        textAlignment: NSTextAlignment?,
                        numberOfLines: NSInteger?) -> UILabel {
    
    let label = UILabel(frame: frame == nil ? CGRect.zero : frame!)
    label.font = font == nil ? UIFont.systemFont(ofSize: ipad == true ? 18 : 14) : font!
    label.textColor = textColor == nil ? UIColor.clear : textColor!
    label.textAlignment = textAlignment == nil ? .left : textAlignment!
    label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth == nil ? false : adjustsFontSizeToFitWidth!
    label.numberOfLines = numberOfLines == nil ? 1 : numberOfLines!
    if bacColor != nil {
        label.backgroundColor = bacColor
    }
    return label
}

/**
 创建button
 
 - parameter frame:              坐标
 - parameter normalTitle:        正常状态标题
 - parameter normalImage:        正常状态图片
 - parameter selectedTitle:      选中状态标题
 - parameter selectedImage:      选中状态图片
 - parameter normalTilteColor:   正常状态字体颜色
 - parameter selectedTitleColor: 选中状态字体闫泽
 - parameter bacColor:               背景颜色
 - parameter font:               字体
 - parameter target:             事件target
 - parameter action:             事件
 
 - returns: 返回button
 */
public func createButton(_ frame: CGRect?,
                         normalTitle: String? = nil,
                         normalImage: UIImage? = nil,
                         selectedTitle: String? = nil,
                         selectedImage: UIImage? = nil,
                         normalTilteColor: UIColor? = nil,
                         selectedTitleColor: UIColor? = nil,
                         bacColor: UIColor? = nil,
                         font: UIFont? = nil,
                         target: AnyObject?,
                         action: Selector) -> UIButton {
    
    let button = UIButton(type: .custom)
    button.frame = frame == nil ? CGRect.zero : frame!
    button.setTitle(normalTitle, for: .normal)
    button.setTitle(selectedTitle, for: .selected)
    button.setImage(normalImage, for: .normal)
    button.setImage(selectedImage, for: .selected)
    button.setTitleColor(normalTilteColor, for: .normal)
    button.setTitleColor(selectedTitleColor, for: .selected)
    button.backgroundColor = bacColor
    button.addTarget(target, action: action, for: .touchUpInside)
    
    if let titleLabel = button.titleLabel {
        titleLabel.font = font
    }
    return button
}


public func getBackBtn() -> UIButton {
    let backBtn = UIButton(type: .custom)
    backBtn.setImage(UIImage(named:"nav_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
    backBtn.setTitle("     ", for: .normal)
    backBtn.setTitleColor(nav_button_textColor, for: .normal)
    backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    backBtn.tintColor = UIColor.black
    return backBtn
}

@discardableResult public func addTGR(_ target: AnyObject, action: Selector, view: UIView) -> UITapGestureRecognizer {
    let tgr = UITapGestureRecognizer(target: target, action: action)
    view.addGestureRecognizer(tgr)
    return tgr
}

/// 字符串转文字
public func colorWithHexString(_ hex:String,alpha:CGFloat = 1) ->UIColor {
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = String(cString.suffix(from: index))
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

public func createImageView(_ frame: CGRect?,
                            image: UIImage?,
                            contentMode: UIView.ContentMode?) -> UIImageView {
    
    let imageView = UIImageView(frame: frame == nil ? CGRect.zero : frame!)
    imageView.image = image
    imageView.contentMode = contentMode == nil ? .scaleAspectFit : contentMode!
    return imageView
}

//MARK: --
public func getWindow() -> UIWindow {
    var windows = UIApplication.shared.windows as Array
    return windows[0]
}
func gd_currentTabbarController()->MQITabBarController {
    return (UIApplication.shared.delegate as! AppDelegate).tabBarController
}
func gd_currentNavigationController()->MQINavigationViewController {
    return gd_currentTabbarController().selectedViewController as! MQINavigationViewController
}
func gd_currentViewController()->UIViewController{
    let nav = gd_currentNavigationController()
    if nav.viewControllers.count > 0 {
        return nav.viewControllers.last!
    }
    return UIViewController()
}
public func getMaskView(_ frame: CGRect) -> UIView {
    let maskView_ = UIView(frame: frame)
    maskView_.isUserInteractionEnabled = true
    maskView_.backgroundColor = UIColor.black
    maskView_.alpha = 0
    return maskView_
}
public func after(_ time: Double, block: @escaping (() -> ())) {
    let time = DispatchTime.now() + Double(Int64(UInt64(time)*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
        block()
    })
}

public func getBoolWithValue(_ value: Any?) -> Bool {
    if let value = value {
        if value is NSString || value is String || value is NSNumber  {
            return "\(value)" == "0" ? false : true
        }else if value is Bool {
            return value as! Bool
        }else {
            return false
        }
    }else {
        return false
    }
}
public func getIntWithValue(_ value: Any?) -> NSInteger {
    if let value = value {
        if value is NSInteger || value is NSString || value is String || value is NSNumber{
            return NSInteger("\(value)".integerValue())
        }else if value is Int {
            return value as! NSInteger
        }else {
            return 0
        }
    }else {
        return 0
    }
}

public func getCurrentVersion() -> String {
    let infoDict = Bundle.main.infoDictionary!
    let currentVersion: AnyObject? = infoDict["CFBundleShortVersionString"] as AnyObject?
    if currentVersion != nil {
        return "\(currentVersion!)"
    }
    return ""
}

//MARK:  阅读上传记录改为秒
public func GetCurrent_millisecondIntervalSince1970String() -> String {
//    return String(format: "%.0lf",Date().timeIntervalSince1970*1000)//ms
     return "\(Int(Date().timeIntervalSince1970))" //s
}

public func dispatchArchive(_ obj: Any, path: String, completion: ((_ suc: Bool) -> ())? = nil) {
    DispatchQueue.global().async { () -> Void in
        let suc = NSKeyedArchiver.archiveRootObject(obj, toFile: path)
        completion?(suc)
    }
}


public func decodeStringForKey(_ aDecoder: NSCoder, key: String) -> String {
    if let obj = aDecoder.decodeObject(forKey: key) {
        if obj is String || obj is NSString {
            return obj as! String
        }else {
            return ""
        }
    }else {
        return ""
    }
}
public func decodeObjForKey(_ aDecoder: NSCoder, key: String) -> Any? {
    let obj = aDecoder.decodeObject(forKey: key)
    return obj
}


public func decodeBoolForKey(_ aDecoder: NSCoder, key: String) -> Bool {
    return aDecoder.decodeBool(forKey: key)
}


public func decodeIntForKey(_ aDecoder: NSCoder, key: String) -> Int {
    return Int(aDecoder.decodeInteger(forKey: key))
}

public func decodeIntegerForKey(_ aDecoder: NSCoder, key: String) -> NSInteger {
    return NSInteger(aDecoder.decodeInteger(forKey: key))
}

public func decodeFloatForKey(_ aDecoder: NSCoder, key: String) -> Float {
    return aDecoder.decodeFloat(forKey: key)
}
public func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}
//解析url参数 ？  &
public func convertUrlToDictionary(_ urlString:String) -> [String:AnyObject]? {
    
    let array = urlString.components(separatedBy: "&")
    let finalResult = NSMutableDictionary()
    
    for eachParm in array {
        let eachArray = eachParm.components(separatedBy: "=")
        if eachArray.count > 1 {
            let key = eachArray[0]
            let value = eachArray[1]
            finalResult.setObject(value, forKey: key as NSCopying)
        }
    }
    return finalResult as? [String : AnyObject]
}
//字典g转魔情
public func dictionaryToJsonString(_ dic:[String:Any]) -> String {
    
    if (!JSONSerialization.isValidJSONObject(dic)){
        return ""
    }
    let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    let jsonString = String(data: data!, encoding: String.Encoding.utf8)
    
    return jsonString!
}
//color 转 image
public func createImageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//color 转 image
public func getShowMoney(_ coin: String) -> NSString {
    if coin == "" || isPurnInt(string: coin) != true{
        return ""
    }
    let con = coin.floatValue() / 100.00
    let intNum = Int(con)
    if con - Float(intNum) <= 0{
        let intStr = NSString.init(format: "%d", intNum)
        return intStr
    }else{
        if coin.int32Value() % 10 > 0{
            let str = NSString.init(format: "%.2f", con)
            return str
        }else{
            let str = NSString.init(format: "%.1f", con)
            return str
        }
    }
}
func isPurnInt(string: String) -> Bool {
    
    let scan: Scanner = Scanner(string: string)
    
    var val:Int = 0
    
    return scan.scanInt(&val) && scan.isAtEnd
    
}
//添加常按手势
@discardableResult public func addLongPress(_ target: AnyObject, action: Selector, view: UIView) -> UILongPressGestureRecognizer {
    let tgr = UILongPressGestureRecognizer(target: target, action: action)
    tgr.minimumPressDuration = 0.5
    view.addGestureRecognizer(tgr)
    return tgr
}

//根据文字、字体、最大边长，获取自适应的rect
public func getAutoRect(_ str: String?, font: UIFont, maxWidth: CGFloat, maxHeight: CGFloat) -> CGRect {
    if let str = str {
        if str.count <= 0 {
            return CGRect.zero
        }
        
        let size = CGSize(width: maxWidth, height: maxHeight)
        let actualRect = NSString(string: str).boundingRect(with: size,
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil)
        return actualRect
    }else {
        return CGRect.zero
    }
}


//MARK:小数点一位
public func qiuZhengshu(_ string:String)->String {
    var newN = ""
    if string.floatValue() > 10000 {
        let number = string.floatValue() / 10000
        let lastStr = formatFloat(number)
        newN = "\(lastStr)" + kLocalized("TenRhousand")
    }else if string.floatValue() > 1000 {
        let number = string.floatValue() / 1000
        let lastStr = formatFloat(number)
        newN = "\(lastStr)" + kLocalized("thousand")
    }else {
        newN = string + ""
    }
    return newN
}
func formatFloat(_ f:Float)->NSString {
    let str = NSString(format: "%.1f", f)
    let number = str.floatValue
    let i = roundf(number)
    if i == number {
        return NSString(format: "%.0f", number)
    }else {
        return NSString(format: "%.1f", number)
    }
}

///东8区时间
func getTimeStampToString(_ t_Str:String,format:String = "yyyy-MM-dd")->String {
    let time = t_Str.integerValue()
    if time <= 0 {return t_Str}
//    let date =  Date.init(timeIntervalSinceNow:  TimeInterval(time))
    
    let date = Date.init(timeIntervalSince1970: TimeInterval(time))
    let formatter = DateFormatter()
    formatter.dateFormat = format /// yyyy-MM-dd HH:mm:ss
//    if let current = TimeZone(secondsFromGMT: 28800) {
//        formatter.timeZone = current
//    }else{
//       formatter.timeZone =  TimeZone.current
//    }
     formatter.timeZone =  TimeZone.current
    return formatter.string(from: date)
}


func getNowtimeDate(_ t_Str:String) -> String {
    var timeString = ""
    let oldTime = t_Str.integerValue()
    if oldTime <= 0 {return timeString}
    let oldDate =  Date(timeIntervalSince1970: TimeInterval(oldTime))
    let time = Date().timeIntervalSince(oldDate)
    if time < 60 {
        timeString = kLocalized("just_date")
    }else if time/60 < 60 {
        timeString = kLongLocalized("MinutesAgo", replace: "\(Int(time/60))", isFirst: true)
    }else if time/(60*60) < 24 {
        timeString =  kLongLocalized("HoursBefore", replace: "\(Int(time/(60*60)))", isFirst: true)
    }else if time/(24*60*60) < 30 {
        timeString = kLongLocalized("DaysAgo", replace: "\(Int(time/(24*60*60)))", isFirst: true)
    }else {
       timeString =  getTimeStampToString(t_Str)
    }
    
  return timeString
    
}
func getCurrentStamp() -> Int{
    return Int(Date().timeIntervalSince1970)
}
