
//
//  GYShelfVC.swift
//  Reader
//
//  Created by CQSC  on 16/7/15.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit

import FSPagerView

import MJRefresh
class MQIShelfVC: MQIBaseShelfVC {

    var isRefreshing: Bool = false

    fileprivate var IsReturnFromReader: Bool = false
    fileprivate var topbackView: UIView!
    fileprivate var customNavView: UIView!
    fileprivate var rightBtn: UIButton!
    fileprivate var leftBtn: UIButton!

    var newUpdateBooks = [MQIEachBook]()
    var bookIds: [String]! {
        return books.map({ $0.book_id })
    }
    var lastBook: MQIEachBook? {
        didSet(oldValue) {
//            shelfActionViewHeader.lastBook = lastBook
        }
    }
    var loginInBool: Bool = false
    ///编辑状态
    var isEdit = false
    var selectedTag = 0 ///当前选中的类型值
    ///编辑中的书籍
    var editBooks = [MQIEachBook]() {
        didSet(oldValue) {
            if isHistory {
                chooseBtn.isSelected = (editBooks.count >= historyBooks.count) ? true : false
            } else {
                chooseBtn.isSelected = (editBooks.count >= books.count) ? true : false
            }

        }
    }

    var popupAdsenseModel = MQIPopupAdsenseModel() {
        didSet(oldValue) {
            if popupAdsenseModel.total != 0 {
                // 有数据
                gcollectionView.reloadData()
            } else {

            }
        }
    }

    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.frame = CGRect(x: 20, y: 0, width: screenWidth - 40, height: 100)
        viewPager.dsySetCorner(radius: 6)
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cellId")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //        //设置转场的模式
        //        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)

