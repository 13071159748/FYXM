//
//  MQIIAPManager.swift
//  XSDQReader
//
//  Created by moqing on 2019/1/8.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import StoreKit


/*
 1. 用户发起请求 -> 苹果收款 -> 服务器验证 -> 成功
 2. 用户发起请求 -> 苹果收款(缓存事物) -> 服务器验证（消费事物） -> 成功(删除订单) 失败(缓存订单)
 3. 用户发起请求(未消费事物->恢复购买) -> 苹果收款(缓存事物) -> 服务器验证（消费事物） -> 成功(删除订单) 失败(缓存订单)
 */
let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
let applePayOrder13 = "applePayOrder13.plist"
class MQIIAPManager: NSObject {
    /***********测试使用*************/
    /// 是否保留以前缓存
    var isDebugFirstStart: Bool = false
    /// 是否测试恢复数据
    var isDebugRestore: Bool = false
    /// 是否测试验证数据失败
    var isDebugPayFailure: Bool = false
    /// 是否测试订阅续费提示
    var isDebugSubscribe: Bool {
        return isDebug
    }
    /***********测试使用*************/
    var isClean: Bool = false
    /// 点击后产品id
    var productId: String = ""

    ///恢复数据使用
    var restoreID: String?
    ///当前支付数据  Value 支付事物  key 唯一标识符
    var currentPaymentDic = [String: SKPaymentTransaction]()

    /// 回调
    var callbackBlock: ((_ suc: Bool, _ msg: String) -> ())?
    /// 首充完成回调
    var callbackDataBlock: (() -> ())?

    /// 首充完成弹框回调
    var callbackPromptBlock: ((_ model: MQIComplexResultModel) -> ())?

    /// 当前订单模型
    var currentPayModel: MQIApplePayModelNew?

    var currentItemModel: MQIApplePayItemModel?
    var payModel: MQIApplePayListModel?
    static let shared = MQIIAPManager()
    //    /// 忽略以前恢复交易的时间 2018-08-27 02:00:00
    //    var  dontDeal:Int = 1535306400
    /// 是否第一次启动
    var isFirst = false
    /// 当程序启动是监听到有未完成的订单使用
    var passiveThings = false

    var lock = NSLock()
    override init() {
        super.init()
        passiveThings = true
        addPayObserve()
    }

    deinit {
        removePayObserve()
    }

    /// 添加监听
    func addPayObserve() {
        SKPaymentQueue.default().add(self)
//        tesLocalOrders()
    }

    ///移除监听
    func removePayObserve() {
        passiveThings = false
        SKPaymentQueue.default().remove(self)
    }

    /// 检测本地订单
    func tesLocalOrders() {
        let list = readOrderPaperList()
        var linstNEW = [MQIApplePayModelNew]()
        if list.count > 0 {
            for model in list {
                if model.verifyNumber <= 3 {
                    model.verifyNumber += 1
                    linstNEW.append(model)
                    self.requestVerify2(model.recepit, isSanBox: false, trade_no: model.identifier, product_id: model.product_id, createDateStr: model.createDateStr)
                }

            }
            saveOrderPaperList(list: linstNEW)
        }
    }

