//
//  GYReadVC.swift
//  Reader
//
//  Created by _CHK_  on 2017/6/22.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
/*
 拉拉
 */
import PSAlertView

class MQIReadViewController: UIViewController ,UIGestureRecognizerDelegate,ICSDrawerControllerChild,ICSDrawerControllerPresenting{
    
    weak var drawer: ICSDrawerController?
    
    var readModel: GYReadModel!
    
    var bid: String!
    
    var book: MQIEachBook!{
        didSet(oldValue) {
            MQIEventManager.shared.eSetFirebaseData(book.class_name)
        }
    }
    
    var listVC: MQIChapterListViewController!
    
    var readOperation: MQIReadOperation!
    
    lazy var style: GYReadStyle! = {
        return GYReadStyle.shared
    }()
    var pushView:MQICommentPushView!
    /// 用于区分PageViewController正反面的值(固定)
    fileprivate var TempNumber:NSInteger = 1
    /// 是否允许切换下一页
    public var allowToCover: Bool = true
    
    /// 阅读菜单UI
    private(set) var readMenu: GYReadMenu!
    /// 翻页控制器 (仿真)
    fileprivate(set) var pageViewController:UIPageViewController?
    /// 翻页控制器 (无效果,覆盖,上下)
    fileprivate(set) var coverController: GYCoverController?
    var to_index:Int?
    var to_chapter_id:String?
    //TODO: 数据是否还没有配置完成 （注：在增加新功能的时候记得考虑在刚进入阅读器加载失败的状态此功能是否可用会不会崩溃）
    var isCreating:Bool = true
    var currentReadViewController: MQIReadPageViewController?
    fileprivate var isAllowToSwippageVC:Bool = true
    
    var lastTouchView:UIView?
    var is_new_book:Bool = false{
        didSet(oldValue) {
            var  hidden = book.checkIsWholdSubscribe()
            if is_new_book {
                hidden = is_new_book
            }
            if GYBookManager.shared.isFree_limit_time || GYBookManager.shared.whole_subscribe == "1" {
                hidden = true
            }
            
            readMenu.topView.checkBuyBtn(hidden)
        }
    }
    
