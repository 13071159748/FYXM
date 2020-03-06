//
//  MQIReadOperation.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

import Reachability


let first_chapter_alert_text = kLocalized("IsFirstPage")
let last_chapter_alert_text = kLocalized("IsLastPage")

class MQIReadOperation: NSObject {
    
    /// 阅读控制器
    weak var vc: MQIReadViewController!
    
    // MARK: -- init
    init(vc: MQIReadViewController) {
        super.init()
        self.vc = vc
        
    }
    override init() {
        super.init()
    }
    // MARK: -- 获取阅读控制器 MQIReadPageViewController
    /// 获取阅读View控制器
    func GetReadViewController(readRecordModel: MQIReadRecordModel?) -> MQIReadPageViewController? {
        
        if let readRecordModel = readRecordModel {
            let readViewController = MQIReadPageViewController()
            readViewController.readRecordModel = readRecordModel
            readViewController.readController = vc
            return readViewController
        }else {
            if let _ = vc.readMenu {
                vc.readMenu.bottomView.sliderClear()
            }
        }
        
        return nil
    }
    
    var isDownloading: Bool = false
    
    /// 是否需要重新 获取 需要下载的 章节 id 总数
    public var needRefreshSubscribeIds: Bool = true
    
    var forceToPage: Int = 0   //当网络请求 需要切换 到 某一页的时候 可以 通过修改 forceToPage 达到强制切换目的 作用域 （GetCurrentReadViewController）
    var forceToUpdateFont: Bool = false  //强制 刷新 字体 当网络出错的 时候 刷新 一定要强制 刷新
    var currentReadPageVC:MQIReadPageViewController?
    /// 获取当前阅读记录的阅读View控制器
    @discardableResult    func GetCurrentReadViewController(isUpdateFont: Bool = false, isSave: Bool = false, toPage: NSInteger = 0,isFirstEnter:Bool=false,to_index:Int? = nil,to_chapter_id:String? = nil) -> MQIReadPageViewController? {
        forceToPage = toPage
        forceToUpdateFont = isUpdateFont
        if vc.readModel.chapterList.count <= 0 {
            
            guard let list = GYBookManager.shared.getChapterListFromLocation(vc.book), list.count > 0 else {
                //启动下载
                let readViewController = MQIReadPageViewController()
                readViewController.readController = vc
                readViewController.addPreloadView()
                currentReadPageVC = readViewController
                
                
                vc.multipleRelationsRequest(tid:to_chapter_id ?? "0", book_old: vc.book, completion: {[weak self] (book, chapter,list_new) in
                    if let strongSelf = self {
                        let requestChapter = chapter
                        readViewController.dismissPreloadView()
                        readViewController.dismissWrongView()
                        strongSelf.vc.readModel.chapterList = list_new
                        strongSelf.vc.listVC.chapterList = list_new
                        strongSelf.vc.readModel.chapterList = list_new
                        strongSelf.isDownloading = false
                        if let  to_chapter_id =  to_chapter_id {
                            for i in  0..<list_new.count {
                                if list_new[i].chapter_id == to_chapter_id {
                                    strongSelf.vc.readModel.readRecordModel.chapterIndex = NSNumber.init(value: i)
                                    break
                                }
                            }
                            
                        }
                        
                        strongSelf.vc.readModel.modifyReadRecordModel(chapter: requestChapter, toPage: strongSelf.forceToPage, isUpdateFont: strongSelf.forceToUpdateFont, isSave: isSave)
                        readViewController.readRecordModel = strongSelf.vc.readModel.readRecordModel
                        strongSelf.vc.listVC.reloadChapter(strongSelf.vc.readModel.readRecordModel.chapterIndex.intValue, chapter_id: requestChapter.chapter_id)
                        if isFirstEnter {strongSelf.vc.requestreadLog()}
                        readViewController.reload()
                    }
                }) {[weak self ] (code,msg) in
                    if let strongSelf = self {
                        strongSelf.isDownloading = false
                        let type =  strongSelf.getWrong(code: code)
                        readViewController.addWrongView(msg, type: type, refresh: {
                            strongSelf.operationWrong(type: type, completion: {
                                readViewController.dismissWrongView()
                                readViewController.addPreloadView()
                                strongSelf.isDownloading = true
                                strongSelf.GetCurrentReadViewController(isUpdateFont: isUpdateFont, isSave: isSave, toPage: toPage, isFirstEnter: isFirstEnter, to_index: to_index, to_chapter_id: to_chapter_id)
                            })
                        })
                    }
                }
                //
                //                getList(readViewController,to_index: to_index,to_chapter_id: to_chapter_id, completion: {[weak self] (chapter) in
                //                    if let strongSelf = self {
                //                        let requestChapter = chapter
                //                        strongSelf.isDownloading = false
                //
                //                        if let  to_chapter_id =  to_chapter_id {
                //                            let list = strongSelf.vc.readModel.chapterList
                //                            for i in  0..<list.count {
                //                                if list[i].chapter_id == to_chapter_id {
                //                                    strongSelf.vc.readModel.readRecordModel.chapterIndex = NSNumber.init(value: i)
                //                                }
                //                            }
                //
                //                        }
                //
                //                        strongSelf.vc.readModel.modifyReadRecordModel(chapter: requestChapter, toPage: strongSelf.forceToPage, isUpdateFont: strongSelf.forceToUpdateFont, isSave: isSave)
                //                        readViewController.readRecordModel = strongSelf.vc.readModel.readRecordModel
                //                        strongSelf.vc.listVC.reloadChapter(strongSelf.vc.readModel.readRecordModel.chapterIndex.intValue, chapter_id: requestChapter.chapter_id)
                //                        if isFirstEnter {strongSelf.vc.requestreadLog()}
                //                        readViewController.reload()
                //                    }
                //                })
                return readViewController
            }
            isDownloading = false
            vc.readModel.chapterList = list
            vc.listVC.chapterList = list
            
            GYBookManager.shared.getChapterList(vc.book, forceRefresh: MQIPlanManager.shared.checkNeedRefresh(.refreshChpaterList, id: vc.book.book_id), completion: {[weak self] (list) in
                if let strongSelf = self {
                    if  strongSelf.vc != nil {
                        strongSelf.vc.readModel.chapterList = list
                        strongSelf.vc.listVC.chapterList = list
                    }
                    
                }
                }, failed: { (code, msg) in
            })
            
        }
        
        let readViewController = MQIReadPageViewController()
        readViewController.readController = vc
        currentReadPageVC = readViewController
        if vc.readModel.readRecordModel.readChapterModel == nil {
            if vc.readModel.chapterList.count > 0 {
                ///跳章看
                if let to_indexNew  =  to_index ,to_indexNew >= 0 && to_indexNew < vc.readModel.chapterList.count {
                    vc.readModel.readRecordModel.readChapterModel = vc.readModel.chapterList[to_indexNew]
                } else if let  to_chapter_id =  to_chapter_id {
                    
                    
                    var  chapter:MQIEachChapter?
                    let list = vc.readModel.chapterList
                    for i in  0..<list.count {
                        if list[i].chapter_id == to_chapter_id {
                            chapter = list[i]
                            vc.readModel.readRecordModel.chapterIndex = NSNumber.init(value: i)
                        }
                    }
                    if  chapter != nil  {
                        vc.readModel.readRecordModel.readChapterModel = chapter!
                    }else{
                        vc.readModel.readRecordModel.readChapterModel = vc.readModel.chapterList[0]
                    }
                    
                    
                }
                    
                else{
                    vc.readModel.readRecordModel.readChapterModel = vc.readModel.chapterList[0]
                }
            }else {
                let readChapterModel = MQIEachChapter()
                if let to_indexNew  =  to_index  {
                    readChapterModel.chapter_code = "\(to_indexNew)"
                }else if let  to_chapter_id =  to_chapter_id {
                    readChapterModel.chapter_id = to_chapter_id
                }
                vc.readModel.readRecordModel.readChapterModel = readChapterModel
            }
        }
        
        let chapter = vc.readModel.readRecordModel.readChapterModel!
        
        if chapter.content == "" {
            //
            //启动下载
            if let content = GYBookManager.shared.getChapterDataFromLocation(vc.book.book_id, tid: chapter.chapter_id) {
                if chapter.isDown == false {
                    chapter.isDown = true
                    //如果出现 本地存在章节了 而 章节 又显示 ‘未下载的’ 特殊情况  这里处理
                    vc.book.addTidToDownTids(chapter.chapter_id)
                    
                    var index = vc.readModel.readRecordModel.chapterIndex.intValue
                    if index <= 0 { index = 0}
                    if index <   vc.readModel.chapterList.count {
                        vc.readModel.chapterList[index].isDown = true
                        vc.listVC.reloadChapter(index, chapter_id: chapter.chapter_id)
                    }
                }
                chapter.content = content
                vc.readModel.modifyReadRecordModel(chapter: chapter, toPage: forceToPage, isUpdateFont: forceToUpdateFont, isSave: isSave)
                readViewController.readRecordModel = vc.readModel.readRecordModel
                preloadChapter(index: vc.readModel.readRecordModel.chapterIndex.intValue)
            }else {
                readViewController.addPreloadView()
                
                getContent(readViewController, completion: {[weak self] (chapter) in
                    if let strongSelf = self {
                        strongSelf.isDownloading = false
                        strongSelf.vc.readModel.modifyReadRecordModel(chapter: chapter, toPage: strongSelf.forceToPage, isUpdateFont: strongSelf.forceToUpdateFont, isSave: isSave)
                        readViewController.readRecordModel = strongSelf.vc.readModel.readRecordModel
                        readViewController.reload()
                    }
                })
            }
            
            return readViewController
        }else {
            vc.readModel.modifyReadRecordModel(chapter: chapter, toPage: forceToPage, isUpdateFont: forceToUpdateFont, isSave: isSave)
            readViewController.readRecordModel = vc.readModel.readRecordModel
            preloadChapter(index: vc.readModel.readRecordModel.chapterIndex.intValue)
        }
        
        if isUpdateFont {
            vc.readModel.readRecordModel.updateFont(isSave: true)
        }
        
        if isSave {
            vc.readModel.readRecordModel.save()
        }
        
        return GetReadViewController(readRecordModel: vc.readModel.readRecordModel.copySelf())
    }
    