    //TODO:  初始化时必须调用
    func clean() {
        if isClean {
            return
        }
        isClean = !isClean
        self.restoreID = nil
        self.callbackBlock = nil
        self.currentPayModel = nil
        self.passiveThings = false
        self.callbackDataBlock = nil
        self.callbackPromptBlock = nil
        isClean = false

    }
    /// 开始支付操作
    func requestProductId(productId: String) {
        self.productId = productId
        self.restoreID = nil
        if SKPaymentQueue.canMakePayments() == true {
            MQIEventManager.shared.appendEventData(eventType: .purchase_start, additional: ["method": "appstore", "sku_id": productId])
            systemRecoveryProcess(productId)
        } else {
            MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
            callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("BannedThePurchaseOfFunctionsLocally"))

        }

    }

    ///交易验证
    func verifyReceipt(_ transaction: SKPaymentTransaction, isfailed: Bool = false, isRestore: Bool = false) {


        if transaction.transactionDate == nil || isfailed {
            /// 取消或者其他操作
            self.callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("PurchaseFailed"))
            self.deleteOrder(order_id: currentPayModel?.order_id ?? "")
            currentPayModel = nil
            return
        }
        let receiptData = getReceiptData()
        if let receiptData = receiptData {
            getCacheOrder().first?.order_status = "100"
            callbackBlock?(false, kLocalized("TheTopUp"))


            mqLog("验证是否充值成功 == \(String(describing: transaction.transactionIdentifier))")


            if let identifier = transaction.transactionIdentifier {

                currentPaymentDic[identifier] = transaction
                if isDebugSubscribe && identifier.contains("vip") {
                    MQILoadManager.shared.makeToast("正在开通vip，或者是在续费开通的路上")
                }


                let productid = transaction.payment.productIdentifier
                /// 向服务器验证订单
                let recepitStr = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)

                MQIEventManager.shared.appendEventData(eventType: .purchased, additional: ["method": "appstore", "sku_id": productid, "transaction_id": identifier, "receipt": recepitStr])

                saveOrderPaper(recepitStr: recepitStr, product_id: productid, identifier: identifier, createDateStr: getDateStr(date: transaction.transactionDate))

                if passiveThings || currentPayModel == nil {

                    ///启动时监听回调
                    self.requestVerify2(recepitStr, isSanBox: isfailed, trade_no: identifier, product_id: productid, createDateStr: getDateStr(date: transaction.transactionDate))
                    return
                }

                if currentPayModel?.order_id == "" { currentPayModel = nil }
                ///验证订单
                self.requestVerify(recepitStr, isSanBox: isfailed, trade_no: identifier, product_id: productid, createDateStr: getDateStr(date: transaction.transactionDate), payModel: currentPayModel) { [weak self] (suc, msg) in
                    self?.callbackBlock?(suc, msg)
                }
                currentPayModel = nil
            } else {
                self.callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("PurchaseFailed"))
                self.deleteOrder(order_id: currentPayModel?.order_id ?? "")
                currentPayModel = nil
            }

        } else {
            self.callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("PurchaseFailed"))
            self.deleteOrder(order_id: currentPayModel?.order_id ?? "")
            currentPayModel = nil
        }
    }

    func finishATransation(transaction: SKPaymentTransaction) {
        // 不能完成一个正在交易的订单.
        if (transaction.transactionState == .purchasing) {
            return;
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

//MARK:  支付操作
extension MQIIAPManager {
    /// 向服务器验证充值结果
    func requestVerify(_ recepitStr: String, isSanBox: Bool, trade_no: String, product_id: String, createDateStr: String, payModel: MQIApplePayModelNew?, completion: @escaping ((_ suc: Bool, _ msg: String) -> ())) {

        /// 更新订单
        if let model = payModel {
            model.product_id = product_id
            model.identifier = trade_no
            model.createDateStr = createDateStr
            model.recepit = recepitStr
            model.order_status = "100"
            model.order_status_desc = "等待服务器验证"
            updateCacheOrderState(model)
        }

        mqLog("===\(trade_no)")
        if isDebugRestore {
            completion(false, "DSYCALLBACK_1充值失败== 恢复数据状态不可验证数据Debug")
            return
        }
        if isDebugPayFailure {
            completion(false, "DSYCALLBACK_1充值失败== Debug")
            return
        }

        var order_id: String?

        if let payModel = payModel, payModel.product_id == product_id {
            order_id = payModel.order_id
        } else { order_id = nil }

        GYAppleVerifyRequestNew(receipt: recepitStr, isSanBox: isSanBox, trade_no: trade_no, version: getCurrentVersion(), product_id: product_id, order_id: order_id)

            .request({ [weak self] (request, response, result: MQIComplexResultModel) in

                if let strongSelf = self {
                    /// 移除内购
                    if let cTransaction = strongSelf.currentPaymentDic[trade_no] {
                        strongSelf.finishATransation(transaction: cTransaction)
                        strongSelf.currentPaymentDic.removeValue(forKey: trade_no)
                    }
                    UserNotifier.postNotification(.refresh_coin)
                    mqLog(" end ----  success")
                    if let order_id_old = payModel?.order_id {
                        self?.deleteOrder(order_id: order_id_old, identifier: trade_no)
                    }

                    if product_id == productHeader + "1" && !strongSelf.getFirstList() { /// 是否是首充  // 本账号第一次充值优惠
                        strongSelf.getFirstList(isSave: true)
                        strongSelf.callbackDataBlock?()
                    }
                    MQIEventManager.shared.appendEventData(eventType: .purchase_complete, additional: ["method": "appstore", "sku_id": product_id])

                    if product_id.contains("coin.cqsc.") {
                        let purchased = product_id.replacingCharacters(pattern: " coin.cqsc.", template: "").doubleValue()
                        MQIEventManager.shared.ePurchased(purchased)
                    }
//
                    self?.deleteOrderPaper(recepitStr: recepitStr)

                    strongSelf.deleteLoadSuccOrder(identifier: trade_no, dBlock: {
                        MQILoadManager.shared.dismissProgressHUD()
                        completion(true, kLocalized("TopUpSuccess"))
                        self?.callbackPromptBlock?(result)
                    })
                    if self?.isDebugSubscribe == true && product_id.contains("vip") {
                        MQILoadManager.shared.makeToast("开通vip成功了。。。", duration: 3)
                    }

                }
            }, failureHandler: { [weak self] (err_msg, err_code) in
                    mqLog("end ---- error \(err_msg)")
                    if self?.isDebugSubscribe == true && product_id.contains("vip") {
                        MQILoadManager.shared.makeToast("vip续费出现问题err_code\(err_code)===err_msg\(err_msg)", duration: 10)
                    }
                    if let strongSelf = self {
                        if err_code == "9016" {
                            /// 此时的订单是w服务器验证过的，但是本地还存在的情况
                            /// 移除内购
                            if let cTransaction = strongSelf.currentPaymentDic[trade_no] {
                                strongSelf.finishATransation(transaction: cTransaction)
                                strongSelf.currentPaymentDic.removeValue(forKey: trade_no)
                            }
                            strongSelf.deleteOrderPaper(recepitStr: recepitStr)
                            strongSelf.deleteLoadSuccOrder(identifier: trade_no, dBlock: {

                            })

                        } else {
                            MQIEventManager.shared.appendEventData(eventType: .purchase_fail, additional: ["method": "appstore", "sku_id": product_id, "error_code": "\(err_code)"])
                            if let model = payModel {
                                model.order_status = "服务器验证失败"
                                self?.saveOrder(model: model)
                            }

                            if !strongSelf.getFirstList() && product_id == productHeader + "1" { /// 是否是首充  // 本账号第一次充值优惠
                                strongSelf.getFirstList(isSave: true)
                                strongSelf.callbackDataBlock?()
                            }
                        }
                        MQILoadManager.shared.dismissProgressHUD()
                        completion(false, "DSYCALLBACK_1" + err_msg)
                    }
                })

    }

    /// 向服务器验证充值结果
    func requestVerify2(_ recepitStr: String, isSanBox: Bool, trade_no: String, product_id: String, createDateStr: String) {

        GYAppleVerifyRequestNew(receipt: recepitStr, isSanBox: isSanBox, trade_no: trade_no, version: getCurrentVersion(), product_id: product_id, order_id: nil)
            .request({ [weak self] (request, response, result: MQIComplexResultModel) in
                if let strongSelf = self {
                    UserNotifier.postNotification(.refresh_coin)
                    if let cTransaction = strongSelf.currentPaymentDic[trade_no] {
                        strongSelf.finishATransation(transaction: cTransaction)
                        strongSelf.currentPaymentDic.removeValue(forKey: trade_no)
                    }
                    mqLog(" end ----  success")
                    MQIEventManager.shared.appendEventData(eventType: .purchase_complete, additional: ["method": "appstore", "sku_id": product_id])
                    if product_id.contains("coin.cqsc.") {
                        let purchased = product_id.replacingCharacters(pattern: " coin.cqsc.", template: "").doubleValue()
                        MQIEventManager.shared.ePurchased(purchased)
                    }
                    //
                    self?.deleteOrderPaper(recepitStr: recepitStr)
                    if self?.isDebugSubscribe == true && product_id.contains("vip") {
                        MQILoadManager.shared.makeToast("续费开通vip成功。。。", duration: 3)
                    }
                    MQILoadManager.shared.dismissProgressHUD()
                }
            }, failureHandler: { [weak self] (err_msg, err_code) in
                    mqLog("end ---- error \(err_msg)")
                    if self?.isDebugSubscribe == true && product_id.contains("vip") {
                        MQILoadManager.shared.makeToast("vip续费出现问题err_code\(err_code)===err_msg\(err_msg)", duration: 10)
                    }
                    if let strongSelf = self {
                        if err_code == "9016" {
                            /// 此时的订单是服务器验证过的，但是本地还存在的情况
                            /// 移除内购
                            if let cTransaction = strongSelf.currentPaymentDic[trade_no] {
                                strongSelf.finishATransation(transaction: cTransaction)
                                strongSelf.currentPaymentDic.removeValue(forKey: trade_no)
                            }
                            strongSelf.deleteOrderPaper(recepitStr: recepitStr)

                        } else {
                            MQIEventManager.shared.appendEventData(eventType: .purchase_fail, additional: ["method": "appstore", "sku_id": product_id, "error_code": "\(err_code)"])
                        }
                        MQILoadManager.shared.dismissProgressHUD()
                    }
                })

    }

    /// 根据商品id创建支付请求
    func startPaymentWithProductId(productId: String) -> Void {
        if productId == "" {
            mqLog("productId 为空")
            MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
            callbackBlock?(false, "DSYCALLBACK_1 productId 为空")
            self.currentPayModel = nil
            return
        }
        let productID: NSSet = NSSet(object: productId)
        let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

    /// 填写付款信息
    func buyProduct(_ product: SKProduct) {
        mqLog("向苹果发送付款请求");
        let payment = SKMutablePayment(product: product)
        payment.applicationUsername = MQIUserManager.shared.user?.user_id ?? "00"
        SKPaymentQueue.default().add(payment);
    }

    //// 获取凭证
    @discardableResult func getReceiptData() -> Data? {
        let receiptURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptURL!)
        return receiptData
    }

    /// 获取到商品信息
    func verifyApple(_ encoderData: Data) {
        let recepitStr = encoderData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        let url = URL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        let playoad = "{\"receipt-data\" : \"\(recepitStr)\"}"
        let palyoadData = (playoad as NSString).data(using: String.Encoding.utf8.rawValue)
        request.httpBody = palyoadData
        let result = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)

        if result == nil {
            mqLog("failed")
        }
        let dict = try? JSONSerialization.jsonObject(with: result!, options: JSONSerialization.ReadingOptions.allowFragments)
        mqLog("dict = \(String(describing: dict))")
        if dict != nil {
            mqLog("success")
            callbackBlock?(true, kLocalized("BuySuccess"))
        }
    }

}
//MARK:  操作方法
extension MQIIAPManager {

    /// 是否启动恢复
    func needToRecover() -> (Bool, [SKPaymentTransaction]) {
        let tansactions = SKPaymentQueue.default().transactions

        var result = true
        if isDebugFirstStart {
            result = false
        }

        if getReceiptData() == nil {
            return (result, [SKPaymentTransaction]())
        } else {
            return (result, tansactions)
        }

    }

    ///字符串转时间
    func strTodate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str)!
    }


    func getDateStr(date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date ?? Date())
    }
