//
//  MQIOpenlikeManger.swift
//  MoQingInternational
//
//  Created by moqing on 2019/5/22.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

struct MQIOpenlikeManger {

    /// 打开链接
    @discardableResult static func openLike(_ data: Any?) -> Bool {

        guard let dataNew = data else {
            return false
        }
        if dataNew is URL {
            return urlLinke(dataNew as! URL)
        }
        if dataNew is String {
            guard let url = URL(string: dataNew as! String) else {
                return false
            }
            return urlLinke(url)
        }

        return true
    }

    /// 打开通知
    static func openNotice(userInfo: [AnyHashable: Any]) {
        var url = ""
        var book_id = ""
        var tab = ""

        if userInfo["book_id"] != nil {
            book_id = userInfo["book_id"] as! String
        }
        if userInfo["url"] != nil {
            url = userInfo["url"] as! String
        }
        if userInfo["tab"] != nil {
            tab = userInfo["tab"] as! String
        }
        let aps = userInfo["aps"] as! NSDictionary
        if let category = aps["category"] {
            todo(key: category as! String, book_id: book_id, url: url, tab: tab)
        }
    }


}



//MARK:   特定链接
extension MQIOpenlikeManger {

    /// 特定链接
    static func todo(key: String, book_id: String? = nil, url: String? = nil, tab: String? = nil, webvc: MQIWebVC? = nil) {
        if key == "open.page.HOME" {
            var index = 1
            if tab == "bookshelf" {
                index = 0
            } else if tab == "store" {
                index = 1
            } else {
                index = 2
            }
            let dict = ["index": index] as [String: NSInteger]
            DownNotifier.postNotification(.clickTabbar, object: nil, userInfo: dict)
            if webvc != nil {
                webvc?.popVC()
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            switch (key) {
            case "open.page.BOOK_DETAIL":
                //书籍详情
                if book_id != "" || book_id != nil {
                    MQIOpenlikeManger.toBookIofo(book_id!)
                }
                break;
            case "open.page.LOTTERY":
                //签到
                toSignVC()
                if webvc != nil {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        webvc?.webView.reload()
                    }
                }
                break;
            case "open.page.READER":
                //阅读页
                if book_id != "" || book_id != nil {
                    MQIOpenlikeManger.toReader(book_id!)
                }
                break;
            case "open.page.ACT":
                if url != "" || url != nil {
                    MQIOpenlikeManger.toWebVC(url!, true)
                }
                break;
            case "open.page.PAY":
                MQIOpenlikeManger.toPayVC(toPayChannel: .normalToPay, nil)
                if webvc != nil {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        webvc?.webView.reload()
                    }
                }
                break;
            default:
                break;
            }


        }
    }

}

extension MQIOpenlikeManger {


    ///拼接字符串
    static func getParsingAtts(_ str: String?, font: UIFont? = nil, defaultTextColor: UIColor = UIColor.black, lineSpacing: CGFloat = 5, textAlignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        return getParsingAtts(parsingString(str), font: font, defaultTextColor: defaultTextColor, lineSpacing: lineSpacing, textAlignment: textAlignment)

    }

    /// 解析字符串
    static func parsingString(_ str: String?, mark_text: String = "<dsy") -> [String] {
        guard let text = str else { return [String]() }
        var text_new = text.replacingOccurrences(of: " ", with: "", options: .literal)
        text_new = text_new.replacingOccurrences(of: "<a:", with: mark_text)
        text_new = text_new.replacingOccurrences(of: "</a>", with: mark_text)
        text_new = text_new.replacingOccurrences(of: "<c:", with: mark_text)
        text_new = text_new.replacingOccurrences(of: "</c>", with: mark_text)
        let text_arr = text_new.components(separatedBy: mark_text).filter({ $0 != "" })
        return text_arr
    }



