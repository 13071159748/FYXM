//
//  MQIRankVC.swift
//  Reader
//
//  Created by _CHK_  on 2018/1/19.
//  Copyright © 2018年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */
import MJRefresh

struct GDOffSet {
    var type :String = "0"
    var key:CGFloat = 0
}

class MQIRankVC: MQIBaseViewController ,MQITableViewDelegate{
    //    fileprivate var leftTitleArray = [MQIRankTypesModel]()//title models
    fileprivate var gdleftTableView:MQIRankLeftTableView!
    fileprivate var gdRightTableView:MQITableView!
    
    fileprivate var gd_TableOffsets = [GDOffSet]()
    
    //当前
    fileprivate var current_Type:String = ""
    fileprivate var currentRightDataArray:[MQIMainEachRecommendModel] = [MQIMainEachRecommendModel]()//models 当前选中的
    
    fileprivate var all_Right_Array = [MQIRankRightSaveModel]() //显示的当前所有数据
    
    fileprivate var local_allRight_Array = [MQIRankRightSaveModel]()//本地所有的right数据
    
    fileprivate var local_Left_Array = [MQIRankTypesModel]()
    
    fileprivate let leftWidth:CGFloat = 106*gdscale > 106 ? 106 : 106*gdscale
    
    fileprivate var rightloadingView:MQIPreloadView!
    
    fileprivate var limit = "20"
    fileprivate let startOffSet = "0"
    fileprivate var isFooterRefresh :Bool = false
    fileprivate var isHeaderRefresh:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.alpha = 0
        nav.alpha = 0
        addPreloadView()
        addContentTableView()
        configLeftView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
}

extension MQIRankVC {
    
    func recordOffSet() {
        let offset = gdRightTableView.contentOffset.y
        let gdoffset = GDOffSet(type: current_Type, key: offset)
        if let _ = gd_TableOffsets.filter({$0.type == current_Type}).first {
            for index in 0..<gd_TableOffsets.count {
                if gd_TableOffsets[index].type == current_Type {
                    gd_TableOffsets[index] = gdoffset
                }
            }
        }else {
            gd_TableOffsets.append(gdoffset)
        }
    }
    //滚动到记录位置
    func scrollToRecordOffSet() {
        if let offset = gd_TableOffsets.filter({$0.type == current_Type}).first {
            let content_Height = gdRightTableView.contentSize.height
            if offset.key > content_Height {
                gdRightTableView.setContentOffset(CGPoint.init(x: 0, y: content_Height), animated: false)
            }else {
                gdRightTableView.setContentOffset(CGPoint(x:0,y:offset.key), animated: false)
            }
        }else {
            gdRightTableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            
        }
        
    }
    
    func loadLocalTitleData() {
        
        let localTitles = MQILocalSaveDataManager.shared.readDataJingpin_LeftTitle()
        if localTitles.count > 0 {
            //reload rankLeftDatas
            //看第一条
            local_Left_Array = localTitles
            gdleftTableView.rankLeftDatas = local_Left_Array
            dismissPreloadView()
            loadCacheContentData(type: localTitles[0].type)
        }
    }
    //获取cache 系统内存的数据
    func loadCacheContentData(type:String) {
        
        current_Type = type
        //当前有数据
        guard all_Right_Array.count <= 0 else {
            //缓存有数据
            let model = all_Right_Array.filter({$0.rank_type == type}).first
            guard let existModel = model else {
                addRightPreloadView()
                net_detailContentRequest(type: type, offset: startOffSet, limit: limit)
                return
            }
            currentRightDataArray = existModel.books
            gdRightTableView.reloadData()
            scrollToRecordOffSet()
            dismissRightLoadingView()
            return
        }
        //从沙盒拿
        loadLocalSandboxContentData(type: type)
    }
    //获取沙盒内数据
    func loadLocalSandboxContentData(type:String) {
        
        local_allRight_Array = MQILocalSaveDataManager.shared.readDataJingpin_rightContents()
        guard local_allRight_Array.count > 0 else {
            //拿着type 请求net
            addRightPreloadView()
            net_detailContentRequest(type: type, offset: startOffSet, limit: limit)
            return
        }
        all_Right_Array = local_allRight_Array//给沙盒
        let model = local_allRight_Array.filter({$0.rank_type == type}).first
        guard let existModel = model else {
            //拿着type 请求net
            addRightPreloadView()
            net_detailContentRequest(type: type, offset: startOffSet, limit: limit)
            return
        }
        //本地有当前type 的 content
        currentRightDataArray = existModel.books
        gdRightTableView.reloadData()
        scrollToRecordOffSet()
        dismissRightLoadingView()
        
    }
}