/*
    //开始交易
    func startTransaction() -> Void {
        let result = needToRecover()
        var results: Bool = false
        if (result.0) {
            let transactions = result.1
            if transactions.count > 0 {
                for tan in transactions {
                    let dentifier = tan.payment.productIdentifier
                    if dentifier != "" && dentifier == productId && tan.transactionDate != nil {
                        restoreID = dentifier
                        results = true
                        break
                    } else {
                        results = false
                        continue
                    }
                }
            } else {
                results = false
            }
        } else {
            results = false
        }

        if results {
            MQILoadManager.shared.dismissProgressHUD()
            showAlerView(message: kLocalized("beenPaidSuccessfully"), okTitle: kLongLocalized("ClickToGetTheMagicCoin", replace: COINNAME), isCancelction: false) { (cancel) in
                SKPaymentQueue.default().restoreCompletedTransactions()
                MQILoadManager.shared.addProgressHUD("")
            }

        } else {
            callbackBlock?(false, "")
            startPaymentWithProductId(productId: productId)

        }
    }
*/

    /// 展示一个一个AlerView
    func showAlerView(message: String, okTitle: String = kLocalized("retry"), isCancelction: Bool = true, block: @escaping ((_ isCancel: Bool) -> ())) -> Void {
        let alertController = UIAlertController(title: kLocalized("PayWarning"),
            message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: kLocalized("Cancel"), style: .cancel, handler: {
                action in
                block(true)
            })

        let okAction = UIAlertAction(title: okTitle, style: .default,
            handler: { action in
                block(false)
            })
        if isCancelction {
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        let currentVC = gd_currentViewController()
        currentVC.present(alertController, animated: true, completion: nil)
    }



    //获取首次充值优惠列表
    @discardableResult func getFirstList(isSave: Bool = false) -> Bool {
        if let u = MQIUserManager.shared.user {
            var list = saveFirstList()
            let r = [u.user_id: true]
            if list.contains(r) {
                return true
            }
            if isSave {
                list.append(r)
                saveFirstList(list)
            }
            list.removeAll()
            return false
        } else {
            return false
        }
    }

    //储存首次充值优惠列表
    @discardableResult func saveFirstList(_ list: [[String: Bool]]? = nil) -> [[String: Bool]] {

        let userD = UserDefaults.standard
        var result: [[String: Bool]] = [[String: Bool]]()
        if list == nil { /// 取数据
            if let r = userD.value(forKey: "MQISaveFirstList") as? [[String: Bool]] {
                result = r
            } else {
                result = [[String: Bool]]()
            }
        } else {
            userD.setValue(list, forKey: "MQISaveFirstList")
            userD.synchronize()
            result = [[String: Bool]]()
        }
        return result
    }

    /// 删除订单信息
    func deleteLoadSuccOrder(identifier: String, dBlock: (() -> ())? = nil) {
        //        let list = MQIFileManager.readApplePayListNew()
        //        var saveList = [MQIApplePayModelNew]()
        //        saveList = list.filter({$0.identifier != identifier})
        //        MQIFileManager.saveApplePayListNew(list: saveList)
        dBlock?()
    }


    /// 获取未验证订单
    func getReloadOrder() -> [MQIApplePayModelNew] {
        let list = MQIFileManager.readApplePayListNew()
        var temp = [MQIApplePayModelNew]()
        for i in 0..<list.count {
            if MQIUserManager.shared.checkIsLogin() {
                temp.append(list[i])
            }
        }
        return temp
    }

    /// 获取恢复订单
    func getRestoreOrder() -> [MQIApplePayModelNew] {
        let result = needToRecover()
        if !result.0 {
            return [MQIApplePayModelNew]()
        }
        var temp = [MQIApplePayModelNew]()
        for tan in result.1 {
            if tan.transactionDate != nil {
                let model = MQIApplePayModelNew.init(jsonDict: ["userId": MQIUserManager.shared.user?.user_id ?? "", "product_id": tan.payment.productIdentifier, "identifier": tan.transactionIdentifier ?? "", "createDateStr": getDateStr(date: tan.transactionDate)])
                temp.append(model)
            }
        }

        return temp
    }


}
/// 新票据处理
extension MQIIAPManager {

