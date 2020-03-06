//
//  MQIGoodVC.swift
//  Reader
//
//  Created by _CHK_  on 2018/1/10.
//  Copyright © 2018年 _xinmo_. All rights reserved.
//

import UIKit

import MJRefresh

class MQIGoodVC: MQIBaseViewController {
    var gdCollectionView:MQICollectionView!
    var mainRecommendArray = [MQIChoicenessListModel]()
    var isRefresh: Bool = false
    //    var isFooterRefresh = false
    fileprivate let limit = 10
    fileprivate var offset:NSInteger = 0
    fileprivate var topNavView:UIView!
   
    var isInfoVC:Bool = false
    
    override func viewWillLayoutSubviews() {
        if !isInfoVC {
           preloadView?.frame =  CGRect (x: 0, y:0, width: screenWidth, height: screenHeight - nav.height - status.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isInfoVC {
            nav.alpha = 0
            status.alpha = 0
    
            contentView.frame = CGRect(x: 0,y: 0, width: view.width, height: view.height-x_TabbarHeight-root_status_height-root_nav_height)
        }
       addCollectionView()
   
        addPreloadView()
        isRefresh = true
        request(offset: "0", limit: "10")
//         judgeGoodBooks_isHaveLocalCache()
      addNotifier()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
    
}

//MARK:  视图操作
extension MQIGoodVC {
    func addCollectionView()   {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: contentView.bounds,collectionViewLayout: layout)
        
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQIGoodCollectionViewCell.self, xib: false)
        gdCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.isRefresh = true
                weakSelf.offset = weakSelf.offset + 10
                weakSelf.request(offset: "\(weakSelf.offset)", limit: "\(weakSelf.limit)")
            }
        })
        
        gdCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]()->Void in
            if let strongSelf = self {
                strongSelf.offset = strongSelf.offset + 10
                strongSelf.request(offset: "\(strongSelf.offset)", limit: "\(strongSelf.limit)")
            }
        })
        
        contentView.addSubview(gdCollectionView)
        gdCollectionView.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            gdCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}

extension MQIGoodVC:MQICollectionViewDelegate {
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return mainRecommendArray.count
    }
    //    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
    //        return 0
    //    }
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18*gdscale, bottom: 0, right: 18*gdscale)
        //        return UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
       
        let eachModel = mainRecommendArray[indexPath.row]
        if mainRecommendArray.count - 1 == indexPath.row {
            return MQIGoodCollectionViewCell.getSize(eachModel.width, height: eachModel.height,lastItem: true,model: eachModel)
        }
        return MQIGoodCollectionViewCell.getSize(eachModel.width, height: eachModel.height, model: eachModel)
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let eachModel = mainRecommendArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQIGoodCollectionViewCell.self, forIndexPath: indexPath)
        if eachModel.isOpenRereesh == "1" {
            cell.isOpenRefresh = true
        }else{
            cell.isOpenRefresh = false
        }
        if eachModel.type == "ad" {
            cell.isAd = true
        }else{
            cell.isAd = false
        }
        cell.refreshBlock = {[weak self]()-> Void in
            if let weakSelf = self {
//                weakSelf.gdCollectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                weakSelf.gdCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.08) {
                    weakSelf.gdCollectionView.mj_header.beginRefreshing()
                }
//                 weakSelf.gdCollectionView.mj_header.beginRefreshing()
                
            }
        }
        cell.eachbookModel = eachModel
        return cell
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let eachModel = mainRecommendArray[indexPath.row]
        if eachModel.type == "ad" {
            if eachModel.ad_type == "lottery"{
                MQIUserOperateManager.shared.toSignVC()
            }else if eachModel.ad_type == "beneifit"{
//                let vc = GYWelfareCentre() //福利
//                pushVC(vc)
            }else if eachModel.ad_type == "link" && eachModel.ad_link != ""{
                let vc =  MQIWebVC()
                vc.url = eachModel.ad_link
                pushVC(vc)
            }
        }else{
            AAEnterReaderType.shared.enterType = .enterType_0
            MQIUserOperateManager.shared.toReader(eachModel.book_id)
          
        }
    }
    
    
    
}


extension MQIGoodVC {
    
