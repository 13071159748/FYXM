//
//  MQIBookStoreBaseViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh
import SDWebImage

let MQIBookStore_FooterCellID = "MQIBookStore_FooterCellID"
let MQIBookStore_HeaderCellID = "MQIBookStore_HeaderCellID"
struct BSRefreshFinish {//判断刷新是否结束   三个都结束才结束
    var banner_RFinish:Bool
    var nav_RFinish:Bool
    var recommends_RFinish:Bool
}
struct BSReloadFinishAppearError {//判断加载失败  三个都失败才显示失败 只在最后提示一次
    var banner_loadFinish:Bool
    var nav_loadFinish:Bool
    var recommends_loadFinish:Bool
}

class MQIBookStoreViewController: MQIBaseViewController {
    var bannerView:MQIBanneStorerView!
    
    //banner
    var gdCollectionView:MQICollectionView!
    
    var bknavView:MQIBookStoreNavViewABC!//导航按钮
    
    var adSenseView: MQIMarqueeView?//跑马灯广告位
    
    var topBGView: UIView!
    
    //bannerArray
    var mainBannerArray = [MQIMainBannerModel]()
    //nav分来
    var mainNavArray = [MQIMainNavModel]()
    //推荐列表
    var mainRecommendArray = [MQIMainRecommendModel]()
    //广播广告位
    var mainAdArray = [MQIPopupAdsenseListModel]()
    
    //检查是否全部加载成功----刷新
    var is_refreshFinished:BSRefreshFinish!
    //检测是否全部失败 -- 加载弹窗
    var isAll_LoadError:BSReloadFinishAppearError!
    //创建定时器
    var timer_Update:Timer!
    fileprivate var customNavView:UIView!

    fileprivate var welfareView:FLAnimatedImageView!
    
    fileprivate  var rightBtn:UIButton!
    fileprivate  var searchBtn:UIButton!
    