        return viewPager
    }()

    lazy var pagerControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: 50, y: 70, width: 80, height: 20))
        //设置下标的个数
        pageControl.numberOfPages = 8
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .selected)
        return pageControl

    }()

    /// 选中按钮下部状态栏
    fileprivate var bottomToolView: UIView!
    /// 全选btn
    fileprivate var chooseBtn: UIButton!

    public var collectionSections: Int! {
        if type == .tiled {
            return tiledBooks.count + 1
        } else {
            return 2
        }
    }

    fileprivate var editorBtn: UIButton!

    fileprivate var toastView: UIView!
    fileprivate var toastSelectedbBtn: UIButton?

    fileprivate var historyBooks = [MQIEachBook]() {
        didSet {
            if historyBooks.count <= 0 {
                addNoHistoryBook()
            } else {
                removeNoHistoryBook()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserNotifier.addObserver(self, selector: #selector(MQIShelfVC.loginIn), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQIShelfVC.loginOut), notification: .login_out)
        ShelfNotifier.addObserver(self, selector: #selector(MQIShelfVC.addShelfSuc(_:)), notification: .refresh_shelf)
        ShelfNotifier.addObserver(self, selector: #selector(MQIShelfVC.refreshLastBook), notification: .refresh_recent)
        ShelfNotifier.addObserver(self, selector: #selector(MQIShelfVC.refreshRecommendsBooks), notification: .refresh_recommends)
        nav.alpha = 0
        status.alpha = 0

        contentView.frame = CGRect(x: 0,
            y: 0,
            width: view.width,
            height: view.height - x_TabbarHeight)

        addTopView()

        contentScrView = UIScrollView(frame: CGRect(x: 0, y: customNavView.maxY, width: contentView.width, height: contentView.height - customNavView.maxY))
        contentScrView.bounces = false
        contentScrView.isPagingEnabled = true
        contentScrView.showsHorizontalScrollIndicator = false
        contentScrView.showsVerticalScrollIndicator = false
        contentScrView.delegate = self
        contentView.addSubview(contentScrView)
        contentScrView.contentSize = CGSize(width: 2 * contentView.width, height: 0)
        contentScrView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        gcollectionView.removeFromSuperview()
        gcollectionView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentScrView.height)
        contentScrView.addSubview(gcollectionView)

        addHistoryView()

        historyCollectionView.frame = CGRect(x: contentScrView.width, y: 0, width: contentScrView.width, height: contentScrView.height)
        contentScrView.addSubview(historyCollectionView)

        gcollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.getPopupAdsenseList()
                strongSelf.requestUpdate(strongSelf.bookIds, alert: true, completion: nil)
            }
        })

        configBooks(true)
        addBottomView()
//        requestShelfPush()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPopupAdsenseList()
        lastBook = MQIRecentBookManager.shared.books.first
        switch IsReturnFromReader {
        case true:
            historyBooks = MQIRecentBookManager.shared.books
            books = MQIShelfManager.shared.books
            gcollectionView.reloadData()
            historyCollectionView.reloadData()
            IsReturnFromReader = false
            break
        default:
            break
        }

    }

    override func switchLanguage() {
        super.switchLanguage()
        rightBtn.setTitle(kLocalized("ReadHistory"), for: .normal)
        leftBtn.setTitle(kLocalized("MineShelf"), for: .normal)
        bottomToolView.removeFromSuperview()
        addBottomView()
    }

    func addHistoryView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        historyCollectionView = MQICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        historyCollectionView.backgroundColor = bacColor
        historyCollectionView.gyDelegate = self
        historyCollectionView.alwaysBounceVertical = true
        historyCollectionView.registerCell(MQIShelfTiledsCell.self, xib: false)
        historyCollectionView.registerCell(MQIShelfListCell.self, xib: false)
        historyCollectionView.register(MQIShelfHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDHistoryHelfHeader")
    }

    /// 上部导航栏
    func addTopView() {

        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
//        customNavView.layer.addDefineLayer(customNavView.bounds)
        customNavView.backgroundColor = UIColor.white
        view.addSubview(customNavView)

        let bottomLineView = UIView(frame: CGRect(x: 0, y: customNavView.maxY - 1, width: customNavView.width, height: 1))
        bottomLineView.backgroundColor = UIColor.colorWithHexString("D4D7EA")
        customNavView.addSubview(bottomLineView)

        let titlelable = UILabel(frame: CGRect(x: 15, y: x_statusBarAndNavBarHeight, width: 100, height: 30))
        titlelable.font = UIFont.boldSystemFont(ofSize: 18)
        titlelable.textColor = kUIStyle.colorWithHexString("#1C1C1E")
        customNavView.addSubview(titlelable)
//        titlelable.text =  self.tabBarController?.selectedViewController?.tabBarItem.title
        titlelable.maxY = customNavView.maxY - 10


        leftBtn = UIButton()
        leftBtn.frame = CGRect(x: 0, y: x_statusBarAndNavBarHeight, width: kUIStyle.scale1PXW(100), height: 30)
        leftBtn.setTitleColor(UIColor.colorWithHexString("1C1C1E"), for: .selected)
        leftBtn.setTitleColor(UIColor.colorWithHexString("9DA0A9"), for: .normal)
        leftBtn.titleLabel?.font = kUIStyle.boldSystemFont(size: 18)
        customNavView.addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(topNavBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        leftBtn.contentHorizontalAlignment = .right
        leftBtn.centerY = titlelable.centerY
        leftBtn.maxX = customNavView.centerX - 15
        leftBtn.tag = 1001
        leftBtn.setTitle(kLocalized("MineShelf"), for: .normal)
        leftBtn.isSelected = true

        rightBtn = UIButton()
        rightBtn.frame = CGRect(x: 0, y: leftBtn.y, width: leftBtn.width, height: leftBtn.height)
        rightBtn.setTitleColor(UIColor.colorWithHexString("1C1C1E"), for: .selected)
        rightBtn.setTitleColor(UIColor.colorWithHexString("9DA0A9"), for: .normal)
        rightBtn.titleLabel?.font = kUIStyle.boldSystemFont(size: 18)
        customNavView.addSubview(rightBtn)
        rightBtn.addTarget(self, action: #selector(topNavBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        rightBtn.contentHorizontalAlignment = .left
        rightBtn.centerY = leftBtn.centerY
        rightBtn.x = customNavView.centerX + 15
        rightBtn.tag = 1002
        rightBtn.setTitle(kLocalized("ReadHistory"), for: .normal)


        editorBtn = UIButton()
        editorBtn.frame = CGRect(x: customNavView.width - 60 - 20, y: 0, width: 60, height: 44)
        editorBtn.setTitleColor(UIColor.colorWithHexString("ABB5B7"), for: .selected)
        editorBtn.titleLabel?.font = kUIStyle.boldSystemFont(size: 12)
        customNavView.addSubview(editorBtn)

        editorBtn.addTarget(self, action: #selector(editorBtnAction), for: UIControl.Event.touchUpInside)
        editorBtn.setImage(UIImage(named: "CHK_ditor_image")?.withRenderingMode(.alwaysTemplate), for: .normal)
        editorBtn.setImage(UIImage(named: "CHK_close_image")?.withRenderingMode(.alwaysTemplate), for: .selected)
        editorBtn.imageView?.contentMode = .scaleAspectFit
        editorBtn.contentHorizontalAlignment = .right
        editorBtn.tintColor = kUIStyle.colorWithHexString("#1C1C1E")
        editorBtn.titleLabel?.textAlignment = NSTextAlignment.center
        editorBtn.centerY = titlelable.centerY


//        let  searchbutton = view.addCustomButton(CGRect.init(x: editorBtn.x-40, y: 0, width: 22, height: 22), title: nil, action: {[weak self] (btn) in
//            if let weakSelf = self{
//                weakSelf.restoreState()
//                weakSelf.pushVC(MQISearchVC())
//            }
//        })
//        searchbutton.centerY = titlelable.centerY
//        let image =  UIImage(named: "shelf_searchBtn")?.withRenderingMode(.alwaysTemplate)
//        searchbutton.setImage(image, for: .normal)
//        searchbutton.tintColor = kUIStyle.colorWithHexString("#1C1C1E")
//        customNavView.addSubview(searchbutton)



    }
    @objc func editorBtnAction() {

        if isHistory {
            if historyBooks.count <= 0 {
                editorBtn.isSelected = false
                return
            }
        } else {
            if self.books.count <= 0 {
                editorBtn.isSelected = false
                return
            }
        }

        editorBtn.isSelected = !editorBtn.isSelected
        self.isEdit = editorBtn.isSelected
        self.bottomToolView.isHidden = !editorBtn.isSelected
        self.bottomAnimate(view: self.tabBarController!.tabBar, state: editorBtn.isSelected)
        self.bottomAnimate(view: self.bottomToolView, state: !editorBtn.isSelected)
        if editorBtn.isSelected {
            editBooks.removeAll()
        }
        reloadCollectionView()

    }

    @objc func topNavBtnAction(btn: UIButton) {

        switch btn.tag {
        case 1001:
            changeNavBtnData(false)
            contentScrView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        default:
            changeNavBtnData(true)
            contentScrView.setContentOffset(CGPoint(x: contentScrView.width, y: 0), animated: true)
        }

    }

    //MARK:  添加Bottom视图
    func addBottomView() -> Void {
        bottomToolView = UIView(frame: CGRect(x: 0, y: kUIStyle.kScrHeight - kUIStyle.kTabBarHeight, width: kUIStyle.kScrWidth, height: kUIStyle.kTabBarHeight))
        bottomToolView.backgroundColor = UIColor.white
        bottomToolView.layer.shadowColor = UIColor.black.cgColor // 阴影颜色
        bottomToolView.layer.shadowOffset = CGSize.init(width: 0, height: 0) // 偏移距离
        bottomToolView.layer.shadowOpacity = 0.5 // 不透明度
        bottomToolView.layer.shadowRadius = 5.0 // 半径
        bottomToolView.isHidden = true
        self.tabBarController!.view.addSubview(bottomToolView)

        let deleteBtn = UIButton(frame: CGRect.init(x: kUIStyle.kScrWidth * 0.5, y: 0, width: kUIStyle.kScrWidth * 0.5, height: bottomToolView.height - kUIStyle.kTabBarSafeBottomHeight))
        bottomToolView.addSubview(deleteBtn)
        deleteBtn.addTarget(self, action: #selector(bottomBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        deleteBtn.setTitle(kLocalized("Delete"), for: .normal)
//        deleteBtn.setImage(UIImage(named: "shelf_del_image"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteBtn.setTitleColor(mainColor, for: .normal)
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

        chooseBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: kUIStyle.kScrWidth * 0.5, height: deleteBtn.height))
        chooseBtn.setTitle(kLocalized("FutureGenerations"), for: .normal)
//        let image  = UIImage(named: "CHK_shelf_edit_sel_image")?.withRenderingMode(.alwaysTemplate)
//        chooseBtn.setImage(image, for: .normal)
//        chooseBtn.tintColor = UIColor.white
        chooseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        chooseBtn.setTitleColor(mainColor, for: .normal)
        bottomToolView.addSubview(chooseBtn)
        chooseBtn.addTarget(self, action: #selector(bottomBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        chooseBtn.tag = 100
        chooseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

        let line = UIView(frame: CGRect.init(x: kUIStyle.kScrWidth * 0.5 - 0.5, y: 8, width: 1, height: deleteBtn.height - 16))
        line.backgroundColor = mainColor
        bottomToolView.addSubview(line)


    }


    /// 下部按钮点击方法 true全选
    @objc func bottomBtnClick(btn: UIButton) -> Void {
        if btn.tag == 100 { /// 全选
            btn.isSelected = !btn.isSelected
            if btn.isSelected {

                if isHistory {
                    editBooks = historyBooks
                } else {
                    editBooks = books
                }
            } else {
                editBooks.removeAll()
            }
            reloadCollectionView()
        } else {
            if editBooks.count > 0 {
                if self.isHistory {
                    for i in 0..<editBooks.count {
                        MQIRecentBookManager.shared.removeRecentBook(book: editBooks[i])
                    }
                    getLocalAllBooks()
                    lastBook = historyBooks.first
                    restoreState()
                    MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
                    return

                } else {
                    MQIShelfManager.shared.syncShelf(save: nil, del: editBooks.map({ $0.book_id })) { (suc, msg) in
                        if suc {
                            MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
                        }
                    }
                    editBooks.removeAll()
                    getLocalAllBooks()
                    restoreState()
                    return
                }

            }
            if editBooks.count == 0 {
                MQILoadManager.shared.makeToast(kLocalized("PleaseSelectTheBookToDelete"))
                return
            }
            restoreState()
        }

    }

    func restoreState() {
        if !isEdit { return }
        self.isEdit = false
        editBooks.removeAll()
        chooseBtn.isSelected = false
        editorBtn.isSelected = false
        bottomAnimate(view: tabBarController!.tabBar, state: false)
        bottomAnimate(view: bottomToolView, state: true)
        if isHistory {
            historyCollectionView.reloadData()
        } else {
            gcollectionView.reloadData()
        }

    }

    @objc func refreshRecommendsBooks() {
        DispatchQueue.main.async {
            self.books = MQIShelfManager.shared.books
            self.gcollectionView.reloadData()
        }

    }

    override func addPreloadView() {
        if preloadView == nil {
            preloadView = MQIPreloadView(frame: self.view.bounds)
        }
        self.view.addSubview(preloadView!)
        self.view.bringSubviewToFront(preloadView!)
    }


    @objc func refreshLastBook() {
        IsReturnFromReader = true
        historyBooks = MQIRecentBookManager.shared.books
        self.historyCollectionView.reloadData()
    }
    //MAKR:登录的时候获取两个库所有书籍
    func getLocalAllBooks() {
        if isHistory == true {
            historyBooks = MQIRecentBookManager.shared.books
        } else {
            books = MQIShelfManager.shared.books
        }
    }

    func reloadCollectionView() {
        if isHistory == true {
            self.historyCollectionView.reloadData()
        } else {
            self.gcollectionView.reloadData()
        }

    }

    func configBooks(_ alert: Bool) {
        lastBook = MQIRecentBookManager.shared.books.first
        MQIShelfManager.shared.shelfManager_requestRecommends()//判断推荐书籍是否已经推荐
        historyBooks = MQIRecentBookManager.shared.books
        books = MQIShelfManager.shared.books
        gcollectionView.reloadData()
        historyCollectionView.reloadData()
        if checkNetStatus() {
            requestUpdate(books.map({ $0.book_id }), alert: alert, completion: nil)
        }

    }

    func requestUpdate(_ ids: [String], alert: Bool, completion: ((_ suc: Bool) -> ())?) {

        MQIShelfManager.shared.syncShelf(save: ids, del: nil) { [weak self] (suc, msg) in
            if let strongSelf = self {
                if suc {
                    let result = MQIShelfManager.shared.books

                    strongSelf.newUpdateBooks = result
                    strongSelf.checkBooksUpdate(result)
                    strongSelf.requestFinish()
                    if alert == true {
                        MQILoadManager.shared.makeToast(kLocalized("TheBookInformationSynchronizationIsSuccessful"))
                    }
                    completion?(true)
                } else {
                    completion?(false)
                    strongSelf.dismissPreloadView()
                    strongSelf.gcollectionView.mj_header.endRefreshing()
                    completion?(false)
                }
            }
        }
    }


    func requestFinish() {
        dismissPreloadView()
        dismissWrongView()
        gcollectionView.mj_header.endRefreshing()
        gcollectionView.reloadData()
    }
    func requestShelfPush() {
        GYBookShelfPushRequest(tj_type: "1")
            .request({ [weak self] (request, response, result: MQIBaseModel) in
                if let strongSelf = self {
                    if let time = result.dict["batch_time"] as? String {
                        if strongSelf.checkTime(time) == false {
                            return
                        }

                        if let array = result.dict["list"] as? [[String: AnyObject]] {
                            var newBooks = [MQIEachBook]()
                            for dict in array {
                                let book = MQIEachBook(jsonDict: dict)
                                newBooks.append(book)
                            }

                        }
                    }
                }

            }) { (err_msg, err_code) in

        }
    }

    func deleteBooks() { //开始删除
        if isHistory == true {
            if editBookIsNowRead.count <= 0 {
                MQILoadManager.shared.makeToast(kLocalized("CheckNeedDeleteBook"))
                return
            }


            MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLongLocalized("DoYouWantToDeleteTheSelectedBo", replace: "\(editBookIsNowRead.count)"), block: {
                    self.requestDeleteBooks()
                })
        } else {
            if editBookIds.count <= 0 {
                MQILoadManager.shared.makeToast(kLocalized("CheckNeedDeleteBook"))
                return
            }

            MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLongLocalized("DoYouWantToDeleteTheSelectedBo", replace: "\(editBookIds.count)"), block: {
                    self.requestDeleteBooks()
                })
        }
    }


    func requestDeleteBooks() {

        if checkNetStatus() == false || (MQIUserManager.shared.checkIsLogin() == false) {
            removeBooksFromBooks()

            deleteFinish()
            MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
        } else {
            if isHistory == true {
                MQILoadManager.shared.dismissProgressHUD()
                self.removeBooksFromBooks()
                self.deleteFinish()
                MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
            } else {
                MQILoadManager.shared.addProgressHUD(kLocalized("Deleting"))
                GYBookShelfRequest(ids: nil, delete: editBookIds)
                    .request({ [weak self] (request, response, result) in
                        MQILoadManager.shared.dismissProgressHUD()
                        if let strongSelf = self {
                            strongSelf.removeBooksFromBooks()
                            strongSelf.deleteFinish()
                        }
                        MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
                    }) { (err_msg, err_code) in
                        MQILoadManager.shared.dismissProgressHUD()
                        MQILoadManager.shared.makeToast(err_msg)
                }
            }


        }

    }
//    //（之前的）删除最近阅读
//    func removeLastedBook() {
//        let lastedbooks = MQIRecentBookManager.shared.books
//        var ends: [MQIEachBook] = [MQIEachBook]()
//        for id in editBookIds {
//            ends = lastedbooks.filter({$0.book_id != id})
//        }
//        MQIRecentBookManager.shared.updateRecents(ends)
//
//    }

    //删除本地书删除
    func removeBooksFromBooks() {
        if isHistory == true {
            for i in 0...editBookIsNowRead.count - 1 {
                MQIRecentBookManager.shared.removeRecentBook(book: editBookIsNowRead[i])
            }
            getLocalAllBooks()
            self.historyCollectionView.reloadData()
        } else {
            var userbooks = MQIShelfManager.shared.books

            for id in editBookIds {
                userbooks = userbooks.filter({ $0.book_id != id })
            }
            MQIShelfManager.shared.updateBooks(userbooks)
            getLocalAllBooks()
        }
    }

    override func deleteFinish() {
        super.deleteFinish()
        refreshLastBook()
    }

    func checkBooksUpdate(_ result: [MQIEachBook]) {

        for i in 0..<books.count {
            if let book = result.filter({ $0.book_id == books[i].book_id }).first {

                if (book.book_update != books[i].book_update) {
                    books.replaceSubrange(i...i, with: [book])
                    books[i].book_isUpdate = true
                    books[i].book_update = book.book_update
                    books[i].updateBook = 1
                } else {
                    //如果之前提示更新了，但是还没点击阅读，则状态还是更新图标，不变
                    if books[i].book_isUpdate || books[i].updateBook == 1 {
                        books.replaceSubrange(i...i, with: [book])
                        books[i].book_isUpdate = true
                        books[i].book_update = book.book_update
                        books[i].updateBook = 1
                    } else {

                        books.replaceSubrange(i...i, with: [book])
                        books[i].book_isUpdate = false
                        books[i].updateBook = 0

                    }
                }

            }
        }

        self.reloadCollectionView()
        MQIShelfManager.shared.updateBooks(books)
    }




    deinit {
        NotificationCenter.default.removeObserver(self)

    }

    /// 下部视图动画
    func bottomAnimate(view: UIView, state: Bool) -> Void {
        let bounds = view.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        if state {
            UIView.animate(withDuration: 0.3) {
                view.frame = CGRect.init(x: 0, y: screenHeight, width: width, height: height)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                view.frame = CGRect.init(x: 0, y: screenHeight - height, width: width, height: height)
            }
        }

    }
    //MARK: --
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
//MARK:通知-登录退出
extension MQIShelfVC {
    @objc func loginIn() {
        isRefreshing = false
        loginInBool = true
        let ids = MQIShelfManager.shared.books.map({ $0.book_id })
        requestUpdate(ids, alert: false, completion: nil)


    }

    @objc func loginOut() {

        if books.count <= 0 {
            addNoBook()
        }
        gcollectionView.reloadData()
    }

    @objc func addShelfSuc(_ noti: Notification) {
        if let book = noti.userInfo?["book"] as? MQIEachBook {
            books.insert(book, at: 0)
            MQIShelfManager.shared.updateBooks(books)
            gcollectionView.reloadData()
        } else {
            requestUpdate(bookIds, alert: false, completion: nil)
        }
    }
    //    func update_loginListHeaderIcon() {
    //        if MQIUserManager.shared.checkIsLogin() == true {
    //            if let user = MQIUserManager.shared.user {
    //                let avatar = user.user_avatar.replacingOccurrences(of: " ", with: "")
    //                if avatar.count > 0 {
    //                    listBtn.sd_setImage(with: URL(string: avatar), for: .normal, placeholderImage: UIImage(named: "mine_header"))
    //                    return
    //                }
    //            }
    //
    //        }
    ////            let image = UIImage(named: "list_headerIcon")?.withRenderingMode(.alwaysTemplate)
    //            listBtn!.setImage(UIImage(named: "mine_header"), for: .normal)
    ////            listBtn!.tintColor = UIColor(white: 1, alpha: 1)
    //    }

}


extension MQIShelfVC {


    //MARK: --
    func checkTime(_ time: String) -> Bool {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let currentDate = formatter.date(from: formatter.string(from: time.stringToDate()))
        var oldDate = UserDefaults.standard.object(forKey: SHELFPUSHTIME) as? Date
        if currentDate == nil {
            return false
        }

        if oldDate == nil {
            configShelfPushTimePrams(currentDate!)
            oldDate = formatter.date(from: formatter.string(from: Date()))!
        }

        let aTimer = currentDate!.timeIntervalSince(oldDate!)
        if aTimer > 0 {
            configShelfPushTimePrams(currentDate!)
            return true
        } else {
            return false
        }
    }

    func configShelfPushTimePrams(_ date: Date) {
        UserDefaults.standard.set(date, forKey: SHELFPUSHTIME)
        UserDefaults.standard.synchronize()
    }

}


extension MQIShelfVC {
    override func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return super.numberOfCollectionView(collectionView)
    }

    override func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        if collectionView == historyCollectionView {
            return historyBooks.count
        }
        return books.count

    }
    override func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        if isHistory == true {
            return .zero
        }
        if type == .tiled && self.popupAdsenseModel.total != 0 {
            return CGSize(width: screenWidth, height: 110)
        } else {
            return .zero
        }
    }

    override func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {

        if isHistory == true {
            return 0
        }
        if type == .tiled {
            return 10
        } else {
            return 0
        }
    }

    override func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        if isHistory == true {
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        if type == .tiled {
            return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        } else {
            return UIEdgeInsets.zero
        }
    }

    override func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                if collectionView == historyCollectionView {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDHistoryHelfHeader", for: indexPath) as! MQIShelfHeaderCollectionReusableView
                    return header
                }
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDSHelfHeader", for: indexPath) as! MQIShelfHeaderCollectionReusableView

                header.backgroundColor = .white
                header.frame = CGRect(x: 0, y: 10, width: screenWidth - 40, height: 100)
                header.addSubview(self.viewPager)
                self.pagerControl.numberOfPages = self.popupAdsenseModel.total
                header.addSubview(self.pagerControl)
                pagerControl.snp.makeConstraints { (make) in
                    make.right.equalTo(-10)
                    make.bottom.equalTo(0)
                    make.width.equalTo(80)
                    make.height.equalTo(20)
                }
                return header
            }
            return UICollectionReusableView()

        }
        return super.viewForSupplementaryElement(collectionView, kind: kind, indexPath: indexPath)
    }

    override func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {

        return super.sizeForFooter(collectionView, layout: layout, section: section)
    }

    override func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        if isHistory == true {
            return MQIShelfListCell.getSize()
        }
        if type == .tiled {
            return MQIShelfTiledsCell.getSize()
        } else {
            return MQIShelfListCell.getSize()
        }
