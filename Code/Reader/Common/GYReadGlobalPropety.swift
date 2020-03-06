//
//  GYReadGlobalPropety.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

/// 翻页类型
enum GYReadEffectType: String {
    case none = "无"               // 无效果
    case translation = "简约"         // 平移
    case simulation = "仿真"          // 仿真
    case upAndDown = "上下"           // 上下
    func conversion()->String {
        switch self {
        case .none:  return kLocalized("ThereIsNo")
        case .translation: return kLocalized("contracted")
        case .simulation: return kLocalized("TheSimulation")
        case .upAndDown:  return  kLocalized("UpAndDown")
        }
    }
    
}


/// 字体类型
enum GYReadFontType: String {
    case system = "系统"             // 系统
    case one = "黑体"                // 黑体
    case two = "楷体"                // 楷体
    case three = "宋体"              // 宋体
}

enum GYReadLineStyle: Float {
    case min = 1.4
    case max = 2.2
    case mid = 2.0
    case original = 1.9
    case custom = 0.0
}

enum GYReadFontStyle: String {
    case zh_hans = "简体"
    case zh_hant = "繁体"
}


enum readSettingViewSytle: String{
    case fontView = "fontView"
    case moreView = "moreView"
}

// MARK: -- 屏幕属性
/// 导航栏高度
let NavgationBarHeight:CGFloat = root_nav_height+root_status_height

/// 菜单背景颜色
let GYMenuUIColor: UIColor = UIColor.black.withAlphaComponent(0.85)


// MARK: -- Key
/// 是夜间还是日间模式   true:夜间 false:日间
let GYKey_IsNighOrtDay:String = "isNightOrDay"


// MARK: -- 获取时间

/// 获取当前时间传入 时间格式 "YYYY-MM-dd-HH-mm-ss"
func GetCurrentTimerString(dateFormat:String) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: Date())
}

/// 将 时间 根据 类型 转成 时间字符串
func GetTimerString(dateFormat:String, date:Date) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: date)
}

/// 获取当前的 TimeIntervalSince1970 时间字符串
func GetCurrentTimeIntervalSince1970String() -> String {
    
    return String(format: "%.0f",Date().timeIntervalSince1970)
}

// MARK: -- 阅读ViewLayout
func GetPageVCLayout() -> pageVCLayout {
    var pageLayout = pageVCLayout()
    
    pageLayout.s_width = screenWidth
    pageLayout.s_height = screenHeight
    
    pageLayout.margin_top = 12
    pageLayout.margin_bottom = 4
    pageLayout.margin_left = 20
    pageLayout.margin_right = 20
    
    pageLayout.titleView_height = 18
    pageLayout.titleView_tableView_space = 10
    
    pageLayout.statusView_height = 20
    pageLayout.statusView_tableView_space = 12
    
    return pageLayout
}

/* 阅读View的位置
 
 需要做横竖屏的可以在这里修改阅读View的大小
 
 GetReadViewFrame 会使用与 阅读View的Frame 以及计算分页的范围
 
 */
func GetReadViewFrame() -> CGRect {
    let pageLayout = GetPageVCLayout()
//    let height = pageLayout.s_height-pageLayout.margin_top-pageLayout.margin_bottom-pageLayout.titleView_tableView_space-pageLayout.titleView_height-pageLayout.statusView_tableView_space-pageLayout.statusView_height
//    MQLog("🍌🍌---\(height)")
    return CGRect(x: 0,
                  y: 0,
                  width: pageLayout.s_width-pageLayout.margin_left-pageLayout.margin_right,
                  height: pageLayout.s_height-pageLayout.margin_top-pageLayout.margin_bottom-pageLayout.titleView_tableView_space-pageLayout.titleView_height-pageLayout.statusView_tableView_space-pageLayout.statusView_height-x_StatusBarHeight+20-x_TabbatSafeBottomMargin)
}