    var isStatusBarHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        
        return isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    var isStatusBarLightContent:Bool = false {
        didSet{
            if isStatusBarLightContent != oldValue {
                UIApplication.shared.setStatusBarStyle(isStatusBarLightContent == true ? .lightContent : .default, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifier()
        self.drawer?.fd_prefersNavigationBarHidden = true
        //        self.drawer?.fd_interactivePopDisabled = true
        MQICouponManager.shared.isLocatedReader = true
        
        isStatusBarLightContent = true /// 白色状态栏
        view.backgroundColor = UIColor.white ///白色背景
        
        listVC.chapterSel = {[weak self](index, chapter) -> Void in
            if let strongSelf = self {
                strongSelf.readOperation.GoToChapter(strongSelf.currentReadViewController , chapterIndex: index, toPage: 0)
            }
        }
        checkReader()
        configReader()
        
    }
    
    func configReader() {
        
        if  self.book == nil {
            let  emptyBook = MQIEachBook()
            emptyBook.book_id = self.bid
            self.book = emptyBook
        }else{
            self.bid =  self.book.book_id
        }
        
        readMenu = GYReadMenu.readMenu(vc: self, delegate: self)
        readOperation = MQIReadOperation(vc: self)
        self.isCreating = true
        creatPageController(MQIReadPageViewController())
        self.currentReadViewController?.addPreloadView()
        checkData { [weak self] in
            if let strongSelf = self {
                //                strongSelf.addNotifier()
                strongSelf.isCreating = false
                strongSelf.configData()
                //                strongSelf.readMenu.topView.checkBuyBtn()
                strongSelf.save()
            }
        }
    }
    
    func configData()  {
        if book != nil {
            configRead()
        }else {
            let pageVC = MQIReadPageViewController()
            creatPageController(pageVC)
            readOperation.requestBookInfo( bid, pageVC: pageVC)
        }
        
        requestreadLog()
        addGuid_imge()
    }
    
    func addNotifier() {
        UserNotifier.addObserver(self, selector: #selector(MQIReadViewController.userLogin), notification: .login_in)
        APPNotifier.addObserver(self, selector: #selector(MQIReadViewController.save), notification: .enter_background)
        NotificationCenter.default.addObserver(self, selector: #selector(showPopBox(_:)), name: NSNotification.Name(rawValue: "DisplayThePopUpBoxInTheReader"), object: nil)
    }
    
    //检查navViews
    func checkReader() {
        GDControlRemoveManager.shared.judge_naviViewsIsNeedRemove(self.navigationController)
    }
    
    func configRead() {
        bid = book.book_id
        readMenu?.initData()
        listVC.book = book
        let topage  = (readModel.readRecordModel == nil) ? 0 : readModel.readRecordModel.page.intValue
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: topage,isFirstEnter: true,to_index: to_index,to_chapter_id:to_chapter_id))
        to_index = nil
        to_chapter_id = nil
    }
    
    /// MARK: -- 创建 PageController
    
    /// 创建效果控制器 传入初始化显示控制器
    func creatPageController(_ displayController:UIViewController?) {
        
        /// 清理
        if pageViewController != nil {
            pageViewController?.view.removeFromSuperview()
            pageViewController?.removeFromParent()
            pageViewController = nil
        }
        
        if coverController != nil {
            coverController?.view.removeFromSuperview()
            coverController?.removeFromParent()
            coverController = nil
        }
        
        /// 创建
        if style.styleModel.effectType == .simulation { /// 仿真
            allowToCover = true
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue as Int)]
            pageViewController = UIPageViewController(transitionStyle:.pageCurl,
                                                      navigationOrientation:UIPageViewController.NavigationOrientation.horizontal,
                                                      options: options)
            pageViewController!.delegate = self
            pageViewController!.dataSource = self
            /// 为了翻页背面的颜色使用
            pageViewController!.isDoubleSided = true
            view.insertSubview(pageViewController!.view, at: 0)
            addChild(pageViewController!)
            pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }else{ /// 无效果 覆盖 上下
            coverController = GYCoverController()
            coverController!.delegate = self
            view.insertSubview(coverController!.view, at: 0)
            addChild(coverController!)
            coverController!.setController(displayController)
            if style.styleModel.effectType == .translation {
                coverController!.openAnimate = true
                coverController!.isCoverPage = true
            }else if style.styleModel.effectType == .none {
                coverController!.openAnimate = true
                coverController!.isCoverPage = false
            }else if style.styleModel.effectType == .upAndDown {
                coverController!.openAnimate = false
                coverController!.gestureRecognizerEnabled = false
            }
            coverController?.view.backgroundColor = UIColor.red
        }
        removeThelastTouchView()
        /// 记录
        currentReadViewController = displayController as? MQIReadPageViewController
        
    }
    func pushToReadEndVC() {
        //        if let _ = book {
        //            let bookInfoVC = GDBookInfoVC()
        //            bookInfoVC.bookId = book.book_id
        //            pushVC(bookInfoVC)
        //        }
        if let book = book {
            let readEndVC = MQIReadEndViewController()
            readEndVC.book = book
            pushVC(readEndVC)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if readMenu != nil {
            if readMenu.menuShow == true {
                return
            }
        }
        
        /// 设置状态栏颜色
        setStatusBarStyle()
        isStatusBarHidden = true
        
        let userAM =  MQINewUserActivityManager.shared
        ///上报历史记录
        let end = userAM.getCompleteReadTime()
        //        userAM.endReadTime()
        userAM.uploadReadTime(end)
        ///记录阅读时间
        userAM.beginReadTime()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isCreating { return }
        isStatusBarHidden = false
        save()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isCreating { return }
        updateRedlog()
        ///记录消失
        MQINewUserActivityManager.shared.endReadTime()
        
    }
    ///展示阅读器弹框
    @objc func showPopBox(_ no:Notification) {
        let userAM =  MQINewUserActivityManager.shared
        guard   let userInfo = no.userInfo as? [String:String]  else {
            return
        }
        
        DispatchQueue.main.async {
            if userAM.promptText != "" {
                if self.readMenu?.menuShow ?? false {
                    userAM.showActivityView(self.view,y: NavgationBarHeight+10 ,title: userInfo["promptText"]!, image: userInfo["image_name"]!)
                }else{
                    userAM.showActivityView(self.view,title:  userInfo["promptText"]!, image: userInfo["image_name"]!)
                }
            }
        }
        
    }
    
    
    @objc func userLogin() {
        if readOperation == nil{ return }
        
        func relodView(){
            creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: readModel.readRecordModel.page.intValue))
            
            if let downBook = GYBookManager.shared.getDownloadBook(book.book_id) {
                book.downTids = downBook.downTids
                book.buyTids = downBook.buyTids
                listVC.book = book
            }
            
            if readMenu == nil{ return }
            readMenu.topView.checkBuyBtn()
            readMenu.novelsSettingView.checkSubscribe()
            
        }
        self.currentReadViewController?.dismissWrongView()
        self.currentReadViewController?.addPreloadView()
        GYBookManager.shared.getSubscribeChapterIds(book_id: self.book.book_id) { [weak self] (msg) in
            if let weakSelf = self {
                weakSelf.currentReadViewController?.dismissPreloadView()
                relodView()
            }
            
        }
    }
    
    @objc func save() {
        if isCreating { return }
        style.saveStyleModel()
        if book != nil {
            
            GYBookManager.shared.updateDownloadBook(book)
            MQIFileManager.saveChapterList(book.book_id, list: readModel.chapterList)
            if MQIShelfManager.shared.checkIsExist(book.book_id) {
                book.book_isUpdate = false
                book.updateBook = 0
                MQIShelfManager.shared.addToBooks(book)
            }
            if readModel.readRecordModel != nil &&  readModel.readRecordModel.readChapterModel != nil {
                let chapterIndex = readModel.readRecordModel?.chapterIndex.intValue ?? 0
                MQIRecentBookManager.shared.addRecentReader(book, chapter: readModel.readRecordModel?.readChapterModel,position: (chapterIndex < 0) ? 0:chapterIndex)
            }
            
        }
        
    }
    /// 上传阅读记录
    func updateRedlog()  {
        let currentchapterid = readModel.readRecordModel.readChapterModel?.chapter_id
        guard let chapterid = currentchapterid else {return}
        AAReadLogManager.shared.save_read_logWhenDisappear(bid, chapter_id: chapterid, position: "0")
    }
    deinit {
        removeThelastTouchView()
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 设置状态栏颜色
    private func setStatusBarStyle() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }
    
}
//MARK:  配置UI
extension MQIReadViewController{
    