//        return super.sizeForItem(collectionView, layout: layout, indexPath: indexPath)
    }

    override func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var book = MQIEachBook()
        if collectionView == historyCollectionView {
            book = historyBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }
        if isHistory == true {
            let cell = collectionView.dequeueReusableCell(MQIShelfListCell.self, forIndexPath: indexPath)
            cell.backgroundColor = collectionView.backgroundColor
            cell.isEdit(self.isEdit)
            cell.isBtnSelected = editBooks.contains(book)
            cell.book = book
            return cell
        }
        if type == .tiled {
//            let book = books[indexPath.row]
            let cell = collectionView.dequeueReusableCell(MQIShelfTiledsCell.self, forIndexPath: indexPath)
            cell.backgroundColor = collectionView.backgroundColor
            cell.book = book
            cell.isEdit(self.isEdit)
            cell.isBtnSelected = editBooks.contains(book)
            return cell
        } else {
//            let book = books[indexPath.row]
            let cell = collectionView.dequeueReusableCell(MQIShelfListCell.self, forIndexPath: indexPath)
            cell.backgroundColor = collectionView.backgroundColor
            cell.isEdit(self.isEdit)
            cell.isBtnSelected = editBooks.contains(book)
            cell.book = book
            return cell

        }


    }
    override func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        if self.isEdit {
            if isHistory == true {
                let cell = collectionView.cellForItem(at: indexPath) as! MQIShelfListCell
                cell.isBtnSelected = !cell.isBtnSelected
                if cell.editMaskBtn.isSelected {
                    editBooks.append(cell.book)
                } else {
                    editBooks = editBooks.filter({ $0.book_id != cell.book.book_id })

                }
                return
            }
            if self.type == .tiled {
                let cell = collectionView.cellForItem(at: indexPath) as! MQIShelfTiledsCell
                cell.isBtnSelected = !cell.isBtnSelected
                if cell.editMaskBtn.isSelected {
                    editBooks.append(cell.book)
                } else {
                    editBooks = editBooks.filter({ $0.book_id != cell.book.book_id })

                }

            } else {
                let cell = collectionView.cellForItem(at: indexPath) as! MQIShelfListCell
                cell.isBtnSelected = !cell.isBtnSelected
                if cell.editMaskBtn.isSelected {
                    editBooks.append(cell.book)
                } else {
                    editBooks = editBooks.filter({ $0.book_id != cell.book.book_id })

                }
            }

        } else {
            var book = MQIEachBook()
            if collectionView == historyCollectionView {
                book = historyBooks[indexPath.row]
            } else {
                book = books[indexPath.row]
            }
            toRead(book)
            reloadReadBook(book)
            /// 最近阅读
            if self.isHistory {
                MQIEventManager.shared.appendEventData(eventType: .recents_book, additional: ["book_id": book.book_id])
            }

        }


    }

    //    func getLastReaderCell(_ collectionView: MQICollectionView, indexPath: IndexPath) -> GYShelfLastReaderCell {
    //        let cell = collectionView.dequeueReusableCell(GYShelfLastReaderCell.self, forIndexPath: indexPath)
    //        cell.delegate = self
    //        cell.toReader = {[weak self](book) -> Void in
    //            self?.toRead(book)
    //        }
    //        cell.toHome = {[weak self]() -> Void in
    //            self?.toHomeVC()
    //        }
    //        return cell
    //    }

    func toRead(_ book: MQIEachBook) {
        if book.book_id == lastBook?.book_id {
            if MQIUserManager.shared.checkIsLogin() == true {
                if MQIShelfManager.shared.books.filter({ $0.book_id == book.book_id }).first == nil {

                    MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLongLocalized("HaveNotAddedTheBookshelfVDoYouAddYourBookshelf", replace: book.book_name), block: {
                            MQIUserOperateManager.shared.addShelf(book, completion: {
                            })
                            MQIUserOperateManager.shared.toReader(book.book_id)
                        }, cancelBlock: {
                            MQIUserOperateManager.shared.toReader(book.book_id)
                        })
                    return
                }
            }
        }
        IsReturnFromReader = true
        AAEnterReaderType.shared.enterType = .enterType_0
        MQIUserOperateManager.shared.toReader(book.book_id)
    }
    func reloadReadBook(_ book: MQIEachBook) {
        book.book_isUpdate = false
        book.updateBook = 0
        if self.isHistory == true {
            MQIRecentBookManager.shared.addRecentReader(book)

        } else {

            MQIShelfManager.shared.addToBooks(book)
        }
        getLocalAllBooks()

        reloadCollectionView()
    }
}

