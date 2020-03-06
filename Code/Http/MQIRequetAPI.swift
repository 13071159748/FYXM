//
//  MQIRequetAPI.swift
//  CQSC
//
//  Created by moqing on 2019/3/8.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

//TODO:  /********************新接口START********************************/
///接口地址 http://git.dev.moqing.com/luochong/app-api-doc/blob/master/SUMMARY.md


//MARK:推荐位列表
let bookstore_recommends = "recommend.index2"
class BookStoreRecommendsRequest:MQIBaseRequest {
    override init() {
        super.init()
        //        isCDN = true
        method = .get
        path = bookstore_recommends
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK:书城导航
let  bookstore_nav = "index.navigation"
class BookStorenNavigationRequest:MQIBaseRequest {
    override init() {
        super.init()
        //        isCDN = true
        method = .get
        path = bookstore_nav
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}


//MARK:书城banner
let bookstore_Banner = "banner.index"
class BookStoreBannerRequest:MQIBaseRequest {
    override init() {
        super.init()
        //        isCDN = true
        method = .get
        path = bookstore_Banner
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK: --书籍信息
let bookInfoPath = "book.show"
class GYBookInfoRequest: MQIBaseRequest {
    init(book_id: String) {
        super.init()
        isCDN = true
        method = .get
        path = bookInfoPath
        param = ["book_id" : book_id]
    }
}

//MARK: --书籍目录列表
let bookListPath2 = "book/%@/simple_chapters"
class GYChapterListRequest: MQIBaseRequest {
    init(book_id: String, chapter_code: String?) {
        super.init()
        isCDN = true
        method = .get
        path = String.init(format: bookListPath2, book_id)
        //        path = bookListPath
        //        param = ["book_id" : book_id,"limit" : "0","offset" : "0","sort":"0"]
        
        
    }
}
//MARK: -- 获取免费章节内容
let chapterfreePath = "chapter.free"
class GYChapterFreeRequest: MQIBaseRequest {
    init(book_id: String,chapter_id:String) {
        super.init()
        isCDN = true
        method = .get
        path = chapterfreePath
        param = ["book_id" : book_id,"chapter_id":chapter_id]
    }
}

//MARK: 精选页面
let get_choiceness_list1 = "recommend.featured"//[{}]
class GDChoicenessRequest:MQIBaseRequest {
    init(offset:String,limit:String) {
        super.init()
        isCDN = true
        method = .get
        path = get_choiceness_list1
        param = ["offset":offset,"limit":limit,"section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}
//MARK: 获取所有已经订阅的章节
let getAllSubscribeChapterPath = "chapter.ordered"//{key:[]}
class GYAllSubscribeChapterRequest: MQIBaseRequest {
    init(book_id: String, start_chapter_id: String) {
        super.init()
        //        isCDN = true
        method = .get
        path = getAllSubscribeChapterPath
        param = ["book_id" : book_id, "start_chapter_id" : start_chapter_id]
    }
}

//MARK: 闪屏页面
let splash = "recommend.splash"//{}
class GDSplashRequest:MQIBaseRequest {
    override init() {
        super.init()
        isCDN = true
        method = .get
        path = splash
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}
//MARK: 获取榜单类型
let rank_types = "rank.name"//[{}]
class GDRankTypesRequest:MQIBaseRequest {
    override init() {
        super.init()
        isCDN = true
        method = .get
        path = rank_types
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}
//MARK: 某一种榜单详情列表
let rank_list = "rank.list"//[{}]
class GDRankListRequest:MQIBaseRequest {
    init(type:String,offset:String,limit:String) {
        super.init()
        isCDN = true
        method = .get
        path = rank_list
        param = ["type":type,"offset":offset,"limit":limit,"section" : MQ_SectionManager.shared.section_ID.rawValue]
        
    }
}

//MARK: 搜索书籍
let search_book = "search.multi"
class GYSearchRequest: MQIBaseRequest {
    init(keyword: String, offset: String, limit: String) {
        super.init()
//        isCDN = true
        method = .post
        path = search_book
        param = ["keyword" : keyword, "offset" : offset, "limit" : limit]
        MQIEventManager.shared.eSearch()
        //                    param = ["keyword" : keyword, "offset" : offset, "limit" : limit,"section" : MQ_SectionManager.shared.section_ID.rawValue]
        /*
         keyword string 否 要搜索的关键词
         section int  否 取哪个平台的数据，可选值：1-女频 2-男频 3-漫画 4-短篇 5-音频。默认值：1
         class_id int 否 一级分类ID
         subclass_id  int 否 二级分类ID
         offset int 否 查询偏移量，默认0
         limit  int 否 每页显示条数，默认10
         free int   否 1-免费 2-收费
         words  int  否 1 - 30万字以内 2 - 30-50万字 3 - 50-100万字 4 - 大于100万字
         update int 否 1 - 3日内更新 2 - 7日内更新 3 - 15日内更新 4 - 30日内更新
         order int 否 1 - 周人气排序 2 - 月人气排序 3 - 总人气排序 4 - 周赞排序 5 - 月赞排序 6 - 总赞排序 7 - 字数排序
         status int 否 1 - 连载 2 - 完结
         */
    }
}
//MARK: 搜索热词
let hot_search = "search.hot_keyword"
class GYSearchHotRequest: MQIBaseRequest {
    override init() {
        super.init()
        isCDN = true
        method = .get
        path = hot_search
        param = ["section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK: --详情页 推荐位书籍
let infoRecommends = "recommend.get"//{[]}
class GYBookInfoRecommendsRequest: MQIBaseRequest {
    init(tj_type: String) {
        super.init()
        isCDN = true
        method = .get
        path = infoRecommends
        param = ["app_page" : tj_type,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}

/// 阅读页末页
let get_choiceness_by_book = "recommend.rand_banner"
class GDGetChoicenessByBookRequest:MQIBaseRequest {
    init(book_id:String) {
        super.init()
        isCDN = true
        method = .get
        path = get_choiceness_by_book
        param = ["limit":"10","offset":"0","hidden_book":book_id,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK: 分类列表
let book_classList = "book.classlist"
class MQIBookClassListRequest:MQIBaseRequest {
    override  init() {
        super.init()
        isCDN = true
        method = .get
        path = book_classList
        param = ["section_id" : MQ_SectionManager.shared.section_ID.rawValue]
    }
    
}
////MARK: --详情页 评论接口
let infoComments = "comment.list"
class GYBookInfoCommentsRequest: MQIBaseRequest {
    init(start_id: String, limit: String, book_id: String,comment_type:String = "0",offset: String) {
        super.init()
        isCDN = true
        method = .get
        path = infoComments
        param = ["start_id" : start_id,
                 "limit" : limit,
                 "comment_target" : book_id,
                 "comment_type":comment_type,
                 "offset":offset]
    }
}
//MARK: --作者其他书籍
let otherBooks = "search.same_author"//[{}]
class GYBookInfoOtherBooksRequest: MQIBaseRequest {
    init(user_id: String, book_id: String) {
        super.init()
        isCDN = true
        method = .get
        path = otherBooks
        param = ["user_id" : user_id, "book_id" : book_id]
    }
}
//MARK:  分类列表详情
let book_classListInfo = "book.list"
class MQIBookClassListInfoRequest:MQIBaseRequest {
    init(id:String,class_id:String,offset:String ,limit:String = "10") {
        super.init()
        isCDN = true
        method = .get
        path = book_classListInfo
        param = ["class_type":id,"target_class_id":class_id,"offset":offset,"limit":limit,"section_id" : MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK:更新用户信息 user  签到
let update_userInfo = "user.info"
class Update_userInfoRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = update_userInfo
    }
}

//MARK:首页无限加载
let home_guessyoulike = "index.guessyoulike"
class MQ_Home_GuessyoulikeRequest:MQIBaseRequest {
    init(offset: String, limit: String) {
        super.init()
        isCDN = true
        method = .get
        path = home_guessyoulike
        param = ["offset" : offset, "limit" : limit,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}


//MARK: --获取章节内容
let chapterContentPath = "chapter.content"
//let getChapterContent = "read" /// 免费
class GYChapterContentRequest: MQIBaseRequest {
    init(book_id: String, chapter_id: String,subscribe: Bool,read_type:String = "0") {
        super.init()
        method = .post
        path = chapterContentPath
        //      param = ["book_id" : book_id, "chapter_id" : chapter_id, "subscribe" : subscribe == true ? "true" : "false"]
        var  read_typeNEW = "0"
        if read_type.contains("1"){
            read_typeNEW = "1"
        }else if read_type.contains("2") {
            read_typeNEW = "2"
        }
        
        param = ["book_id" : book_id, "chapter_id" : chapter_id, "subscribe" : subscribe == true ? "true" : "false","read_type":read_typeNEW]
        /* read_type
         0 - 如果是vip且用戶未訂閲則返回需要訂閲錯誤
         1 - vip章節直接扣費訂閲
         2 - 免費訂閲
         */
    }
}

//MARK: 获取加密章节内容
let getEncryptionContentPath = "chapter.encrypted"//{}
//let getEncryptionContentPath = "chapter.content"//{}
class GYEncryptionContentRequest: MQIBaseRequest {
    init(book_id: String,chapter_id:String,cdn:Bool = true) {
        super.init()
        isCDN = cdn
        method = .get
        path = getEncryptionContentPath
        param = ["book_id" : book_id,"chapter_id":chapter_id]
    }
}


//MARK:订阅内容提示
let subscribeInfoPath = "chapter.subscribe_tips"//{}
//subscribe_info_free
class GYChapterSubscibeInfoRequest: MQIBaseRequest {
    
    init(book_id:String, chapter_id: String) {
        super.init()
        method = .get
        path = subscribeInfoPath
        param = ["book_id":book_id, "chapter_id" : chapter_id]
        
    }
}
//MARK:订阅内容提示
let batchBooksPath = "book.batch" //[{}]
class GYBatchBooksRequest: MQIBaseRequest {
    
    init(book_ids:[String]) {
        super.init()
        method = .post
        path = batchBooksPath
        param = ["book_id":book_ids]
        
    }
}

//MARK: 用户打赏
let userReward = "book.reward" // {"code": 200,"desc": "success"}
class GYUserRewardRequest: MQIBaseRequest {
    init(book_id: String, coin: String) {
        super.init()
        method = .post
        path = userReward
        param = ["book_id" : book_id, "coin" : coin]
    }
}
//MARK: 用户点赞
let comment_vote = "comment.vote" // {"code": 200,"desc": "success"}
/*book_id int 是 作品唯一ID vote_num int 是 点赞数量*/
class GYCommentVoteRequest: MQIBaseRequest {
    init(comment_id: String) {
        super.init()
        method = .post
        path = comment_vote
        param = ["comment_id" : comment_id]
    }
}

//MARK: 检查手机是否注册过
let userMobileCheckPath = "user.checkmobile" // {"exists": false}
class GYUserMobileCheckRequest: MQIBaseRequest {
    init(mobile: String) {
        super.init()
        method = .post
        path = userMobileCheckPath
        param = ["mobile": mobile];
    }
}


//MARK: --手机号注册
let registerPath = "user.register"
class GYUserRegisterRequest: MQIBaseRequest {
    init(phone_number: String, password: String, code: String, nick: String, device_id: String) {
        super.init()
        method = .post
        path = registerPath
        param = ["mobile" :phone_number,
                 "password" : password,
                 "smscode" : code,
                 "nickname" : nick,
                 "device_id" : device_id]
    }
}

//MARK: --手机号登录
let loginPath = "user.login"
class GYUserLoginRequest: MQIBaseRequest {
    init(mobile: String, password: String, device_id: String) {
        super.init()
        method = .post
        path = loginPath
        param = ["mobile" : mobile, "password" : password, "device_id" : device_id]
    }
}
//MARK: 设置密码
let change_pass = "user.setpass" // 绑定时设置密码设置用户密码
//let change_pass = "user.setpass" mobile string password string
class MQChange_passRequest:MQIBaseRequest {
    init(auth_code:String,password:String) {
        super.init()
        method = .post
        path = change_pass
        param = ["mobile":auth_code,"password":password]
        
    }
}

//MARK: 消费记录 一本书
let user_costInfo = "user.cost_detail"
class GYUserCostInfoRequest: MQIBaseRequest {
    init(book_id: String, start_id: String, limit: String,offset:String) {
        super.init()
        method = .get
        path = user_costInfo
        param = ["book_id" : book_id, "start_id" : start_id, "limit" : limit,"offset":offset]
    }
}

//订阅记录 消费记录 全部
let cost_book_list = "user.cost_list" //[]
class GDUserCostBookListRequest:MQIBaseRequest {
    init(offset:String,limit:String){
        super.init()
        method = .get
        path = cost_book_list
        param = ["offset":offset, "limit" : limit]
    }
}

//MARK: --获取小说币余额
let userCoinPath = "user.surplus" //{}
class GYUserCoinRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = userCoinPath
    }
}

//MARK: 充值记录
let user_order = "user.charge" //[{}]
class GYUserOrderListRequest: MQIBaseRequest {
    init(start_id: String, limit: String) {
        super.init()
        method = .get
        path = user_order
        param = ["offset" : start_id, "limit" : limit]
    }
}
//MARK: 修改昵称
let edit_user = "user.nick"// {"code":200,"desc":"success"}
class GDUserNickRequest: MQIBaseRequest {
    init(user_nick:String) {
        super.init()
        method = .post
        path = edit_user
        param = ["nickname":user_nick]
        
    }
}
//MARK:打赏记录
let user_RewardLog = "user.reward"//[{}]
class GDUserRewardRequest:MQIBaseRequest {
    init(start_id: String, limit: String) {
        super.init()
        method = .get
        path = user_RewardLog
        param = ["offset":start_id,"limit":limit]
    }
}

//MARK: 用户签到
let userSign = "user.sign"
class GYUserSignRequest: MQIBaseRequest {
    init(position:String = "1") {
        super.init()
        method = .post
        path = userSign
        param = ["position":position]
    }
}
//新的用户签到
class GDUserSignRequest: MQIBaseRequest {
    init(position:String) {
        super.init()
        method = .post
        path = userSign
        param = ["position":position]
    }
}

//MARK: 新增或更新书架
let addBookShelf = "shelf.save" //{"code": 200,"desc": "success"}
class GYBookShelfAddRequest: MQIBaseRequest {
    init(book_id: String) {
        super.init()
        method = .post
        path = addBookShelf
        param = ["book_id" : book_id]
    }
}

//MARK: --书架同步
let bookShelfPath = "shelf.sync"
class GYBookShelfRequest: MQIBaseRequest {
    init(ids: [String]?, delete: [String]?) {
        super.init()
        method = .post
        path = bookShelfPath
        param = ["save" : [String](), "del" : [String](),"hidden":"0"]
        if let ids = ids {
            param!["save"] = ids
        }
        if let delete = delete {
            param!["del"] = delete
        }
    }
}

//MARK: --书架删除一本书
let bookDeleteShelfPath = "shelf.delete" // "code": 200,"desc": "success"
class GYBookDeleteShelfRequest: MQIBaseRequest {
    init(book_id:String) {
        super.init()
        method = .post
        path = bookDeleteShelfPath
        param = ["book_id" : book_id]
    }
}
//MARK: -阅读记录一本书
let get_read_log = "readlog.get"
class GDGet_read_logRequest:MQIBaseRequest {
    init(book_id:String) {
        super.init()
        method = .get
        path = get_read_log
        param = ["book_id":book_id]
    }
}
//MARK: 新增阅读记录
let save_read_log = "readlog.save" //"code": 200,"desc": "success"
class GDSave_read_logRequest:MQIBaseRequest {
    init(book_id:String,chapter_id:String,position:String,readtime:String) {
        super.init()
        method = .post
        path = save_read_log
        param = ["book_id":book_id,"chapter_id":chapter_id,"position":position,"readtime":readtime]
    }
}

//MARK: 网络阅读记录
let get_network_read_log = "readlog.pull" //{data:[{}],total:""}
class GDGet_network_read_logRequest:MQIBaseRequest {
    init(limit:String,offset:String) {
        super.init()
        method = .get
        path = get_network_read_log
        param = ["limit":limit,"offset":offset]
    }
}


//MARK: 推荐书籍 页面内的
let book_tjs = "recommend.get"
class GDBookInfoRecommendsRequest:MQIBaseRequest {
    init(book_id:String){
        super.init()
        method = .get
        path = book_tjs
        param = ["app_page":TYPE_BOOK_DETAIL,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}



//MARK: 书架首次安装推荐书
let bookShelfRecommendPath = "recommend.get"
class GYBookShelfRecommends: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = bookShelfRecommendPath
        param = ["app_page":TYPE_INIT_BOOKSHELF,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK: 推荐书籍 精选
let select_tjs = "recommend.rand_banner"
class GDSelectRecommendsRequest:MQIBaseRequest {
    init(limit:String,offset:String){
        super.init()
        method = .get
        path = select_tjs
        param = ["limit":limit,"offset":offset,"section":MQ_SectionManager.shared.section_ID.rawValue]
    }
}


//MARK: --发送验证码
let phoneVertifyCodePath = "sms.send"//{"code":200,"desc":"success"}
class GYUserPhoneVertifyCodeRequest: MQIBaseRequest {
    init(phone: String) {
        super.init()
        method = .post
        path = phoneVertifyCodePath
        param = ["mobile" : phone]
    }
}


//MARK: 发布评论
let comment = "comment.post" // "code": 200,"desc": "success"
class GYCommentRequest: MQIBaseRequest {
    init(book_id: String, comment_type: String, chapter_id: String, comment_content: String) {
        super.init()
        method = .post
        path = comment
        param = ["comment_target" : book_id, "comment_type" : comment_type, "comment_content" : comment_content]
        if comment_type == "2" {
            param!["chapter_id"] = chapter_id
        }
    }
}


//MARK:  阅读时长数据上报接口
let report_reading = "report.reading" //{"next_time": 500,"message": "還有未完成的閱讀任務噢" 任务完成："code": 200,"desc": "success"}
class MQIUserReadingRequest:MQIBaseRequest {
    init(during:Int) {
        super.init()
        method = .post
        path = report_reading
        param = ["during":during]
    }
}
///用户领取每10分钟的阅读金币
let freetask_get_read_gold = "freetask.get_read_gold" //{"code":200,"desc":"success"}
class MQIGetReadGoldRequest:MQIBaseRequest {
    init(timestamp:Int) {
        super.init()
        method = .post
        path = freetask_get_read_gold
        param = ["timestamp":timestamp]
    }
}



//MARK:  获取用户绑定信息
let get_user_othersite = "user.snsinfo" //{"accounts":[]}
class MQGet_user_othersiteRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = get_user_othersite
    }
}

//MARK: --绑定手机
let bindMobilePath = "user.bindmobile"
class GYUserBindMobileRequest: MQIBaseRequest {
    init(phone: String, code: String) {
        super.init()
        method = .post
        path = bindMobilePath
        param = ["mobile" : phone, "smscode" : code]
    }
}



//MARK: 用户修改密码
let userChangePswPath = "user.resetpass"///{"code":200,"desc":"success"}
class GYUserChangePswRequest: MQIBaseRequest {
    init(phone: String, code: String, password: String) {
        super.init()
        method = .post
        path = userChangePswPath
        param = ["mobile" : phone, "smscode" : code, "password" : password]
    }
}

//MARK:  福利中心-每日福利
let welfare_benefits = "welfare.daily" // {welfare_list:[]}
class GDBenefitsRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = welfare_benefits
        
    }
}

//MARK:  福利中心-领取奖励
let welfare_benefits_receive = "welfare.receive"///{"code":200,"desc":"success"}
class MQIBenefitsReceiveRequest:MQIBaseRequest {
    init(id:Int) {
        super.init()
        method = .post
        path = welfare_benefits_receive
        param = ["id":id]
        MQIEventManager.shared.eReceiveBenefit()
    }
}


//MARK: 我的金币明细
let user_goldlist = "user.goldlist"
class MQ_User_GoldlistRequest:MQIBaseRequest {
    init(offset:String ,limit:String = "10") {
        super.init()
        method = .get
        path = user_goldlist
        param = ["offset":offset,"limit":limit]
        
    }
}

//MARK: 我的现金明细
let user_incomelist = "user.incomelist"
class MQ_User_IncomelistRequest:MQIBaseRequest {
    init(offset:String ,limit:String = "10") {
        super.init()
        method = .get
        path = user_incomelist
        param = ["offset":offset,"limit":limit]
        
    }
}


//MARK:完本
let complete_book = "search.multi"
class MQ_Complete_bookRequest:MQIBaseRequest {
    init(offset: String, limit: String,status:String?,order:String?,update:String?) {
        super.init()
        method = .post
        path = complete_book
        param = ["offset" : offset, "limit" : limit,"section":MQ_SectionManager.shared.section_ID.rawValue]
        if status != nil {
            param!["status"] = status!
        }
        if order != nil {
            param!["order"] = order!
        }
        if update != nil {
            param!["update"] = update!
        }
    }
}

//MARK:金币兑换零钱
let freewithdraw_gold = "freewithdraw.gold" //{"code":200,"desc":"success"}
class MQ_Freewithdraw_GoldRequest:MQIBaseRequest {
    init(cash: String) {
        super.init()
        method = .post
        path = freewithdraw_gold
        param = ["cash" : cash]
    }
}


//MARK:提现兑换列表
let user_cashlist = "user.cashlist" //[{}]
class MQ_User_CashlistRequest:MQIBaseRequest {
    init(offset: String, limit: String) {
        super.init()
        method = .get
        path = user_cashlist
        param = ["offset" : offset, "limit" : limit]
    }
}

//MARK:绑定邀请码
let user_bind_introduce = "freetask.bind_introducer" //{"code":200,"desc":"success"}
class MQ_User_Bind_IntroduceRequest:MQIBaseRequest {
    init(invite_code: String) {
        super.init()
        method = .post
        path = user_bind_introduce
        param = ["invite_code" : invite_code]
    }
}

//MARK:支付宝充值
let to_pay_alipay = "charge.alipay" //{}
class MQ_to_pay_alipayRequest:MQIBaseRequest {
    init(fee: String,type:String) {
        //fee 充值金额，单位为『分』 type 充值类型 1-购买阅读币 2-购买VIP 默认为1
        super.init()
        method = .post
        path = to_pay_alipay
        param = ["fee":fee,"type":type]
    }
}

//MARK:微信充值
let to_pay_weixin = "charge.weixin" //{}
class MQ_to_pay_weixinRequest:MQIBaseRequest {
    init(fee: String,type:String) {
        //fee 充值金额，单位为『分』 type 充值类型 1-购买阅读币 2-购买VIP 默认为1
        super.init()
        method = .post
        path = to_pay_weixin
        param = ["fee":fee,"type":type]
    }
}


//MARK:每日分享任务
let dailyshare = "freetask.dailyshare" //{"code":200,"desc":"success"}
class MQ_DailyshareRequest:MQIBaseRequest {
    init(timestamp: String) {
        super.init()
        method = .post
        path = dailyshare
        param = ["timestamp":timestamp]
    }
}


//MARK: --第三方账号登录
let userSnsPath = "user.sns"///{"code":200,"desc":"success"}
class GYUserSnsPathtRequest: MQIBaseRequest {
    // sns_platform 第三方平台名称，目前可用：weixin,qq,weibo,alipay
    init(_ sns_platform:String,param:[String:Any]) {
        super.init()
        method = .get
        path = userSnsPath
        self.param = param
        self.param!["sns_platform"] = sns_platform
    }
}



//MARK: -- 详情页 投票
let infoToVote = "book.vote"
class GYBookInfoToVoteRequest: MQIBaseRequest {
    init(user_id: String, book_id: String, toVote: Bool, vote_num: String) {
        super.init()
        method = .post
        path = infoToVote
        param = ["book_id" : book_id,
                 "vote_num" : vote_num]
    }
}

//MARK: --金币兑换VIP
let freewithdraw_vip = "freewithdraw.vip" //{"code":200,"desc":"success"}
class GYFreewithdraw_vipRequest: MQIBaseRequest {
    //   要兑换的VIP天数
    init(days: String) {
        super.init()
        method = .post
        path = freewithdraw_vip
        param = ["days" : days]
    }
}
//MARK: 检查手机是否注册过
let userCheckExists = "user.checkmobile"
class GDUserPhoneNumCheckExists: MQIBaseRequest {
    init(phoneNumber:String) {
        super.init()
        method = .post
        path = userCheckExists
        param = ["mobile": phoneNumber];
    }
}

//MARK: 查看购买状态
let applePayTypePath = "version.review"
class GYPayTypeRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = applePayTypePath
        param = ["version": getCurrentVersion()]
    }
}

//MARK: 批量订阅
let chapterSubscribe = "chapter.batch"
class GYChapterSubscribeRequest: MQIBaseRequest {
    init(book_id: String, start_chapter_id: String, limit: String, whole_subscribe: String? = nil) {
        super.init()
        method = .post
        path = chapterSubscribe
        param = ["book_id" : book_id, "start_chapter_id" : start_chapter_id, "limit": limit]
        guard let whole_subscribe = whole_subscribe else {
            return
        }
        param!["whole_subscribe"] = whole_subscribe
    }
}

/// 订阅  新接口所有订阅都走这个
class GYSubscribeBookRequest: MQIBaseRequest {
    init(book_id: String, chapter_ids: [String]) {
        super.init()
        method = .post
        path = chapterSubscribe
        param = ["book_id" : book_id, "chapter_id" : chapter_ids]
        
        MQIEventManager.shared.eSubscribeChapter()
        //TODO:  新版的标识，传1表示批量订阅 会有折扣逻辑  不是批量不传
        if chapter_ids.count > 1 {
            param!["batch"] = "1"
        }
    }
}


//MARK: 充值列表 //TODO:   月卡新增参数  join_fuel = 1   打折卡新增参数join_discount
let apppayList = "charge.list"
let apppayList2 = "charge.list2" ///不验证登录
class GDGetApplePayList: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = apppayList2
        if MQIPayTypeManager.shared.isAvailable() {
            param = ["channel_code":"apple","currency":"USD","join_discount":"1"]
        } else {
            param = ["channel_code":"apple","currency":"USD","join_discount":"1", "debug":"1"]
        }
        
        
    }
}

//MARK: 个人中心红点提示
let user_notification = "notification.usercenter"
class MQIGetUserNotification:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = user_notification
    }
}

//MARK: 上报token
let push_token = "firebase.upload_id"
class MQIPushRegisterRequest:MQIBaseRequest {
    init(push_id:String) {
        super.init()
        method = .get
        path = push_token
        param = ["push_id":push_id]
    }
}

//MARK:  我的赠送记录
let premium_list = "user.premium"
class MQIGetPremiumList:MQIBaseRequest {
    init(start_id:String ,limit:String = "10") {
        super.init()
        method = .get
        path = premium_list
        param = ["offset":start_id,"limit":limit]
    }
}

//MARK:  首页活动弹框
let home_notification = "notification.task"
class MQIHomeNotificationRequest:MQIBaseRequest {
    init(first_open:Bool) {
        super.init()
        method = .get
        path = home_notification
        param = ["first_open":first_open]
    }
}

class MQIUploadEventDataRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .post
    }
}

//MARK:  每日分享任务完成
let daily_share = "task.finish"
class MQIDaily_shareRequest:MQIBaseRequest {
    init(id:String) {
        super.init()
        method = .post
        path = daily_share
        param = ["id":id]
    }
}


//MARK: 苹果二次验证
let appleVerifyPathNEW = "charge.iap_verify"
class GYAppleVerifyRequestNew: MQIBaseRequest {
    
    @objc init(receipt: String, isSanBox: Bool,trade_no:String, version:String,product_id:String,order_id:String? = nil) {
        super.init()
        method = .post
        path = appleVerifyPathNEW
        
        if order_id == nil {
            param = ["receipt" : receipt, "transaction_id" : trade_no,"version" : version,"product_id":product_id,"section":MQ_SectionManager.shared.section_ID.rawValue,]
        }else{
            param = ["receipt" : receipt, "transaction_id" : trade_no,"version" : version,"product_id":product_id,"order_id":order_id!,"section":MQ_SectionManager.shared.section_ID.rawValue,]
        }
        
    }
    
    @objc func request(success: ((GYResultModel) -> ())?, failure: ((String, String) -> ())?) {
        request({ (_, _, r: GYResultModel) in
            success?(r)
        }) { (errorDes, code) in
            failure?(errorDes, code)
        }
        
    }
        
}


//MARK: 获取免费章节内容
let getAllFreeChapterContentsPath = "chapter.encrypted"
class GYAllFreeChapterContentsRequest: MQIBaseRequest {
    init(book_id: String,chapter_id:String) {
        super.init()
        isCDN = true
        method = .get
        path = getEncryptionContentPath
        param = ["book_id" : book_id,"chapter_id":chapter_id]
    }
}
//MARK: --获取指定章节内容
let chapterContentByIdsPath = "chapter.encrypted"
class GYChapterContentByIdsRequest: MQIBaseRequest {
    init(book_id: String, start_chapter_id: String, chapter_ids: [String]) {
        super.init()
        //        method = .post
        //        path = chapterContentByIdsPath
        //        param = ["book_id" : book_id, "start_chapter_id" : start_chapter_id,  "chapter_ids" : chapter_ids]
        isCDN = true
        method = .get
        path = getEncryptionContentPath
        param = ["book_id" : book_id,"chapter_id":start_chapter_id]
    }
}


//MARK: 消息列表  [{}]
let messagecenter_list = "messagecenter.list"
class MQIGetMsglistRequest: MQIBaseRequest {
    init(offset:String,limit:String) {
        super.init()
        method = .get
        path = messagecenter_list
        param = ["offset":offset,"limit":limit,"is_html":"1"]
    }
}

//MARK: 签到列表  [{}]
let sign_list = "sign.continued_list" /// {[]}
class MQIGetSignListRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = sign_list
    }
}

//MARK: 签到
let sign_continued = "sign.continued2" /// {[]}
class MQIDignContinuedtRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = sign_continued
        param = ["section": MQ_SectionManager.shared.section_ID.rawValue]
    }
}

//MARK: 查看购买状态
let autoRegisterPath = "user.auto_register"
class GYAutoRegisterRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .post
        path = autoRegisterPath
        param = ["version": getCurrentVersion(), "device_id" : DEVICEID]
    }
}

///获取作品消费某本书某个批量订阅的信息
let user_batch_detail = "user.batch_detail"
class MQIUserBatchDetailRequest:MQIBaseRequest {
    init(book_id:String,offset:String,parent_id:String,limit: String) {
        super.init()
        method = .get
        path = user_batch_detail
        param = ["book_id":book_id,"parent_id":parent_id,"offset":offset,"limit":limit]
    }
}

///获取用户是否评论过
let user_is_praise = "user.is_praise"
class MQIUseris_praiseRequest:MQIBaseRequest {
   override init() {
        super.init()
        method = .get
        path = user_is_praise
    }
}
/// 领取好评
let user_praise = "user.praise"
class MQIUser_praiseRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = user_praise
       
    }
}

/// 获取打折卡产品信息
let product_discount2 = "product.discount2"
class MQIProduct_discount2Request:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = product_discount2
        param = ["currency": "USD",
                 "channel_code": "apple"]
    }
}