    /// 缓存票据
    func saveOrderPaper(recepitStr: String, product_id: String, identifier: String, createDateStr: String) {

        if contrastOrderPaper(p1: recepitStr) == false {
            var list = readOrderPaperList()
            let model = MQIApplePayModelNew()
            model.recepit = recepitStr
            model.userId = MQIUserManager.shared.user?.user_id ?? "-1"
            model.product_id = product_id
            model.identifier = identifier
            model.createDateStr = createDateStr
            list.insert(model, at: 0)
            /// 数据不可超过20条
            if list.count > 20 { list.removeLast() }
            saveOrderPaperList(list: list)
        }
    }

    ///删除票据
    func deleteOrderPaper(recepitStr: String) {
        var list = readOrderPaperList()
        list = list.filter({ $0.recepit != recepitStr })
        saveOrderPaperList(list: list)
    }

    /// 对比
    func contrastOrderPaper(p1: String) -> Bool {
        return (readOrderPaperList().filter({ $0.recepit == p1 }).first != nil)
    }

    ///读取未验证的支付列表
    func readOrderPaperList() -> [MQIApplePayModelNew] {
        let infoPath = MQIFileManager.getCurrentStoreagePath("applePayOrder24.plist")
        if FileManager.default.fileExists(atPath: infoPath) {
            if let bookPathsInfo = NSKeyedUnarchiver.unarchiveObject(withFile: infoPath) as? [MQIApplePayModelNew] {
                return bookPathsInfo
            } else {
                return [MQIApplePayModelNew]()
            }
        } else {
            return [MQIApplePayModelNew]()
        }
    }

