//
//  MQIDailyModelList.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/5.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIDailyModelList: MQIBaseModel {
    var read_task_list:[readItemModel] = [readItemModel]()/// 列表数据
    var next_milestone_time: NSInteger = 0 //下个未完成阅读时长任务所需时间（值为-1时，没有阅读任务可做了）
    var daily_accumulated_duration: NSInteger = 0 ///日累计阅读时长 单位为分钟
    var week_accumulated_duration: NSInteger = 0 ///周累计阅读时长  单位为分钟
    var accomplish_count:NSInteger = 0 //已完成任务数
    var total_count:NSInteger = 0 //已完成任务数
    var available_count:NSInteger = 0 //已完成任务数
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "read_task_list"{
            read_task_list = setValueToArray(value, key: key)
        }else if key == "next_milestone_time"{
            next_milestone_time = getIntWithValue(value)
        }else if key == "daily_accumulated_duration"{
            daily_accumulated_duration = getIntWithValue(value)
        }else if key == "week_accumulated_duration"{
            week_accumulated_duration = getIntWithValue(value)
        }else if key == "accomplish_count"{
            accomplish_count = getIntWithValue(value)
        }else if key == "total_count"{
            total_count = getIntWithValue(value)
        }else if key == "available_count"{
            available_count = getIntWithValue(value)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}
//单个阅读任务模型
class readItemModel: MQIBaseModel {
    var id:String = "" //阅读id
    var time_long: String = "" //阅读时长
    var status_code: String = "" //完成状态 //任务状态hang_in_the_air进行中receive可领取already_received已领取cancel取消
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}



//新用户模型
class MQINewUserModel: MQIBaseModel {
    
    var is_new_user_task: Bool = false //类型daily每日 fresh新人
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "is_new_user_task" {
            is_new_user_task = getBoolWithValue(value)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}

/// 福利模型
class MQIWelfareModel: MQIBaseModel {
    
    var banner = MQIWelfareItemModel() ///banner
    var welfare_list = [MQIWelfareItemModel]() /// 列表数据
    var total: Int = 0  ///该信息总共有多少条  可选，未提供时返回-1
    var next: Int = 0  ///分页信息，下一页从哪个id开始  可选，未提供时返回-1
    var gained: Int = 0 ///已获得的金额
    var remainder: Int = 0 ///剩余可获得的金额
    var task_title:String = "" /// 福利名称
    var unit:String = "" /// 单位
    var popupAdsenseModel = MQIPopupAdsenseModel()
    
    /// 签到
    var background_url:String = ""
    /// 签到列表
    var list  = [MQIWelfareItemModel]()
    /// 一次性任务
    var once_welfare_list  = [MQIWelfareItemModel]()
    
    /// 今日送豆数
    var today_premium: String = ""
    ///明日送豆数
    var tomorrow_premium:String = ""
    ///是否领取好评券
    var is_receive:String = ""
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner" {
            banner = MQIWelfareItemModel.init(jsonDict: value as! [String : Any])
        }else if key == "welfare_list" {
            welfare_list = setValueToArray(value, key: key)
        }
        else if key == "list" {
            list = setValueToArray(value, key: key)
        }
        else if key == "once_welfare_list" {
            once_welfare_list = setValueToArray(value, key: key)
        }

        else {
            super.setValue(value, forKey: key)
        }
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}


/// 福利列表模型
class MQIWelfareItemModel: MQIBaseModel {
    var id: Int = 0  ///每日福利id
    var task_name: String = "" ///福利项目名
    //    var caption: String = "" ///福利说明
    //    var bg: String = "" ///福利背景图片
    var reward_value: Int = 0 ///奖励数量
    var unit: String = "" ///奖励类型 魔币/魔豆等
    var status_code: String = ""///福利的完成状态 hang_in_the_air进行中receive可领取already_received已领取cancel取消
    var desc: String = "" ///福利说明
    var code: String = "" ///领取成功code
    var icon:String = "" /// 图片
    /******获取用户福利统计信息*****/
    //    var type:String = "" ///数据类型，daily为每日福利数据，fresh为新人福利数据
    var time_long: Int = 0 ///阅读任务时长
    /******获取用banner福利统计信息*****/
    var image:String = "" /// banner的图片,图片要带上分辨率参数
    var url:String = "" ///banner的跳转活动页地址
    
    var action_name:String = "" /// 未完成时的按钮文案
    var action:String = "" /// 未完成时的跳转链接，eg:open.page.LOTTERY
    var max: Int = 0 //任务最大进度
    var progress: Int = 0 //任务当前进度
    var progress_unit: String = "" //任务进度单位
    
    
    