/// 获取用户打折卡详细信息
let mydiscount_detail = "mydiscount.detail"
class MQIMydiscount_detailRequest:MQIBaseRequest {
      init(offset: String, limit: String) {
        super.init()
        method = .get
        path = mydiscount_detail
        param = ["section": MQ_SectionManager.shared.section_ID.rawValue,
                 "limit": limit,
                 "offset": offset,
                 "channel_code": "apple"]
    }
}

/// 我的打折卡省钱明细
let user_cost_reduction = "user.cost_reduction"
class MQIUser_cost_reductionRequest:MQIBaseRequest {
    init(offset: String, limit: String) {
        super.init()
        method = .get
        path = user_cost_reduction
        param = [
                    "limit": limit,
                 "offset": offset]
    }
}

/// 弹窗列表
let popup_list = "popup.list"
class MQIPopup_listRequest:MQIBaseRequest {
   override init() {
        super.init()
        method = .get
        path = popup_list
        param = ["lang": DSYLanguageControl.currentLanStr]
    }
}

///兑换码
let redeem_exchange = "redeem.exchange"
class MQIRedeemExchangeRequest:MQIBaseRequest {
    init(redeem_code:String) {
        super.init()
        method = .get
        path = redeem_exchange
        param = ["redeem_code":redeem_code]
    }
}