    fileprivate  var toastView: UIView!
    fileprivate  var toastSelectedbBtn: UIButton?
    fileprivate  var guessyoulikeModel = MQIMainRecommendModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if let rightBtn = self.rightBtn {
            if rightBtn.isSelected {
                return UIStatusBarStyle.lightContent
            }else{
                return UIStatusBarStyle.default
            }
        }
       return UIStatusBarStyle.default
    }
    
    var appdelegate: AppDelegate? {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            return appdelegate
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.white
        mqLog(NSHomeDirectory())
      
        addNotifier()
        hiddenNav()
        
        contentView.frame = CGRect(x: 0,y: 0, width: view.width,  height:view.height - x_TabbarHeight)
        
        addTopView()
        
        addcollectionView()
   
        addBannerView()

        addWelfareView()
        
        subViewCallback()
        
        if MQ_SectionManager.shared.showHobbyView() {
             MQIVersionBouncedView.show()
            if cacheTime() {
                judgeBanner_Nav_Recommends_LocalCache()
                gdCollectionView.mj_header.beginRefreshing()
            }else{
                judgeBanner_Nav_Recommends_LocalCache()
            }
        }
        setRightBtnState()
        setDefaultguessyoulikeData()
        ruoKan_differentWithNormal()
        registerPushToken()
        MQINewUserActivityManager.shared.upLoadUserFirstLogin()
        getHomeNotification()
        if  MQIUserManager.shared.checkIsLogin() {
            MQIUserManager.shared.updateUserState(checkedIn: 1)
        }
        createTimer()
     
        
    }
    override func switchLanguage() {
        super.switchLanguage()
        gdCollectionView.mj_header?.beginRefreshing()
        searchBtn.setTitle(   "  "+"  "+kLocalized("PleaseEnterTheTitleOrAuthorName"), for: .normal)
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MQINewUserActivityManager.shared.isShowWelfareTask() == false {
            //超过2小时，请求活动弹窗接口
            MQINewUserActivityManager.shared.requestDataForAFixedDuration()
            
            //展示活动弹窗
            showActivities()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setSectionID() {
        super.setSectionID()
        setRightBtnState()
        addPreloadView()
        loadBookstoreBanner()
        loadBookstoreNavRequest()
        loadBookstoreRecommendsRequest()
        getPopupAdsenseList()
        if MQIShelfManager.shared.shelf_judgeIsFirstRequestRecommendsBooks(){
            MQIShelfManager.shared.shelf_requestRecommends()
        }
    }
    /// 刷新时长 30分钟
    let duration_Time = 60*30
    let cacher_refresh_time_key = "home_cacher_refresh_time_key"
    /// 数据缓存时间
    @discardableResult   func cacheTime(_ start:String? = nil ) -> Bool {
        if start == nil {
            if getCurrentStamp() - UserDefaults.standard.integer(forKey: cacher_refresh_time_key)  > duration_Time {
                return true
            }else{
                return false
            }
        }else{
            UserDefaults.standard.set(getCurrentStamp(), forKey: cacher_refresh_time_key)
            return UserDefaults.standard.synchronize()
        }
        
        
    }
  
    func subViewCallback()  {
        bannerView.clickItemToIndex = { [weak self](index) in
            self?.gdbannerSelected(index)
        }
        
        bknavView.bookStoreNavBtnClick = {[weak self](index)-> Void in
            if let weakSelf = self {
                let bannerModel = weakSelf.mainNavArray[index]
                mqLog(bannerModel.url)
                if bannerModel.app_link == "" {
                    if bannerModel.url.range(of: "pay") != nil {
                        MQIUserOperateManager.shared.toPayVC(nil)
                        
                    }else if bannerModel.url.hasSuffix("top") {
                        let rankVC = MQIRankViewController.create()!
                        weakSelf.pushVC(rankVC)
                    }
                    else {
                        let vc = MQIWebVC()
                        vc.url = bannerModel.url
                        mqLog(bannerModel.url)
                        weakSelf.pushVC(vc)
                    }
                }else{
                    if bannerModel.app_link.hasSuffix("hot") {   ///热门
                        let vc = MQIDoneBookViewController.create() as! MQIDoneBookViewController
                        vc.title = bannerModel.title
                        vc.m_order = "3"
                        weakSelf.pushVC(vc)
                        
                    }else if bannerModel.app_link.hasSuffix("latest") {//最新
                        let vc = MQIDoneBookViewController.create() as! MQIDoneBookViewController
                        vc.title = bannerModel.title
                        vc.m_update = "4"
                        weakSelf.pushVC(vc)
                        
                        
                    }else if bannerModel.app_link.hasSuffix("ranking") {///排行
                        //                        let vc = GDRankViewController()
                        //                        vc.title = bannerModel.title
                        //                        weakSelf.pushVC(vc)
                        //
                        let vc = MQIRankViewController.create()!
                        vc.title = bannerModel.title
                        weakSelf.pushVC(vc)
                    }
                    else if bannerModel.app_link.hasSuffix("boutique") { /// 精选
                        let vc = MQISelectViewController.create()!
                        vc.title =  bannerModel.title
                        weakSelf.pushVC(vc)
                        
                    }
                        
                    else if bannerModel.app_link.hasSuffix("genre") { ///分类
                        let vc = MQIClassificationViewController.create()!
                        vc.title = bannerModel.title
                        weakSelf.pushVC(vc)
                        
                    }
                    else if bannerModel.app_link.hasSuffix("done") { ///完本
                        let vc = MQIDoneBookViewController.create() as! MQIDoneBookViewController
                        vc.title = bannerModel.title
                        vc.m_status = "2"
                        weakSelf.pushVC(vc)
                    }
                    
                }
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ collectionView: MQICollectionView) {

    }

}

extension MQIBookStoreViewController:MQICollectionViewDelegate {
    
    //MARK: Delegate
    func numberOfCollectionView(_ collectionView:MQICollectionView) -> Int {
        
        return mainRecommendArray.count
    }
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        
        let model = mainRecommendArray[section]
          mqLog("\( model.type)")
        if model.type == "6" || model.type == "7"  {
           return model.topics.count
        }
        
        if  (model.type == "31" && model.topics.count > 0) || model.type == "127" || model.type == "128" {
            return 1
        }

        return model.books.count
        
    }
    //横向距离   每个cell的
   
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {

        return Book_Store_Manger
    }
    
    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: Book_Store_Manger, bottom: 10, right: Book_Store_Manger)
        
    }
    
    //设置footer header View
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        //header
        if kind == UICollectionView.elementKindSectionHeader {
             let commendModel:MQIMainRecommendModel = mainRecommendArray[indexPath.section]
             if commendModel.name == "" {
                return UICollectionReusableView()
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MQIBookStore_HeaderCellID, for: indexPath) as! MQIBookStoreHeaderCollectionReusableViewABC
            
            header.newLabel?.removeFromSuperview()
            header.newLabel = nil
            header.removeNSNotificationCenter()
     
            header.addheaderView()
            header.header_title?.text = commendModel.name
            header.commendModel = commendModel
            if commendModel.type == "1"{
                mqLog("commendModel.limitTime==\(commendModel.limitTime)")
            }

            if commendModel.limit_time != "" {
                header.timeIntervalSecond = commendModel.limit_time
                header.registerNSNotificationCenter()
                header.dsc_title?.isHidden = true
                header.rightBtn?.setTitle("更多免费", for: .normal)
            }else if   commendModel.type == "dsy" {
                header.newLabel.isHidden = true
                header.newTitleLabel?.isHidden = true
                header.dsc_title?.isHidden = true
                header.rightBtn?.setTitle("", for: .normal)
            }
            else{
                  header.newLabel.isHidden = true
                  header.newTitleLabel?.isHidden = true
                 header.dsc_title?.isHidden = false
                 header.rightBtn?.setTitle("查看更多", for: .normal)
            }
            header.dsc_title?.text = commendModel.title
            header.clickRightBtn_block = { [weak self] (id)in
                guard let weakSelf = self else { return }
                if commendModel.limit_time != "" {
                     MQIOpenlikeManger.openLike("https://h5/wish/index/\(MQ_SectionManager.shared.section_ID.rawValue)")
                }else{
                    if let id = id {
                        let vc = MQIMoreBookViewController()
                        vc.tj_id = id
                        weakSelf.pushVC(vc)
                    }
                   
                }
            }
            header.dsc_title?.isHidden = false
            if !commendModel.title.isEmpty {
                header.dsc_title?.text = commendModel.title
            } else {
                header.dsc_title?.text = ""
            }
            
            return header
            
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MQIBookStore_FooterCellID, for: indexPath) as! MQIBookStoreFooterCollectionReusableViewABC
            footer.addFooterLine()
            if mainRecommendArray.count - 1 == indexPath.section {
                footer.backgroundColor = UIColor.white
            } else {
                footer.backgroundColor = UIColor.colorWithHexString("#F4F7FA")
            }
            return footer
        }
        return UICollectionReusableView()
        
    }
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        let commendModel:MQIMainRecommendModel = mainRecommendArray[section]
        if commendModel.name == "" {
            
            return CGSize.zero
        }

        return CGSize(width: screenWidth, height: 36*gdscale)
        
    }
    func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        
        let commendModel:MQIMainRecommendModel = mainRecommendArray[section]
        if commendModel.type == "102" || commendModel.type == "101" {
            return CGSize(width: screenWidth, height: 8)
        }
        
        if mainRecommendArray.count - 1 == section {
            return CGSize(width: screenWidth, height: 10)
        }
        
        return CGSize(width: screenWidth, height: 0)
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        
        let commendModel:MQIMainRecommendModel = mainRecommendArray[indexPath.section]