    func addGuid_imge()  {
        if !MQIUserDefaultsKeyManager.shared.reader_Guide_isAvailable() {return}
        
        let bacView = UIView(frame: self.view.bounds)
        bacView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.6)
        self.view.addSubview(bacView)
        bacView.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(hiddenGuid_imge(tap:))))
        self.view.bringSubviewToFront(bacView)
        let  bacimgae = UIImageView(image: UIImage(named: "reader_back_guid_imge"))
        bacimgae.center = bacView.center
        bacView.addSubview(bacimgae)
        
    }
    
    @objc func hiddenGuid_imge(tap:UITapGestureRecognizer)  {
        tap.view?.removeFromSuperview()
        MQIUserDefaultsKeyManager.shared.reader_Guide_Save()
    }
    
}
/// 仿真做动画
extension MQIReadViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    /// MARK: -- UIPageViewControllerDelegate
    /// 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        currentReadViewController = pageViewController.viewControllers?.first as? MQIReadPageViewController
        /// 更新阅读记录
        readOperation.readRecordUpdate(readViewController: currentReadViewController)
        /// 更新进度条
        readMenu.bottomView.sliderUpdate()
        
    }
    /// 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        ///        readMenu.menuSH(isShow: false)
        /// 更新阅读记录
        //        readOperation.readRecordUpdate(readViewController: pageViewController.viewControllers?.first as? GYReadPageVC, isSave: false)
        if let _ = readMenu {
            readMenu.menuSH(isShow: false)
        }
    }
    
    
    /// MARK: -- UIPageViewControllerDataSource
    /// 用于区分正反面的值(固定)
    
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if  isCreating { return nil}
        TempNumber -= 1
        removeThelastTouchView()
        if abs(TempNumber) % 2 == 0 { /// 背面
            currentReadViewController = readOperation.GetAboveReadViewController()
            if let currentReadViewController = currentReadViewController {
                let bacVC = MQIReadPageBacViewController()
                bacVC.updateWithViewController(currentReadViewController)
                return bacVC
            }else {
                let vc = UIViewController()
                vc.view.backgroundColor =  style.styleModel.themeModel.textColor.withAlphaComponent(0.55)
                return vc
            }
        }else{ /// 内容
            allowToCover = false
            configAllowToCover()
            if let currentReadViewController = currentReadViewController {
                return currentReadViewController
            }else {
                return readOperation.GetAboveReadViewController()
            }
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if  isCreating { return nil}
        TempNumber += 1
        
        if abs(TempNumber) % 2 == 0 { /// 背面
            if let currentReadViewController = currentReadViewController {
                let bacVC = MQIReadPageBacViewController()
                bacVC.updateWithViewController(currentReadViewController)
                return bacVC
            }else {
                let bacVC = MQIReadPageBacViewController()
                bacVC.updateWithViewController(viewController)
                return bacVC
            }
        }else{ /// 内容
            allowToCover = false
            configAllowToCover()
            let belowReadVC = readOperation.GetBelowReadViewController()
            if belowReadVC == nil {
                createThelastTouchView()
            }
            return belowReadVC
            //return readOperation.GetBelowReadViewController()
        }
    }
    
    fileprivate func createThelastTouchView() {
        //判断是否是最后一页
        if readModel == nil {
            return
        }
        let readRecordModel = readModel.readRecordModel.copySelf()
        let index = readRecordModel.chapterIndex.intValue
        
        guard (index + 1) >= readModel.chapterList.count else {
            return
        }
        guard lastTouchView == nil else {
            return
        }
        
        lastTouchView = UIView(frame: CGRect(x: screenWidth-100, y: x_statusBarAndNavBarHeight, width: 100, height: screenHeight - x_statusBarAndNavBarHeight - 150))
        //        lastTouchView?.backgroundColor = UIColor.gray
        self.view.addSubview(lastTouchView!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MQIReadViewController.lastgesture))
        singleTap.numberOfTapsRequired = 1
        lastTouchView?.addGestureRecognizer(singleTap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MQIReadViewController.lastgesture))
        swipeLeft.direction = .left
        lastTouchView?.addGestureRecognizer(swipeLeft)
        
    }
    fileprivate func removeThelastTouchView() {
        if lastTouchView != nil {
            lastTouchView?.removeFromSuperview()
            lastTouchView = nil
        }
        
    }
    @objc fileprivate func lastgesture() {
        pushToReadEndVC()
    }
    
    fileprivate func configAllowToCover() {
        after(1, block: {[weak self] in
            guard self?.allowToCover == false else{
                return
            }
            self?.allowToCover = true
        })
    }
}
/// 简约动画
extension MQIReadViewController: GYCoverControllerDelegate {
    