/// 末页
let end_content = "recommend.get_with_content"
class MQIEndContentRequest:MQIBaseRequest {
    init(app_page:String = "book_end",book_id:String,offset:String) {
        super.init()
        method = .get
        path = end_content
        param = ["app_page":app_page,"book_id":book_id,"offset":offset]
        
    }
}
/// 获取章节内容  chapter_id 没章节id，如果值为0，则默认是该书第一章   auto_subscribe自动购买： 1 买， 2 不买

let get_new_chapter_content = "chapter/%@/%@"
class MQIGetNewChapteContentRequest:MQIBaseRequest {
    init(book_id:String,chapter_id:String = "0",auto_subscribe:String) {
        super.init()
        method = .get
        path = String(format: get_new_chapter_content, book_id,chapter_id)
        param = ["lang": DSYLanguageControl.currentLanStr,"auto_subscribe":auto_subscribe]
    }
}

let update_avatar = "user.upload_avatar"
class GDUpdateAvatarRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .post
        path = update_avatar
    }
}
/// 用户.邮箱验证（登录）
let user_check_emailcode_login = "user.check_emailcode_login"
class MQIuser_check_emailcode_loginRequest:MQIBaseRequest {
    /// send_type  bind 绑定 reset_pass 重置密码 reset_email 变更邮箱
    init(email:String,email_code:String,send_type:String) {
        super.init()
        method = .post
        path = user_check_emailcode_login
        param = ["email": email,"email_code":email_code,"send_type":send_type]
    }
}

