//
//  MQIReadPageViewController.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


struct pageVCLayout {
    var s_width: CGFloat = screenWidth
    var s_height: CGFloat = screenHeight
    
    var margin_top: CGFloat = 0
    var margin_bottom: CGFloat = 0
    var margin_left: CGFloat = 0
    var margin_right: CGFloat = 0
    
    var titleView_height: CGFloat = 0
    var titleView_tableView_space: CGFloat = 0
    
    var statusView_height: CGFloat = 0
    var statusView_tableView_space: CGFloat = 0
}

class MQIReadPageViewController: UIViewController {
    
    var gtableView: MQITableView!
    
    var pageLayout: pageVCLayout!
    
    /// 阅读控制器
    weak var readController: MQIReadViewController!
    
    /// 顶部状态栏
    private(set) var topStatusView: GYRMTitleView?
    
    /// 底部状态栏
    private(set) var bottomStatusView: GYRMStatusView?
    
    fileprivate var preloadView: MQIReadPagePreloadView?
    fileprivate var wrongView: MQIReadPageWrongView?
    
    /// 上下翻页模式 cell高度
    fileprivate var udCellFrame: (CTFrame?, CGFloat)?
    
    /// 临时阅读记录
    var readRecordModel: MQIReadRecordModel?
    
    fileprivate var udHeader: MQIReadPageHeader?
    fileprivate var udFooter: MQIReadPageFooter?
    
    fileprivate var chapter: MQIEachChapter! {
        if let c = readController.readModel.readRecordModel?.readChapterModel {
            return c
        }else {
            return MQIEachChapter()
        }
    }
    
    lazy var effectType: GYReadEffectType! = {
        return GYReadStyle.shared.styleModel.effectType
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 配置坐标先
        pageLayout = GetPageVCLayout()
        
        // 添加子控件
        setupUI()
        
        // 配置背景颜色
        configureBGColor()
        
        // 配置阅读模式
        configureReadEffect()
        
        // 配置阅读记录
        configureReadRecordModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let readController = readController {
            readController.allowToCover = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        if let _ = readRecordModel {
        // 释放该临时模型
            readRecordModel = nil
        }
        // 移除定时器
        bottomStatusView?.removeTimer()
        
        if let udHeader = udHeader {
            udHeader.removeObservers()
            self.udHeader = nil
        }
        
        if let udFooter = udFooter {
            udFooter.removeObservers()
            self.udFooter = nil
        }
    }
}


extension MQIReadPageViewController: MQITableViewDelegate {
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        if effectType == .upAndDown {  //上下滚动
            if let readRecordModel = readRecordModel {
                if let c = readRecordModel.readChapterModel {
                    let chapterIndex = readRecordModel.chapterIndex.intValue
                    guard chapterIndex == -1 else {
                        return  c.frameRefs.count
                    }
                    return 1
                }
            }
            return 1
        }else {
            
            return 1
        }
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        if effectType == .upAndDown {  //上下滚动
            return 1
        }else {
            return 1
        }
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        if effectType == .upAndDown { // 上下滚动
            //            return getUDCellFrameRef().1 < gtableView.height ? gtableView.height : getUDCellFrameRef().1
            return tableView.height
            
        }else {
            return tableView.height
        }
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(MQIReadPageTableViewCell.self, forIndexPath: indexPath)
        if let readRecordModel = readRecordModel {
            let page = readRecordModel.page.intValue
            let chapterIndex = readRecordModel.chapterIndex.intValue
            if let c = readRecordModel.readChapterModel {
                //最后一页
                //                if let readVC = readController {
                //                    let chapterCount = readVC.readModel.chapterList.count
                //                    if chapterIndex == chapterCount {
                //                        cell.addReadEndView()
                //                        return cell
                //                    }
                //                }
                if c.frameRefs.count > page {
                    guard chapterIndex == -1 else {
                        
                        if effectType == .upAndDown { // 上下滚动
                            //                            let frameRef = getUDCellFrameRef()
                            //                            let height = udCellFrame!.1 < gtableView.height ? udCellFrame!.1 : 0
                            
                            cell.addUDReadView(c.frameRefs[indexPath.section], height: 0)
                            
                        }else {
                            cell.addReadView(c.frameRefs[page])
                        }
                        return cell
                    }
                    cell.addReadCoverView(readController.book)
                }
            }
        }
        return cell
    }
    
    func gScrollViewDidEndDecelerating(_ tableView: MQITableView!) {
        configUDPage()
    }
    
    func gScrollViewDidEndDragging(_ tableView: MQITableView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            configUDPage()
        }
    }
    
}


//MARK:  操作方法
extension MQIReadPageViewController{
    
    // MARK: -- 配置背景颜色
    func configureBGColor() {
        let temeModel = GYReadStyle.shared.styleModel.themeModel!
        topStatusView?.textColor = temeModel.statusColor
        bottomStatusView?.textColor = temeModel.statusColor
        view.layer.contents = temeModel.bgImage.cgImage
    }
    
