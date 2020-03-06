//
//  GYReadMenu.swift
//  Reader
//
//  Created by _CHK_  on 2017/6/23.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit

import Spring

@objc protocol GYReadMenuDelegate: NSObjectProtocol {
    
    /// 状态栏 将要 - 隐藏以及显示状态改变
    @objc optional func readMenuWillShowOrHidden(readMenu: GYReadMenu, isShow: Bool)
    
    /// 状态栏 完成 - 隐藏以及显示状态改变
    @objc optional func readMenuDidShowOrHidden(readMenu: GYReadMenu, isShow: Bool)
    
    /// 点击下载
    @objc optional func readMenuClickDownload(readMenu: GYReadMenu)
    
    /// 点击书签按钮
    @objc optional func readMenuClickMarkButton(readMenu: GYReadMenu, button: UIButton)
    
    /// 点击上一章（上一话）
    @objc optional func readMenuClickPreviousChapter(readMenu: GYReadMenu)
    
    /// 点击下一章（下一话）
    @objc optional func readMenuClickNextChapter(readMenu: GYReadMenu)
    
    /// 停止滚动进度条
    @objc optional func readMenuSliderEndScroll(readMenu: GYReadMenu, slider: MQISliderPopover)
    
    /// 滚动条滚动中
    @objc optional func readMenuSliderChangeScroll(readMenu: GYReadMenu, slider: MQISliderPopover)
    /// 点击背景颜色
    @objc optional func readMenuClicksetupColor(readMenu: GYReadMenu, index: NSInteger)
    
    /// 点击翻书动画
    @objc optional func readMenuClicksetupEffect(readMenu: GYReadMenu, type: String)
    
    /// 点击字体类型
    @objc optional func readMenuClicksetupFont(readMenu: GYReadMenu, type: String)
    
    /// 点击字体大小
    @objc optional func readMenuClicksetupFontSize(readMenu: GYReadMenu, fontSize: CGFloat)
    
    /// 点击修改该行高
    @objc optional func readMenuClicksetupLineHeight(readMenu: GYReadMenu, linHeight: CGFloat)
    
    /// 点击修改该段落高度
    @objc optional func readMenuClicksetupParagraphHeight(readMenu: GYReadMenu, paragraphHeight: CGFloat)
    
    /// 点击修改该文字间距
    @objc optional func readMenuClicksetupLetterSpace(readMenu: GYReadMenu, letterSpace: CGFloat)
    
    /// 点击修改该文字粗细
    @objc optional func readMenuClicksetupFontWidth(readMenu: GYReadMenu, fontWidth: CGFloat)
    
    /// 点击日间夜间
    @objc optional func readMenuClickLightButton(readMenu: GYReadMenu, isDay: Bool)
    
    /// 点击章节列表
    @objc optional func readMenuClickChapterList(readMenu: GYReadMenu)
    
    /// 点击简体繁体
    @objc optional func readMenuClickSimple(readMenu: GYReadMenu)
    
    /// 点击订阅
    @objc optional func readMenuClickSubscribe(readMenu: GYReadMenu, isSubscribe: Bool)
    
    /// 展示更多字体
    @objc optional func readMenuClickShowMoreFont(readMenu: GYReadMenu)
    
    /// 加入书架
    @objc optional func readMenuClickAddShelf(readMenu: GYReadMenu)
    
    /// 打赏
    @objc optional func readMenuClickReward(readMenu: GYReadMenu, coin: Int)
    
    /// 购买 非全本
    @objc optional func readMenuClickBuyChapter(readMenu: GYReadMenu,subscribeCount:Int)
    
    /// 购买 全本
    @objc optional func readMenuClickBuyBook(readMenu: GYReadMenu)
    
    /// 分享
    @objc optional func readMenuClickShared(readMenu: GYReadMenu)
    /// 分享
    @objc optional func readMenuClickComment(readMenu: GYReadMenu)
    
    @objc optional func readMenuClickToDetail(readMenu:GYReadMenu)
    /// 报错
    @objc optional func readMenuClickAnError(readMenu:GYReadMenu)
}