//        mqLog(commendModel.type)
        //版本1.5.0 用到127 128 101-103
        switch commendModel.type {
        case "127":
            return MQIRecommendTopicsCollectionViewCell.getSize()
        case "128":
            return MQIRecommendTopicsTwoCollectionViewCell.getSize()
            
        case "101":
            //单本书
            return MQIBookTypeOneCollectionCellABC.getSize()
        case "102":
            //左边是书右边是介绍
            return MQIBookTypeTwoCollectionCellABC.getSize()
        case "103":
            if indexPath.row < 1 {
                //介绍
                return MQIBookTypeTwoCollectionCellABC.getSize()
            }else{
                //单本书
                return MQIBookTypeOneCollectionCellABC.getSize()
            }
            
        case "108":
            if indexPath.row < 1 {
                
                return MQIBookTypeTwoCollectionCellABC.getSize()
            }else {
                
                return MQIBookTypeThreeCollectionCellABC.getSize()
            }
            
        case "112":
            if indexPath.row > 5 {
                //左边是书右边是介绍
                return MQIBookTypeTwoCollectionCellABC.getSize()
            }else {
                //横行的
                return MQIBookTypeOneCollectionCellABC.getSize()
            }
            
        case "dsy":
            let c = indexPath.row % 6
            if c > 2 {
                //单本书
                return MQIBookTypeOneCollectionCellABC.getSize()
            }else{
                //横行的
                return MQIBookTypeTwoCollectionCellABC.getSize()
            }
        default:
            return MQIBookTypeTwoCollectionCellABC.getSize()
        }
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let commendModel:MQIMainRecommendModel = mainRecommendArray[indexPath.section]
        
        if commendModel.type == "31" {
            let cell = collectionView.dequeueReusableCell(MQIBookTypeBannerCollectionCellABC.self, forIndexPath: indexPath)
            cell.banners = commendModel.topics
            return cell
        } else if commendModel.type == "127" {
            let cell = collectionView.dequeueReusableCell(MQIRecommendTopicsCollectionViewCell.self, forIndexPath: indexPath)
            cell.indexModel = commendModel
            cell.tapItemBlock = {[weak self](type, urlOrBookId) in
                guard let weakSelf = self else { return }
                if type == .bookIdType {
                    weakSelf.pushBookInfo(urlOrBookId)
                } else {
                    weakSelf.openLink(url: urlOrBookId)
                }
                
            }
            return cell
        } else if commendModel.type == "128" {
            
            let cell = collectionView.dequeueReusableCell(MQIRecommendTopicsTwoCollectionViewCell.self, forIndexPath: indexPath)
            cell.indexModel = commendModel
            cell.tapItemBlock = {[weak self](url) in
                guard let weakSelf = self else { return }
                weakSelf.openLink(url: url)
            }
            return cell
        }
        
        
        let eachModel:MQIMainEachRecommendModel = commendModel.books[indexPath.row]
        switch commendModel.type {
            
        case "101":
            //单本书
            let cell = collectionView.dequeueReusableCell(MQIBookTypeOneCollectionCellABC.self, forIndexPath: indexPath)
            cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            //            cell.nameLabel?.text = eachModel.book_name
            cell.bookNameText = eachModel.book_name
            return cell
            
        case "102":
            //左边是书右边是介绍
            let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
            cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            cell.book_nameLabel?.text = eachModel.book_name
            cell.statusText = eachModel.subclass_name
            cell.classText = eachModel.book_words
            cell.bookcontentText = eachModel.book_intro
            return cell
            
        case "103": //1+3
            if indexPath.row < 1 {
                
                //左边是书右边是介绍
                let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.book_nameLabel?.text = eachModel.book_name
                cell.statusText = eachModel.subclass_name
                cell.classText = eachModel.book_words
                cell.bookcontentText = eachModel.book_intro
                return cell
            } else {
                //单本书
                let cell = collectionView.dequeueReusableCell(MQIBookTypeOneCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.bookNameText = eachModel.book_name
                return cell
            }
            
        case "108":
            if indexPath.row < 1 {
                let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.book_nameLabel?.text = eachModel.book_name
                cell.statusText = eachModel.subclass_name
                cell.classText = eachModel.book_words
                cell.bookcontentText = eachModel.book_intro
                return cell
            } else {
                
                let cell = collectionView.dequeueReusableCell(MQIBookTypeThreeCollectionCellABC.self, forIndexPath: indexPath)
                cell.book_nameLabel?.text = eachModel.book_name
                cell.book_introLabel?.text = eachModel.book_intro
                //                cell.classText = eachModel.book_label
                //                cell.statusText = eachModel.book_status
                cell.class_nameLabel?.isHidden = true
                cell.book_StatusLabel?.isHidden = true
                return cell
            }
            
        case "112":
            if indexPath.row > 5 {
                let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.book_nameLabel?.text = eachModel.book_name
                cell.statusText = eachModel.subclass_name
                cell.classText = eachModel.book_words
                cell.bookcontentText = eachModel.book_intro
                return cell
            } else {
                
                //单本书
                let cell = collectionView.dequeueReusableCell(MQIBookTypeOneCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.bookNameText = eachModel.book_name
                return cell
            }

        case "dsy":
            let c = indexPath.row % 6
            if c > 2 {
                //单本书
                let cell = collectionView.dequeueReusableCell(MQIBookTypeOneCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                //                cell.nameLabel?.text = eachModel.book_name
                cell.bookNameText = eachModel.book_name
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
                cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                cell.book_nameLabel?.text = eachModel.book_name
                //            cell.statusText = eachModel.subclass_name
                cell.statusText = (eachModel.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
                cell.classText = eachModel.book_words
                cell.bookcontentText = eachModel.book_intro
                cell.book_authorText = eachModel.subclass_name
                return cell
            }
            
        default:
            let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
            cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            cell.book_nameLabel?.text = eachModel.book_name
            //            cell.statusText = eachModel.subclass_name
            cell.statusText = (eachModel.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
            cell.classText = eachModel.book_words
            cell.bookcontentText = eachModel.book_intro
            cell.book_authorText = eachModel.subclass_name
            return cell
        }
    }
    
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let commendModel:MQIMainRecommendModel = mainRecommendArray[indexPath.section]
        if commendModel.type == "127" || commendModel.type == "128" {return}
        let eachModel:MQIMainEachRecommendModel = commendModel.books[indexPath.row]
        pushBookInfo(eachModel.book_id)
    }
}


//MARK:  福利
extension MQIBookStoreViewController {
    
    /// 右下角福利弹框
    func addWelfareView() {
        let w: CGFloat = kUIStyle.scaleW(91*2) //kUIStyle.scaleH(156)
        let h: CGFloat = kUIStyle.scaleW(77*2) //kUIStyle.scaleW(<#T##w: CGFloat##CGFloat#>)
        welfareView = FLAnimatedImageView(frame: CGRect(x: kUIStyle.kScrWidth-w-19.0, y: kUIStyle.kScrHeight-kUIStyle.kTabBarHeight-h-20.0, width: w, height: h))
        welfareView.image = UIImage(named: "activity_center")
        welfareView.isUserInteractionEnabled = true
        contentView.addSubview(welfareView)
        contentView.bringSubviewToFront(welfareView)
        welfareView.dsyAddTap(self, action:  #selector(welfareViewClick))
        welfareView.contentMode = .scaleAspectFit
//        welfareView.backgroundColor = .orange
    }
    
    @objc func welfareViewClick()  {
        
        MQIOpenlikeManger.toEvent()
    }
    
    /// 新用户福利
    func getHomeNotification()  {
        
        /// 展示弹框  首次安装
        if MQINewUserActivityManager.shared.isShowWelfareTask() {
            
            if !MQINewUserActivityManager.shared.isWelfareTaskData() {
                /// 初次安装
                MQINewUserActivityManager.shared.getHomeNotification(true) { [weak self]  in
                    if let weakSelf = self {
                        weakSelf.showActivities()
                    }
                }
            } else { MQINewUserActivityManager.shared.getHomeNotification(MQIUserManager.shared.checkIsLogin() ? MQINewUserActivityManager.shared.is7DayNewUser():true) {[weak self]  in
                if let weakSelf = self {
                    weakSelf.showActivities()
                }
                }
            }
        }else{
            MQINewUserActivityManager.shared.welfareTaskModel = MQINewUserActivityManager.shared.getLocalData()
        }
    }
    ///展示活动弹框
    func showActivities()  {
        
        if MQINewUserActivityManager.shared.welfareTaskModel.list.count == 0 { return }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            MQINewUserActivityManager.shared.addWelfareActivities(superView: self.tabBarController!.view, block: nil)
        }
    }
    
    @objc func loginInFunc() {
        
        MQINewUserActivityManager.shared.isShowWelfareTask(true)
        MQINewUserActivityManager.shared.getHomeNotification(MQIUserManager.shared.checkIsLogin() ? MQINewUserActivityManager.shared.is7DayNewUser() : true) {
            ///下载
//            UIImageView().sd_setImage(with: URL(string:  MQINewUserActivityManager.shared.welfareTaskModel.image))
        }
        
        MQINewUserActivityManager.shared.upLoadUserFirstLogin()
        registerPushToken()
    }
    @objc func loginOutFunc() {
     
        MQINewUserActivityManager.shared.isShowWelfareTask(true)
        MQINewUserActivityManager.shared.saveLocalData(data: MQINotificationModel())
        MQINewUserActivityManager.shared.welfareTaskModel = MQINotificationModel()
        MQIUserDiscountCardInfo.default = nil
    }

    ///上传token
    func  registerPushToken()  {
        if !MQIUserManager.shared.checkIsLogin() { return }
        if let tooken =  UserDefaults.standard.string(forKey: "push_token") ,tooken.count > 0 {
            MQIPushRegisterRequest(push_id: tooken).request({ (u, ue, mo) in
                mqLog("上传数据token成功")
            }) { (msg, co) in
                mqLog("\(msg)")
            }
        }
    }
}



extension  MQIBookStoreViewController  {
    func setDefaultguessyoulikeData() {
        guessyoulikeModel.type = "dsy"
        guessyoulikeModel.name = "猜你喜欢"
    }
    func getGuessyoulike(_ offset:String = "0")  {
        MQ_Home_GuessyoulikeRequest.init(offset: offset, limit: "18")
            .requestCollection({[weak self](request, response, result:[MQIMainEachRecommendModel]) in
                if let weakSelf = self {
                    
                    if offset != "0" {
                        weakSelf.mainRecommendArray.removeLast()
                    }
                    weakSelf.guessyoulikeModel.books.append(contentsOf: result)
                    weakSelf.mainRecommendArray.append(weakSelf.guessyoulikeModel)
                    weakSelf.gdCollectionView.reloadData()
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                }
                
                
            }) { [weak self] (errorMsg, errorCode) in
                if let weakSelf = self {
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                   MQILoadManager.shared.makeToast(errorMsg)
                }
        }
    }
    
}

//MARK:  操作方法
extension MQIBookStoreViewController {
    
    func setRightBtnState()  {
        //        rightBtn.setTitle(MQ_SectionManager.shared.section_ID.conversion(), for: .normal)
        if MQ_SectionManager.shared.section_ID == .Girl {
            rightBtn.isSelected = false
            customNavView.backgroundColor = UIColor.colorWithHexString("917C8F")
        }else{
            customNavView.backgroundColor = UIColor.colorWithHexString("30344D")
            rightBtn.isSelected = true
            
        }
        bannerView.backgroundColor = customNavView.backgroundColor
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    @objc func toastBtnClick(_ btn:UIButton)  {
        if toastSelectedbBtn?.tag == btn.tag {
            rightBtn.isSelected = false
            hiddenToastView(true)
            return
        }
        toastSelectedbBtn?.isSelected = false
        btn.isSelected = true
        toastSelectedbBtn = btn
        
        MQ_SectionManager.shared.changeSectionID(SECTIONTYPE.createType(btn.titleLabel!.text!))
        hiddenToastView(true)
        
    }
    @objc func to_Classification()  {
        let vc = MQIClassificationViewController.create()!
        vc.title = kLocalized("classification")
        pushVC(vc)
    }
    
    @objc func changeHobby()  {
        
        if MQ_SectionManager.shared.section_ID == .Boy {
            MQ_SectionManager.shared.changeSectionID(.Girl)
        }else{
            MQ_SectionManager.shared.changeSectionID(.Boy)
        }
        
        //        if !self.toastView.isHidden {
        ////            rightBtn.isSelected = false
        //            hiddenToastView(true)
        //            return
        //        }
        ////        rightBtn.isSelected = true
        //        hiddenToastView(false)
        //
    }
    
    func hiddenToastView(_ hidden: Bool)  {
        if hidden {
            self.toastView.alpha = 1
            self.toastView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.toastView.alpha = 0.2
            }) { (cop) in
                if cop {
                    self.toastView.isHidden = true
                }
            }
        }else{
            self.toastView.isHidden = false
            self.toastView.alpha = 0.2
            UIView.animate(withDuration: 0.3) {
                self.toastView.alpha = 1
            }
            
        }
        
    }
    
    
    
    @objc func toSearch(_ btn: UIButton) {
        let vc = MQISearchViewController()
        pushVC(vc)
    }
    
    
    //MARK:定时器  为了同步，只能放在这里，不能放每个cell里
    func createTimer() {
        if timer_Update == nil {
            timer_Update = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MQIBookStoreViewController.timerCountDown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer_Update, forMode:RunLoop.Mode.common)
        }
    }
    @objc func timerCountDown() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:Header_Timer_Notification), object: nil)
    }
    //MARK:刷新
    @objc func mj_refreshAction() {
        is_refreshFinished.banner_RFinish = false
        is_refreshFinished.nav_RFinish = false
        is_refreshFinished.recommends_RFinish = false
        SDImageCache.shared().clearDisk()
        loadBookstoreBanner()
        loadBookstoreNavRequest()
        loadBookstoreRecommendsRequest()
        getPopupAdsenseList()
    }
    //MARK:banner Click
    func gdbannerSelected(_ index:NSInteger) {
        if index < mainBannerArray.count {
            let bannerModel = mainBannerArray[index]
            MQIEventManager.shared.appendEventData(eventType: .banner_book, additional: ["book_id":bannerModel.book_id])
            if bannerModel.type == "LINK" || bannerModel.type == "link"{
                let vc = MQIWebVC()
                vc.url = bannerModel.url
                pushVC(vc)
            }else if bannerModel.type == "BOOK" || bannerModel.type == "book"{
                //                //打开书籍阅读
                //                let bookInfoVC = GDBookInfoVC()
                if bannerModel.id == "" {
                    //                   bookInfoVC.bookId = bannerModel.book_id
//                    MQIUserOperateManager.shared.toReader(bannerModel.book_id)
                }else{
                    //                    bookInfoVC.bookId = bannerModel.id
//                    MQIUserOperateManager.shared.toReader(bannerModel.id)
                }
                //                pushVC(bookInfoVC)
                pushBookInfo(bannerModel.book_id)
                
            }else{
                
            }
        }
    }
    
    
    
    //MARK:判断Banner是否有缓存
    func judgeBanner_Nav_Recommends_LocalCache() {
        addPreloadView()
        contentView.bringSubviewToFront(preloadView!)
        
        let bannerCaches = MQILocalSaveDataManager.shared.readDataBookStore_Banner()
        if bannerCaches.count > 0 {//使用缓存
            mainBannerArray.removeAll()
            mainBannerArray.append(contentsOf: bannerCaches)
            bannerView.books = mainBannerArray
        }else {
            loadBookstoreBanner()
            
        }
        
        let navCaches = MQILocalSaveDataManager.shared.readDataBookStore_Nav()
        if navCaches.count > 0 {
            mainNavArray.removeAll()
            mainNavArray.append(contentsOf: navCaches)
            bknavView.navDatas = navCaches
        }else {
            loadBookstoreNavRequest()
        }
        
        let recommendCaches = MQILocalSaveDataManager.shared.readDataBookStore_Recommends()
        if recommendCaches.count > 0 {
            mainRecommendArray.removeAll()
            mainRecommendArray.append(contentsOf: recommendCaches)
            gdCollectionView.reloadData()
            dismissPreloadView()
        }else {
            loadBookstoreRecommendsRequest()
        }
        
        getPopupAdsenseList()
    }

    func contentSize(){
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Scroll"), object: self, userInfo: ["currentTable":gdCollectionView.contentOffset.y])
    }
    
    //第一次进来请求推荐书籍  签到
    func ruoKan_differentWithNormal() {
//        if MQIShelfManager.shared.shelf_judgeIsFirstRequestRecommendsBooks(){
//            MQIShelfManager.shared.shelf_requestRecommends()
//        }
        MQIUserDiscountCardInfo.reload()
        MQISignManager.shared.SignJudgeToday_IsSign { (suc) in
            UserNotifier.postNotification(.sign_finish)
        }
    }

    @objc private func signToPushController() {
        MQIUserOperateManager.shared.toSignVC()
    }
    
    /// 书籍详情
    fileprivate func pushBookInfo(_ bookId: String) {
        
        MQIUserOperateManager.shared.toBookInfo(bookId)
        MQIEventManager.shared.appendEventData(eventType: .home_recommend_book, additional: ["book_id":bookId])
    }
    
    fileprivate func openLink(url: String) {
        if url == "" {return}
        MQIOpenlikeManger.openLike(url)
    }
    
    //MARK: 广播点击
    fileprivate func adBannerTapAction(_ index: Int) {
        if mainAdArray.count > index {
            let url = mainAdArray[index].url
            openLink(url: url)
        }
    }
}

