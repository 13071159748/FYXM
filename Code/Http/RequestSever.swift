//
//  RequestSever.swift
//  Reader
//
//  Created by CQSC  on 16/7/15.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


let SUCCESSCODE = "0"
let ERRORCODE   = "err_code"

let WRONGNETMSG = kLocalized("NetworkStrike")
let WRONGOUTMSG = kLocalized("NetworkConnectionTimeout")

class RequestSever: NSObject
{
    //小说吧网络请求出错后，errMsg字段后台返回空字符串，故添加此方法判断错误码返回相应的提示
    class func showMsgWithErrorCode(_ errorCode:String!) ->String
    {
        let error = NSError(domain: "",code: Int(errorCode)!,userInfo: nil)
        return self.showMsgWithError(error) as String
    }
    
    class func showMsgWithError(_ error:NSError!) ->NSString
    {
        var aString:NSString! = kLocalized("NetworkStrike") as NSString
        if error != nil
        {
            if error.domain == NSURLErrorDomain && error.code == -1004
            {
                aString = WRONGNETMSG as NSString
            }
            if error.code == -1009
            {
                aString = WRONGNETMSG as NSString
            }
            if error.domain == NSURLErrorDomain && error.code == -1001
            {
                aString = WRONGOUTMSG as NSString
            }
            if error.code == -1011
            {
                aString = kLocalized("TheServerIsOffPleaseTryAgainLater") as NSString
            }
            if error.domain == NSURLErrorDomain && error.code == -1003  //开启飞行模式后，第一次网络请求会返回code＝-1003的错误
            {
                aString = WRONGNETMSG as NSString
            }
            if error.code == -500   //版本过低，请升级程序
            {
                aString = kLocalized("TheVersionIsTooLowPleaseUpdateTheProgram") as NSString
            }
            if error.code == -600   //数据库错误
            {
                aString = kLocalized("DatabaseError")  as NSString
            }
            if error.code == -1002   //用户名不能为空
            {
                aString = kLocalized("TheUsernameCannotBeEmpty") as NSString
            }
            if error.code == -1003   //密码不能为空
            {
                aString = kLocalized("ThePasswordCannotBeEmpty") as NSString
            }
            if error.code == -1004   //密码错误
            {
                aString = kLocalized("PleaseEnterTheCorrectOriginalPassword") as NSString
            }
            if error.code == -1005   //用户不存在
            {
                aString = kLocalized("UserDoesNotExist") as NSString
            }
            if error.code == -1010  //用户uid错误，可能不为数字或为0
            {
                aString = kLocalized("TheAccountIsAbnormal") as NSString
            }
            if error.code == -1021  //用户小说币不足
            {
//                aString = "\(COINNAME)不足，请充值" as NSString
            }
            if error.code == -1022  //扣除小说币失败
            {
//                aString = "扣除\(COINNAME)失败" as NSString
            }
            if error.code == -1025  //扣费金额不正确
            {
                aString = kLocalized("TheAmountOfDeductionIsIncorrect")as NSString
            }
            if error.code == -1040  //pay_user表中无此用户
            {
                aString = kLocalized("TheFreeSectionHasBeenDownloaded") as NSString
            }
            if error.code == -1041  //用户不是VIP用户
            {
                aString = kLocalized("TheFreeSectionHasBeenDownloaded") as NSString
            }
            if error.code == -1050  //手机号码不正确
            {
                aString = kLocalized("PleaseEnterTheCorrectMobilePhoneNumber") as NSString
            }
            if error.code == -1051  //该手机号已进行过验证
            {
                aString = kLocalized("ThePhoneNumberHasBeenAuthenticated") as NSString
            }
            if error.code == -1071  //签到点数不足
            {
                aString = kLocalized("InsufficientCheckInPoints")as NSString
            }
            if error.code == -2000  //系统连接超时
            {
                aString = kLocalized("TheNetworkIsNotGood") as NSString
            }
            if error.code == -2010  //苹果服务器请求超时
            {
                aString = kLocalized("TheNetworkIsNotGood") as NSString
            }
            if error.code == -2020  //提交参数不正确
            {
                aString = kLocalized("TheSubmissionParameterIsIncorrect") as NSString
            }
            if error.code == -3000  //bid错误，可能不为数字或小于1
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -3001  //书籍不存在
            {
                aString = kLocalized("BooksDonExist") as NSString
            }
            if error.code == -3002  //书籍不是VIP书籍
            {
                aString = kLocalized("BooksAreNotVIPBooks") as NSString
            }
            if error.code == -3100  //tid错误，可能tid不为数字或小于1
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -3101  //章节不存在
            {
                aString = kLocalized("ChaptersDonExist") as NSString
            }
            if error.code == -3102  //章节不是vip
            {
                aString = kLocalized("NotAVIPSection") as NSString
            }
            if error.code == -3201  //限免期间，无法下载
            {
                aString = kLocalized("CannotBeDownloadedDuringTheFreePeriod") as NSString
            }
            if error.code == -8000  //用户未订阅指定书籍章节
            {
                aString = kLocalized("UnsubscribedChapters") as NSString
            }
            if error.code == -8001  //订阅事务失败
            {
                aString = kLocalized("SubscriptionTransactionFailed") as NSString
            }
            if error.code == -8002  //添加自动订阅失败
            {
                aString = kLocalized("AddingAutomaticSubscriptionsFailed") as NSString
            }
            if error.code == -4001  //API请求时间戳过期
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -4002  //API请求没有时间戳
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -4011  //API请求签名错误
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -4012  //API请求没有签名
            {
                aString = kLocalized("UnknownErrorPleaseTryAgainLater") as NSString
            }
            if error.code == -4022  //缺少SESSION_ID
            {
                aString = kLocalized("TheLackOfSESSION_ID") as NSString
            }
            if error.code == -4023  //SESSION已过期
            {
                aString = kLocalized("TheSESSIONHasBeenExpired") as NSString
            }
            if error.code == -7011  //非法的打赏请求
            {
                aString = kLocalized("IllegalRewardRequest") as NSString
            }
            if error.code == -7021  //非法的月票请求
            {
                aString = kLocalized("IllegalMonthlyTickeRequest") as NSString
            }
            if error.code == -7022  //用户月票数量不足
            {
                aString = kLocalized("MonthlyTicketShortage") as NSString
            }
            if error.code == -7023  //扣月票失败
            {
                aString = kLocalized("FailToDeductMonthlyTicket") as NSString
            }
            if error.code == -7024  //禁止投月票
            {
                aString = kLocalized("NoMonthlyVoting") as NSString
            }
            if error.code == -7071   //该设备今天已进行签到操作
            {
                aString = kLocalized("TheDeviceWasCheckedInToday") as NSString
            }
            if error.code == -7072   //该设备已赠送小说币
            {
//                aString = "该设备已赠送\(COINNAME)" as NSString
            }
            if error.code == -7081   //充值金额错误
            {
                aString = kLocalized("WrongAmountOfRecharge") as NSString
            }
            if error.code == -8001   //购买章节失败
            {
                aString = kLocalized("FailedPurchaseSection") as NSString
            }
            if error.code == -9001   //抱歉，因不可抗力，该功能被暂停使用
            {
                aString = kLocalized("HisFunctionIsSuspendedDueToForceMajeure") as NSString
            }
            if error.code == 7040   //收藏/取消收藏成功
            {
                aString = kLocalized("OperationIsSuccessful") as NSString
            }
            if error.code == 8000   //用户已订阅指定书籍章节
            {
                aString = kLocalized("NoRepeatSubscription") as NSString
            }
            if error.code == 8001   //用户订阅章节成功
            {
                aString = kLocalized("ChaptersHaveBeenSubscribedSuccessfully") as NSString
            }
            if error.code == 8002   //添加自动订阅成功
            {
                aString = kLocalized("AutomaticSubscriptionHasBeenSuccessfullySubscribed") as NSString
            }
        }
        return aString
    }
    
    class func isSuccessCode(_ responseObject : AnyObject) ->Bool
    {
        var isSuccess = false
        
        if "\(responseObject.value(forKey: ERRORCODE)!)" == SUCCESSCODE || "\(responseObject.value(forKey: ERRORCODE)!)" == "1"
        {
            isSuccess = true
        }
        
        return isSuccess
    }
}