    //储存支付列表
    func saveOrderPaperList(list: [MQIApplePayModelNew]) {
        NSKeyedArchiver.archiveRootObject(list, toFile: MQIFileManager.getCurrentStoreagePath("applePayOrder24.plist"))
    }
}
//MARK:  代理监听
extension MQIIAPManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {

    //MARK: SKProductsRequestDelegate
    /// 购买状态更新
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        //        let products = response.invalidProductIdentifiers
        if products.count <= 0 {
            MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
            callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("UnableToObtainProductInformation"))
        } else {
            let validProduct: SKProduct = response.products[0] as SKProduct
            self.buyProduct(validProduct);
        }
    }
    /// 商品信息请求失败
    func request(_ request: SKRequest, didFailWithError error: Error) {
        MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
        callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("UnableToObtainProductInformation"))
    }

    //MARK: SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

        guard MQIUserManager.shared.checkIsLogin() else { callbackBlock?(false, "DSYCALLBACK_1未登录"); MQILoadManager.shared.dismissProgressHUD();return }

        for trans in transactions {
            let transaction = trans
//            finishATransation(transaction:transaction)
//            continue
//
            switch transaction.transactionState {
            case .purchasing:
                mqLog("in-purchase - purchasing 事务正在添加到服务器队列中")

                if isDebugFirstStart {
                    MQILoadManager.shared.dismissProgressHUD()
                }

            case .deferred:
                mqLog("in-purchase - deferred  事务在队列中，但其最终状态是等待外部操作。")

            case .purchased: /// 验证结果
                mqLog("in-purchase - finished  交易在队列中，用户已被收费。客户应完成交易")
                if isDebugRestore {
                    MQILoadManager.shared.dismissProgressHUD()
                    callbackBlock?(false, "DSYCALLBACK_1数据进入恢复状态== Debug")
                    break
                }

                if isDebugSubscribe == true && transaction.payment.productIdentifier.contains("vip") {
                    MQILoadManager.shared.makeToast("检测到将要续费订阅", duration: 1.5)
                }

                verifyReceipt(trans)
            case .restored: /// 验证结果
                mqLog("restored  事务从用户的购买历史中恢复。客户应完成交易")
                if isDebugSubscribe == true && transaction.payment.productIdentifier.contains("vip") {
                    MQILoadManager.shared.makeToast("检测到将要续费订阅", duration: 1.5)
                }
                verifyReceipt(trans, isRestore: true)
//                if let User  = MQIUserManager.shared.user {
//                    let  orderUserId = transaction.payment.applicationUsername
//                    if let  original = transaction.original {
//                        /// 在第一次支付 或者回复时是当前用户时恢复订单
//                        mqLog("连续订阅\(original)")
//                        if orderUserId != nil  {
//                            if orderUserId == User.user_id{
//                                verifyReceipt(trans, isRestore:true)
//                            }else{ /// 不做处理
//                                callbackBlock?(false, "DSYCALLBACK_1续费订阅异常")
//                            }
//                        }else{
//                            verifyReceipt(trans, isRestore:true)
//                        }
//                    }else{
//                        mqLog("普通支付以及连续订阅 ")
//                      verifyReceipt(trans, isRestore:true)
//                    }
//
//                }else{
//                    callbackBlock?(false, "DSYCALLBACK_1没有登录")
//
//                }

            case .failed:
                MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
                mqLog("failed   事务在添加到服务器队列之前被取消或失败。")

                callbackBlock?(false, "DSYCALLBACK_1支付失败")
                finishATransation(transaction: transaction)

            }
        }


    }

    ///恢复购买回调
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        mqLog("1")
        guard MQIUserManager.shared.checkIsLogin() else { callbackBlock?(false, "DSYCALLBACK_1未登录"); MQILoadManager.shared.dismissProgressHUD();return }
        let transactions = queue.transactions
        for trans in transactions {
            let transaction = trans

//         finishATransation(transaction:transaction)
//            continue
            mqLog("\(String(describing: transaction.transactionIdentifier))==\(transaction.payment.productIdentifier)")

            switch transaction.transactionState {
            case .purchasing:
                mqLog("in-purchase - purchasing 事务正在添加到服务器队列中")
            case .deferred:
                mqLog("in-purchase - deferred  事务在队列中，但其最终状态是等待外部操作。")
            case .purchased:
                mqLog("in-purchase - finished  交易在队列中，用户已被收费。客户应完成交易")
                if isDebugSubscribe == true && transaction.payment.productIdentifier.contains("vip") {
                    MQILoadManager.shared.makeToast("检测到将要续费订阅", duration: 1.5)
                }
                verifyReceipt(trans)
                restoreID = nil

            case .restored:
                mqLog("restored  事务从用户的购买历史中恢复。客户应完成交易")
                if isDebugSubscribe == true && transaction.payment.productIdentifier.contains("vip") {
                    MQILoadManager.shared.makeToast("检测到将要续费订阅", duration: 1.5)
                }
                verifyReceipt(trans, isRestore: true)
                restoreID = nil
            case .failed:
                MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
                mqLog("failed   事务在添加到服务器队列之前被取消或失败")
                callbackBlock?(false, "DSYCALLBACK_1支付失败")
                finishATransation(transaction: transaction)

            }

        }

    }
    /// //恢复购买失败
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        mqLog("2")
        MQIEventManager.shared.appendEventData(eventType: .purchase_cancel, additional: ["method": "appstore", "sku_id": productId])
        callbackBlock?(false, "DSYCALLBACK_1" + kLocalized("ThePurchaseFailed"))
    }


}
/*
 
 2.正常支付
 2.1 创建订单（缓存订单）
 2.2 发起支付
 2.3 成功 删除缓存订单（finish内购）
 2.4 失败
 
 3.恢复订单
 3.1 查看后台恢复订单
 3.2 查看恢复项（本地，系统）
 3.3 对比
 3.3.1 服务器有订单 本地有订单 一致  恢复
 3.3.2 服务器有订单  本地没有订单没有恢复项目   提示恢复
 3.3.3 服务器没有订单 本地有订单  重新创建订单 恢复
 3.3.4 服务器没有订单 本地没有订单  正常支付
 
 */