    @objc  func login(){
        isRefresh = true
        offset = 0
        mainRecommendArray.removeAll()
        gdCollectionView.reloadData()
        request(offset: "0", limit: "10")
    }
    @objc func logout(){
        isRefresh = true
        offset = 0
        mainRecommendArray.removeAll()
        gdCollectionView.reloadData()
        request(offset: "0", limit: "10")
    }
    @objc func goTop(){
        gdCollectionView.scrollRectToVisible(CGRect (x: 0, y: 0, width: screenWidth, height: gdCollectionView.height), animated: true)
    }
    func addCustomNavigationView() {
        topNavView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: root_status_height+10))
        topNavView.layer.addDefineLayer(topNavView.bounds)
        view.addSubview(topNavView)
    }
    func judgeGoodBooks_isHaveLocalCache() {
        let goodBooks = MQILocalSaveDataManager.shared.readDataJingpin_books()
        if goodBooks.count > 0 {
            mainRecommendArray.removeAll()
            mainRecommendArray.append(contentsOf: goodBooks)
            gdCollectionView.reloadData()
            dismissPreloadView()
            
        }else {
            isRefresh = true
            request(offset: "0", limit: "10")
        }
        
    }
    
    
    
    func addNotifier() {
        UserNotifier.addObserver(self, selector: #selector(MQIGoodVC.goTop), notification: .gotop)
        UserNotifier.addObserver(self, selector: #selector(MQIGoodVC.login), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQIGoodVC.logout), notification: .login_out)
    }

}

//MARK:  网络请求
extension MQIGoodVC {
    func request(offset: String, limit: String) {
        
        GDChoicenessRequest(offset: offset, limit: limit).requestCollection({ [weak self](request, response, result:[MQIChoicenessListModel]) in
            if result.count > 0{
                if let weakSelf = self {
                    var tempArr = result
                    if offset == "0" {
                        if result.count > 0 {
                            for i in 0...result.count - 1{
                                if result[i].type == "ad"{
                                    let model = tempArr[i]
                                    tempArr.remove(at: i)
                                    if tempArr.count > 1{
                                        tempArr.insert(model, at: 1)
                                    }else{
                                        tempArr.insert(model, at: 0)
                                    }
                                }
                            }
                        }
                        MQILocalSaveDataManager.shared.SaveDataJingpin_Books(tempArr)
                    }
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    if result.count < weakSelf.limit {
                        weakSelf.gdCollectionView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf.gdCollectionView.mj_footer.endRefreshing()
                    }
                    
                    if weakSelf.isRefresh {
                        weakSelf.isRefresh = false
                        if weakSelf.mainRecommendArray.count > 0{
                            for i in 0...weakSelf.mainRecommendArray.count - 1{
                                if weakSelf.mainRecommendArray[i].isOpenRereesh == "1"{
                                    weakSelf.mainRecommendArray[i].isOpenRereesh = "0"
                                }
                            }
                            weakSelf.mainRecommendArray.first?.isOpenRereesh = "1"
                        }
                        weakSelf.mainRecommendArray.insert(contentsOf: tempArr, at: 0)
                    }else{
                        weakSelf.mainRecommendArray.append(contentsOf: tempArr)
                    }
                    weakSelf.gdCollectionView.reloadData()
                }
            }else{
                if let weakSelf = self {
                    //                    GYLoadManager.shared.makeToast("已经是最后一页啦")
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    weakSelf.gdCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
        }) { [weak self](msg, code) in
            if let weakSelf = self  {
                let goodBooks = MQILocalSaveDataManager.shared.readDataJingpin_books()
                if goodBooks.count > 0 {
                    weakSelf.mainRecommendArray.removeAll()
                    weakSelf.mainRecommendArray.append(contentsOf: goodBooks)
                    weakSelf.gdCollectionView.reloadData()
                    weakSelf.dismissPreloadView()
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                }else {
                    MQILoadManager.shared.makeToast(msg)
                    weakSelf.dismissPreloadView()
                    //                    weakSelf.dismissWrongV()
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                    
                    if weakSelf.isRefresh {
                        weakSelf.isRefresh = false
                        guard weakSelf.mainRecommendArray.count <= 0 else{
                            return
                        }
                    }
                    weakSelf.addWrongView(msg, refresh: {
                        weakSelf.request(offset: offset, limit: limit)
                    })
                    
                }
            }
        }
    }
    
}
