//
//  MQISelectViewController.swift
//  XSDQReader
//
//  Created by moqing on 2018/10/16.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

import MJRefresh

class MQISelectViewController: MQIBaseViewController {
    
    fileprivate var customNavView:UIView!
    var gdCollectionView:MQICollectionView!
    var mainRecommendArray = [MQIMainRecommendModel]()
    var isRefresh: Bool = false
    //    var isFooterRefresh = false
    fileprivate let limit = 10
    fileprivate var offset:NSInteger = 0
    var books = [MQIChoicenessListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.backgroundColor = UIColor.colorWithHexString("D4D7EA")
     
        addgdCollectionView()
        setgdCollectionViewFunc()
        addPreloadView()
        isRefresh = true
        request(offset: "0", limit: "10")
        registereNotifier()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func registereNotifier()  {
        UserNotifier.addObserver(self, selector: #selector(MQISelectViewController.goTop), notification: .gotop)
        UserNotifier.addObserver(self, selector: #selector(MQISelectViewController.login), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQISelectViewController.logout), notification: .login_out)
    }
    
    
}

extension MQISelectViewController:MQICollectionViewDelegate {
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return books.count
        
    }
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 9
    }
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
    }
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        return  MQISelectCollectionViewCell.getSize(lastItem: false, model: books[indexPath.row])
        
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let eachModel = books[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQISelectCollectionViewCell.self, forIndexPath: indexPath)
        cell.eachbookModel = eachModel
        cell.clickLast_time_readBlock = { [weak self] in
            if let weakSelf = self {
                weakSelf.gdCollectionView.scrollRectToVisible(CGRect (x: 0, y: 0, width: screenWidth, height: weakSelf.gdCollectionView.height), animated: true)
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    weakSelf.gdCollectionView.mj_header.beginRefreshing()
                }
            }
            
        }
        return cell
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        
        let book_id = books[indexPath.row].book_id
        MQIUserOperateManager.shared.toReader(book_id)
        MQIEventManager.shared.appendEventData(eventType: .boutique_book, additional: ["book_id":book_id])
        
    }
    
}


extension MQISelectViewController {
    
    @objc func toSearch(_ btn: UIButton) {
        let vc = MQISearchViewController()
        pushVC(vc)
    }
    
    @objc  func login(){
        isRefresh = true
        offset = 0
        books.removeAll()
        gdCollectionView.reloadData()
        request(offset: "0", limit: "10")
    }
    @objc func logout(){
        isRefresh = true
        offset = 0
        books.removeAll()
        gdCollectionView.reloadData()
        request(offset: "0", limit: "10")
    }
    
    @objc func goTop(){
        gdCollectionView.scrollRectToVisible(CGRect (x: 0, y: 0, width: screenWidth, height: gdCollectionView.height), animated: true)
    }
    
    func judgeGoodBooks_isHaveLocalCache() {
        let goodBooks = MQILocalSaveDataManager.shared.readDataJingpin_books()
        if goodBooks.count > 0 {
            books.removeAll()
            books.append(contentsOf: goodBooks)
            gdCollectionView.reloadData()
            dismissPreloadView()
            
        }else {
            isRefresh = true
            request(offset: "0", limit: "10")
        }
        
    }
    
}
extension MQISelectViewController {
    
    func request(offset: String, limit: String) {
        
        GDChoicenessRequest(offset: offset,limit: limit).requestCollection({ [weak self] (request, response, resultOld:[MQISelectDataModel]) in
            
            if let weakSelf = self {
                weakSelf.dismissPreloadView()
                weakSelf.gdCollectionView.mj_header.endRefreshing()
                weakSelf.gdCollectionView.mj_footer.endRefreshing()
                //                weakSelf.gdCollectionView.mj_footer.resetNoMoreData()
                guard let resultNEW = resultOld.first else {
                    return
                }
                let  result = resultNEW.books
                if result.count == 0 {
                    return
                }
                //                if offset == "0" {
                //                    MQILocalSaveDataManager.shared.SaveDataJingpin_Books(result)
                //
                //                }
                if weakSelf.isRefresh {
                    if offset != "0" {
                        for  m in  weakSelf.books {m.last_time_read = ""}
                        result.last?.last_time_read = "上次浏览到这里，点此刷新"
                        weakSelf.books.insert(contentsOf: result, at: 0)
                    }else{
                        weakSelf.books.last?.last_time_read = ""
                        weakSelf.books.insert(contentsOf: result, at: 0)
                    }
                }else{
                    weakSelf.books.append(contentsOf: result)
                }
                
                weakSelf.gdCollectionView.reloadData()
            }
            
            
        }) { [weak self](msg, code) in
            if  let weakSelf = self  {
                //                let goodBooks = MQILocalSaveDataManager.shared.readDataJingpin_books()
                //                if goodBooks.count == 0 {
                //                    weakSelf.addWrongView(msg, refresh: {
                //                        weakSelf.request(offset: offset, limit: limit)
                //                    })
                //                }else{
                //                     MQILoadManager.shared.makeToast(msg)
                //                    weakSelf.dismissPreloadView()
                //                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                //                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                //                }
                MQILoadManager.shared.makeToast(msg)
                weakSelf.dismissPreloadView()
                weakSelf.gdCollectionView.mj_header.endRefreshing()
                weakSelf.gdCollectionView.mj_footer.endRefreshing()
                
            }
        }
        
    }
}
extension  MQISelectViewController {
    func setgdCollectionViewFunc()   {
        gdCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.isRefresh = true
                weakSelf.request(offset: "\(weakSelf.books.count)", limit: "\(weakSelf.limit)")
            }
        })
        
        gdCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]()->Void in
            if let strongSelf = self {
                strongSelf.isRefresh  = false
                strongSelf.request(offset: "\(strongSelf.books.count)", limit: "\(strongSelf.limit)")
            }
        })
        
        contentView.addSubview(gdCollectionView)
        //        gdCollectionView.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            gdCollectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    func addgdCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: CGRect(x: 0, y: 1, width: contentView.width, height: contentView.height-1),collectionViewLayout: layout)
        gdCollectionView.backgroundColor = UIColor.white
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQISelectCollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQISelectMultipleCollectionViewCell.self, xib: false)
      
    }
    
    /// 上部导航栏
    func addTopView() {
        
        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        customNavView.layer.addDefineLayer(customNavView.bounds)
        view.addSubview(customNavView)
        
        let titlelable =  UILabel(frame: CGRect(x: 15, y: kUIStyle.kStatusBarHeight , width: 100, height: 42))
        titlelable.font  = UIFont.boldSystemFont(ofSize: 18)
        titlelable.textAlignment = .center
        titlelable.textColor = kUIStyle.colorWithHexString("#FFFFFF")
        customNavView.addSubview(titlelable)
        titlelable.centerX  = customNavView.centerX
        titlelable.text =  self.tabBarController?.selectedViewController?.tabBarItem.title
        //
        let  searchbutton = view.addCustomButton(CGRect.init(x: customNavView.width - 40, y: 0, width: 22, height: 22), title: nil, action: {[weak self] (btn) in
            if let weakSelf = self{
                weakSelf.toSearch(btn)
            }
        })
        searchbutton.centerY = titlelable.centerY
        let image =  UIImage(named: "shelf_searchBtn")?.withRenderingMode(.alwaysTemplate)
        searchbutton.setImage(image, for: .normal)
        searchbutton.tintColor = UIColor.white
        customNavView.addSubview(searchbutton)
        
    }
}