let reviewNotCreateOrderSet: Set<String> = ["cqsc.card.discount_5"/*打折卡*/]
extension MQIIAPManager {


    /// 进入支付页面 检查订单
    func checkRestoreOrder2(callback: (() -> ())?) {
        /// 检查恢复订单流程
        query_order { (modelOld) in
            callback?()
            /// 获取本地缓存的订单
            guard let modelNew = modelOld else {
                return
            }
            MQILoadManager.shared.dismissProgressHUD()
            if modelNew.order_id.count < 2 || modelNew.product_id.count < 2 {
                return
            }
            self.currentPayModel = modelNew
            self.showOrderView(modelNew, callback: { (m) in
                self.deleteOrder(order_id: modelNew.order_id)
                if m != nil {
                    /// 继续支付
                    MQILoadManager.shared.addProgressHUD("")
                    self.systemRecoveryProcess(modelNew.product_id)
                } else {
                    MQILoadManager.shared.addProgressHUD("")
                    self.cancel_order(order_id: modelNew.order_id, callback: { (msg) in
                        MQILoadManager.shared.dismissProgressHUD()
                        self.callbackBlock?(false, "DSYCALLBACK_1 订单已取消")
                    })
                }
            })
        }
    }


    /// 检查订单
    func checkRestoreOrder(_ product_id: String) {
        /// 检查恢复订单流程
        query_order { (modelOld) in
            /// 获取本地缓存的订单
            var cacheOrderList = self.getCacheOrder()
            guard let modelNew = modelOld else {
                self.systemRecoveryProcess(product_id)
                return
            }

            ///本地缓存
            if let cacheModel = cacheOrderList.first {
                /// 本地缓存与服务器一致
                if cacheModel.order_id == modelNew.order_id { /// 100
                    /// 内购已完成 等待服务器验证
                    if cacheModel.order_status == "100" {
                        self.currentPayModel = nil
                        MQILoadManager.shared.dismissProgressHUD()
                        self.showOrderView(cacheModel, callback: { (m) in
                            if m != nil {
                                /// 继续支付
                                MQILoadManager.shared.addProgressHUD("")
                                ///验证订单
                                self.requestVerify(cacheModel.recepit, isSanBox: false, trade_no: cacheModel.identifier, product_id: cacheModel.product_id, createDateStr: cacheModel.createDateStr, payModel: cacheModel, completion: { (suc, msg) in
                                    self.callbackBlock?(suc, msg)
                                })
                            }
                        })
                    } else {
                        self.deleteOrder(order_id: cacheModel.order_id)
                        self.currentPayModel = modelNew
                        MQILoadManager.shared.dismissProgressHUD()
                        self.showOrderView(modelNew, callback: { (m) in

                            if m != nil {
                                /// 继续支付
                                MQILoadManager.shared.addProgressHUD("")
                                self.startPaymentWithProductId(productId: modelNew.product_id)
                            } else {
                                /// 取消恢复
                                MQILoadManager.shared.addProgressHUD("")
                                self.cancel_order(order_id: modelNew.order_id, callback: { (msg) in
                                    MQILoadManager.shared.dismissProgressHUD()
                                    self.deleteOrder(order_id: modelNew.order_id)
                                    self.callbackBlock?(false, "DSYCALLBACK_1 订单已取消")
                                })
                            }
                        })
                    }
                } else {
                    cacheOrderList.removeFirst()
                    self.saveApplePayOrderList(list: cacheOrderList)
                    /// 没有支付的订单 删除本地数据以服务器为准 （开始新支付的是会缓存新的订单）
                    self.deleteOrder(order_id: modelNew.order_id)
                    self.systemRecoveryProcess(product_id)
                }
            } else {
                ///本地没有支付的订单 删除本地数据以服务器为准 （开始新支付的是会缓存新的订单）
                self.currentPayModel = modelNew
                self.deleteOrder(order_id: modelNew.order_id)
                self.systemRecoveryProcess(product_id, model: modelNew)
            }

        }

    }