/// 用户.邮箱验证（非登录）
let user_check_emailcode = "user.check_emailcode"
class MQIuser_check_emailcodenRequest:MQIBaseRequest {
    init(email:String,email_code:String,send_type:String) {
        super.init()
        method = .post
        path = user_check_emailcode
        param = ["email": email,"email_code":email_code,"send_type":send_type]
    }
}

/// 邮箱登录
let user_email_login = "user.email_login"
class MQIuser_email_loginRequest:MQIBaseRequest {
    init(email:String,Pwd:String) {
        super.init()
        method = .post
        path = user_email_login
         param = ["email": email,"password":Pwd]
    }
}
/// 邮箱注册
let user_email_register = "user.email_register"
class MQIuser_email_registerRequest:MQIBaseRequest {
    init(email:String,Pwd:String,nickname:String) {
        super.init()
        method = .post
        path = user_email_register
        param = ["email": email,"password":Pwd,"nickname":nickname]
    }
}

/// 用户.设置密码和找回密码（邮箱）
let user_email_set_pass = "user.email_set_pass"
class MQIuser_email_set_pass:MQIBaseRequest {
    init(email:String,Pwd:String,email_code:String,send_type:String) {
        super.init()
        method = .post
        path = user_email_set_pass
        param = ["email":email,"password": Pwd,"email_code":email_code,"send_type":send_type]
    }
}