//MARK:  添加视图
extension MQIBookStoreViewController{
    
    func addNotifier() {
        UserNotifier.addObserver(self, selector: #selector(MQIBookStoreViewController.loginInFunc), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQIBookStoreViewController.loginOutFunc), notification: .login_out)
        UserNotifier.addObserver(self, selector: #selector(MQIBookStoreViewController.scrollViewDidScroll), notification: .bookStoreScroll)
    }
    
    func addcollectionView()  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        gdCollectionView = MQICollectionView(frame: CGRect(x: 0, y: customNavView.maxY, width: view.width, height: contentView.height-customNavView.maxY),collectionViewLayout: layout)
        contentView.addSubview(gdCollectionView)
        
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQIBookTypeOneCollectionCellABC.self, xib: false)
        gdCollectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        gdCollectionView.registerCell(MQIBookTypeThreeCollectionCellABC.self, xib: false)
        gdCollectionView.registerCell(MQIBookTypeOneImgDescriptionCollectionCellABC.self, xib: false)
        gdCollectionView.registerCell(MQIBookTypeBannerCollectionCellABC.self, xib: false)
        gdCollectionView.registerCell(MQIRecommendTopicsCollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQIRecommendTopicsTwoCollectionViewCell.self, xib: false)
        gdCollectionView.register(MQIBookStoreFooterCollectionReusableViewABC.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MQIBookStore_FooterCellID)
        gdCollectionView.register(MQIBookStoreHeaderCollectionReusableViewABC.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MQIBookStore_HeaderCellID)
        
        
        if #available(iOS 11.0, *) {
            gdCollectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        gdCollectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            if let weakSelf = self {
                weakSelf.getGuessyoulike("\(weakSelf.guessyoulikeModel.books.count)")
            }
            
        })
        
    }
    func addBannerView() {
        let viewheight = MQIBanneStorerView.getMinX()
        let bgView = UIView(frame: CGRect(x: 0, y: -viewheight, width: screenWidth, height: viewheight))
        topBGView = bgView
        bgView.backgroundColor = UIColor.white
        gdCollectionView.addSubview(bgView)
        
        bannerView =  MQIBanneStorerView(frame: bgView.bounds)
        bgView.addSubview(bannerView)
        
        //导航
        bknavView = MQIBookStoreNavViewABC(frame: CGRect(x: 0, y: bannerView.maxY+10, width: screenWidth, height: kUIStyle.scaleH(140)))
        bgView.addSubview(bknavView)
        
//        let waveImageView = UIImageView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: 22))
//        bgView.addSubview(waveImageView)
//        waveImageView.image = UIImage.init(named: "user_headerBottom")
//        waveImageView.maxY = bknavView.y-6
        
        
        bgView.frame = CGRect(x: 0, y: -bknavView.maxY-10, width: screenWidth, height: bknavView.maxY+10)
        
        gdCollectionView.contentInset = UIEdgeInsets(top: bgView.height-1, left: 0, bottom: 0, right: 0)
        
        let ref_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(MQIBookStoreViewController.mj_refreshAction))
        ref_header?.ignoredScrollViewContentInsetTop = bgView.height
        gdCollectionView.mj_header = ref_header
        //刷新
        is_refreshFinished = BSRefreshFinish(banner_RFinish: false, nav_RFinish: false, recommends_RFinish: false)
        isAll_LoadError = BSReloadFinishAppearError(banner_loadFinish: true, nav_loadFinish: true, recommends_loadFinish: true)
    }
    
    //MARK: 广播广告位
    func addAdView() {
        if mainAdArray.count == 0 {
            if let adSenseView = adSenseView {
                adSenseView.removeFromSuperview()
            }
            topBGView.frame = CGRect(x: 0, y: -bknavView.maxY-10, width: screenWidth, height: bknavView.maxY+10)
            gdCollectionView.contentInset = UIEdgeInsets(top: topBGView.height-1, left: 0, bottom: 0, right: 0)
            return
        }
        
        if adSenseView == nil {
            adSenseView = MQIMarqueeView()
            adSenseView?.frame = CGRect(x: 0, y: bknavView.maxY, width: screenWidth, height: MQIMarqueeView.getHeight())
            topBGView.addSubview(adSenseView!)
            topBGView.frame = CGRect(x: 0, y: -(adSenseView!.maxY), width: screenWidth, height: adSenseView!.maxY)
            gdCollectionView.contentInset = UIEdgeInsets(top: topBGView.height-1, left: 0, bottom: 0, right: 0)
            let ref_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(MQIBookStoreViewController.mj_refreshAction))
            ref_header?.ignoredScrollViewContentInsetTop = topBGView.height
            gdCollectionView.mj_header = ref_header
            gdCollectionView.contentOffset = CGPoint(x: 0, y: -(topBGView.height-1))
            adSenseView!.tapIndexBlock = {[weak self] (index) in
                guard let weakSelf = self else { return }
                weakSelf.adBannerTapAction(index)
            }
        }
        adSenseView!.adListArray = mainAdArray
    }
    
    
    //MARK:创建导航栏
    func addSearchBtn() {
        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        customNavView.layer.addDefineLayer(customNavView.bounds)
        view.addSubview(customNavView)
        customNavView.alpha = 0
        
        let alphaView = UIView (frame: CGRect (x: 0, y: x_StatusBarHeight, width: screenWidth, height: 44))
        alphaView.backgroundColor = UIColor.clear
        view.addSubview(alphaView)
        
        
    }
    
    
    /// 上部导航栏
    func addTopView() {
        
        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        //        customNavView.layer.addDefineLayer(customNavView.bounds)
        view.addSubview(customNavView)
        
        
        
         searchBtn = createButton(CGRect(x: 24, y: customNavView.maxY-27, width: customNavView.width-24-60, height: 27),
                                     normalTitle: "  "+"  "+kLocalized("PleaseEnterTheTitleOrAuthorName"),
                                     normalImage: nil,
                                     selectedTitle: nil,
                                     selectedImage:nil,
                                     normalTilteColor: UIColor.colorWithHexString("999999"),
                                     selectedTitleColor: nil,
                                     bacColor: UIColor.colorWithHexString("#ffffff",alpha:1),
                                     font: systemFont(13),
                                     target: self,
                                     action: #selector(MQIBookStoreViewController.toSearch(_:)))
        
        customNavView.addSubview(searchBtn)
        searchBtn.tintColor = UIColor.colorWithHexString("999999")
        searchBtn.contentHorizontalAlignment = .left
        //        searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        searchBtn.dsySetCorner(radius: searchBtn.height*0.5)
        
        
        let image =  UIImage(named: "shelf_searchBtn")?.withRenderingMode(.alwaysTemplate)
        let imgaeView = UIImageView(frame: CGRect(x: searchBtn.width-25, y: 0, width: 15, height: 15))
        imgaeView.image = image
        imgaeView.tintColor = UIColor.colorWithHexString("999999")
        searchBtn.addSubview(imgaeView)
        imgaeView.centerY = searchBtn.height*0.5
        
        rightBtn = createButton(CGRect(x:15, y: customNavView.maxY-30-8, width: 25, height: 25),
                                normalTitle: nil,
                                normalImage: UIImage(named: "home_top_girl"),
                                selectedTitle: nil,
                                selectedImage: UIImage(named: "home_top_boy"),
                                normalTilteColor: UIColor.white,
                                selectedTitleColor: nil,
                                bacColor: UIColor.clear,
                                font: systemFont(14),
                                target: self,
                                action: #selector(MQIBookStoreViewController.changeHobby))
        customNavView.addSubview(rightBtn)
        searchBtn.centerY = rightBtn.centerY
        searchBtn.x = rightBtn.maxX+15
        rightBtn.isSelected = false
        
    }
    

    
    func addHobbyToastView() {
        toastView = UIView(frame: CGRect(x: 15, y: nav.maxY+5, width: kUIStyle.scale1PXW(80), height: kUIStyle.scale1PXH(76)))
        //        toastView.centerX = rightBtn.centerX
        //        toastView.maxX = nav.width-5
        toastView.backgroundColor = kUIStyle.colorWithHexString("000000", alpha: 0.7)
        toastView.dsySetCorner(radius: 5)
        toastView.alpha = 0
        toastView.isHidden = true
        self.view.addSubview(toastView)
        
        let titleArr = [SECTIONTYPE.Boy.conversion(),SECTIONTYPE.Girl.conversion()]
        let w = toastView.width
        let h = toastView.height/CGFloat(titleArr.count)
        for  i in 0..<titleArr.count {
            let btn = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*h, width: w, height: h))
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(kUIStyle.colorWithHexString("ffffff"), for: .normal)
            btn.setTitleColor(mainColor, for: .selected)
            btn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 14)
            btn.tag = 101+i
            btn.addTarget(self, action: #selector( toastBtnClick(_:)), for: .touchUpInside)
            toastView.addSubview(btn)
            if btn.titleLabel!.text ==  MQ_SectionManager.shared.section_ID.conversion() {
                btn.isSelected = true
                toastSelectedbBtn = btn
            }else{
                btn.isSelected = false
            }
        }
        
    }
   
    
}