    //// 新签到
    ///第几天签到
    var signed_day:String = ""
    ///签到日期
    var date:String = ""
    ///签到日期
    var premium:String = ""
    ///签到的状态　　signed-已签到　可签到 ''　unsign-待签到
    var status:String = ""
    ///签到图标,为空的话用默认的，否则用接口提供的地址
    var icon_url:String = ""
    ///
    var final_premium:String = ""
    
    
    
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        id = decodeIntForKey(aDecoder, key: "id")
        reward_value = decodeIntForKey(aDecoder, key: "reward_value")
        task_name = decodeStringForKey(aDecoder, key: "task_name")
        unit = decodeStringForKey(aDecoder, key: "unit")
        status_code = decodeStringForKey(aDecoder, key: "status_code")
        desc = decodeStringForKey(aDecoder, key: "desc")
        
        
        time_long = decodeIntForKey(aDecoder, key: "time_long")
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(reward_value, forKey: "reward_value")
        aCoder.encode(task_name, forKey: "task_name")
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(status_code, forKey: "status_code")
        aCoder.encode(desc, forKey: "desc")
        
        
        aCoder.encode(time_long, forKey: "time_long")
        
        
    }
}

/// 福利广告模型
class MQIPopupAdsenseModel: MQIBaseModel {
    var popupAdsenseList = [MQIPopupAdsenseListModel]() /// 列表数据
    var total: Int = 0  ///该信息总共有多少条  可选，未提供时返回-1

    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            popupAdsenseList = setValueToArray(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}

/// 福利中心广告模型列表
final class MQIPopupAdsenseListModel: MQIBaseModel,ResponseCollectionSerializable  {
    
    var id: Int = 0  ///每日福利id
    var title: String = "" ///用户user_id
    var desc: String = "" //订单号
    var url: String = "" //对应订单或活动id
    var group_id: String = "" //赠送的豆
    var start_time: String = "" ///剩余的豆
    var end_time: String = "" //赠送时间
    var update_time: String = "" //到期时间
    var pop_position: String = "" //类型名称
    var pop_type: String = "" // 1 不过期 2 过期
    var pop_relation_id: String = ""
    var image: String = ""
    
     override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}

/// 活动列表
class MQITaskModel: MQIBaseModel {
    var taskList = [MQITaskListModel]() /// 列表数据
    var next_id: String = "0"  ///该信息总共有多少条  可选，未提供时返回-1

    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            taskList = setValueToArray(value, key: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}

/// 活动
final class MQITaskListModel: MQIBaseModel,ResponseCollectionSerializable  {
    
    var event_id: Int = 0  ///每日福利id
    var event_name: String = "" ///用户user_id
    var event_desc: String = "" //订单号
    var active_time: String = "" //对应订单或活动id
    var expiry_time: String = "" //赠送的豆
    var event_status: String = "" ///剩余的豆
    var fire_status: String = "" //赠送时间
    var url: String = "" //到期时间
    var img: String = "" //类型名称
    var is_need_login: Int = 0 //是否需要登录 0不需要登录  1登录
     override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
}

/// 赠送记录模型
final class MQIPremiumModel: MQIBaseModel,ResponseCollectionSerializable  {
    
    var id: Int = 0  ///每日福利id
    var user_id: String = "" ///用户user_id
    var order_id: String = "" //订单号
    var target_id: String = "" //对应订单或活动id
    var premium_coin: String = "" //赠送的豆
    var premium_remain: String = "" ///剩余的豆
    var premium_create: String = "" //赠送时间
    var premium_end: String = "" //到期时间
    var type: String = "" //类型名称
    var status: String = "" // 1 不过期 2 过期
    
     override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
    
    
}


/// 活动通知模型
class MQINotificationModel: MQIBaseModel {
    
//    var id:Int = 0  ///活动的id
//    var title: String = "" ///活动的名称
//    var url: String = "" //该活动的活动页链接地址
//    var image: String = "" //该活动的活动宣传图片链接地址
//    var start_time: Int = 0 //活动开始时间的时间戳，单位：秒
//    var end_time: Int = 0 ///活动结束时间的时间戳，单位：秒
//    var fresh_man: Bool = false /// 是否是新人福利
//    var type: String = "" /// 提示类型   new_user 新手福利
//
//
//    var icon: String = ""  /// 该活动的首页icon图标
//    var desc: String = ""  /// 该活动描述
//
//
//    var total:String = ""
    
    var pay =  MQINotificationItemModel() //充值提示
    var feedback =  MQINotificationItemModel()  //反馈提示
    var task_daily =  MQINotificationItemModel()  //任务提示
    var message_center =  MQINotificationItemModel()  //任务提示
    var list = [MQINotificationItemModel]()  //首页弹框
    
    required override init() {
        super.init()
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "pay" {
            pay = setDictToModel(value, key: key)
        } else if key == "feedback" {
            feedback = setDictToModel(value, key: key)
        } else if key == "task_daily" {
            task_daily = setDictToModel(value, key: key)
        }
//        else if key == "fresh_man"{
//            fresh_man  = getBoolWithValue(value)
//        }
        else if key == "message_center"{
            message_center = setDictToModel(value, key: key)
        }
        else if key == "list" {
            list = setValueToArray(value, key: key)
        } else{
            super.setValue(value, forKey: key)
        }
        
    }
    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
//        id = decodeIntForKey(aDecoder, key: "id")
//        title = decodeStringForKey(aDecoder, key: "title")
//        url = decodeStringForKey(aDecoder, key: "url")
//        image = decodeStringForKey(aDecoder, key: "image")
//        desc = decodeStringForKey(aDecoder, key: "desc")
//        icon = decodeStringForKey(aDecoder, key: "icon")
//        start_time = decodeIntForKey(aDecoder, key: "start_time")
//        end_time = decodeIntForKey(aDecoder, key: "end_time")
//        fresh_man = decodeBoolForKey(aDecoder, key: "fresh_man")
//        total = decodeStringForKey(aDecoder, key: "total")
        