    /// MARK: -- GYCoverControllerDelegate
    /// 切换结果
    func coverController(_ coverController: GYCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        /// 记录
        currentReadViewController = currentController as? MQIReadPageViewController
        
        /// 更新阅读记录
        readOperation.readRecordUpdate(readViewController: currentReadViewController)
        //        MQLog(currentReadViewController?.readRecordModel)
        /// 更新进度条
        readMenu.bottomView.sliderUpdate()
        //        MQLog(currentReadViewController?.readRecordModel?.readChapterModel?.chapter_id)
    }
    
    /// 将要显示的控制器
    func coverController(_ coverController: GYCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        if let _ = readMenu {
            readMenu.menuSH(isShow: false)
        }
        
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: GYCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        if  isCreating { return nil}
        return readOperation.GetAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: GYCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        if  isCreating { return nil}
        return readOperation.GetBelowReadViewController()
    }
}

extension MQIReadViewController: GYReadMenuDelegate {
    /// 背景颜色
    func readMenuClicksetupColor(readMenu: GYReadMenu, index: NSInteger) {
        if readOperation.isDownloading == true {return}
        listVC.changeBgType()
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: false, isForce: true)
    }
    
    /// 翻书动画
    func readMenuClicksetupEffect(readMenu:GYReadMenu, type: String) {
        if readOperation.isDownloading == true {return}
        let page = readModel.readRecordModel.page.intValue
        let pageVC = readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true, toPage: page)
        creatPageController(pageVC)
    }
    
    /// 字体
    func readMenuClicksetupFont(readMenu:GYReadMenu, type: String) {
        if readOperation.isDownloading == true {return}
        if let fontType = GYReadFontType(rawValue: type) {
            style.styleModel.readFontStyle = fontType
            creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        }
    }
    
    /// 字体大小
    func readMenuClicksetupFontSize(readMenu: GYReadMenu, fontSize: CGFloat) {
        if readOperation.isDownloading == true {return}
        ///        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: true, isForce: true)
    }
    
    ///行高排版
    func readMenuClicksetupLineHeight(readMenu: GYReadMenu, linHeight: CGFloat) {
        if readOperation.isDownloading == true {return}
        //        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: true, isForce: true)
    }
    
    /// 段落高度
    func readMenuClicksetupParagraphHeight(readMenu: GYReadMenu, paragraphHeight: CGFloat) {
        if readOperation.isDownloading == true {return}
        //        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: true, isForce: true)
    }
    
    /// 文字间距
    func readMenuClicksetupLetterSpace(readMenu: GYReadMenu, letterSpace: CGFloat) {
        if readOperation.isDownloading == true {return}
        //        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: true, isForce: true)
    }
    
    /// 文字粗细
    func readMenuClicksetupFontWidth(readMenu: GYReadMenu, fontWidth: CGFloat) {
        if readOperation.isDownloading == true {return}
        //        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: true, isForce: true)
    }
    
    /// 拖拽进度条
    func readMenuSliderEndScroll(readMenu: GYReadMenu, slider: MQISliderPopover) {
        if readOperation.isDownloading == true {return}
        guard style.styleModel.effectType == .upAndDown else {
            let toPage = NSInteger(slider.value)
            readOperation.GoToChapter(currentReadViewController, chapterIndex: readModel.readRecordModel.chapterIndex.intValue, toPage: toPage)
            return
        }
        
    }
    
    /// 滚动条滚动中
    func readMenuSliderChangeScroll(readMenu: GYReadMenu, slider: MQISliderPopover) {
        guard style.styleModel.effectType == .upAndDown else {
            return
        }
        
        currentReadViewController?.pullToOffsetY(CGFloat(slider.value))
    }
    
    /// 点击书签列表
    func readMenuClickMarkList(readMenu: GYReadMenu, readMarkModel: MQIReadMarkModel) {
        readModel.modifyReadRecordModel(readMarkModel: readMarkModel, isUpdateFont: true, isSave: false)
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: false, isSave: true))
    }
    
    /// 下载
    func readMenuClickDownload(readMenu: GYReadMenu) {
        
        
        
    }
    
    /// 上一章
    func readMenuClickPreviousChapter(readMenu: GYReadMenu) {
        if readOperation.isDownloading == true {return}
        let chapterIndex = readModel.readRecordModel.chapterIndex.intValue-1
        readOperation.GoToChapter(currentReadViewController, chapterIndex: chapterIndex, toPage: 0)
    }
    
    /// 下一章
    func readMenuClickNextChapter(readMenu: GYReadMenu) {
        if readOperation.isDownloading == true {return}
        let chapterIndex = readModel.readRecordModel.chapterIndex.intValue+1
        readOperation.GoToChapter(currentReadViewController, chapterIndex: chapterIndex, toPage: 0)
    }
    
    /// 点击章节列表
    func readMenuClickChapterList(readMenu: GYReadMenu) {
        if listVC.chapterList.count > 0 {
            if let chapter = readModel.readRecordModel.readChapterModel {
                listVC.currentChapterId =  chapter.chapter_id
            }
            drawer?.open()
        }
    }
    
    /// 切换日夜间模式
    func readMenuClickLightButton(readMenu: GYReadMenu, isDay: Bool) {
        if readOperation.isDownloading == true {return}
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: false, isForce: true)
        
    }
    
    /// 状态栏 将要 - 隐藏以及显示状态改变
    func readMenuWillShowOrHidden(readMenu: GYReadMenu, isShow: Bool) {
        
        pageViewController?.tapGestureRecognizerEnabled = !isShow
        
        coverController?.tapGestureRecognizerEnabled = !isShow
        
        MQINewUserActivityManager.shared.isMenuShow = readMenu.menuShow
        
        
        if isShow {
            
        }
    }
    
    /// 点击书签按钮
    func readMenuClickMarkButton(readMenu: GYReadMenu, button: UIButton) {
        
        if button.isSelected {
            
            let _ = readModel.removeMark()
            
            button.isSelected = readModel.checkMark()
            
        }else{
            
            readModel.addMark()
            
            button.isSelected = true
        }
    }
    
    ///打赏
    func readMenuClickReward(readMenu: GYReadMenu, coin: Int) {
        if MQIUserManager.shared.checkIsLogin() == false {
            MQIloginManager.shared.toLogin(nil, finish: {[weak self] () -> Void in
                if let strongSelf = self {
                    MQILoadManager.shared.addAlert(kLocalized("Exception"), msg: "\(kLocalized("MakeSureException"))\(coin)\(COINNAME)？", block: {
                        strongSelf.readOperation.rewardRequest(coin)
                        
                    }, cancelBlock: {
                        
                    })
                }
            })
        }else {
            //            readOperation.rewardRequest(coin)
            MQILoadManager.shared.addAlert(kLocalized("Exception"), msg: "\(kLocalized("MakeSureException"))\(coin)\(COINNAME)？", block: {[weak self]()->Void in
                if let weakSelf = self
                {
                    weakSelf.readOperation.rewardRequest(coin)
                }
                }, cancelBlock: {
                    
            })
        }
    }
    
    /// 点击简体繁体
    func readMenuClickSimple(readMenu: GYReadMenu) {
        if readOperation.isDownloading == true {return}
        readOperation.reloadReadViewController(pageVC: currentReadViewController, isSave: false, isForce: true)
    }
    
    /// 点击订阅 更多中的
    func readMenuClickSubscribe(readMenu: GYReadMenu, isSubscribe: Bool) {
        if isSubscribe == true {
            GYBookManager.shared.addDingyueBook(self.book)
        }else {
            GYBookManager.shared.removeDingyueBook(book)
        }
    }
    
    /// 展示更多字体
    func readMenuClickShowMoreFont(readMenu: GYReadMenu) {
        
    }
    
    ///加入书架
    func readMenuClickAddShelf(readMenu: GYReadMenu) {
        if MQIUserManager.shared.checkIsLogin() {
            MQIUserOperateManager.shared.addShelf(book, completion: nil)
            MQIEventManager.shared.eAddBookshelfMenu()
        }else{
            MQIloginManager.shared.toLogin(nil)  { [weak self] in
                if let weakSelf = self {
                    MQIUserOperateManager.shared.addShelf(weakSelf.book, completion: nil)
                    MQIEventManager.shared.eAddBookshelfMenu()
                }
            }
        }
        
    }
    
    ///购买-订阅-非全本
    func readMenuClickBuyChapter(readMenu: GYReadMenu,subscribeCount:Int) {
        //        pushToDownloadVC()
        requestSubscribeVC(subscribeCount, type: .chapter)
    }
    
    func readMenuClickAnError(readMenu: GYReadMenu) {
        mqLog("报错")
        if let chapter = readModel.readRecordModel.readChapterModel {
            let vc  = MQIWebVC()
            vc.url = anErrorHttpURL()+"?chapter_id=\(chapter.chapter_id)&book_id=\(book.book_id)"
            if  MQIUserManager.shared.checkIsLogin() {
                pushVC(vc)
            }else{
                MQIUserOperateManager.shared.toLoginVC { [weak self] in
                    self?.pushVC(vc)
                }
                
            }
            
            
        }
        
    }
    
    func readMenuClickBuyBook(readMenu: GYReadMenu) {
        requestSubscribeVC(0, type: .book)
    }
    //TODO:  分享 ====
    func readMenuClickShared(readMenu: GYReadMenu) {
        if let book = book {
            MQISocialManager.shared.sharedBook(book)
        }
    }
    func readMenuClickToDetail(readMenu: GYReadMenu) {
        if let book = book {
            MQIUserOperateManager.shared.toBookInfo(book.book_id)
            
        }
        
    }
    func readMenuClickComment(readMenu: GYReadMenu) {
        if let book = book, let chapter = readModel.readRecordModel.readChapterModel {
            let pushCommentVC = {[weak self] in
                if let strongSelf = self {
                    //                    let vc = GYReadCommentEditVC()
                    //                    vc.book = book
                    //                    vc.chapter = chapter
                    //                    strongSelf.present(vc, animated: true, completion: nil)
                    strongSelf.pushView = MQICommentPushView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: strongSelf.view.height))
                    strongSelf.pushView.bookid = book.book_id
                    strongSelf.pushView.comment_type = .comment_chapter
                    strongSelf.pushView.chapterid = chapter.chapter_id
                    strongSelf.view.addSubview(strongSelf.pushView)
                    strongSelf.pushView.commentClose = {()->Void in
                        strongSelf.pushView.removeFromSuperview()
                    }
                    strongSelf.pushView.commentPushFinishBlock = {()->Void in
                        strongSelf.pushView.removeFromSuperview()
                    }
                }
            }
            
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {
                    pushCommentVC()
                })
            }else {
                pushCommentVC()
            }
            
        }
    }
}

