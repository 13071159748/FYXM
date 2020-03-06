//
//  MQIAliPayCallBackManger.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

//MARK: - 结果返回的回调
typealias aliZFCallBack = (_ resultDic:[AnyHashable: Any]?)->()
//MARK: - 微信支行 返回的结构体 回调用
//typealias WXApiPayCallBack = (_ resultResp : PayResp?) ->()
//MARK: - QQWallet callBack
//typealias QQPayCallBack = (message: QWMessage, error:NSError)-> ()

class MQIAliPayCallBackManger: NSObject {

    fileprivate static var __once: () = {
        Inner.instance = MQIAliPayCallBackManger()
    }()
    var callBack        : aliZFCallBack!
//    var wxCallBack      : WXApiPayCallBack!
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIAliPayCallBackManger?
    }
    
    class var shared: MQIAliPayCallBackManger {
        _ = MQIAliPayCallBackManger.__once
        return Inner.instance!
    }
    // MARK 获取微信支付errorMsg
    func getWXPayErrorMsg (_ errCode : NSInteger) -> String!
    {
        var errMsg : String!
        
        switch(errCode) {
        case -1:
            errMsg = kLocalized("NormalErrorType")
        case -2 :
            errMsg = kLocalized("TheUserClicksCancelAndReturns")
        case -3 :
            errMsg = kLocalized("SendFailure")
        case -4 :
            errMsg = kLocalized("AuthorizationFailure")
        case -5 :
            errMsg = kLocalized("WeChatIsNotSupported")
        default:
            print("")
        }
        return errMsg
    }
    func getAliPayCallBackMsg(_ errcode:NSInteger) ->String! {
        
        var errMsg:String!
        switch errcode {
        case 9000:
            errMsg = kLocalized("PayForSuccess")
        case 8000:
            errMsg =  kLocalized("CheckTheBalanceLater")//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
        case 4000:
            errMsg = kLocalized("PayForFailure")
        case 5000:
            errMsg = kLocalized("RepeaTheRequest")//重复请求
        case 6001:
            errMsg = kLocalized("CanceledPayment")//用户中途取消
        case 6002:
            errMsg = kLocalized("NetworkConnectionError")
        case 6004:
            errMsg = kLocalized("PayForFailure") //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
        default:
            errMsg = kLocalized("PayForFailure")
        }
        return errMsg
    }

}