    ///拼接字符串
    static func getParsingAtts(_ textArr: [String], font: UIFont? = nil, defaultTextColor: UIColor = UIColor.black, lineSpacing: CGFloat = 5, textAlignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let att1 = NSMutableAttributedString()

        for str in textArr {

            if str.contains(">") {

                var isUrl_str: String = ""
                var isColor_str: String = ""
                let str_sub_arr = str.components(separatedBy: ">").filter({ $0 != "" })
                for uStr in str_sub_arr {
                    if uStr.contains("://") { isUrl_str = uStr;break }
                    if uStr.contains("#") && uStr.count > 6 { isColor_str = uStr;break }
                }

                if isUrl_str.count > 0 {
                    let ustr2 = str.replacingOccurrences(of: isUrl_str + ">", with: "")
                    let att_new = NSAttributedString(string: ustr2, attributes: [NSAttributedString.Key.link: isUrl_str.replacingOccurrences(of: " ", with: "", options: .literal), .underlineStyle: NSUnderlineStyle.single.rawValue])
                    att1.append(att_new)

                } else if isColor_str.count > 0 {
                    let ustr2 = str.replacingOccurrences(of: isColor_str + ">", with: "")
                    let att_new = NSAttributedString(string: ustr2, attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(isColor_str)])
                    att1.append(att_new)
                } else {
                    let att_new = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: defaultTextColor])
                    att1.append(att_new)
                }
            } else {
                let att_new = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: defaultTextColor])
                att1.append(att_new)
            }
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        if let font = font {
            att1.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: font], range: NSRange.init(location: 0, length: att1.length))
        } else {
            att1.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange.init(location: 0, length: att1.length))
        }

        return att1

    }


}

//MARK:  跳转方法
extension MQIOpenlikeManger {
    /// 可接收的 scheme 集合
    fileprivate static func schemes() -> [String] { return [TARGET_NAME_EN, "custom"] }
    /// 解析跳转方法
    /// - Parameter url: 符合 mangacatapp://navigator/novel/read/14111 类型
    static func toPath (_ url: URL) {
        if !schemes().contains(url.scheme ?? "") { return }
        let results = editorURL(url: url)
        let testArr = results.0

        if testArr.first == "novel" {
            if testArr.contains("reader") || testArr.contains("read") {
                toReader(testArr.last!)
            } else if testArr.contains("detail") || testArr.contains("book") {
                toBookIofo(testArr.last!)
            }
        } else if testArr.contains("detail") || testArr.contains("book") {
            toBookIofo(testArr.last!)
        } else if testArr.first == "reader" {
            toReader(testArr.last!)
        } else if testArr.first == "lottery" {
            toSignVC()
        } else if testArr.first == "pay" {
            toPayVC(toPayChannel: .normalToPay, nil)
        } else if testArr.first == "discount" {
            toDCVC()
        } else if testArr.first == "actcenter" {
            toEvent()
        } else if testArr.first == "recommend" {
            toRecommendSecondVC(testArr.last!.integerValue())
        }
    }