extension MQIReadViewController {
    //新的订阅界面
    func requestSubscribeVC(_ count:Int, type: GYSubscribeType) {
        
        let action = {[weak self] in
            if let strongSelf = self {
                guard type == .chapter else {
                    strongSelf.sure_ToSubscribeBook()
                    return
                }
                strongSelf.sure_ToSubscribe(count)
            }
        }
        
        
        if MQIUserManager.shared.checkIsLogin() == false {
            MQILoadManager.shared.addAlert(msg: kLocalized("NoLog"), block: {()->Void in
                MQIUserOperateManager.shared.toLoginVC({
                    action()
                })
                
            }, cancelBlock: {()->Void in
                
            })
            
        }else {
            action()
        }
    }
    
    func sure_ToSubscribe(_ count:Int) {
        var index: String!
        if let chapterid = currentReadViewController?.readRecordModel?.readChapterModel?.chapter_id {
            index = chapterid
        }else if let readModelid = readModel.readRecordModel.readChapterModel?.chapter_id {
            index = readModelid
        }else {
            index = "0"
        }
        readOperation.subScribeRequest(count, book: book, start_chapter_id: index, completion: {result in
            guard let result = result else {
                return
            }
            self.readMenu.subscribeView.addsubScribe_SuccessView(result.end_chapter_name, coin: result.coin)
        })
        
    }
    