extension MQIRankVC {
    
    func addContentTableView() {
        gdRightTableView = MQITableView(frame: CGRect(x: leftWidth, y: 0, width: screenWidth-leftWidth, height: screenHeight-root_nav_height-root_status_height-x_TabbarHeight))
        gdRightTableView.gyDelegate = self
        gdRightTableView.backgroundColor = UIColor.white
        gdRightTableView.registerCell(MQIRankRightCell.self, xib: false)
        gdRightTableView.tableFooterView = UIView()
        view.addSubview(gdRightTableView)
        gdRightTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.isHeaderRefresh = true
                weakSelf.net_detailContentRequest(type: weakSelf.current_Type, offset: weakSelf.startOffSet, limit: weakSelf.limit)
            }
        })
        gdRightTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.isFooterRefresh = true
                weakSelf.net_detailContentRequest(type: weakSelf.current_Type, offset: "\(weakSelf.currentRightDataArray.count)", limit: weakSelf.limit)
            }
        })
        if #available(iOS 11.0, *) {
            gdRightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        gdRightTableView.estimatedRowHeight = 0
        gdRightTableView.estimatedSectionFooterHeight = 0
        gdRightTableView.estimatedSectionHeaderHeight = 0
        
        
        
        
    }
    func configLeftView() {
        gdleftTableView = MQIRankLeftTableView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: screenHeight-root_nav_height-root_status_height-x_TabbarHeight))
        gdleftTableView.rankSelected = {[weak self](model)->Void in
            if let weakSelf = self {
                weakSelf.isHeaderRefresh = false//new
                weakSelf.isFooterRefresh = false//new
                weakSelf.gdRightTableView.mj_header.endRefreshing()//new
                weakSelf.gdRightTableView.mj_footer.endRefreshing()//new
                weakSelf.dismissRightLoadingView()
                
                weakSelf.recordOffSet()
                weakSelf.current_Type = model.type
                weakSelf.loadCacheContentData(type: model.type)
            }
        }
        view.addSubview(gdleftTableView)
        
        loadLocalTitleData()
        net_headerRequest()
        
    }
    
    fileprivate func addRightPreloadView() {
        if rightloadingView == nil {
            rightloadingView = MQIPreloadView(frame: gdRightTableView.frame)
            view.addSubview(rightloadingView)
        }
        rightloadingView.backgroundColor = UIColor.clear
    }
    fileprivate func dismissRightLoadingView() {
        if let _ = rightloadingView {
            //            rightLoadView.dismiss({[weak self]()->Void in
            //                if let weakSelf = self {
            //                    weakSelf.rightloadingView = nil
            //                }
            //            })
            rightloadingView.removeFromSuperview()
            rightloadingView = nil
        }
    }
}


extension MQIRankVC {
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return currentRightDataArray.count
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQIRankRightCell.getSizeHeight()
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIRankRightCell.self, forIndexPath: indexPath)
        let model = currentRightDataArray[indexPath.row]
        cell.model = model
       
        return cell
    }
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let eachModel = currentRightDataArray[indexPath.row]
        AAEnterReaderType.shared.enterType = .enterType_0
        MQIUserOperateManager.shared.toReader(eachModel.book_id)

        
        //        let readEndVC = GDReadEndVC()
        //        readEndVC.bookId = eachModel.book_id
        //        pushVC(readEndVC)
        
        
    }
    
    
}