let GYReaderToolBar_moreBtnSide: CGFloat = 48
let GYReaderToolBar_moreSpace: CGFloat = 5
class GYReadMenu: NSObject, UIGestureRecognizerDelegate {
    
    
    private(set) weak var vc: MQIReadViewController! /// 控制器
    private(set) weak var delegate: GYReadMenuDelegate! /// 代理
    private var animateDuration: TimeInterval = 0.20 /// 阅读页面动画的时间
    public var menuShow: Bool = false /// 菜单显示
    private(set) var singleTap: UITapGestureRecognizer! /// 单击手势
    private(set) var bacView: UIView! //设置背景View
    private(set) var topView: GYRMTopView! /// TopView
    private(set) var topActionView: GYRMTopActionView!
    private(set) var bottomView: GYRMBottomView! /// BottomView
    private(set) var moreView: GYRMMoreView!
    private(set) var lightView: GYRMLightView! /// 亮度
    private(set) var rewardView: GYUserRewardView!//打赏界面
    private(set) var subscribeView:MQIUserSubscribeView!//订阅界面
    var coverView: UIView! /// 遮盖亮度
    private(set) var novelsSettingView: GYRMSettingView! /// 小说阅读设置
    private(set) var readProgressView:GDReadProgressView!
    private let MoreViewH: CGFloat = 270 //MoreView 高
    private let BottomViewH: CGFloat = 110 + x_TabbatSafeBottomMargin/// BottomView 高
    private let NovelsSettingViewH: CGFloat = 300 + x_TabbatSafeBottomMargin/// NovelsSettingView 高
    private let LightViewH:CGFloat = 64 /// LightView 高
    
    /// 初始化
    class func readMenu(vc: MQIReadViewController, delegate: GYReadMenuDelegate) ->GYReadMenu {
        let readMenu = GYReadMenu(vc: vc, delegate: delegate)
        return readMenu
    }
    
    /// 初始化函数
    private init(vc: MQIReadViewController, delegate: GYReadMenuDelegate) {
        super.init()
        // 记录
        self.vc = vc
        self.delegate = delegate
        // 允许获取电量信息
        UIDevice.current.isBatteryMonitoringEnabled = true
        // 隐藏导航栏
        vc.fd_prefersNavigationBarHidden = true
        // 禁止手势返回
        vc.fd_interactivePopDisabled = true
        // 添加手势
        initTapGestureRecognizer()
        // 创建UI
        creatUI()
        //        // 初始化数据
        //        initData()
    }
    