    // 重新加载 一遍  pageVC
    func reloadReadViewController(pageVC: MQIReadPageViewController?, isSave: Bool = false, isForce: Bool = true) {
        if let pageVC = pageVC, let chapter = vc.readModel.readRecordModel.readChapterModel {
            
            let page = vc.readModel.readRecordModel.page.intValue
            vc.readModel.modifyReadRecordModel(chapter: chapter, toPage: page, isUpdateFont: false, isSave: isSave, isForce: isForce)
            
            let total = chapter.pageCount.intValue
            if page > total-1 {
                vc.readModel.readRecordModel.page = NSNumber(value: total-1)
            }
            
            pageVC.readRecordModel = vc.readModel.readRecordModel
            pageVC.reload()
            vc.listVC.changeBgType()
        }
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->MQIReadPageViewController? {
        
        // 没有阅读模型
        if vc.readModel == nil {return nil}
        
        // 阅读记录
        var readRecordModel:MQIReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
        }else{ // 网络小说
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            let page = readRecordModel!.page.intValue
            
            //            let currentChapterIndex = readRecordModel!.chapterIndex.intValue
            //            let chapterCount = vc.readModel.chapterList.count
            
            //            if page == 0 || currentChapterIndex == chapterCount  || GYReadStyle.shared.styleModel.effectType == .upAndDown {
            if page == 0 || GYReadStyle.shared.styleModel.effectType == .upAndDown {
                let index = readRecordModel!.chapterIndex.intValue-1
                
                if index == -1 {
                    if readRecordModel?.readChapterModel == nil {
                        return nil
                    }
                    readRecordModel!.chapterIndex = NSNumber(value: index)
                    return GetReadViewController(readRecordModel: readRecordModel)
                }else if index < -1 {
                    operationTheFirst()
                    readRecordModel = nil
                }else {
                    
                    readRecordModel!.chapterIndex = NSNumber(value: index)
                    
                    let chapter = vc.readModel.chapterList[index]
                    readRecordModel!.readChapterModel = chapter
                    //                    if isDownloading == true {
                    //                        return GetReadViewController(readRecordModel: nil)
                    //                    }
                    MQIDataUtil.saveShelfBook(vc.book, atts: [.chapterId(chapter.chapter_id.integerValue()),.chapterTitle(chapter.chapter_title),.chapterPosition(index)])
                    readRecordUpdate(readRecordModel: readRecordModel, isSave:true)
                    return GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: GYReadLastPageValue)
                }
            }else {
                readRecordModel?.page = NSNumber(value: (page-1))
            }
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    
    /// 获得下一页控制器
    func GetBelowReadViewController() ->MQIReadPageViewController? {
        // 没有阅读模型
        if (vc.readModel == nil) {return nil}
        
        // 阅读记录
        var readRecordModel:MQIReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
        }else{ // 网络小说
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            let page = readRecordModel!.page.intValue
            let nowPageCount = readRecordModel?.readChapterModel?.pageCount
            if nowPageCount == nil {
                return nil
            }
            let lastPage = readRecordModel!.readChapterModel!.pageCount.intValue - 1
            var index = readRecordModel!.chapterIndex.intValue
            
            if page+1 > lastPage || index == -1 || GYReadStyle.shared.styleModel.effectType == .upAndDown {
                index += 1
                //                if index == vc.readModel.chapterList.count {
                //                    readRecordModel!.chapterIndex = NSNumber(value: index)
                //                    return GetReadViewController(readRecordModel: readRecordModel)
                //                }
                //                else if index > vc.readModel.chapterList.count {
                
                if index >= vc.readModel.chapterList.count {
                    operationTheLast()
                    readRecordModel = nil
                }else {
                    
                    readRecordModel!.chapterIndex = NSNumber(value: index)
                    readRecordModel!.page = NSNumber(value: 0)
                    
                    let chapter = vc.readModel.chapterList[index]
                    readRecordModel!.readChapterModel = chapter
                    
                    //                    if isDownloading == true {
                    //                        return GetReadViewController(readRecordModel: nil)
                    //                    }
                    readRecordUpdate(readRecordModel: readRecordModel, isSave:true)
                    MQIEventManager.shared.appendEventData(eventType: .event_reader_chapter, additional: ["book_id" : vc.book.book_id,"chapter_id":    chapter.chapter_id])
                    MQIDataUtil.saveShelfBook(vc.book, atts: [.chapterId(chapter.chapter_id.integerValue()),.chapterTitle(chapter.chapter_title),.chapterPosition(index)])
                    AAReadLogManager.shared.save_read_logWhenDisappear(vc.book.book_id, chapter_id: chapter.chapter_id, position: "0")
                    MQIDataUtil.saveShelfBook(vc.book, atts: [.chapterId(chapter.chapter_id.integerValue()),.chapterTitle(chapter.chapter_title),.chapterPosition(index)])
                    return GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: 0)
                }
            }else {
                readRecordModel?.page = NSNumber(value: (page+1))
            }
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    /// 跳转指定章节 指定页码 (toPage: -1 为最后一页 也可以使用 GYReadLastPageValue)
    func GoToChapter(_ pageVC: MQIReadPageViewController?, chapterIndex: Int?, chapterId: String? = nil, toPage: Int = 0) {
        if vc.readModel.chapterList.count <= 0 {
            return
        }
        
        if let index = chapterIndex {
            if index < 0 {
                operationTheFirst()
            }else if index > vc.readModel.chapterList.count-1 {
                operationTheLast()
            }else {
                if index == vc.readModel.readRecordModel.chapterIndex.intValue {
                    vc.creatPageController(GetCurrentReadViewController(isUpdateFont: false, isSave: true, toPage: toPage))
                }else {
                    let chapter = vc.readModel.chapterList[index]
                    vc.readModel.readRecordModel.chapterIndex = NSNumber(value: index)
                    vc.readModel.readRecordModel.page = NSNumber(value: toPage)
                    vc.readModel.readRecordModel.readChapterModel = chapter
                    vc.creatPageController(GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: toPage))
                    MQIEventManager.shared.appendEventData(eventType: .event_reader_chapter, additional: ["book_id" : vc.book.book_id,"chapter_id":       chapter.chapter_id ])
                    AAReadLogManager.shared.save_read_logWhenDisappear(vc.book.book_id, chapter_id: chapter.chapter_id, position: "0")
                    MQIDataUtil.saveShelfBook(vc.book, atts: [.chapterId(chapter.chapter_id.integerValue()),.chapterTitle(chapter.chapter_title),.chapterPosition(index)])
                }
            }
        }else {
            if toPage != vc.readModel.readRecordModel.page.intValue {
                vc.creatPageController(GetCurrentReadViewController(isUpdateFont: false, isSave: true, toPage: toPage))
            }
        }
    }
    