    //重新加载
    func reload() {
        checkIsCoverPage()
        configureBGColor()
        configureReadRecordModel()
        
        if let wrongView = wrongView {
            wrongView.reloadColor()
        }else {
            if effectType == .upAndDown {
                udCellFrame = nil
                gtableView.reloadData()
                fixPage()
            }else {
                gtableView.reloadData()
            }
        }
    }
    
    //MARK: --
    @discardableResult func checkIsCoverPage() -> Bool {
        if let readRecordModel = readRecordModel {
            let chapterIndex = readRecordModel.chapterIndex.intValue
            guard chapterIndex == -1 else {
                return false
            }
            
            gtableView.frame = view.bounds
            view.bringSubviewToFront(gtableView)
            return true
        }
        return false
    }
    
    // MARK: -- 阅读模式
    
    /// 配置阅读效果
    func configureReadEffect() {
        if effectType != .upAndDown {
            gtableView.isScrollEnabled = false
        }else {
            gtableView.isScrollEnabled = true
        }
    }
    
    // MARK: -- 滚动到阅读记录
    /// 配置阅读记录
    func configureReadRecordModel() {
        
        if let readRecordModel = readRecordModel {
            if topStatusView != nil && gtableView != nil {
                topStatusView!.bookLabel.text = "《\(readController.book.book_name)》"
                topStatusView!.chapterLabel.text = chapter.chapter_title
            }
            
            if effectType == .upAndDown { // 上下滚动
                if bottomStatusView != nil {
                    bottomStatusView!.isHidden = true
                }
            }else {
                if bottomStatusView != nil {
                    bottomStatusView!.isHidden = false
                    bottomStatusView!.titleLabel.text = "\(readRecordModel.page.intValue + 1)/\(chapter.pageCount.intValue)"
                }
                readController.readMenu.bottomView.sliderUpdate()
            }
        }
    }
    
    
    func configUDPage() {
        if let readRecordModel = readRecordModel {
            if let c = readRecordModel.readChapterModel {
                let total = c.pageCount.intValue
                
                let offsetHeight = gtableView.contentSize.height/CGFloat(total)
                
                var index: Int = 0
                while CGFloat(index+1)*offsetHeight < gtableView.contentOffset.y {
                    index += 1
                }
                if gtableView.contentOffset.y+gtableView.height+50 >= gtableView.contentSize.height {
                    index = total-1
                }
                readRecordModel.page = NSNumber(value: index)
            }
        }
    }
    
    func getUDCellFrameRef() -> (CTFrame?, CGFloat)  {
        guard udCellFrame == nil else {
            return udCellFrame!
        }
        guard checkIsCoverPage() == false else {
            udCellFrame = (nil, screenHeight)
            return udCellFrame!
        }
        if let readRecordModel = readRecordModel {
            if let c = readRecordModel.readChapterModel {
                
                udCellFrame = GYReadParser.GetReadFrameRef(title: c.chapter_htmlTitle,
                                                           titleAttrs: GYReadStyle.shared.readTitleAttribute(),
                                                           content: c.chapter_htmlContent,
                                                           attrs: GYReadStyle.shared.readAttribute())
                //                MQLog("\(c.chapter_htmlTitle)    \(c.chapter_htmlContent)")
                return udCellFrame!
            }
        }
        
        return (nil, gtableView.height)
    }
    
    func fixPage() {
        if let readRecordModel = readRecordModel {
            if let c = readRecordModel.readChapterModel {
                let total = c.pageCount.intValue
                let page = readRecordModel.page.intValue
                
                let offsetHeight = gtableView.contentSize.height/CGFloat(total)
                
                var pointHeight: CGFloat = CGFloat(page)*offsetHeight
                if page == total-1 {
                    pointHeight = gtableView.contentSize.height-gtableView.height
                }
                if readRecordModel.chapterIndex != -1 {
                    gtableView.setContentOffset(CGPoint(x: 0, y: pointHeight), animated: false)
                }
                
                readController.readMenu.bottomView.UDSliderUpdate(pointHeight, maxOffsetY: gtableView.contentSize.height-gtableView.height)
            }
            
        }
    }
    
    func pullToOffsetY(_ offsetY: CGFloat) {
        let max = gtableView.contentSize.height-gtableView.height
        gtableView.setContentOffset(CGPoint(x: 0, y: offsetY > max ? max : offsetY), animated: false)
    }
    
}