/// 用户.密码验证身份
let user_password_check = "user.password_check"
class MQIuser_password_check:MQIBaseRequest {
    init(password:String) {
        super.init()
        method = .post
        path = user_password_check
        param = ["password": password]
    }
}

/// 用户.检测邮箱是否存在
let user_check_email = "user.check_email"
class MQIuser_check_email:MQIBaseRequest {
    init(email:String) {
        super.init()
        method = .post
        path = user_check_email
        param = ["email": email]
    }
}

/// 用户.发送邮箱验证码（非登录）
let user_send_email = "user.send_email"
class MQIuser_send_email:MQIBaseRequest {
    init(email:String,send_type:String) {
        super.init()
        method = .post
        path = user_send_email
        param = ["email": email,"send_type":send_type]
    }
}


/// 用户.发送邮箱验证码（登录）
let user_send_email_login = "user.send_email_login"
class MQIuser_send_email_login:MQIBaseRequest {
    init(email:String,send_type:String,code:String) {
        super.init()
        method = .post
        path = user_send_email_login
        param = ["email": email,"send_type":send_type,"code":code]
    }
}

/// 新版本更新提示
let version_tips = "version.tips"
class MQIversion_tipsRequest:MQIBaseRequest {
   override init() {
        super.init()
        method = .get
        path = version_tips
    }
}