extension MQIRankVC {
    
    func net_headerRequest() {
        //如果本地有，就直接显示本地的，然后请求的时候，请求下来之后存到本地，下次进应用再读新数据
        //请求下来之后拿着第一个model  请求详情接口  刷新两个tableview
        //如果count > 0    type  name
        GDRankTypesRequest().requestCollection({ [weak self](request, response, result:[MQIRankTypesModel]) in
            if  let weakSelf = self {
                weakSelf.dismissPreloadView()
                weakSelf.dismissWrongView()
                if weakSelf.local_Left_Array.count <= 0 {//本地没titles 刷新
                    weakSelf.gdleftTableView.rankLeftDatas = result
                    //刷新之后 load第一个type的content
                    if result.count > 0 {
                        weakSelf.loadCacheContentData(type: result[0].type)
                    }
                }
                MQILocalSaveDataManager.shared.SaveData_JingpinTitle(array: result)
            }
        }) { [weak self](errMsg, errcode) in
            if let weakSelf = self {
                weakSelf.dismissPreloadView()
                weakSelf.title_loadfailed()
            }
        }
    }
    func title_loadfailed() {
        addWrongView(kLocalized("NewError"),refresh:{[weak self]()-> Void in
            if let weakSelf = self {
                weakSelf.net_headerRequest()
                weakSelf.wrongView?.setLoading()
            }
        })
        wrongView?.frame = CGRect(x: 0, y: -nav.height - status.height, width: screenWidth, height: screenHeight)
    }
    
    func net_detailContentRequest(type:String,offset:String,limit:String) {
        
        GDRankListRequest(type: type, offset: offset, limit: limit).requestCollection({ [weak self](request, response, result:[MQIMainEachRecommendModel]) in
            if let weakSelf = self {
                if weakSelf.current_Type == type {//新加的
                    
                    weakSelf.gdRightTableView.mj_header.endRefreshing()
                    weakSelf.gdRightTableView.mj_footer.endRefreshing()
                    //                    weakSelf.dismissRightWrongView()
                    weakSelf.dismissRightLoadingView()
                    if weakSelf.isFooterRefresh {
                        for each in result {
                            weakSelf.currentRightDataArray.append(each)
                        }
                    }else {
                        weakSelf.currentRightDataArray = result
                    }
                    let saveModel = MQIRankRightSaveModel()
                    saveModel.rank_type = type
                    saveModel.books = weakSelf.currentRightDataArray
                    weakSelf.replaceModelWith(model: saveModel)
                    
                    weakSelf.gdRightTableView.reloadData()
                    if weakSelf.isFooterRefresh != true && weakSelf.isHeaderRefresh != true {
                        weakSelf.scrollToRecordOffSet()
                    }
                    weakSelf.isHeaderRefresh = false
                    weakSelf.isFooterRefresh = false
                    
                    if offset == weakSelf.startOffSet {//把array存储到本地
                        MQILocalSaveDataManager.shared.SaveData_JingpinContents(array: weakSelf.all_Right_Array)
                    }
                    
                }
                
                
                
            }
            
        }) { [weak self](err_msg, err_code) in
            if let weakSelf = self {
                if weakSelf.current_Type == type {
                    weakSelf.dismissRightLoadingView()
                    weakSelf.gdRightTableView.mj_header.endRefreshing()
                    weakSelf.gdRightTableView.mj_footer.endRefreshing()
                    
                    weakSelf.isHeaderRefresh = false
                    weakSelf.isFooterRefresh = false//是上拉加载失败的
                    
                    
                }
                
            }
        }
    }
    
    //更新-新数据
    func replaceModelWith(model:MQIRankRightSaveModel) {
        
        if let _ = all_Right_Array.filter({$0.rank_type == model.rank_type}).first {
            for index in 0..<all_Right_Array.count {
                if all_Right_Array[index].rank_type == model.rank_type {
                    all_Right_Array[index] = model
                }
            }
        }else {
            all_Right_Array.append(model)
        }
        
        
        
    }
    
}