//MARK: 网络请求
extension MQIBookStoreViewController {
    
    
    //MARK:banner请求
    func loadBookstoreBanner() {
        isAll_LoadError.banner_loadFinish = true
        GYBookInfoRecommendsRequest(tj_type: TYPE_STOER_DAILY)
            .request({[weak self] (request, response, resultOld: MQRecommendInfoModel) in
                if let weakSelf = self {
                    let  result = resultOld.data
                    if result.count > 0 {
                        var resultMew = [MQIMainBannerModel]()
                        
                        for i in 0..<result.count {
                            let book = result[i]
                            let model  = MQIMainBannerModel()
                            model.cover = book.book_cover
                            model.book_id = book.book_id
                            model.book_name = book.book_name
                            model.type = "book"
                            model.name  = resultOld.name
                            resultMew.append(model)
                        }
                        
                        weakSelf.mainBannerArray.removeAll()
                        weakSelf.mainBannerArray.append(contentsOf: resultMew)
                        MQILocalSaveDataManager.shared.SaveDataBookStore_Banner(resultMew)
                    }
                    weakSelf.is_refreshFinished.banner_RFinish = true
                    weakSelf.isAll_LoadError.banner_loadFinish = true
                    weakSelf.bannerView.books = weakSelf.mainBannerArray
                    weakSelf.finishMJ_Refresh()
                    
                }
                
                
            }) { [weak self](err_msg, err_code) in
                if let weakSelf = self {
                    weakSelf.is_refreshFinished.banner_RFinish = true
                    weakSelf.isAll_LoadError.banner_loadFinish = false
                    weakSelf.finishMJ_Refresh()
                    
                }
        }
        
        
    }
    //MARK:导航分类请求
    func loadBookstoreNavRequest() {
        isAll_LoadError.nav_loadFinish = true
        BookStorenNavigationRequest().requestCollection({[weak self](request, response, result:[MQIMainNavModel]) in
            if let weakSelf = self {
                if result.count > 0 {
                    weakSelf.mainNavArray.removeAll()
                    weakSelf.bknavView.navDatas = result
                    weakSelf.mainNavArray.append(contentsOf: result)
                    MQILocalSaveDataManager.shared.SaveDataBookStore_Nav(result)
                }
                
                weakSelf.is_refreshFinished.nav_RFinish = true
                weakSelf.isAll_LoadError.nav_loadFinish = true
                weakSelf.finishMJ_Refresh()
                
            }
        }) {[weak self](errorMsg, errorCode) in
            if let weakSelf = self {
                weakSelf.is_refreshFinished.nav_RFinish = true
                weakSelf.isAll_LoadError.nav_loadFinish = false
                weakSelf.finishMJ_Refresh()
                
            }
        }
    }
    //MARK:推荐列表
    func loadBookstoreRecommendsRequest() {
        isAll_LoadError.recommends_loadFinish = true
        
        BookStoreRecommendsRequest()
            .requestCollection({[weak self](request, response, result:[MQIMainRecommendModel]) in
                if let weakSelf = self {
                    weakSelf.dismissPreloadView()
                    weakSelf.mainRecommendArray.removeAll()
                    weakSelf.is_refreshFinished.recommends_RFinish = true
                    weakSelf.isAll_LoadError.recommends_loadFinish = true
                    
                    weakSelf.mainRecommendArray.append(contentsOf: result)
                    weakSelf.gdCollectionView.reloadData()
                    weakSelf.finishMJ_Refresh()
                    weakSelf.judgeIsAppearErrorToast()
                    MQILocalSaveDataManager.shared.SaveDataBookStore_Recommends(result)
                    weakSelf.guessyoulikeModel.books.removeAll()
                    weakSelf.cacheTime("1")
                }
            }) {[weak self](errorMsg, errorCode) in
                if let weakSelf = self {
                    weakSelf.dismissPreloadView()
                    weakSelf.is_refreshFinished.recommends_RFinish = true
                    weakSelf.isAll_LoadError.recommends_loadFinish = false
                    weakSelf.finishMJ_Refresh()
                    weakSelf.judgeIsAppearErrorToast()
                    
                }
        }
    }
    //MARK:判断是否显示错误弹窗
    func judgeIsAppearErrorToast() {
        if !isAll_LoadError.banner_loadFinish || !isAll_LoadError.nav_loadFinish || !isAll_LoadError.recommends_loadFinish{
            MQILoadManager.shared.makeToast(kLocalized("LoadFailedPleaseCheckTheNetworkConnection"))
        }
        
        let bannerCaches = MQILocalSaveDataManager.shared.readDataBookStore_Banner()
        let navCaches = MQILocalSaveDataManager.shared.readDataBookStore_Nav()
        let recommendCaches = MQILocalSaveDataManager.shared.readDataBookStore_Recommends()
        
        if (bannerCaches.count == 0)&&(navCaches.count==0)&&(recommendCaches.count==0)&&(!isAll_LoadError.banner_loadFinish)&&(!isAll_LoadError.nav_loadFinish) && (!isAll_LoadError.recommends_loadFinish){
            //如果加载失败，本地没缓存的，则隐藏collectionView  显示加载按钮
            
            gdCollectionView.isHidden = true
            addWrongView(kLocalized("TheNetworkIsOff"), refresh: {[weak self]() -> () in
                if let weakSelf = self {
                    weakSelf.gdCollectionView.isHidden = false
                    weakSelf.mj_refreshAction()
                    weakSelf.wrongView?.setLoading()
                }
            })
            
        }else {
            dismissWrongView()
        }
    }
    
    
    //MARK: 广播
    func getPopupAdsenseList() {
        MQIPopupAdsenseRequest(pop_position: "21").request({ [weak self](request, response, result: MQIPopupAdsenseModel) in
            guard let weakSelf = self else { return }
            weakSelf.mainAdArray = result.popupAdsenseList
            weakSelf.addAdView()

        }) { (err_msg, err_code) in
            
        }
    }
    
    
    //MARK:结束MJ_refresh
    func finishMJ_Refresh() {
        if gdCollectionView.mj_header.isRefreshing {
            if allRefresh_Finished() {
                gdCollectionView.mj_header.endRefreshing()
            }
        }
        
    }
    //MARK:判断是否全部刷新完毕
    func allRefresh_Finished() -> Bool{
        if is_refreshFinished.banner_RFinish && is_refreshFinished.nav_RFinish && is_refreshFinished.recommends_RFinish {
            return true
        }
        return false
    }
}