//TODO: /*******************************新接口END**************************************/



let wxLoginPath = "login_wechat"
let googleLoginPath = "login_google/index"
let facebookLoginPath = "login_facebook/index"
let twitterLoginPath = "login_twitter/index"
let lineLoginPath = "login_line/index"
//MARK: --第三方登录
class MQIUserWXLoginRequest: MQIBaseRequest {
    init(auth_code: String, device_id: String, bind: Bool) {
        super.init()
        method = .post
        path = wxLoginPath
        let deviceid = String.init(DEVICEID)
        param = ["auth_code" : auth_code, "device_id" : deviceid, "bind" : bind == true ? "1" : "0"]
    }
}

class MQIUserGoogleLoginRequest: MQIBaseRequest {
    init(id_token: String) {
        super.init()
        method = .post
        path = googleLoginPath
        let deviceid = String.init(DEVICEID)
        param = ["device_id" : deviceid, "id_token" : id_token]
    }
}

class MQIUserFacebookLoginRequest: MQIBaseRequest {
    init(access_token: String) {
        super.init()
        method = .post
        path = facebookLoginPath
        let deviceid = String.init(DEVICEID)
        param = ["device_id" : deviceid, "access_token" : access_token]
    }
}

class MQIUserTwitterLoginRequest: MQIBaseRequest {
    init(oauth_token: String, user_id: String,screen_name:String,oauth_token_secret:String) {
        super.init()
        method = .post
        path = twitterLoginPath
        let deviceid = String.init(DEVICEID)
        param = ["device_id" : deviceid, "oauth_token" : oauth_token, "user_id" : user_id, "screen_name" : screen_name, "oauth_token_secret" : oauth_token_secret]
    }
}