    //MARK: 订阅开启关闭
    func subScribe(_ isSubscribe: Bool) {
        
    }
    
    // MARK: -- 同步记录
    
    /// 更新记录
    func readRecordUpdate(readViewController: MQIReadPageViewController?, isSave:Bool = true) {
        readRecordUpdate(readRecordModel: readViewController?.readRecordModel, isSave: isSave)
    }
    
    /// 更新记录
    func readRecordUpdate(readRecordModel: MQIReadRecordModel?, isSave: Bool = false) {
        if let readRecordModel = readRecordModel {
            vc.readModel.readRecordModel = readRecordModel
            
            if isSave == true {
                vc.readModel.readRecordModel.save()
            }
        }
    }
    
    func operationTheFirst() {
        MQILoadManager.shared.makeToast(first_chapter_alert_text)
        vc.allowToCover = true
    }
    
    func operationTheLast() {
        MQILoadManager.shared.makeToast(last_chapter_alert_text)
        //        vc.allowToCover = true
        //        vc.allowToCover = false
        vc.pushToReadEndVC()
    }
}


extension MQIReadOperation {
    //网络请求
    func getList(_ pageVC: MQIReadPageViewController,to_index:Int? = nil,to_chapter_id:String? = nil, completion: ((_ chapter: MQIEachChapter) -> ())?) {
        isDownloading = true
        
        GYBookManager.shared.getChapterListFromServer(vc.book, locationList: nil, completion: {[weak self] (list) in
            if let strongSelf = self {
                strongSelf.vc.readModel.chapterList = list
                strongSelf.vc.listVC.chapterList = list
                strongSelf.getContent(pageVC,to_index: to_index,to_chapter_id: to_chapter_id, completion: completion)
            }
            }, failed: {[weak self] (code, msg) in
                if let strongSelf = self {
                    strongSelf.isDownloading = false
                    let type = strongSelf.getWrong(code: code)
                    pageVC.addWrongView(msg, type: type, refresh: {
                        strongSelf.operationWrong(type: type, completion: {
                            pageVC.dismissWrongView()
                            pageVC.addPreloadView()
                            
                            strongSelf.isDownloading = true
                            strongSelf.getList(pageVC, to_index: to_index,to_chapter_id: to_chapter_id,completion: completion)
                        })
                    })
                }
        })
    }
    
    
    func getContent(_ pageVC: MQIReadPageViewController,to_index:Int? = nil,to_chapter_id:String? = nil, completion: ((_ chapter: MQIEachChapter) -> ())?) {
        isDownloading = true
        let index = vc.readModel.readRecordModel.chapterIndex.intValue
        if index > vc.readModel.chapterList.count {
            pageVC.dismissPreloadView()
            pageVC.addWrongView(kLocalized("GetWrongAgain"), type: .other, refresh: {[weak self]() -> Void in
                if let strongSelf = self {
                    if strongSelf.vc.readModel.chapterList.count > 0 {
                        strongSelf.vc.readModel.readRecordModel.chapterIndex = NSNumber(value: strongSelf.vc.readModel.chapterList.count-1)
                        strongSelf.getContent(pageVC, completion: completion)
                    }else {
                        strongSelf.getList(pageVC, completion: completion)
                    }
                }
            })
            return
        }
        
        guard index != -1 else{//首页
            pageVC.dismissPreloadView()
            vc.readMenu.bottomView.sliderClear()
            isDownloading = false
            preloadChapter(index: index)
            completion?(MQIEachChapter())
            return
        }
        //        guard index != vc.readModel.chapterList.count else {
        //            pageVC.dismissPreloadView()
        //            vc.readMenu.bottomView.sliderClear()
        //            isDownloading = false
        //            completion?(MQIEachChapter())
        //            return
        //        }
        
        var requestChapter: MQIEachChapter!
        if to_index != nil  {
            requestChapter = vc.readModel.chapterList[index]
            //            vc.readModel.readRecordModel.readChapterModel = requestChapter
        }
            
        else  if let  to_chapter_id =  to_chapter_id {
            let list = vc.readModel.chapterList
            for i in  0..<list.count {
                if list[i].chapter_id == to_chapter_id {
                    requestChapter = list[i]
                }
            }
            if requestChapter == nil {
                requestChapter = vc.readModel.chapterList[index]
            }
        }
            
        else{
            if let c = vc.readModel.readRecordModel.readChapterModel {
                if c.chapter_id == "" {
                    requestChapter = vc.readModel.chapterList[index]
                }else {
                    requestChapter = c
                }
            }else {
                if vc.readModel.chapterList.count > 0 {
                    requestChapter = vc.readModel.chapterList[index]
                }else {requestChapter = MQIEachChapter()}//判断一下，否则第一次读书没成功，没缓存，再进会崩溃（网络不好!）
            }
        }
        /// 去当给定阅读模型为当前阅读
        if requestChapter.chapter_id != "" {
            vc.readModel.readRecordModel.readChapterModel = requestChapter
        }
        
        
        GYBookManager.shared.getChapterContent(vc.book, chapter: requestChapter, completion: {[weak self] (chapter) in
            if let strongSelf = self {
                pageVC.dismissPreloadView()
                pageVC.dismissWrongView()
                
                strongSelf.isDownloading = false
                
                if strongSelf.vc.book.downTids.contains(chapter.chapter_id) == false {
                    strongSelf.vc.book.downTids.append(chapter.chapter_id)
                }
                strongSelf.vc.readModel.chapterList[index] = chapter
                strongSelf.vc.readModel.readRecordModel.chapterIndex = NSNumber(value: index)
                strongSelf.vc.readModel.readRecordModel.readChapterModel = chapter
                
                strongSelf.vc.book.addTidToDownTids(chapter.chapter_id)
                
                strongSelf.vc.listVC.reloadChapter(index, chapter_id: chapter.chapter_id)
                
                strongSelf.preloadChapter(index: index)
                
                completion?(chapter)
            }
            }, failed: {[weak self] (code, msg) in
                if let strongSelf = self {
                    if strongSelf.vc  == nil {
                        return
                    }
                    if strongSelf.vc != nil {
                        strongSelf.vc.readMenu.bottomView.sliderClear()
                    }
                    
                    let type = strongSelf.getWrong(code: code)
                    
                    strongSelf.checkWrong(type, bid: strongSelf.vc.book.book_id, tid: requestChapter.chapter_id, completion: { (unSubscribeChapter,newType) in
                        
                        strongSelf.isDownloading = false
                        pageVC.addWrongView(msg, type: newType, unSubscribeChapter: unSubscribeChapter, refresh: {
                            if unSubscribeChapter?.is_new_book == "1" {
                                GYBookManager.shared.buyTids.append(requestChapter.chapter_id)
                            }
                            strongSelf.operationWrong(type: newType, completion: {
                                pageVC.dismissWrongView()
                                pageVC.addPreloadView()
                                if strongSelf.vc != nil {
                                    strongSelf.vc.readMenu.novelsSettingView.checkSubscribe()
                                }
                                strongSelf.forceToUpdateFont = true
                                strongSelf.isDownloading = true
                                if strongSelf.vc != nil {
                                    if strongSelf.vc.readModel.chapterList.count <= 0 {
                                        strongSelf.getList(pageVC, completion: completion)
                                    }else {
                                        strongSelf.getContent(pageVC,to_index: to_index, completion: completion)
                                    }
                                }
                                
                            })
                        })
                        
                    })
                    
                    //礼券弹窗规则：只要是vip章节就弹
                    if (type == .needSubscribeChapter) || (type == .needSubscribeBook) || (type == .needLogin) || (type == .needCoin) {
                        
                        if MQICouponManager.shared.coupon_readerLoading == false {
                            if MQICouponManager.shared.isLocatedReader == true{
                                if strongSelf.vc != nil{
                                    MQICouponManager.shared.inReaderToPostCouponsView(strongSelf.vc)
                                }
                                
                            }
                            
                        }
                    }
                }
        })
    }
    //预加载
    func preloadChapter(index: Int) {
        if index-1 >= 0 {
            if index-1 < vc.readModel.chapterList.count {
                let c = vc.readModel.chapterList[index-1]
                //需求说不让自动订阅上一章、下一章
                if c.chapter_vip == false
                    //||(c.chapter_vip == true && GYBookManager.shared.checkIsSubscriber(vc.book))
                {
                    if c.content == "" {
                        
                        GYBookManager.shared.getChapterContent(vc.book, chapter: c, completion: {[weak self] (chapter) in
                            if let strongSelf = self {
                                strongSelf.vc.book.addTidToDownTids(chapter.chapter_id)
                                
                                if strongSelf.vc.book.downTids.contains(chapter.chapter_id) == false {
                                    strongSelf.vc.book.downTids.append(chapter.chapter_id)
                                }
                                
                                strongSelf.vc.readModel.chapterList[index-1] = chapter
                                strongSelf.vc.listVC.reloadChapter(index-1, chapter_id: chapter.chapter_id)
                            }
                        }) { (msg, code) in
                        }
                    }
                }
            }
            
        }
        
        if index+1 < vc.readModel.chapterList.count-1 {
            let c = vc.readModel.chapterList[index+1]
            if c.chapter_vip == false
                //                ||
                //                (c.chapter_vip == true && GYBookManager.shared.checkIsSubscriber(vc.book)) {
            {
                if c.content == "" {
                    
                    GYBookManager.shared.getChapterContent(vc.book, chapter: c, completion: {[weak self] (chapter) in
                        if let strongSelf = self {
                            strongSelf.vc.book.addTidToDownTids(chapter.chapter_id)
                            
                            if strongSelf.vc.book.downTids.contains(chapter.chapter_id) == false {
                                strongSelf.vc.book.downTids.append(chapter.chapter_id)
                            }
                            
                            strongSelf.vc.readModel.chapterList[index+1] = chapter
                            strongSelf.vc.listVC.reloadChapter(index+1, chapter_id: chapter.chapter_id)
                        }
                    }) { (msg, code) in
                        
                    }
                }
            }
        }
    }
    