    /// 正常充值流程
    func usualStartTrading(_ product_id: String) {
        self.currentPayModel = nil
        create_order(product_id: product_id) { (modelOld) in
            guard let model = modelOld else {
                return
            }
            /// 缓存订单
            self.currentPayModel = model
            self.saveOrder(model: model)
            /// 开始支付
            self.startPaymentWithProductId(productId: model.product_id)

        }

    }

    /// 系统恢复流程
    func systemRecoveryProcess(_ product_id: String, model: MQIApplePayModelNew? = nil) {
        /// 获取恢复订单
//        let result = self.needToRecover()
//        var p_id:String?
//        if (result.0) { /// 可以恢复
//            let transactions = result.1
//            if transactions.count > 0 { /// 有本地恢复订单
//                p_id = transactions.first?.payment.productIdentifier
//            }
//        }
//        self.restoreID  = p_id
        if model != nil { currentPayModel = model }
        /// 是否有系统恢复的订单
        if self.restoreID != nil { /// 这是恢复订单
            if model != nil {
                /// 订单号与恢复账号不相同
                if model?.product_id != self.restoreID! {

                    if model!.order_id == "" {
                        /// 没有单号  单纯的恢复
                        self.create_order(product_id: product_id) { (modelOld) in
                            guard let model = modelOld else {
                                return
                            }
                            /// 缓存订单
                            self.currentPayModel = model
                            self.saveOrder(model: model)
                            /// 开始恢复
                            self.restoreCompletedTransactions()
                        }
                    } else {
                        /// 取消服务器订单
                        self.cancel_order(order_id: model!.order_id, callback: { (msg) in
                            MQILoadManager.shared.dismissProgressHUD()
                            self.deleteOrder(order_id: model!.order_id)
                            /// 系统没有订单
                            self.create_order(product_id: product_id) { (modelOld) in
                                guard let model = modelOld else {
                                    return
                                }
                                /// 缓存订单
                                self.currentPayModel = model
                                self.saveOrder(model: model)
                                /// 开始恢复
                                self.restoreCompletedTransactions()
                            }
                        })
                    }

                } else {
                    self.currentPayModel = model
                    self.saveOrder(model: model!)
                    self.restoreCompletedTransactions()
                }

            } else {
                /// 系统没有订单 弹框提示这是恢复订单
                MQILoadManager.shared.dismissProgressHUD()
                showAlerView(message: kLocalized("beenPaidSuccessfully"), okTitle: kLongLocalized("ClickToGetTheMagicCoin", replace: COINNAME), isCancelction: false) { (cancel) in
                    /// 系统没有订单
                    self.create_order(product_id: product_id) { (modelOld) in
                        guard let model = modelOld else {
                            return
                        }
                        /// 缓存订单
                        self.currentPayModel = model
                        self.saveOrder(model: model)
                        /// 开始恢复
                        self.restoreCompletedTransactions()
                    }
                    MQILoadManager.shared.addProgressHUD("")
                }
            }

        }
        else {
            if model != nil {
                MQILoadManager.shared.dismissProgressHUD()
                self.showOrderView(model!, callback: { (m) in
                    if m != nil {
                        /// 继续支付
                        MQILoadManager.shared.addProgressHUD("")
                        self.startPaymentWithProductId(productId: model!.product_id)
                    } else {
                        /// 取消服务器订单
                        MQILoadManager.shared.addProgressHUD("")
                        self.cancel_order(order_id: model!.order_id, callback: { (msg) in
                            MQILoadManager.shared.dismissProgressHUD()
                            self.deleteOrder(order_id: model!.order_id)
                            self.callbackBlock?(false, "DSYCALLBACK_1 订单已取消")
                        })
                    }
                })
            } else {
                self.usualStartTrading(product_id)
            }
        }
    }