class MQIUserLineLoginRequest: MQIBaseRequest {
    init(access_token: String) {
        super.init()
        method = .post
        path = lineLoginPath
        let deviceid = String.init(DEVICEID)
        param = ["device_id" : deviceid, "access_token" : access_token]
    }
}







class GYUserWBLoginRequest: MQIBaseRequest {
    init(auth_code: String, device_id: String, bind: Bool, uid: String) {
        super.init()
        method = .post
        path = wbLoginPath
        param = ["auth_code" : auth_code, "device_id" : device_id, "bind" : bind == true ? "1" : "0", "uid" : uid]
    }
}

class GYUserQQLoginRequest: MQIBaseRequest {
    init(access_code: String, device_id: String,openid: String) {
        super.init()
        method = .post
        path = qqLoginPath
        param = ["access_token" : access_code, "device_id" : device_id,"openid" : openid]
    }
}

class GYUserQQWebLoginRequest: MQIBaseRequest {
    init(login_code: String) {
        super.init()
        method = .post
        path = qqWebLoginPath
        param = ["login_code" : login_code, "device_id" : DEVICEID]
    }
}



//MARK: --刷新token
class GYUserRefreshTokenRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = authorizationPath
        if let user = MQIUserManager.shared.user {
            let deviceid = String.init(DEVICEID)
            param = ["refresh_token" : user.refresh_token, "device_id" : deviceid]
        }
        needToken = false
    }
}





class GDH5ActionToServerRequest: MQIBaseRequest {
    init(action:String,params:String) {
        super.init()
        method = .post
        path = h5communal_action
        param = ["action":action,"params":params]
    }
}
//MARK: Order
class GYOrderRequest: MQIBaseRequest {
    init(type: String, order_fee: String, channel_id: String,user_coupon_id:String) {
        super.init()
        method = .post
        path = appleOrderPath
        param = ["channel_id" : channel_id, "type" : type, "order_fee" : order_fee,"user_coupon_id":user_coupon_id,"abroad":"1"]
    }
}
//MARK: 微信支付订单
class GYWXPayOrderRequest: MQIBaseRequest {
    init(order_id: String) {
        super.init()
        method = .get
        path = wxOrderPath
        param = ["order_id": order_id]
    }
}
//MARK: 微信支付订单 - 网页版
class GYWXOrderWebRequest: MQIBaseRequest {
    init(order_id: String) {
        super.init()
        method = .get
        path = wxOrderPath_web
        param = ["order_id": order_id]
    }
}
//MARK: 支付宝支付订单 - 网页版
class GYAlipayOrderWebRequest: MQIBaseRequest {
    init(order_id: String) {
        super.init()
        method = .get
        path = alipayOrderPath_web
        param = ["order_id": order_id]
    }
}

//MARK: 苹果二次验证
class GYAppleVerifyRequest: MQIBaseRequest {
    init(order_id: String, money: String, receipt: String, isSanBox: Bool, version:String) {
        super.init()
        method = .post
        path = appleVerifyPath
        param = ["order_id" : order_id, "money" : money, "receipt" : receipt, "isSanbox" : isSanBox == true ? "1" : "0","version" : version]
    }
}


//MARK: 获取可使用的优惠券（根据活动为单位返回的）
class GYGetVaildCouponsRequest: MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = vaildCouponPath
    }
}

//MARK: --弹窗书架
class GYBookShelfPushRequest: MQIBaseRequest {
    init(tj_type: String) {
        super.init()
        method = .post
        path = bookShelfPushPath
        param = ["tj_type" : tj_type]
    }
}


//查询书籍限免信息
class GDQueryFreeLimitRequest:MQIBaseRequest {
    init(book_id:String) {
        super.init()
        method = .post
        path = query_freelimit
        param = ["book_id":book_id]
        
    }
    
}

class GDCommentCountRequest:MQIBaseRequest {
    init(book_id:String,comment_type:String = "0") {
        super.init()
        method = .post
        path = comment_count
        param = ["book_id":book_id,"comment_type":comment_type]
    }
    
}
//MARK: 领取优惠券
class GYTakeVaildCouponsRequest: MQIBaseRequest {
    init(event_id: String) {
        super.init()
        method = .get
        path = takeCouponPath
        param = ["event_id" : event_id]
    }
}



//MARK: 我的优惠券）
class GYGetUserVaildCouponsRequest: MQIBaseRequest {
    init(offset: String, limit: String, valid: Bool, fo: String = "my") {
        super.init()
        method = .get
        path = userCouponPath
        param = ["offset" : offset,
                 "limit" : limit,
                 "status" : valid == true ? "valid" : "invalid",
                 "for" : "fo"]
    }
}


/// 登陆用户首次使用app上报
class GDUserActivationRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .post
        path = user_activation
        param = ["":""]
    }
}

class GDGetUserTask:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = user_task
    }
}


class MQIGetActNotification:MQIBaseRequest {
    init(start_id:String ,limit:String = "10") {
        super.init()
        method = .get
        path = act_notification
    }
}


let event_report = "event_report"
class MQIEventRequest:MQIBaseRequest {
    init(events:[[String:Any]]) {
        super.init()
        method = .post
        path = event_report
        param = ["events":events]
    }
}
/// 福利中心
let daily_welfare = "welfare.daily"
class MQIDailyWelfareRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = daily_welfare
        param = ["once_task_type":"1002"]
    }
}


// 新老接口转换
let getNewtoken = "token.change"
class MQIGetNewTokenRequest:MQIBaseRequest {
    init(_ refresh_token:String) {
        super.init()
        method = .get
        path = getNewtoken
        param = ["token":refresh_token]
    }
}

///获取批量订阅折扣费用详情
let batch_list = "chapter.batch_list"
class MQIGetBatchListRequest:MQIBaseRequest {
    override  init() {
        super.init()
        method = .get
        path = batch_list
        
    }
}