    /// 创建UI
    private func creatUI() {
        
        initBacView()  //初始化背景
        initTopView() // 初始化TopView
        initTopActionView() //初始化TopActionView
        initBottomView() // 初始化BottomView
        initMoreView()
        initNovelsSettingView() // 初始化NovelsSettingView
        initCoverView() // 初始化遮盖亮度
        initLightView() //初始化亮度
    }
    //阅读进度弹窗
    func addServerReadProgressView(_ frame:CGRect,model:MQIReadProgressModel,chapterBlock:(()->())?) {
        
        guard readProgressView == nil else {
            return
        }
        readProgressView = GDReadProgressView(frame: frame,model:model)
        vc.view.addSubview(readProgressView)
        vc.view.bringSubviewToFront(readProgressView)
        readProgressView.actionCancelBlock = {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.readProgressView.removeFromSuperview()
                weakSelf.readProgressView = nil
                //                GDReadProgressManager.shared.saveLocal_user_bids(weakSelf.vc.bid)
            }
        }
        readProgressView.actionToChapterBlock = {[weak self]()->Void in
            chapterBlock?()
            if let weakSelf = self {
                GDReadProgressManager.shared.saveLocal_user_bids(weakSelf.vc.bid)
                weakSelf.readProgressView.removeFromSuperview()
                weakSelf.readProgressView = nil
            }
        }
        
    }
    // MARK: -- TapGestureRecognizer
    
    /// 初始化TapGestureRecognizer
    private func initTapGestureRecognizer() {
        // 单击手势
        singleTap = UITapGestureRecognizer(target: self, action: #selector(GYReadMenu.touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        vc.view.addGestureRecognizer(singleTap)
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        guard vc.allowToCover == true else {
            return
        }
        if let lastView = vc.lastTouchView {
            if !menuShow {//需要show
                lastView.isHidden = true
            }
        }
        
        menuSH()
    }
    
    // MARK: -- UIGestureRecognizerDelegate
    
    /// 点击这些控件不需要执行手势
    private let ClassString: [String] = ["UIScrollView", "UITableViewCellContentView", "GYRMTopView", "GYRMBottomView", "GYRMSettingView", "GYRMSettingCell", "GYRMSettingSubView", "GYRMSettingMoreCell", "GYRMLightView", "GYRMMoreView", "GYRMLightView"]
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let classString = String(describing: touch.view!.classForCoder.self)
        if ClassString.contains(classString) {
            return false
        }else {
            return true
        }
    }
    
    /// 初始化数据
    func initData() {
        // 进度条数据初始化
        bottomView.sliderUpdate()
    }
    
    
    func initBacView() {
        bacView = UIView(frame: UIScreen.main.bounds)
        bacView.isHidden = !menuShow
        bacView.backgroundColor = UIColor(white: 0, alpha: 0)
        bacView.isUserInteractionEnabled = true
        vc.view.addSubview(bacView)
    }
    
    /// 初始化LightView
    private func initLightView() {
        lightView = GYRMLightView(readMenu:self)
        lightView.isHidden = true
        bacView.addSubview(lightView)
        lightView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: LightViewH)
    }
    
    /// 初始化 MoreView
    private func initMoreView() {
        moreView = GYRMMoreView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: MoreViewH), readMenu: self)
        moreView.isHidden = true
        bacView.addSubview(moreView)
    }
    
    /// 初始化NovelsSettingView
    private func initNovelsSettingView() {
        novelsSettingView = GYRMSettingView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: NovelsSettingViewH), readMenu: self)
        novelsSettingView.isHidden = true
        bacView.addSubview(novelsSettingView)
    }
    
    // MARK: -- CoverView
    
    /// 初始化CoverView
    private func initCoverView() {
        coverView = UIView(frame: bacView.bounds)
        coverView.isUserInteractionEnabled = false
        coverView.backgroundColor = UIColor.black
        coverView.alpha = CGFloat(GYReadStyle.shared.styleModel.bookBrightness)
        vc.view.addSubview(coverView)
    }
    
    /// 初始化TopView
    private func initTopView() {
        topView = GYRMTopView(frame: CGRect(x: 0, y: -NavgationBarHeight, width: screenWidth, height: NavgationBarHeight), readMenu: self)
        topView.isHidden = !menuShow
        bacView.addSubview(topView)
    }
    
    private func initTopActionView() {
        let size = GYRMTopActionView.getSize()
        var Y:CGFloat = -20
        if MQIPayTypeManager.shared.type == .inPurchase {
            Y = 0
        }
        topActionView = GYRMTopActionView(frame: CGRect(x: bacView.width-size.width/2-5, y:Y, width: size.width, height: size.height), readMenu: self)
        topActionView.layer.cornerRadius = 5
        topActionView.layer.masksToBounds = true
        topActionView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        topActionView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        topActionView.isHidden = !menuShow
        bacView.addSubview(topActionView)
    }
    
    // 打赏页面
    private func initRewardView() {
        rewardView = GYUserRewardView(frame: CGRect(x: 0, y: vc.view.height, width: vc.view.width, height: GYUserRewardView.getHeight()))
        rewardView.isHidden = true
        rewardView.book = vc.book
        rewardView.rewardCoin = {[weak self](coin) -> Void in
            if let strongSelf = self {
                strongSelf.delegate?.readMenuClickReward?(readMenu: strongSelf, coin: coin)
            }   
        }
        vc.view.addSubview(rewardView)
    }
    //订阅界面
    private func initsubscribeView() {
        if vc.book.checkIsWholdSubscribe() == false {
            subscribeView = GDUserSubscribeChpaterView(frame: CGRect (x: 0, y: vc.view.height, width: vc.view.width, height: GDUserSubscribeChpaterView.getHeight()), book: vc.book)
            subscribeView.readMenu = self
        }else {
            subscribeView = GDUserSubscribeBookView(frame: CGRect (x: 0, y: vc.view.height, width: vc.view.width, height: GDUserSubscribeBookView.getHeight()), book: vc.book)
            subscribeView.readMenu = self
        }
        
        subscribeView.isHidden = true
        subscribeView.subScribeCount = {[weak self](count)->Void in
            if let weakSelf = self {
                if count == 10000 {
                    if weakSelf.topView.buyBtn.isSelected == true {
                        weakSelf.topView.buyBtn.isSelected = false
                        weakSelf.subscribeView(isShow: false,completion:nil)
                    }
                }else if count == -1 {
                    weakSelf.delegate.readMenuClickBuyBook?(readMenu:weakSelf)
                }else{
                    weakSelf.delegate.readMenuClickBuyChapter?(readMenu:weakSelf,subscribeCount:count)
                }
            }
        }
        
        vc.view.addSubview(subscribeView)
        
    }
    /// 返回
    func back() {
        vc.popVC()
    }
    
    // MARK: -- BottomView
    private func initBottomView() {
        bottomView = GYRMBottomView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: BottomViewH), readMenu: self)
        bottomView.isHidden = !menuShow
        bacView.addSubview(bottomView)
        // 设置为日夜间 默认日间
        bottomView.lightBtn.isSelected = MQIUserDefaults.boolForKey(GYKey_IsNighOrtDay)
    }
    
    /// 动画是否完成
    private var isAnimatecompletion: Bool = true
    
    /// 菜单 show hidden
    func menuSH() {
        menuSH(isShow: !menuShow)
    }
    
    /// 菜单 show hidden
    func menuSH(isShow: Bool) {
        
        if rewardView != nil {
            if topActionView.showReward == true {
                topActionView.showReward = false
                rewardView(isShow: false, completion: nil)
                return
            }
        }
        if subscribeView != nil {
            if topView.buyBtn.isSelected == true {
                topView.buyBtn.isSelected = false
                subscribeView(isShow: false,completion:nil)
                
                return
            }
            
        }
        
        if isAnimatecompletion {
            vc.isStatusBarHidden = !isShow
        }
        
        if isShow == false && topActionView.isHidden == false {
            topActionView(isShow: false, completion: { [weak self] in
                if let strongSelf = self {
                    strongSelf.topView.moreBtn.isSelected = false
                    strongSelf.menu(isShow: isShow)
                }
            })
            return
        }
        if let lastView = vc.lastTouchView {
            if !menuShow == false {
                lastView.isHidden = false
            }
        }
        menu(isShow: isShow)
        
        
    }
    
    /// 总控制
    private func menu(isShow: Bool) {
        if menuShow == isShow || !isAnimatecompletion {return}
        isAnimatecompletion = false
        menuShow = isShow
        // 将要动画
        
        delegate?.readMenuWillShowOrHidden?(readMenu: self, isShow: menuShow)
        bottomView(isShow: isShow, completion: nil)
        novelsSettingView(isShow: false, completion: nil)
        moreView(isShow: false, completion: nil)
        lightView(isShow: false, completion:nil)
        topView(isShow: isShow) {[weak self]()->Void in
            if let strongSelf = self {
                strongSelf.bacView.isHidden = !isShow
                strongSelf.isAnimatecompletion = true
                // 完成动画
                strongSelf.delegate?.readMenuDidShowOrHidden?(readMenu: strongSelf, isShow: strongSelf.menuShow)
            }
        }
    }
    
    /// TopView 展示
    func topView(isShow: Bool, completion: (()->Void)?) {
        if topView.isHidden == !isShow {return}
        if isShow {topView.isHidden = false; bacView.isHidden = false}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: NavgationBarHeight)
                }else{
                    strongSelf.topView.frame = CGRect(x: 0, y: -NavgationBarHeight, width: screenWidth, height: NavgationBarHeight)
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.topView.isHidden = true}
                completion?()
            }
        }
    }
    
    func topActionView(isShow: Bool, completion: (()->Void)?) {
        if topActionView.isHidden == !isShow {return}
        topActionView.origin.y = topView.origin.y+topView.bounds.height+10
        if isShow {
            topActionView.layer.anchorPoint = CGPoint(x: 1, y: 0)
            topActionView.isHidden = false;
            bacView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            if let strongSelf = self {
                if isShow == true {
                    strongSelf.topActionView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }else {
                    strongSelf.topActionView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
                }
            }
            }, completion: {[weak self] (suc) in
                if let strongSelf = self {
                    if !isShow {
                        strongSelf.topActionView.isHidden = true
                    }
                }
                completion?()
        })
    }
    
    
    /// BottomView 展示
    func bottomView(isShow: Bool, completion: (()->Void)?) {
        
        if bottomView.isHidden == !isShow {return}
        if isShow {bottomView.isHidden = false; bacView.isHidden = false; self.bottomView.slider.popover.alpha = 1}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.bottomView.frame = CGRect(x: 0, y: screenHeight - strongSelf.BottomViewH, width: screenWidth, height: strongSelf.BottomViewH)
                    strongSelf.bottomView.reloadThemeModel()
                }else{
                    strongSelf.bottomView.slider.popover.alpha = 0
                    strongSelf.bottomView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: strongSelf.BottomViewH)
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.bottomView.isHidden = true}
                completion?()
            }
        }
    }
    
    /// MoreView 展示
    func moreView(isShow: Bool, completion: (() -> ())?) {
        if moreView.isHidden == !isShow {return}
        if isShow {moreView.isHidden = false; moreView.isSubscribe =  GYBookManager.shared.checkIsSubscriber(vc.book, type: vc.book.checkIsWholdSubscribe() == true ? .book : .chapter)}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.moreView.frame = CGRect(x: 0, y: screenHeight - strongSelf.MoreViewH-x_TabbatSafeBottomMargin, width: screenWidth, height: strongSelf.MoreViewH)
                }else{
                    strongSelf.moreView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: strongSelf.MoreViewH)
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.moreView.isHidden = true}
                completion?()
            }
        }
    }
    
    /// LightView 展示
    func lightView(isShow:Bool,completion:(()->Void)?) {
        
        if lightView.isHidden == !isShow {return}
        if isShow {lightView.isHidden = false}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.lightView.frame = CGRect(x: 0, y: screenHeight - strongSelf.LightViewH-x_TabbatSafeBottomMargin, width: screenWidth, height: strongSelf.LightViewH)
                }else{
                    strongSelf.lightView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: strongSelf.LightViewH)
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.lightView.isHidden = true}
                completion?()
            }
        }
    }
    
    /// NovelsSettingView 展示
    func novelsSettingView(isShow: Bool, completion: (()->Void)?) {
        if novelsSettingView.isHidden == !isShow {return}
        if isShow {novelsSettingView.isHidden = false}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.novelsSettingView.frame = CGRect(x: 0, y: screenHeight - strongSelf.NovelsSettingViewH, width: screenWidth, height: strongSelf.NovelsSettingViewH)
                }else{
                    strongSelf.novelsSettingView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: strongSelf.NovelsSettingViewH)
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.novelsSettingView.isHidden = true}
                completion?()
            }
        }
    }
    //订阅view的显示或隐藏
    func subscribeView(isShow:Bool, currentChapter: MQIEachChapter? = nil, completion:(()->())?) {
        if subscribeView == nil {
            initsubscribeView()
        }
        subscribeView.chapter = currentChapter
        if topView.buyBtn.isSelected == !isShow {
            topView.buyBtn.isSelected = isShow
        }
        
        if subscribeView.isHidden == !isShow{return}
        if isShow{subscribeView.isHidden = false}
        UIView.animate(withDuration: animateDuration, animations: {[weak self]()->Void in
            if let weakSelf = self {
                if isShow{
                    weakSelf.subscribeView.y = screenHeight - weakSelf.subscribeView.height-x_TabbatSafeBottomMargin
                }else {
                    weakSelf.subscribeView.y = screenHeight
                }
            }
        }) { [weak self](isOK) in
            if let weakSelf = self {
                if !isShow {
                    weakSelf.subscribeView.isHidden = true
                    after(0.2, block: {
                        weakSelf.subscribeView.dismissFinishView()
                    })
                }
                completion?()
            }
        }
        
    }
    func rewardView(isShow: Bool, completion: (() -> ())?) {
        if rewardView == nil {
            initRewardView()
        }
        
        if rewardView.isHidden == !isShow {return}
        if isShow {rewardView.isHidden = false}
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            if let strongSelf = self {
                if isShow {
                    strongSelf.rewardView.y = screenHeight-GYUserRewardView.getHeight() - x_TabbatSafeBottomMargin
                }else{
                    strongSelf.rewardView.y = screenHeight
                }
            }
        }) {[weak self] (isOK) in
            if let strongSelf = self {
                if !isShow {strongSelf.rewardView.isHidden = true}
                completion?()
            }
        }
    }
}