    /// 开始恢复
    func restoreCompletedTransactions() {
        self.callbackBlock?(false, "订单正在恢复")

        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    /// 开始恢复
    func startCompletedTransactions() {
        if needToRecover().1.count > 0 {
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            mqLog("没有可恢复项目")
        }
        tesLocalOrders()
    }
    //TODO: 触发服务器订单不发验证
    func startReissue() {
//        MQIcharge_apple_reissuet().request({ (_, _, _) in
//
//        }) { (msg, code) in
//            mqLog("\(msg) --- \(code)")
//        }
    }

    ///是否有未完成的订单
    func isTransactioning() -> Bool {
        if needToRecover().1.count > 0 { return true }
        return readOrderPaperList().count > 0
    }


    /// 创建订单
    func create_order(product_id: String, callback: ((_ model: MQIApplePayModelNew?) -> ())?) {
        ///部分指定产品审核期间不创建订单
        if payModel?.is_review == "1" && reviewNotCreateOrderSet.contains(currentPayModel?.product_id ?? "") {
            let m = MQIApplePayModelNew()
            m.product_id = currentPayModel?.product_id ?? ""
            callback?(m)
            return
        }
        MQICreateOrderRequest(product_id: product_id, order_type: nil)
            .request({ (request, response, result: MQIApplePayModelNew)in
                callback?(result)
            }) { (err_msg, err_code) in
                self.callbackBlock?(false, "DSYCALLBACK_1" + err_msg)
                callback?(nil)
        }
    }

    /// 取消订单
    func cancel_order(order_id: String, callback: ((_ msg: String) -> ())?) {

        MQIOrderCancelRequest(order_id: order_id)
            .request({ (request, response, result: MQIApplePayModelNew)in
                callback?(result.message)
            }) { (err_msg, err_code) in
                callback?(err_msg)
        }
    }

    /// 查询目前正在进行的订单
    func query_order(callback: ((_ model: MQIApplePayModelNew?) -> ())?) {
        MQILatestQueryRequest().request({ (request, response, result: MQIApplePayModelNew)in
            if result.order_id == "" {
                callback?(nil)
            } else {
                if (result.expiry_time.integerValue() - getCurrentStamp()) < 20 {
                    callback?(nil)
                } else {
                    callback?(result)
                }

            }

        }) { (err_msg, err_code) in
            callback?(nil)
        }

    }


    func showOrderView(_ model: MQIApplePayModelNew?, callback: ((_ model: MQIApplePayModelNew?) -> ())?) {
        let keyWindow = UIApplication.shared.keyWindow!
        var orderView: MQIPaymentDetailsView?
        if let bView = keyWindow.viewWithTag(100201433) {
            orderView = bView as? MQIPaymentDetailsView
            orderView?.frame = UIScreen.main.bounds
        } else {
            orderView = MQIPaymentDetailsView(frame: UIScreen.main.bounds)
            keyWindow.addSubview(orderView!)
            orderView?.tag = 100201433
        }

        orderView?.payModel = (model, currentItemModel)
        orderView?.touchBGView = {
            callback?(nil)
            orderView?.removeFromSuperview()
        }
        orderView?.touchCancel = {
            callback?(nil)
            orderView?.removeFromSuperview()
        }
        orderView?.touchOK = {
            callback?(orderView?.payModel.0)
            orderView?.removeFromSuperview()
        }
    }



    //保存订单信息
    func saveOrder(model: MQIApplePayModelNew, dBlock: (() -> ())? = nil) {
        var list = MQIFileManager.readApplePayListNew()
        if list.map({ $0.order_id }).contains(model.order_id) == false {
            list.insert(model, at: 0)
        }

        list.first?.userId = MQIUserManager.shared.user?.user_id ?? "-1"
        saveApplePayOrderList(list: list)
        dBlock?()
    }

    /// 删除订单信息
    func deleteOrder(order_id: String, identifier: String = "", dBlock: (() -> ())? = nil) {
        let list = readApplePayOrderList()
        var saveList = [MQIApplePayModelNew]()
        if order_id == "" && identifier != "" {
            saveList = list.filter({ $0.identifier != identifier })
        } else {
            saveList = list.filter({ $0.order_id != order_id })
        }


        saveApplePayOrderList(list: saveList)
        dBlock?()
    }
    /// 获取已支付未验证的订单
    func getCacheVerifyOrder() -> [MQIApplePayModelNew] {
        let list = readApplePayOrderList()
        var temp = [MQIApplePayModelNew]()
        for i in 0..<list.count {
            if list[i].order_status == "100" {
                temp.append(list[i])
            }
        }
        saveApplePayOrderList(list: temp)
        return temp
    }

    /// 获取缓存的订单
    func getCacheOrder() -> [MQIApplePayModelNew] {
        let list = readApplePayOrderList()
        var temp = [MQIApplePayModelNew]()
        let uid = MQIUserManager.shared.user?.user_id
        for i in 0..<list.count {
            if list[i].userId == uid {
                temp.append(list[i])
            }
        }
        return temp
    }


    /// 更新状态
    @discardableResult func updateCacheOrderState(_ model: MQIApplePayModelNew) -> Bool {

        lock.lock();defer { self.lock.unlock() }
        let cacheOrders = getCacheOrder()
        if let fM = cacheOrders.first {
            fM.order_status = model.order_status
            fM.product_id = model.product_id
            fM.identifier = model.identifier
            fM.createDateStr = model.createDateStr
            fM.recepit = model.recepit
            fM.order_status_desc = model.order_status_desc
        }
        saveApplePayOrderList(list: cacheOrders)
        return true
    }

    //读取支付列表
    func readApplePayOrderList() -> [MQIApplePayModelNew] {
        let infoPath = MQIFileManager.getCurrentStoreagePath(applePayOrder13)
        if FileManager.default.fileExists(atPath: infoPath) {
            if let bookPathsInfo = NSKeyedUnarchiver.unarchiveObject(withFile: infoPath) as? [MQIApplePayModelNew] {
                return bookPathsInfo
            } else {
                return [MQIApplePayModelNew]()
            }
        } else {
            return [MQIApplePayModelNew]()
        }
    }

    //储存支付列表
    func saveApplePayOrderList(list: [MQIApplePayModelNew]) {
        var listNew = list
        while listNew.count > 10 { ///本地缓存未支付的订单为10
            listNew.removeFirst()
        }
        NSKeyedArchiver.archiveRootObject(listNew, toFile: MQIFileManager.getCurrentStoreagePath(applePayOrder13))

    }
}