    /// 详情页
    static func toBookIofo(_ bid: String) -> () {
        MQIUserOperateManager.shared.toBookInfo(bid)
    }
    /// WebVC
    static func toWebVC(_ url: String, _ isAc: Bool = false) -> () {
        MQIUserOperateManager.shared.toWebVC(url, isAc)
    }
    /// 签到
    static func toSignVC() -> () {
        MQIUserOperateManager.shared.toSignVC()
    }
    /// 登录
    static func toLoginVC(_ popBlock: (() -> ())?) -> () {
        MQIUserOperateManager.shared.toLoginVC(popBlock)
    }
    /// 阅读器
    static func toReader(_ bid: String, toIndex: Int? = nil) {
        MQIUserOperateManager.shared.toReader(bid, toIndex: toIndex)
    }
    /// 支付
    static func toPayVC(toPayChannel: PayChannelType = .normalToPay, _ popBlock: ((_ suc: Bool) -> ())?) {
        if !MQIPayTypeManager.shared.isAvailable() {
            // 审核
            MQIUserOperateManager.shared.toPayVC(toPayChannel: toPayChannel, popBlock)
            return
        }

        if MQIUserManager.shared.checkIsLogin() {
            MQIUserOperateManager.shared.toPayVC(toPayChannel: toPayChannel, popBlock)
        } else {
            MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: {
                    MQIUserOperateManager.shared.toPayVC(toPayChannel: toPayChannel, popBlock)
                })
        }
    }

    /// 活动中心
    static func toEvent() {
        MQIUserOperateManager.shared.toEvent()
    }

    /// 打折卡
    static func toDCVC() {
        if MQIUserManager.shared.checkIsLogin() {
            MQIUserOperateManager.shared.toDCVC()
        } else {
            MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: {
                    MQIUserOperateManager.shared.toDCVC()
                })
        }
    }

    static func toRecommendSecondVC(_ type: Int) {
        MQIUserOperateManager.shared.toRecommendSecondVC(type: type)
    }

    static func toCardCounponVC() {
        MQIUserOperateManager.shared.toCardCounponVC()
    }


    /// 打开站外链接
    static func openURL(_ url: URL) {
        UIApplication.shared.openURL(url)
    }

    /// 打开七鱼
    static func toQIYU() {
        QYSDK.shared()?.registerAppId(QYSDK_AppId, appName: kLocalized("app_Name"))
        let userInfo = QYUserInfo()
        userInfo.userId = MQIUserManager.shared.user?.user_id ?? "0"
        userInfo.data = "[{\"key\":\"real_name\", \"value\": \"\(MQIUserManager.shared.user?.user_nick ?? "")\"},{\"index\": 0, \"key\":\"UID\", \"label\": \"用户ID\", \"value\": \"\(MQIUserManager.shared.user?.user_id ?? "")\"},{\"index\": 1, \"key\":\"version\", \"label\": \"应用版本\", \"value\": \"\(getCurrentVersion())\"}]"

        QYSDK.shared()?.setUserInfo(userInfo)
        let source = QYSource()
        source.title = kLocalized("app_Name")
        let sessionViewController = QYSDK.shared()?.sessionViewController()
        sessionViewController?.sessionTitle = kLocalized("app_Name")
        sessionViewController?.source = source
        sessionViewController?.hidesBottomBarWhenPushed = true
        gd_currentNavigationController().pushVC(sessionViewController!)
    }

    static func editorURL(url: URL) -> ([String], [String: String]) {
        var testArr = [String]()
        var dic = [String: String]()
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {

            if let url_new = components.url {
                testArr = url_new.path.components(separatedBy: "/")
                testArr = testArr.filter({ $0 != "" && $0 != " " })
            }

            for item in components.queryItems ?? [URLQueryItem]() {
                if let value = item.value {
                    dic.updateValue(value, forKey: item.name)
                }
            }
        }
        return (testArr, dic)
    }
}

/*
 阅读器：scheme://navigator/reader/14184
 书籍详情：scheme://navigator/book/14184
 福利中心/签到：scheme://navigator/lottery
 充值页面：scheme://navigator/pay
 
 站内的域名下的H5: 示例 - https://hrxsh5cdn.dmw11.com/main/term
 
 浏览器打开域名：http开头的其他网页
 */
//MARK:   url 处理
private extension MQIOpenlikeManger {

    static func urlLinke (_ url: URL) -> Bool {
        if url.scheme == "http" || url.scheme == "https" || url.scheme == TARGET_NAME_EN {
            parsingRules_URL(url)
            return true
        }

        return false
    }

    /// 规则
    static func parsingRules_URL(_ url: URL) -> () {

        if url.scheme == "http" || url.scheme == "https" {
            var url_str = url.absoluteString.replacingOccurrences(of: "http:", with: "MQI:")
            url_str = url_str.replacingOccurrences(of: "https:", with: "MQI:")
            if url.host == "h5cdn" {
                toWebVC(url_str.replacingOccurrences(of: "MQI://h5cdn/", with: BASEHTTPURL_CDN))
            } else if url.host == "h5" {
                toWebVC(url_str.replacingOccurrences(of: "MQI://h5/", with: BASEHTTPURL))
            }
            else {
                openURL(url)
            }
            return
        }

        if url.scheme == TARGET_NAME_EN {
            toPath(url)
            return
        }
    }

}