    func sure_ToSubscribeBook() {
        
        MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: "\(kLocalized("WillBook"))《\(book.book_name)》", block: { [weak self] in
            if let strongSelf = self {
                strongSelf.readOperation.subScribeRequest(0, book: strongSelf.book, isWholeSubscribe: true, completion: { (result) in
                    guard let result = result else {
                        return
                    }
                    if let _ = strongSelf.readMenu.moreView {
                        strongSelf.readMenu.novelsSettingView.checkSubscribe()
                    }
                    
                    if let _ = strongSelf.readMenu.topView {
                        strongSelf.readMenu.topView.checkBuyBtn()
                    }
                    
                    guard let subscribeView = strongSelf.readMenu.subscribeView, subscribeView.isHidden == false else {
                        return
                    }
                    
                    strongSelf.readMenu.subscribeView.addsubScribe_SuccessView("", coin: result.coin)
                })
            }
        }) { [weak self] in
            if let strongSelf = self {
                guard let _ = strongSelf.readMenu.moreView else {
                    return
                }
                strongSelf.readMenu.novelsSettingView.checkSubscribe()
            }
        }
    }
    
    
    func pushToDownloadVC() {
        drawer?.close()
        readMenu.subscribeView(isShow: true, completion: nil)
        return
    }
    func requestreadLog(){
        if  isCreating { return }
        GDGet_read_logRequest(book_id:bid).request({[weak self] (request, response, result:MQIReadProgressModel) in
            if let weakSelf = self {
                weakSelf.jumpToChapter(model: result)
            }
        }) { (err_msg, errcode) in
            
        }
        
    }
    func jumpToChapter(model:MQIReadProgressModel) {
        //        MQLog("🍎🍎🍎🍎🍎=\(model.readtime)===\(model.chapter_id)")
        guard readMenu != nil else {
            return
        }
        let currentIndex = readModel.readRecordModel.chapterIndex
        let allCount = readModel.chapterList.count
        
        var shouldPosition = 0
        let serChapterId = model.chapter_id
        for index in 0..<readModel.chapterList.count {
            let  showModel =  readModel.chapterList[index]
            if showModel.chapter_id == serChapterId {
                shouldPosition = index
                model.chapter_title = showModel.chapter_title
            }
        }
        
        //        if shouldPosition >= allCount  || shouldPosition <= 0 || shouldPosition == currentIndex.intValue || shouldPosition < currentIndex.intValue //按服务器改，不用管之前的章节还是现在的章节
        //
        //        {
        //            return
        //        }
        
        if shouldPosition >= allCount  || shouldPosition <= 0 || shouldPosition  == currentIndex.intValue
            
        {
            return
        }
        
        readMenu.addServerReadProgressView(self.view.bounds,model:model) {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.readOperation.GoToChapter(weakSelf.currentReadViewController , chapterIndex:shouldPosition, toPage: 0)//model.position
            }
        }
        
    }
    func toDownload() {
        if MQIUserManager.shared.checkIsLogin() == false {
            let alert = PSPDFAlertView(title: kLocalized("Warn"), message: kLocalized("NoLogin"))
            alert?.addButton(withTitle: kLocalized("DownLoadFree"), block: {[weak self] (index) in
                if let strongSelf = self {
                    strongSelf.readOperation.downloadFreeBooks()
                }
            })
            alert?.addButton(withTitle: kLocalized("TheLogin"), block: { (index) in
                MQIUserOperateManager.shared.toLoginVC({[weak self] in
                    if let strongSelf = self {
                        strongSelf.readOperation.requestSubscribeChapters()
                    }
                })
            })
            alert?.setCancelButtonWithTitle(kLocalized("Cancel"), block: { (index) in })
            alert?.show()
        }else {
            readOperation.requestSubscribeChapters()
        }
    }
    func pushVC(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        let popAction = {[weak self]() -> Void in
            if let strongSelf = self {
                MQILastReaderManager.shared.getLastReader(strongSelf.bid)?.save()
                strongSelf.navigationController?.popViewController(animated: true)
                
            }
        }
        MQICouponManager.shared.isLocatedReader = false
        
        if isCreating { popAction() ; return}
        if MQIUserManager.shared.checkIsLogin() == true {
            if MQIShelfManager.shared.checkIsExist(book.book_id) == false {
                if  book.book_name != "" {
                    MQILoadManager.shared.addAlert(kLocalized("WarmPrompt"), msg:
                        kLongLocalized("JoinYourBookshelf", replace: book.book_name), block: { [weak self]  in
                            if let weakSelf = self {
                                MQIUserOperateManager.shared.addShelf(weakSelf.book, completion: nil)
                            }
                            MQIEventManager.shared.eAddBookshelfonExit()
                            
                            popAction()
                        }, cancelBlock: {
                            
                            popAction()
                    })
                    
                }else{
                    
                    popAction()
                }
            }else {
                
                popAction()
            }
        }else {
            
            popAction()
        }
    }
    
}