///获取批量订阅折扣费用详情
let subscribe_batch_info = "chapter.batch_tips"
class MQISubscribeBatchInfoRequest:MQIBaseRequest {
    init(book_id:String,chapter_ids:[String]) {
        super.init()
        method = .post
        path = subscribe_batch_info
        param = ["book_id":book_id,"chapter_id":chapter_ids]
    }
}

fileprivate let mydiscount_simple = "mydiscount.simple"
class MQIMydiscountsimpleRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = mydiscount_simple
    }
}

/// 获取书籍扩展信息 用来判断订阅按钮的显示
let book_extention = "book.extention"
class MQIBookExtentionRequest:MQIBaseRequest {
    init(book_id:String) {
        super.init()
        method = .get
        path = book_extention
        param = ["book_id":book_id]
    }
}

/// 推荐位.查看更多
let book_get_more = "recommend.get_more"
class MQIbook_get_moreRequest:MQIBaseRequest {
    init(tj_id:String) {
        super.init()
        method = .get
        path = book_get_more
        param = ["section": MQ_SectionManager.shared.section_ID.rawValue,
                 "tj_id": tj_id]
    }
}


//TODO: /*******************************新接口END**************************************/

/// 创建支付订单
let create_order = "order.create"
class MQICreateOrderRequest:MQIBaseRequest {
    
    init(product_id:String,channel_code:String = "apple",order_type:String? = nil) {
        super.init()
        method = .post
        path = create_order
        param = ["product_id":product_id,"channel_code":channel_code]
        if order_type != nil {
            param!["order_type"] = order_type!
        }
        
        // product_id:商品id
        //channel_code 充值渠道    apple  mycard
        // order_type 订单类型  1充币订单 2包半年 3包一年 4月卡 5打折卡
    }
}
/// 查询目前正在进行的订单
let latest_query = "order.latest_query"
class MQILatestQueryRequest:MQIBaseRequest {
    init(channel_code:String = "apple") {
        super.init()
        method = .get
        path = latest_query
        param = ["channel_code":channel_code]
    }
}

/// 取消订单
let order_cancel = "order.cancel"
class MQIOrderCancelRequest:MQIBaseRequest {
    init(order_id:String) {
        super.init()
        method = .get
        path = order_cancel
        param = ["order_id":order_id]
    }
}

/// 支付订单
let purchase_Appstore = "purchase.appstore" /// [code    number message    string]
class MQIPurchaseAppstoreRequest:MQIBaseRequest {
    init(order_id:String,transaction_id:String,recepit:String) {
        super.init()
        method = .post
        path = purchase_Appstore
        param = ["order_id":order_id,"transaction_id":transaction_id,"recepit":recepit]
    }
}


fileprivate let discount_card = "product.discount"
class MQIDiscountCardInfoRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = discount_card
        param = ["currency": "USD",
                 "channel_code": "apple"]
    }
}
fileprivate let user_discount_card = "user.discount"
class MQIUserDiscountCardInfoRequest:MQIBaseRequest {
    override init() {
        super.init()
        method = .get
        path = user_discount_card
    }
}

/// 领取优惠券
fileprivate let couponse_receive_prize = "charge.receive_prize"
class MQICouponseRecievePirceRequest: MQIBaseRequest {
    init(event_id: String, prize_id: String) {
        super.init()
        method = .post
        path = couponse_receive_prize
        param = ["event_id": event_id, "prize_id": prize_id]
    }
}

fileprivate let couponse_user_pirze = "user.prize"
class MQICounponseUserPrize: MQIBaseRequest {
    init(status: Int, offset: Int) {
        super.init()
        method = .get
        path = couponse_user_pirze
        param = ["status":status, "limit": 20, "offset": offset]
    }
}

let recommends_item = "item_recommend.index"
class RecommendsItemRequest: MQIBaseRequest {
    init(_ id: String) {
        super.init()
        method = .get
        path = recommends_item
        param = ["section" : MQ_SectionManager.shared.section_ID.rawValue, "id": id]
    }
}
/// 广告位
let popup_adsense = "popup.adsense"
class MQIPopupAdsenseRequest:MQIBaseRequest {
    init(pop_position:String) {
        super.init()
        method = .get
        path = popup_adsense
        param = ["pop_position":pop_position]
    }
}

/// 活动列表
let charge_task_list = "charge.task_list"
class MQIChargeTaskListRequest:MQIBaseRequest {
    init(next_id:String,limit:String = "20") {
        super.init()
        method = .get
        path = charge_task_list
        param = ["next_id":next_id,"limit":limit]
    }
}

//
/////获取批量订阅折扣费用详情
//let batch_list = "batch.list"
//class MQIGetBatchListRequest:MQIBaseRequest {
//    init(book_id:String,start_chapter_id:String) {
//        super.init()
//        method = .get
//        path = batch_list
//        param = ["book_id":book_id,"start_chapter_id":start_chapter_id]
//    }
//}
//
/////获取批量订阅折扣费用详情
//let subscribe_batch_info = "subscribe.batch.info"
//class MQISubscribeBatchInfoRequest:MQIBaseRequest {
//    init(book_id:String,chapter_ids:[String]) {
//        super.init()
//        method = .post
//        path = subscribe_batch_info
//        param = ["book_id":book_id,"chapter_ids":chapter_ids]
//    }
//}



let wbLoginPath = "login_weibo"
let qqLoginPath = "audio/login_qq"
let qqWebLoginPath = "login_qq_web"

//let autoRegisterPath = "auto_register"
let uploadUserInfoPath = "update_user_info"
let authorizationPath = "authorization"

//h5 请求通用接口
let h5communal_action = "communal_action"
let appleOrderPath = "order"
let wxOrderPath = "wechat_order"
let wxOrderPath_web = "wechat_order_wap"
let alipayOrderPath_web = "get_alipay_config_wap"
let appleVerifyPath = "apple_pay"

let vaildCouponPath = "valid_coupons"

let bookShelfPushPath = "bookshelf_push"

let query_freelimit = "query_freelimit"

let comment_count = "comment_count"
//领取优惠券
let takeCouponPath = "take_coupon"

//我的优惠券
let userCouponPath = "my_coupons"

let user_activation = "task/activation"
///获取用户福利统计
let user_task = "task/user_task_count"
///// 我的赠送记录
//let premium_list = "premium_list"
/// 页活动提示
let act_notification = "act/notification"