        if let list = decodeObjForKey(aDecoder, key: "list") as? [MQINotificationItemModel] {
            self.list = list
        }
     
        if let feedback = decodeObjForKey(aDecoder, key: "feedback") as? MQINotificationItemModel {
            self.feedback = feedback
        }
    }
    
    override func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(url, forKey: "url")
//        aCoder.encode(image, forKey: "image")
//        aCoder.encode(desc, forKey: "desc")
//        aCoder.encode(start_time, forKey: "start_time")
//        aCoder.encode(end_time, forKey: "end_time")
//        aCoder.encode(icon, forKey: "icon")
//        aCoder.encode(fresh_man, forKey: "fresh_man")
        aCoder.encode(list, forKey: "list")
        
    }
    
}

/// 活动通知模型Item
class MQINotificationItemModel: MQIBaseModel {
    
    var show:Bool = false //是否展示
    var message: String = "" //展示的信息
    var multiparty:Bool = false //展示第三方充值
    
    var next_time:Int = 0 //下次上报的时间间隔，单位，秒 上报
    
    /* 若无其他阅读任务，返回成功 */
    var code: String = "" //200
    var desc: String = "" //success
    
    /* 若无其他阅读任务，返回成功 */
    
    
    var unread_num: String = ""///未读消息数量
    
    
    var id:Int = 0  ///活动的id
    var title: String = "" ///活动的名称
    var icon: String = ""  /// 该活动的首页icon图标
    var url: String = "" //该活动的活动页链接地址
    var image: String = "" //该活动的活动宣传图片链接地址
    var start_time: Int = 0 //活动开始时间的时间戳，单位：秒
    var end_time: Int = 0 ///活动结束时间的时间戳，单位：秒
    var pop_position: String = "" //弹窗类型 1新用户弹窗 2首页弹窗 
    var cancel_rect = [NSNumber]() ///取消区域
    var confirm_rect = [NSNumber]() /// 确认区域 ,  [left, top, right, bottom]
//    var fresh_man: Bool = false /// 是否是新人福利
    
//    var had_show = false/// 2小时内是否展示
    var had_show_time: Int = 0 //上一次显示该活动的时间
    
    required override init() {
        super.init()
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "show" {
            show = getBoolWithValue(value)
        } else if key == "multiparty"{
            multiparty  = getBoolWithValue(value)
        }
        else{
            super.setValue(value, forKey: key)
        }
        
    }
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        show = decodeBoolForKey(aDecoder, key: "show")
        multiparty = decodeBoolForKey(aDecoder, key: "multiparty")
        message = decodeStringForKey(aDecoder, key: "message")
        next_time = decodeIntForKey(aDecoder, key: "next_time")
        message = decodeStringForKey(aDecoder, key: "message")
        code = decodeStringForKey(aDecoder, key: "code")
        desc = decodeStringForKey(aDecoder, key: "desc")
        desc = decodeStringForKey(aDecoder, key: "desc")
        unread_num = decodeStringForKey(aDecoder, key: "unread_num")
        id = decodeIntForKey(aDecoder, key: "id")
        title = decodeStringForKey(aDecoder, key: "title")
        icon = decodeStringForKey(aDecoder, key: "icon")
        url = decodeStringForKey(aDecoder, key: "url")
        image = decodeStringForKey(aDecoder, key: "image")
        start_time = decodeIntForKey(aDecoder, key: "start_time")
        end_time = decodeIntForKey(aDecoder, key: "end_time")
        pop_position = decodeStringForKey(aDecoder, key: "pop_position")
        had_show_time = decodeIntForKey(aDecoder, key: "had_show_time")
        
        if let cancel_rect = decodeObjForKey(aDecoder, key: "cancel_rect") as? [NSNumber] {
            self.cancel_rect = cancel_rect
        }
        if let confirm_rect = decodeObjForKey(aDecoder, key: "confirm_rect") as? [NSNumber] {
            self.confirm_rect = confirm_rect
        }
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(show, forKey: "show")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(multiparty, forKey: "multiparty")
        aCoder.encode(next_time, forKey: "next_time")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(unread_num, forKey: "unread_num")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(start_time, forKey: "start_time")
        aCoder.encode(end_time, forKey: "end_time")
        aCoder.encode(pop_position, forKey: "pop_position")
        aCoder.encode(cancel_rect, forKey: "cancel_rect")
        aCoder.encode(confirm_rect, forKey: "confirm_rect")
        aCoder.encode(had_show_time, forKey: "had_show_time")
    }
}