//MARK:  初始化配置数据
extension MQIReadViewController {
    
    func checkData(block:(()->())?)  {
        weak  var readVC = self
        let readAction = {
            let readModel = GYReadModel()
            readModel.bookId = readVC?.bid ?? "0"
            //先判断 是否 跳章 看
            if var toIndexNew = readVC?.to_index {
                if toIndexNew  < 0 {toIndexNew = 0 }
                readVC?.to_index = toIndexNew
                let readRecordModel = MQIReadRecordModel()
                readRecordModel.readChapterModel?.chapter_code = "\(toIndexNew)"
                readRecordModel.bookId = readVC?.bid ?? "0"
                if toIndexNew < 0{
                    readRecordModel.chapterIndex = NSNumber(value: 0)
                }else{
                    readRecordModel.chapterIndex = NSNumber(value: toIndexNew)
                }
                readModel.readRecordModel = readRecordModel
            }
            else if let to_chapter_id = readVC?.to_chapter_id {
                readVC?.to_chapter_id = to_chapter_id
                let readRecordModel = MQIReadRecordModel()
                readRecordModel.readChapterModel?.chapter_id = to_chapter_id
                readRecordModel.bookId = readVC?.bid ?? "0"
                readModel.readRecordModel = readRecordModel
            }
                
            else if let recordModel = MQILastReaderManager.shared.recordDict[readVC?.bid ?? "0"] {
                
                if AAEnterReaderType.shared.enterType == .enterType_0 {
                    if recordModel.chapterIndex.intValue == -1 {
                        recordModel.chapterIndex = NSNumber(value: 0)
                    }
                }
                //再判断 本地是否有 记录
                readModel.readRecordModel = recordModel
            }else {
                
                //最后 从头开始阅读w
                let readRecordModel = MQIReadRecordModel()
                readRecordModel.bookId = self.bid
                if AAEnterReaderType.shared.enterType == .enterType_0 {
                    readRecordModel.chapterIndex = NSNumber(value: 0)
                }else {
                    readRecordModel.chapterIndex = NSNumber(value: -1)
                }
                readModel.readRecordModel = readRecordModel
            }
            AAEnterReaderType.shared.enterType = .enterType_normal
            if let list = readVC?.listVC.chapterList {
                readModel.chapterList = list
            }
            readVC?.readModel = readModel
            block?()
            readVC?.getBookExtention(readVC?.bid ?? "0")
        }
        
        
        guard let book = GYBookManager.shared.getDownloadBook(bid) else {
            let book_old = (self.book == nil) ? MQIEachBook():self.book
            book_old?.book_id = bid
            readVC?.book = book_old
            readVC?.listVC.book = book_old
            multipleRelationsRequest(tid: "0", book_old: book_old, completion: { (book, chapter, list) in
                //                readVC?.book = book
                //                readVC?.listVC.book = book
                readVC?.to_chapter_id = chapter.chapter_id
                readVC?.listVC.chapterList = list
                readAction()
            }) { (code,errmsg) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(errmsg)
                let type =  readVC?.readOperation.getWrong(code: code) ?? GYReadWrongType.other
                readVC?.currentReadViewController?.addWrongView(errmsg, type: type, refresh: {
                    readVC?.checkData(block: block)
                })
                
            }
            
            gd_checkneedRefresh(bid, readVC: self, completion: nil)
            return
        }
        readVC?.book = book
        listVC.book = book
        readAction()
        gd_checkneedRefresh(bid, readVC: self, completion: nil)
        
    }
    
    
    func gd_checkneedRefresh(_ bid:String,readVC:MQIReadViewController,completion:(()->())?) {
        
        GYBookManager.shared.requestBookInfo(bid) { [weak readVC] (book, err_msg,code) in
            guard let result = book else  {
                MQILoadManager.shared.dismissProgressHUD()
                if completion != nil {
                    MQILoadManager.shared.makeToast(err_msg ?? "请求失败")
                }
                return
            }
            readVC?.book = result
            readVC?.listVC.book = result
            completion?()
            
        }
        
    }
    