extension MQIShelfVC: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let page = scrollView.contentOffset.x / scrollView.width

        if page == 0 {
            changeNavBtnData(false)
        } else {
            changeNavBtnData(true)
        }

    }

    func changeNavBtnData(_ isHistory: Bool) {
        restoreState()
        self.isHistory = isHistory
        if !self.isHistory {
            if leftBtn.isSelected { return }
            leftBtn.isSelected = true
            rightBtn.isSelected = !leftBtn.isSelected
        } else {
            if !leftBtn.isSelected { return }
            leftBtn.isSelected = false
            rightBtn.isSelected = !leftBtn.isSelected
        }
        reloadCollectionView()
    }
}

extension MQIShelfVC: FSPagerViewDelegate, FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.popupAdsenseModel.popupAdsenseList.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cellId", at: index)
        if self.popupAdsenseModel.popupAdsenseList.count > 0 {
            let model = self.popupAdsenseModel.popupAdsenseList[index]
            cell.imageView?.sd_setImage(with: URL(string: model.image), placeholderImage: nil, options: [], completed: nil)
        }

        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        MQIOpenlikeManger.openLike(self.popupAdsenseModel.popupAdsenseList[index].url)
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pagerControl.currentPage = targetIndex
    }

    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl.currentPage = pagerView.currentIndex
    }


    func getPopupAdsenseList() {
        MQIPopupAdsenseRequest(pop_position: "18").request({ [weak self](request, response, result: MQIPopupAdsenseModel) in
            self?.popupAdsenseModel = result
        }) { (err_msg, err_code) in

            MQILoadManager.shared.makeToast(err_code)
        }
    }
}