//MARK:  配置UI
extension MQIReadPageViewController{
    /// 创建UI
    func setupUI() {
        
        // TopStatusView
        topStatusView = GYRMTitleView(frame: CGRect(x: pageLayout.margin_left,
                                                    y: pageLayout.margin_top+x_StatusBarHeight-20,
                                                    width: view.width-pageLayout.margin_left-pageLayout.margin_right,
                                                    height: pageLayout.titleView_height))
        topStatusView!.backgroundColor = UIColor.clear
        //        topStatusView?.backgroundColor = UIColor.yellow
        view.addSubview(topStatusView!)
        
        // BottomStatusView
        bottomStatusView = GYRMStatusView(frame:CGRect(x: pageLayout.margin_left,
                                                       y: view.frame.height-pageLayout.margin_bottom-pageLayout.statusView_height-x_TabbatSafeBottomMargin,
                                                       width:view.width-pageLayout.margin_left-pageLayout.margin_right,
                                                       height: pageLayout.statusView_height))
        bottomStatusView!.backgroundColor = UIColor.clear
        //        bottomStatusView?.backgroundColor = UIColor.yellow
        bottomStatusView!.isHidden = effectType == .upAndDown
        view.addSubview(bottomStatusView!)
        
        let maxHeight = effectType == .upAndDown ? (view.height - x_TabbatSafeBottomMargin) : bottomStatusView!.y-pageLayout.titleView_tableView_space
        gtableView = MQITableView(frame: CGRect(x: pageLayout.margin_left,
                                                y: topStatusView!.maxY+pageLayout.statusView_tableView_space,
                                                width: view.width-pageLayout.margin_left-pageLayout.margin_right,
                                                height: maxHeight-topStatusView!.maxY-pageLayout.statusView_tableView_space))
        gtableView.gyDelegate = self
        gtableView.separatorStyle = .none
        gtableView.backgroundColor = UIColor.clear
        gtableView.registerCell(MQIReadPageTableViewCell.self, xib: false)
        view.addSubview(gtableView)
        //        gtableView.backgroundColor = UIColor.red
        if #available(iOS 11.0, *) {
            gtableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if effectType == .upAndDown {
            gtableView.x = 0
            gtableView.width = view.width
            
            udHeader = MQIReadPageHeader
                .headerWithRefreshingBlock(gtableView, refreshingBlock: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.readController.coverController?.udToController(above: true)
                    }
                })
            gtableView.addSubview(udHeader!)
            
            udFooter = MQIReadPageFooter
                .footerWithRefreshingBlock(gtableView, refreshingBlock: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.readController.coverController?.udToController(above: false)
                    }
                })
            gtableView.addSubview(udFooter!)
            
            //            fixPage()
        }
        
        checkIsCoverPage()
        
    }
    //MARK: 重新加载 等待 错误页面
    func addPreloadView() {
        if preloadView == nil {
            preloadView = MQIReadPagePreloadView(frame: view.bounds)
            view.addSubview(preloadView!)
        }
        
        let index = GYReadStyle.shared.styleModel.bookThemeIndex
        if index >= 5 {
            preloadView!.activityView.style = .white
        }else {
            preloadView!.activityView.style = .gray
        }
        
        view.bringSubviewToFront(preloadView!)
    }
    
    func dismissPreloadView() {
        if let _ = preloadView {
            preloadView?.removeFromSuperview()
            preloadView = nil
        }
    }
    
    func addWrongView(_ msg: String, type: GYReadWrongType, unSubscribeChapter: MQIUnSubscribeChapter? = nil, refresh: @escaping (() -> ())) {
        dismissPreloadView()
        if wrongView == nil {
            var book: MQIEachBook
            var subChapter:MQIEachChapter
            //            if let sChapter  = unSubscribeChapter {
            //                if sChapter.chapter_title != "" {
            //                   chapter.chapter_title = sChapter.chapter_title
            //                }
            //                if sChapter.chapter_id != "" {
            //                    chapter.chapter_id = sChapter.chapter_id
            //                }
            //
            //            }
            if let _ = readController{
                book = readController.book
                subChapter = chapter
            }else {
                book=MQIEachBook()
                subChapter = MQIEachChapter()
            }
            
            wrongView = MQIReadPageWrongView(frame: gtableView.bounds,
                                            book: book,
                                            chapter: subChapter,
                                            msg: msg,
                                            wrongType: type,
                                            unSubscribeChapter: unSubscribeChapter,
                                            refresh: refresh)
            wrongView!.subscribeChaptersBlock = {[weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.readController.readMenu.subscribeView(isShow: true,
                                                                     currentChapter: strongSelf.readController.readModel.readRecordModel?.readChapterModel,
                                                                     completion: nil)
                }
            }
            wrongView!.y = -gtableView.y
            wrongView!.height = gtableView.y+gtableView.height
            gtableView.addSubview(wrongView!)
        }
        gtableView.bringSubviewToFront(wrongView!)
    }
    
    
    func dismissWrongView() {
        if let _ = wrongView {
            wrongView?.removeFromSuperview()
            wrongView = nil
        }
    }
}