    /// 书籍第一次打开使用这个回调 并发请求提高打开速度
    func multipleRelationsRequest(_ book_id:String = "", tid:String,book_old:MQIEachBook? = nil , completion:((_ book:MQIEachBook,_ chapter: MQIEachChapter,_ list:[MQIEachChapter])->())?, error_block:((_ cpde:String,_ msg:String) ->())?)   {
        
        var book =  MQIEachBook()
        book.book_id = book_id
        var chapter:MQIEachChapter?
        var list_old = [MQIEachChapter]()
        let queue = DispatchQueue.init(label: "multipleRelationsRequest_DSY")
        let group = DispatchGroup()
        var _err_msg:String?
        var _code: String?
        if book_old == nil {
            queue.async(group: group, execute: {
                group.enter()
                GYBookManager.shared.requestBookInfo(book.book_id, isRefresh: true, callBlock: { (result, err_msg,err_code) in
                    if err_msg != nil {
                        _err_msg = err_msg!
                        _code = err_code!
                        group.leave()
                    }else {
                        book = result!
                        group.leave()
                    }
                    
                })
            })
        }else{
            book = book_old!
        }
        
        queue.async(group: group, execute: {
            group.enter()
            GYBookManager.shared.getChapterListFromServer(book, locationList: nil, completion: { (list_new) in
                list_old = list_new
                group.leave()
            }) { (code, err_msg) in
                _err_msg = err_msg
                _code = code
                group.leave()
                
            }
            
        })
        
        queue.async(group: group, execute: {
            group.enter()
            GYBookManager.shared.getNotListNewChapterContent(book.book_id, tid: tid, completion: { (c) in
                chapter = c
                group.leave()
            }, failed: { (code, err_msg) in
                _err_msg = err_msg
                _code = code
                group.leave()
                
            })
            
        })
        
        group.notify(queue: queue) {
            
            DispatchQueue.main.async {
                if _err_msg == nil {
                    if chapter != nil {
                        completion?(book,chapter!,list_old)
                    }else{
                        completion?(book,MQIEachChapter(),list_old)
                    }
                }else{
                    error_block?(_code!,_err_msg!)
                }
            }
            
        }
        
    }
    
    func getBookExtention(_ book_id:String) {
        MQIBookExtentionRequest(book_id: book_id).request({[weak self] (_, _, model) in
            if let is_new_book = model.dict["is_new_book"] as? Bool {
                if let  new_book_limit_time = model.dict["new_book_limit_time"] as? Int {
                    if new_book_limit_time < getCurrentStamp(){
                        self?.is_new_book = false
                    }else{
                        self?.is_new_book = is_new_book
                    }
                }else{
                    self?.is_new_book = is_new_book
                }
                
            }
            
        }) { (err_msg, code) in
            
        }
    }
}