    func rewardRequest(_ coin: Int) {
        MQILoadManager.shared.addProgressHUD(kLocalized("Exceptioning"))
        GYUserRewardRequest(book_id: vc.book.book_id, coin: "\(coin)")
            .request({ (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("ExceptionSuccess"))
                UserNotifier.postNotification(.refresh_coin)
            }) { [weak self](err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
                if let weakSelf = self {
                    weakSelf.operationWrong(type:weakSelf.getWrong(code: err_code), completion: {
                        
                    })
                }
        }
    }
    
    //    result.isDown = true
    //
    //    MQIFileManager.saveChapterContent(bid, tid: result.chapter_id, content: result.content)
    //
    /// 获取定长的 ChapterIds
    func getFixedChapterIds(_ count:Int, book:MQIEachBook,start_chapter_id : String? = "0") -> ([String]?,String) {
        if book.whole_subscribe == "1" { return (["-11"],"全本订阅")}
        if GYBookManager.shared.whole_subscribe != nil { return (["-11"],"全本订阅")}
        if GYBookManager.shared.isFree_limit_time{ return (nil,"本书限时免费中，可以尽情观看哦。")  }
        let buyTids =  GYBookManager.shared.buyTids
        var ids = [String]()
        var countNew = count
        var startIndex = 0
        if let row = vc.readModel?.readRecordModel?.chapterIndex {
            startIndex = row.intValue
        }
        if startIndex <= 0 {startIndex = 0}
        var chapterList = [MQIEachChapter]()
        if let chapterListNew = vc.readModel?.readRecordModel?.chapterList {
            if let chapterListOld   = GYBookManager.shared.getChapterListFromLocation(book){
                if chapterListNew.count > chapterListOld.count{
                    chapterList = chapterListNew
                }else{
                    chapterList = chapterListOld
                }
            }
            
        }
        
        for i in startIndex..<chapterList.count {
            if countNew <= 0 {break}
            let chapter = chapterList[i]
            if !buyTids.contains(chapter.chapter_id) && chapter.chapter_vip{
                countNew -= 1
                ids.append(chapter.chapter_id)
                mqLog("\(i)=== chapter\(chapter.chapter_title)")
            }
            
        }
        if ids.count <= 0 {
            return (nil,"没有可订阅的后续章节啦")
        }else {
            return (ids,"")
        }
        
    }
    //订阅 10  50  100 章
    func subScribeRequest(_ count:Int, book:MQIEachBook, start_chapter_id : String? = "0", isWholeSubscribe: Bool = false, completion: ((_ result: MQIEachSubscribe?) -> ())?) {
        
        func startScribe() {
            let resultIds = getFixedChapterIds(count, book: book, start_chapter_id: start_chapter_id)
            if resultIds.0 == nil {
                MQILoadManager.shared.dismissProgressHUD()
                if let currentReadPageVC = currentReadPageVC {
                    currentReadPageVC.reload()
                }
                vc.readMenu.subscribeView(isShow: false, completion: {
                    completion?(nil)
                })
                MQILoadManager.shared.makeToast(resultIds.1)
                return
            }
            let ids = resultIds.0!
            GYSubscribeBookRequest(book_id: book.book_id, chapter_ids:ids )
                .request({ [weak self](request, response, result: MQIEachSubscribe) in
                    
                    //                let coin = MQIUserManager.shared.user!.user_coin.integerValue()-result.coin.integerValue()
                    //                MQIUserManager.shared.user!.user_coin = "\(coin)"
                    GYBookManager.shared.buyTids.append(contentsOf: ids)
                    
                    UserNotifier.postNotification(.refresh_coin)
                    GYBookManager.shared.saveChapterList(book, ids)
                    MQIUserManager.shared.updateUserCoin({ (suc, str) in
                        if let weakSelf = self {
                            MQILoadManager.shared.dismissProgressHUD()
                            weakSelf.needRefreshSubscribeIds = true
                            
                            if isWholeSubscribe == true {
                                GYBookManager.shared.addDingyueBook(weakSelf.vc.book, type: .book)
                                GYBookManager.shared.whole_subscribe = "1"
                            }
                            
                            if let currentReadPageVC = weakSelf.currentReadPageVC {
                                weakSelf.getContent(currentReadPageVC, completion: {(chapter) in
                                    weakSelf.isDownloading = false
                                    weakSelf.vc.readModel.modifyReadRecordModel(chapter: chapter)
                                    weakSelf.vc.readModel.modifyReadRecordModel(chapter: chapter, toPage: weakSelf.forceToPage, isUpdateFont: true, isSave: true)
                                    currentReadPageVC.readRecordModel = weakSelf.vc.readModel.readRecordModel
                                    currentReadPageVC.reload()
                                })
                            }
                        }
                        
                        completion?(result)
                    })
                    
                    
                }) {[weak self](err_msg, err_code) in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast("\(err_msg)")
                    if let weakSelf = self {
                        let wrongCode = weakSelf.getWrong(code: err_code)
                        if wrongCode == .needCoin{
                            
                            after(1.5, block: {
                                weakSelf.operationWrong(type:weakSelf.getWrong(code: err_code), completion: {
                                    
                                })
                                weakSelf.vc.readMenu.bottomView(isShow: true, completion: { ()->Void in
                                    weakSelf.vc.readMenu.moreView(isShow: false, completion: nil)
                                })
                            })
                            
                        }else {
                            weakSelf.operationWrong(type:weakSelf.getWrong(code: err_code), completion: {
                                
                            })
                        }
                        
                    }
                    completion?(nil)
            }
        }
        MQILoadManager.shared.addProgressHUD(kLocalized("Booking"))
        
        GYBookManager.shared.getSubscribeChapterIds(book_id: book.book_id) { (msg) in
            if msg != nil {
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg!)
            }else{
                startScribe()
            }
            
        }
        
        
    }
    //下载章节
    func requestSubscribeChapters() {
        guard vc.readModel.chapterList.count > 0 else {
            return
        }
        
        guard needRefreshSubscribeIds == true else {
            downloadBooks()
            return
        }
        
        MQILoadManager.shared.addProgressHUD(kLocalized("GetBookInfo"))
        GYAllSubscribeChapterRequest(book_id: vc.book.book_id, start_chapter_id: vc.readModel.chapterList[0].chapter_id)
            .request({[weak self] (request, response, tModel: MQIBaseModel) in
                if let strongSelf = self {
                    if let tids = tModel.dict["chapter_ids"] {
                        if tids is [String] {
                            strongSelf.vc.book.buyTids = tids as!  [String]
                        }else if tids is [NSNumber] {
                            let newIDs = tids as!  [NSNumber]
                            for i in newIDs {
                                strongSelf.vc.book.buyTids.append(i.stringValue)
                            }
                        }
                    }
                    
                    GYBookManager.shared.buyTids = strongSelf.vc.book.buyTids
                    strongSelf.needRefreshSubscribeIds = false
                    
                    MQILoadManager.shared.dismissProgressHUD()
                    strongSelf.downloadBooks()
                    
                }
            }) {[weak self] (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
                if let strongSelf = self {
                    strongSelf.needRefreshSubscribeIds = true
                }
        }
    }
    
    func downloadBooks() {
        let frees = (vc.readModel.chapterList.filter({$0.chapter_vip == false && $0.isDown == false})).map({$0.chapter_id})
        
        
        var tids = vc.book.buyTids.filter({vc.book.downTids.contains($0) == false})
        guard tids.count <= 0 else {
            tids.append(contentsOf: frees)
            downloadSubscirbeBooks(tids)
            return
        }
        
        guard frees.count <= 0 else {
            MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: "\(kLocalized("YouNeverBook"))《\(vc.book.book_name)》，\(kLocalized("NeedDownL"))", trueBtnTitle: kLocalized("Down"), block: {[weak self] in
                if let strongSelf = self {
                    strongSelf.downloadFreeBooks()
                }
            })
            return
        }
        
        
        if vc.readModel.chapterList.count == vc.book.downTids.count {
            MQILoadManager.shared.makeToast(kLocalized("AlreadyDownLoadCh"))
        }else {
            MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLocalized("YouAlreadyBuy"), block: {[weak self] in
                if let strongSelf = self {
                    if MQIUserManager.shared.checkIsLogin() == false {
                        MQIloginManager.shared.toLogin(nil, finish: {
                            strongSelf.vc.pushToDownloadVC()
                        })
                    }else {
                        strongSelf.vc.pushToDownloadVC()
                    }
                }
            })
        }
        
    }
    
    func downloadFreeBooks() {
        GYBookDownloadManager.shared.toDownloadFreeBooks(vc.book,
                                                         list: vc.readModel.chapterList,
                                                         freeList: nil,
                                                         completion: {
                                                            
                                                            
        }, failed: { (code, msg) in
            if code == ALREADY_DOWNLOAD {
                MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLocalized("YouAlreadyDown"), block: {[weak self] in
                    if let strongSelf = self {
                        if MQIUserManager.shared.checkIsLogin() == false {
                            MQIloginManager.shared.toLogin(nil, finish: {
                                strongSelf.vc.pushToDownloadVC()
                            })
                        }else {
                            strongSelf.vc.pushToDownloadVC()
                        }
                    }
                    
                })
            }
        })
    }
    
    func downloadSubscirbeBooks(_ tids: [String]) {
        GYBookDownloadManager.shared.toDownloadAllSubscribe(vc.book, allList: vc.readModel.chapterList, tids: tids)
    }
    
    
    func requestBookInfo(_ bid: String, pageVC: MQIReadPageViewController) {
        pageVC.addPreloadView()
        isDownloading = true
        
        GYBookManager.shared.requestBookInfo(bid) { [weak self] (book, err_msg,code) in
            if let strongSelf = self {
                guard let result = book else  {
                    strongSelf.isDownloading = false
                    let type = strongSelf.getWrong(code: code!)
                    pageVC.addWrongView(err_msg!, type: type, refresh: {
                        strongSelf.operationWrong(type: type, completion: {
                            pageVC.dismissWrongView()
                            pageVC.addPreloadView()
                            
                            strongSelf.isDownloading = true
                            strongSelf.requestBookInfo(bid, pageVC: pageVC)
                        })
                    })
                    return
                }
                pageVC.dismissPreloadView()
                pageVC.dismissWrongView()
                strongSelf.vc.book = result
                strongSelf.vc.configRead()
            }
            
        }
        
        //
        //        GYBookInfoRequest(book_id: bid)
        //            .request({[weak self](request, response, result: MQIEachBook) in
        //                if let strongSelf = self {
        //                    pageVC.dismissPreloadView()
        //                    pageVC.dismissWrongView()
        //                    if let book = GYBookManager.shared.getDownloadBook(bid){
        //                        result.downTids = book.downTids
        //                        GYBookManager.shared.updateDownloadBook(result)
        //                    }
        //                    GYBookManager.shared.addDownloadBook(result)
        //
        //                    strongSelf.vc.book = result
        //                    strongSelf.vc.configRead()
        //                }
        //            }) {[weak self] (msg, code) in
        //                if let strongSelf = self {
        //                    strongSelf.isDownloading = false
        //                    let type = strongSelf.getWrong(code: code)
        //                    pageVC.addWrongView(msg, type: type, refresh: {
        //                        strongSelf.operationWrong(type: type, completion: {
        //                            pageVC.dismissWrongView()
        //                            pageVC.addPreloadView()
        //
        //                            strongSelf.isDownloading = true
        //                            strongSelf.requestBookInfo(bid, pageVC: pageVC)
        //                        })
        //                    })
        //                }
        //
        //        }
        
    }
    
    func getWrong(code: String) -> GYReadWrongType {
        var wrongType: GYReadWrongType!
        if Reachability(hostname: hostname).currentReachabilityStatus() == .NotReachable {
            wrongType = .needNetWork
        }else {
            
            let loginCode = code.integerValue()
            if code == "-1" {
                wrongType = .getChapterFaild
            }else if MQIUserManager.shared.checkIsLogin() == false || code == "-3" || ( loginCode >= 5000 && loginCode < 6000) {
                wrongType = .needLogin
            }else if code == "10501" || code == "9007" ||  code == "9008"{
                
                guard vc != nil , vc.book.checkIsWholdSubscribe() == true else {
                    wrongType = .needSubscribeChapter
                    //                     UserNotifier.postNotification(.refresh_coin) /// 订阅是刷新余额
                    return wrongType
                }
                
                wrongType = .needSubscribeBook
            }else if code == "11601" || code == "9006" {
                wrongType = .needCoin
            }else {
                if code == "6003" {
                    wrongType = .chapterError
                }else{
                    wrongType = .other
                }
            }
        }
        return wrongType
    }
    
    func checkWrong(_ type: GYReadWrongType, bid: String, tid: String, completion: @escaping ((_ unSubscribeChapter: MQIUnSubscribeChapter?,_ newType:GYReadWrongType) -> ())) {
        if type == .needLogin {
            completion(nil, type)
            return
        }
        
        GYChapterSubscibeInfoRequest(book_id: bid, chapter_id: tid)
            .request({ [weak self] (request, response, result: MQIUnSubscribeChapter) in
                let result_rew = result
                if let weakSelf = self, weakSelf.vc != nil {
                    result_rew.showBuyBtn = weakSelf.vc.is_new_book
                }
                if let user = MQIUserManager.shared.user {
                    if result.is_new_book  == "1" { /// 是新书 就弹新书样式
                        completion(result_rew,.newBook)
                        
                    }else{
                        if (user.user_coin.integerValue() + user.user_premium.integerValue()) >= result.price.integerValue() {
                            completion(result_rew,type)
                            
                            
                        }else {//余额不足自动判断
                            completion(result_rew,.needCoin)
                        }
                    }
                }else {
                    completion(result_rew,type)
                }
                
            }) { (msg, code) in
                completion(nil,type)
        }
    }
    
    func operationWrong(type: GYReadWrongType, completion: (() -> ())?) {
        switch type {
        case .needLogin:
            MQIUserOperateManager.shared.toLoginVC({
                GYBookManager.shared.getSubscribeChapterIds(book_id: self.vc.book.book_id, block: { (msg) in
                    completion?()
                })
            })
        case .needCoin:
            MQIUserOperateManager.shared.toPayVC(toPayChannel: .readerToPay) { (suc) in
                if suc {
                    completion?()
                }
                
            }
        case .needSubscribeChapter,.newBook:
            forceToPage = 0
            vc.readModel.readRecordModel.readChapterModel?.chapter_vip = true//有之前的免费章节，现在不免费了，要想请求vip接口，要这样做
            vc.readModel.readRecordModel.readChapterModel?.isSubscriber = true
            completion?()
        case .needSubscribeBook:
            subScribeRequest(0, book: vc.book, isWholeSubscribe: true, completion: { (result) in
                guard let _ = result else {
                    return
                }
                
                completion?()
            })
        case .needNetWork:
            forceToPage = 0
            completion?()
        case.chapterError:
            forceToPage = 0
            vc.currentReadViewController?.addPreloadView()
            vc.currentReadViewController?.dismissWrongView()
            GYBookManager.shared.getChapterList(vc.book, forceRefresh: true, completion: {[weak self] (list) in
                if let strongSelf = self {
                    if  strongSelf.vc != nil {
                        strongSelf.vc.currentReadViewController?.dismissPreloadView()
                        strongSelf.vc.readModel.chapterList = list
                        strongSelf.vc.listVC.chapterList = list
                        strongSelf.vc.readModel.readRecordModel.chapterIndex = NSNumber.init(value: 0)
                        strongSelf.vc.readModel.readRecordModel.readChapterModel = list[0]
                    }
                    completion?()
                }
                }, failed: { (code, msg) in
                    completion?()
            })
            
        default:
            completion?()
        }
    }
}
