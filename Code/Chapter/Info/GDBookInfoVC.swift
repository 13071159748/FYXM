//
//  GDBookInfoVC.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/2.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit

class GDBookInfoVC: MQIBaseViewController {
    
    var gtableView: MQITableView!
    var bookId: String = ""
    var book:MQIEachBook? {
        didSet{
            if let book = book{
                GYBookManager.shared.getSubscribeChapterIds(book_id: book.book_id) {[weak self] (msg) in
                    self?.buyTids =  GYBookManager.shared.buyTids
                    self?.whole_subscribe = GYBookManager.shared.whole_subscribe
                }
            }
        }
    }
    
    var otherBooks = [MQIEachBook]()//作者其他书
    var comments = [GYEachComment]()//评论
    var recommendBooks = [MQIEachBook]()//推荐书
    var recommendDataModel:MQRecommendInfoModel?
    var maskView_: UIView!
    var rewardView: GYUserRewardView!//打赏弹窗
    fileprivate var keyboardShow: Bool = false
    fileprivate var limit_freeModel = GDQueryFreelimitModel()//限免
    fileprivate var commentRequestLoding: Bool = false//正在请求评论
    fileprivate let footerHeight: CGFloat = 5
    fileprivate var pushView:MQICommentPushView!
    
    var timer_Update:Timer!//定时器
    
    fileprivate var headerCellHeight: CGFloat = 0       //headercell高度
    var shelfBtn: UIButton!
    
    var isSpared: Bool = false {
        didSet {
            headerCellHeight = 0
            gtableView.reloadData()
        }
    }
    //MARK:评论的 header
    var commentHeader: GYBookOriginalInfoCellHeaderView!
    var chapterList = [MQIEachChapter]()
    /// 订阅过deid
    var buyTids:[String]?
    ///全本订阅
    var whole_subscribe:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("BookInfo")
        
        titleLabel.textAlignment = .left
        setupUI()
        addBottomTool()
        
        gtableView.height -= root_bottomTool_height-footerHeight
        //                gtableView.separatorColor = RGBColor(218, g: 218, b: 218)
        maskView_ = UIView(frame: view.bounds)
        maskView_.backgroundColor = UIColor.black
        maskView_.alpha = 0.5
        maskView_.isUserInteractionEnabled = true
        maskView_.isHidden = true
        addTGR(self, action: #selector(GDBookInfoVC.tgrClick), view: maskView_)
        view.addSubview(maskView_)
        
        let  shareBtn =   addRightBtn(nil, imgStr: "BookInfo_share_img")
        
        if  MQIPayTypeManager.shared.isAvailable() {
            let dsBtn = UIButton(frame:shareBtn.bounds)
            dsBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            dsBtn.tag = nav_rightBtn_tag+1
            dsBtn.addTarget(self, action: #selector(toReward), for: UIControl.Event.touchUpInside)
            dsBtn.setImage(UIImage(named: "BookInfo_ds_img"), for: .normal)
            nav.addSubview(dsBtn)
            dsBtn.maxX = shareBtn.x-2
            
        }
        
        ShelfNotifier.addObserver(self, selector: #selector(GDBookInfoVC.addShelfSuc(_:)), notification: .refresh_shelf)
        addComment_rewardView()
        addPreloadView()
        requestBookInfo()
        
        
    }
    
    func setupUI() {
        
        gtableView = MQITableView(frame: contentView.bounds)
        gtableView.gyDelegate = self
        gtableView.backgroundColor = UIColor.white
        gtableView.register(GYNoDataCell.classForCoder(), forCellReuseIdentifier: noData_cell)
        contentView.addSubview(gtableView)
        gtableView.separatorStyle = .none
        gtableView.backgroundColor = UIColor.clear
        gtableView.delaysContentTouches = false
        
        gtableView.registerCell(MQIBookHeaderCell.self, xib: false)
        gtableView.registerCell(MQIBookTipsCell.self, xib: false)
        gtableView.registerCell(MQIBookListCell.self, xib: false)
        gtableView.registerCell(MQIBookOriginalCommentReplyCell.self, xib: false)
        gtableView.registerCell(AABookInfoLikesCell.self, xib: false)
        gtableView.registerCell(MQIBookOriginalOtherBooksCell.self, xib: false)
        
    }
    
    func createTimer() {
        if timer_Update == nil {
            timer_Update = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GDBookInfoVC.timerCountDown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer_Update, forMode:RunLoop.Mode.common)
        }
    }
    @objc func timerCountDown() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:BookOriginalInfo_Timer), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissCommentView()
    }
    var bookInfoDisAppear:Bool = false
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bookInfoDisAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard bookInfoDisAppear else {
            return
        }
        if timer_Update != nil {//手动释放，timer强引用self
            timer_Update.invalidate()
            timer_Update = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func rightBtnAction(_ button: UIButton) {
        if let book  = self.book {
            MQISocialManager.shared.sharedBook(book)
        }
        
    }
    
    
    //MARK:最下方按钮
    override func addBottomTool() {
        bottomTool = UIView(frame: CGRect(x: 0, y: contentView.height-root_bottomTool_height, width: screenWidth, height: root_bottomTool_height))
        bottomTool.isUserInteractionEnabled = true
        bottomTool.backgroundColor = UIColor.white
        contentView.addSubview(bottomTool)
        
        let width = kUIStyle.scale1PXW(120)
        let height = bottomTool.bounds.height
        let btnFont = UIFont.boldSystemFont(ofSize: 14)
        let  downloadBtn = createButton(CGRect(x: 0, y: 0, width: width, height: height),
                                        normalTitle: kLocalized("Down"),
                                        normalImage: nil,
                                        selectedTitle: nil,
                                        selectedImage: nil,
                                        normalTilteColor: UIColor.colorWithHexString("7187FF"),
                                        selectedTitleColor: nil,
                                        bacColor: UIColor.colorWithHexString("ffffff"),
                                        font: btnFont,
                                        target: self,
                                        action: #selector(GDBookInfoVC.toDownload))
        bottomTool.addSubview(downloadBtn)
        
        
        
        shelfBtn = createButton(CGRect(x: bottomTool.width-width, y: 0, width: width, height: height),
                                normalTitle: kLocalized("AddShelf"),
                                normalImage: nil,
                                selectedTitle: kLocalized("AlreadyAdd"),
                                selectedImage: nil,
                                normalTilteColor: UIColor.colorWithHexString("7187FF"),
                                selectedTitleColor: nil,
                                bacColor: UIColor.colorWithHexString("ffffff"),
                                font: btnFont,
                                target: self,
                                action: #selector(GDBookInfoVC.toAddShelf))
        shelfBtn.isSelected = MQIShelfManager.shared.checkIsExist(bookId)
        bottomTool.addSubview(shelfBtn)
        
        let readerBtn = createButton(CGRect(x: downloadBtn.maxX , y: 0, width: shelfBtn.x-downloadBtn.maxX, height: height),
                                     normalTitle: kLocalized("BeginRead"),
                                     normalImage: nil,
                                     selectedTitle: nil,
                                     selectedImage: nil,
                                     normalTilteColor: UIColor.white,
                                     selectedTitleColor: nil,
                                     bacColor: UIColor.colorWithHexString("7187FF"),
                                     font: btnFont,
                                     target: self,
                                     action: #selector(GDBookInfoVC.toReader))
        bottomTool.addSubview(readerBtn)
        
        if MQIRecentBookManager.shared.books.map({$0.book_id}).contains(bookId) {
            readerBtn.setTitle(kLocalized("GoOnRead"), for: .normal)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: bottomTool.width, height: 1))
        lineView.backgroundColor = RGBColor(235, g: 235, b: 235)
        bottomTool.addSubview(lineView)
        
    }
    
}

extension  GDBookInfoVC:MQITableViewDelegate {
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return getTableVeiwNums()
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case getTableVeiwNums() - 2:
            return otherBooks.count//作者其他书
        case 1://评论头--最新评论
            return 0
        case getTableVeiwNums() - 3://查看更多评论按钮
            return 0
        case getTableVeiwNums() - 1://猜你喜欢
            if recommendBooks.count  == 0 { return 0}
            return 1
        default:
            if comments.count > 0 {//评论
                return comments[section - 2].reply.count
            }
            return 0
        }
    }
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        if section == 1 {//评论头
            return GYBookOriginalInfoVC_headerHeight
        }
        if section == 0 {//详情
            return 0
        }
        if section == getTableVeiwNums() - 2 {//作者其他书
            if otherBooks.count > 0 {
                return 35
            }else {
                return 0
            }
        }
        //推荐书
        //        ===========
        if section == getTableVeiwNums() - 1 {
            if recommendBooks.count  == 0 { return 0}
            return 40
        }
        if section == getTableVeiwNums() - 3 {//查看更多评论按钮
            return 44
        }
        if comments.count > 0 {//如果有评论
            //显示5条
            if section >= 2 && section < (comments.count > 5 ? 7 : comments.count+2) {
                let comment = comments[section-2]
                let height = GDCommetsHeaderView.getHeight(comment: comment)
                
                return height
            }
            return 44
        }else {//没有pinglun
            return 0
        }
    }
    func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        if section == 1 {//评论头
            return getCommentHeader()
        }
        //        if section == 1 {//其他书
        if section == getTableVeiwNums() - 2 {//其他书
            if otherBooks.count > 0{
                let otherBookView = UIView(frame: CGRect.zero)
                otherBookView.backgroundColor = UIColor.white
                let label = UILabel(frame: CGRect (x: 16, y: 0, width: 200, height: 35))
                label.textColor = UIColor.colorWithHexString("#313131")
                label.font = systemFont(16)
                label.text = kLocalized("OtherBook")
                otherBookView.addSubview(label)
                return otherBookView
            }
            return UIView()
            
        }
        if section == 0 {
            return UIView()
        }
        if section == getTableVeiwNums() - 1 {//猜你喜欢
            //            if recommendBooks.count  == 0 { return UIView()}
            return getYouLikeHeader()
        }
        
        if section == getTableVeiwNums() - 3 {
            let text = comments.count <= 0 ? kLocalized("ComeFirstComments") : kLocalized("CheckAllComments")
            let lookCommentBtn = UIButton(frame: CGRect.zero)
            lookCommentBtn.addLine(16, lineColor: UIColor.colorWithHexString("#EDEDED"), directions: .top)
            lookCommentBtn.setTitle(text, for: .normal)
            lookCommentBtn.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
            lookCommentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            lookCommentBtn.addTarget(self, action: #selector(GDBookInfoVC.look_pushComment), for: .touchUpInside)
            return lookCommentBtn
        }
        if comments.count > 0 {//评论，现在是 详情+其他书+评论头 所以 = 3  换位置之后是2
            //            if section >= 3 && section < (comments.count > 5 ? 8 : comments.count+3) {
            if section >= 2 && section < (comments.count > 5 ? 7 : comments.count+2) {
                return configCommentHeader(section: section)
            }
        }
        
        return UIView()
        
    }
    
    func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        view.backgroundColor = GYBookOriginalInfoVC_footerColor
        
        switch section {
        case 0:
            if let _ = book {
                return view
            }else {
                return UIView()
            }
        //        case 1://其他书
        case getTableVeiwNums() - 2://作者其他书
            if otherBooks.count > 0{
                return view
            }
            return UIView()
        case getTableVeiwNums() -  1://推荐书
            //            if recommendBooks.count  == 0 { return UIView()}
            return view
        case getTableVeiwNums() - 3 ://更多评论按钮
            return view
        default:
            return UIView()
        }
    }
    func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        switch section {
        case 0:
            if let _ = book {
                return footerHeight
            }else {
                return 0
            }
        //        case 1://其他书 最难
        case getTableVeiwNums() - 2:
            if otherBooks.count > 0{
                return footerHeight
            }
            return 0
        case getTableVeiwNums() - 3://更多评论按钮
            return footerHeight
        case getTableVeiwNums() - 1://猜你喜欢
            if recommendBooks.count  == 0 { return 0}
            return footerHeight
            
        default:
            return 0
        }
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                if let book = book {
                    if headerCellHeight == 0 {
                        headerCellHeight = GYBookOriginalHeaderCell_minHeight+GYBookOriginalHeaderInfo.getHeight(book.book_intro, isSpared: isSpared)
                    }
                    return headerCellHeight+10
                }
            }else if indexPath.row == 1 {
                if let book = book {
                    if book.book_tags != ""{
                        return MQIBookTipsCell.getTipsHeight(book.book_tags)
                    }
                }
            }else {
                return MQIBookListCell.getHeight(nil)
            }
            return 0
        //        case 1:
        case getTableVeiwNums() - 2://作者其他书
            if otherBooks.count > 0 {
                return 130
            }
            return 0
        case 1:
            return 0
        case getTableVeiwNums() - 3://更多评论
            return 0
        case getTableVeiwNums() - 1://猜你喜欢
            //            if recommendBooks.count  == 0 { return 0}
            return AABookInfoLikesCell.infoLikesHeight(recommendBooks.count)
        default:
            
            if comments.count > 0 {
                //有评论
                let comment = comments[indexPath.section-2]
                let height = GYBookOriginalCommentCellReply.getHeight(reply: comment.reply[indexPath.row], width: screenWidth - 63)
                return height
            }
            return 0
        }
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0 :
            if indexPath.row == 0{
                return configHeaderCell(indexPath)
            }else if indexPath.row == 1{
                let cell = gtableView.dequeueReusableCell(MQIBookTipsCell.self, forIndexPath: indexPath)
                if let book = book {
                    if book.book_tags == "" {
                        cell.contentView.isHidden = true
                    }else {
                        cell.contentView.isHidden = false
                        cell.book_Tips = book.book_tags
                    }
                    
                }
                cell.tip_SelectedIndex = {(name) ->Void in
                    
                }
                return cell
            }else {
                let cell = gtableView.dequeueReusableCell(MQIBookListCell.self, forIndexPath: indexPath)
                cell.book = book
                return cell
            }
        //        case 1:
        case getTableVeiwNums() - 2:
            let cell = tableView.dequeueReusableCell(MQIBookOriginalOtherBooksCell.self, forIndexPath: indexPath)
            cell.indexPath = indexPath
            cell.book = otherBooks[indexPath.row]
            return cell
        case getTableVeiwNums() - 1:
            let cell = gtableView.dequeueReusableCell(AABookInfoLikesCell.self, forIndexPath: indexPath)
            cell.books = recommendBooks
            cell.likesClick = {[weak self](bookid)->Void in
                if let weakSelf = self {
                    let bookInfoVC = GDBookInfoVC()
                    bookInfoVC.bookId = bookid
                    weakSelf.pushVC(bookInfoVC)
                    MQIEventManager.shared.appendEventData(eventType: .detail_book, additional: ["book_id" : bookid,"position":weakSelf.recommendDataModel?.name ?? ""])
                }
                
            }
            return cell
            
        default://评论回复
            let cell = gtableView.dequeueReusableCell(MQIBookOriginalCommentReplyCell.self, forIndexPath: indexPath)
            configReplyCell(cell, indexPath: indexPath)
            return cell
        }
    }
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            if indexPath.row == 2 {
                toChapterList()
                return
            }
        //        case 1:
        case getTableVeiwNums() - 2:
            let bookInfoVC = GDBookInfoVC()
            bookInfoVC.bookId = otherBooks[indexPath.row].book_id
            pushVC(bookInfoVC)
        default:
            return
        }
        
        
    }
    func gScrollViewDidScroll(_ tableView: MQITableView) {
        
        if tableView.contentOffset.y > 44 {
            title = book?.book_name
        }else{
            title = kLocalized("BookInfo")
        }
    }
    
    //评论
    func configCommentHeader(section:NSInteger) -> GDCommentsHeaderCollectionCell {
        let commentHeaderView = GDCommentsHeaderCollectionCell(frame: CGRect .zero)
        commentHeaderView.backgroundColor = UIColor.white
        commentHeaderView.header.toVote = {[weak self]comment -> Void in
            if let strongSelf = self {
                strongSelf.toCommentVote(comment: comment, completion: {
                    let version = UIDevice.current.systemVersion
                    if version.doubleValue() <= 9.0 {
                        strongSelf.gtableView.reloadData()
                    }else {
                        strongSelf.gtableView.reloadSections(IndexSet(integer: section) , with: .none)
                    }
                })
            }
        }
        configCommentCell(commentHeaderView, indexPath: section)
        return commentHeaderView
        
    }
    func configCommentCell(_ cell: GDCommentsHeaderCollectionCell, indexPath:NSInteger ) {
        cell.comment = comments[indexPath-2]
    }
    
    func configReplyCell(_ cell: MQIBookOriginalCommentReplyCell, indexPath: IndexPath) {
        cell.fd_enforceFrameLayout = false
        cell.reply = comments[indexPath.section-2].reply[indexPath.row]
    }
    
    //书籍信息header
    func configHeaderCell(_ indexPath:IndexPath) ->MQIBookHeaderCell {
        let cell = gtableView.dequeueReusableCell(MQIBookHeaderCell.self, forIndexPath: indexPath)
        cell.removeNSNotificationCenter()
        cell.book = book
        if limit_freeModel.limit_free {
            cell.limit_freeTime = limit_freeModel.limit_time
            //cell.limit_freeTime = "1617394172"
            createTimer()//定时器判断是否是限时免费的
            cell.registerNSNotificationCenter()
        }
        cell.infoView.isSpared = isSpared
        
        cell.infoView.toSpared = {[weak self]spared -> Void in
            if let strongSelf = self {
                strongSelf.isSpared = spared
            }
        }
        cell.headerBtnClick = {[unowned self](type) -> Void in
            if type == .likeBtn {
                self.toLike()
            }else if type == .rewardBtn {
                self.toReward()
            }else if type == .sharedBtn {
                if let book = self.book {
                    MQISocialManager.shared.sharedBook(book)
                }
            }
        }
        //        cell.toList = {[weak self]() -> Void in
        //            if let strongSelf = self {
        //                strongSelf.toChapterList()
        //            }
        //        }
        return cell
        
    }
    //猜你喜欢header
    func getYouLikeHeader() -> UIView {
        let likeView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: GYBookOriginalInfoVC_headerHeight))
        let titleLabel = UILabel(frame: CGRect (x: 16, y: 0, width: 200, height: GYBookOriginalInfoVC_headerHeight))
        titleLabel.text = kLocalized("GuessYouLike")
        titleLabel.textColor = UIColor.colorWithHexString("#313131")
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        likeView.addSubview(titleLabel)
        return likeView
    }
    
    
    func getTableVeiwNums() -> Int {
        var commentsSections:Int = 0
        if comments.count <= 0 {//如果没有评论 header_1 + 没有更多评论_1 = 2 + 猜你喜欢 + 其他书
            commentsSections = 3 + 1
        }else {
            if comments.count < 5  {//只有一条  header + 1 + 查看全部 + 其他书
                commentsSections = 3 + comments.count + 1
            }else {//只显示5条 header + 5 + 查看全部
                commentsSections = 8 + 1
            }
        }
        return 1 + commentsSections
    }
    
    
    
}
//MARK:下载
extension GDBookInfoVC {
    
    @objc func toDownload() {
        
        MQIActivityDownloadBouncedView.showBouncedView {  [weak self](less) in
            self?.startDownload(less)
        }
        
    }
    
    func startDownload(_ less:Bool = true) {
        guard let book = self.book else {
            return
        }
        if  !MQIUserManager.shared.checkIsLogin(){
            MQIloginManager.shared.toLogin("") { [weak self] in
                if let strongSelf = self {
                    strongSelf.startDownload(less)
                }
            }
            return
        }
        if let list = GYBookManager.shared.getChapterListFromLocation(book) {
            chapterList = list
        }
        if chapterList.count <= 0 {
            MQILoadManager.shared.addProgressHUD("")
            GYBookManager.shared.getChapterListFromServer(book, locationList: nil, completion: { [weak self](list) in
                MQILoadManager.shared.dismissProgressHUD()
                self?.startDownload(less)
            }) {  (code, msg) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg)
            }
            return
            
        }
        downloadFunc(less)
    }
    
    func downloadFunc(_ less:Bool = true)  {
        
        if let  buyTids =  self.buyTids  {
            var   tids = [String]()
            if self.whole_subscribe == "1" {
                tids = chapterList.map({$0.chapter_id})
            } else {
                tids =  buyTids.filter({book!.downTids.contains($0) == false})
            }
            
            GYBookDownloadManager.shared.toDownloadAllSubscribe(book!, allList: chapterList, tids: tids,less: less)
        }else{
            MQILoadManager.shared.addProgressHUD("")
            GYBookManager.shared.getSubscribeChapterIds(book_id: book!.book_id) {[weak self] (msg) in
                MQILoadManager.shared.dismissProgressHUD()
                if let weakSelf = self {
                    var   tids = [String]()
                    if GYBookManager.shared.whole_subscribe == "1" {
                        tids = weakSelf.chapterList.map({$0.chapter_id})
                    } else {
                        tids =    GYBookManager.shared.buyTids.filter({weakSelf.book!.downTids.contains($0) == false})
                    }
                    GYBookDownloadManager.shared.toDownloadAllSubscribe(weakSelf.book!, allList: weakSelf.chapterList, tids: tids)
                }
            }
        }
    }
    
}


//MARK:评论和打赏弹窗
extension GDBookInfoVC {
    
    @objc func tgrClick() {
        if keyboardShow == true {
            //            commentView.textView.endEditing(true)
        }else {
            dismissRewardView()
            dismissCommentView()
        }
    }
    //MARK: --
    func showRewardView() {
        rewardView.isHidden = false
        maskView_.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.maskView_.alpha = 0.5
                strongSelf.contentView.bringSubviewToFront(strongSelf.maskView_)
                
                strongSelf.rewardView.frame.origin.y = strongSelf.view.height-GYUserRewardView.getHeight()
                strongSelf.contentView.bringSubviewToFront(strongSelf.rewardView)
            }
            }, completion: { (suc) in
                
        })
    }
    
    func dismissRewardView() {
        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rewardView.frame.origin.y = strongSelf.view.height
                strongSelf.maskView_.alpha = 0
            }
            }, completion: {[weak self] (suc) in
                if let strongSelf = self {
                    strongSelf.rewardView.isHidden = true
                    strongSelf.maskView_.isHidden = true
                }
        })
    }
    
    //MARK: --
    func showCommentView() {
        
        guard let book = book else {
            MQILoadManager.shared.makeToast(kLocalized("WrongBookInfoReload"))
            return
        }
        
        pushView = MQICommentPushView(frame:CGRect (x: 0, y: 0, width: screenWidth, height: view.height))
        pushView.bookid = book.book_id
        pushView.comment_type = .comment_book
        view.addSubview(pushView)
        
        pushView.commentClose = {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.pushView.removeFromSuperview()
                weakSelf.pushView = nil
                
            }
            
        }
        pushView.commentPushFinishBlock = {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.pushView.removeFromSuperview()
                weakSelf.pushView = nil
            }
        }
        
        
    }
    
    func dismissCommentView() {
        
    }
    
    
    func getCommentHeader() -> GYBookOriginalInfoCellHeaderView {
        if commentHeader == nil {
            commentHeader = GYBookOriginalInfoCellHeaderView(frame: CGRect(x: 0, y: 0, width: gtableView.width, height: GYBookOriginalInfoVC_headerHeight))
            commentHeader.title = kLocalized("NewComments")
            let image = UIImage(named: "comment_edit")?.withRenderingMode(.alwaysTemplate)
            commentHeader.btn.setTitle(kLocalized("Comments"), for: .normal)
            commentHeader.btn.setImage(image, for: .normal)
            commentHeader.btn.tintColor = UIColor.colorWithHexString("#999999")
            //            commentHeader.btn.setTitleColor(UIColor.colorWithHexString("#999999"), for: .normal)
            commentHeader.btnBlock = {[weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.showCommentView()
                }
            }
        }
        return commentHeader
    }
    //MARK:添加打赏和评论的弹框
    func addComment_rewardView() {
        let width = view.bounds.width
        let height = view.bounds.height
        rewardView = GYUserRewardView(frame: CGRect(x: 0, y: height, width: width, height: GYUserRewardView.getHeight()))
        rewardView.isHidden = true
        rewardView.rewardCoin = {[weak self]coin -> Void in
            if self != nil {
                MQILoadManager.shared.addAlert(kLocalized("Exception"), msg: "\(kLocalized("MakeSureException"))\(coin)\(COINNAME)？", block: {[weak self]()->Void in
                    if let strongSelf = self
                    {
                        strongSelf.rewardRequest(coin)
                    }
                    }, cancelBlock: {
                })
            }
        }
        view.addSubview(rewardView)
        
    }
    
    
}




//MARK:接口及其处理
extension GDBookInfoVC {
    
    
    func requestBookInfo() {
        
        GYBookInfoRequest(book_id: bookId)
            .request({[weak self] (request, response, result: MQIEachBook) in
                GYBookManager.shared.saveBook(result)
                if let strongSelf = self {
                    strongSelf.book = result
                    strongSelf.rewardView.book = result
                    strongSelf.requestOther()
                    strongSelf.gtableView.reloadData()
                    strongSelf.dismissWrongView()
                    after(1, block: {
                        strongSelf.dismissPreloadView()
                    })
                }
            }) { [weak self] (err_msg, err_code) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.addWrongView(err_msg, refresh: {
                        strongSelf.requestBookInfo()
                    })
                }
                
        }
        //        GYBookManager.shared.requestBookInfo(bookId) { [weak self] (book, err_msg,code) in
        //
        //            if let strongSelf = self {
        //                guard let result = book else  {
        //                    strongSelf.dismissPreloadView()
        //                    strongSelf.addWrongView(err_msg, refresh: {
        //                        strongSelf.requestBookInfo()
        //                    })
        //                    return
        //                }
        //                strongSelf.book = result
        //                strongSelf.rewardView.book = result
        //                strongSelf.requestOther()
        //                  strongSelf.gtableView.reloadData()
        //                strongSelf.dismissWrongView()
        //                after(1, block: {
        //                    strongSelf.dismissPreloadView()
        //                })
        //            }
        //
        //        }
        
        
        
        
    }
    
    
    
    func requestOther() {
        requestQuery_freeLimit()
        requestOtherBooks()
        
        requestComments(startId: "0")
        requestRecommends()
    }
    //查看是否是限免
    func requestQuery_freeLimit() {
//        GDQueryFreeLimitRequest(book_id: bookId).request({ [weak self](request, response, result:GDQueryFreelimitModel) in
//            if let weakSelf = self{
//                weakSelf.limit_freeModel = result
//                weakSelf.gtableView.reloadSections(IndexSet(integer: 0), with: .none)
//            }
//        }) { (msg, code) in
//        }
    }
    //MARK:作者其他书籍
    func requestOtherBooks() {
        if book!.user_id == "0" {
            return
        }
        
        GYBookInfoOtherBooksRequest(user_id: book!.user_id, book_id: bookId)
            .requestCollection({[weak self] (request, response, result: [MQIEachBook]) in
                if let strongSelf = self {
                    strongSelf.otherBooks = result
                    strongSelf.gtableView.reloadData()
                    //                    strongSelf.gtableView.reloadSections(IndexSet(integer: 2), with: .none)
                }
                }, failureHandler: { (err_msg, err_code) in
                    
            })
    }
    //MARK:推荐书籍
    func requestRecommends() {
        GDBookInfoRecommendsRequest(book_id: book!.book_id).request({ [weak self](request, response, result: MQRecommendInfoModel) in
            if let strongSelf = self {
                //                strongSelf.configRecommends(result)
                strongSelf.recommendDataModel = result
                strongSelf.recommendBooks = result.data
                let version = UIDevice.current.systemVersion
                if version.doubleValue() <= 9.0 {
                    strongSelf.gtableView.reloadData()
                }else {
                    strongSelf.gtableView.reloadSections(IndexSet(integer: strongSelf.getTableVeiwNums() - 1), with: .none)
                }
            }
        }) { (err_msg, err_code) in
            
        }
    }
    //获取评论
    func requestComments(startId: String) {
        if commentRequestLoding == true {return}
        commentRequestLoding = true
        GYBookInfoCommentsRequest(start_id: startId, limit: "5", book_id: bookId, offset: "0")
            .requestCollection({[weak self] (request, response, result: [GYEachComment]) in
                if let strongSelf = self {
                    
                    strongSelf.comments = result
                    strongSelf.commentRequestLoding = false
                    strongSelf.gtableView.reloadData()
                }
            }) {[weak self] (err_msg, err_code) in
                if let strongSelf = self {
                    strongSelf.commentRequestLoding = false
                    MQILoadManager.shared.makeToast(err_msg)
                }
        }
    }
   
    //MARK:评论点赞
    func toCommentVote(comment: GYEachComment, completion: @escaping (() -> ())) {
        if MQIUserManager.shared.checkIsLogin() == false {
            MQIloginManager.shared.toLogin(nil) {[weak self] in
                if let strongSelf = self {
                    strongSelf.requestCommentVote(comment: comment, completion: completion)
                }
            }
        }else {
            requestCommentVote(comment: comment, completion: completion)
        }
    }
    func requestCommentVote(comment: GYEachComment, completion: @escaping (() -> ())) {
        MQILoadManager.shared.addProgressHUD(kLocalized("HardPress"))
        GYCommentVoteRequest(comment_id: comment.comment_id)
            .request({ (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("PressSuccess"))
                MQICommentManager.shared.addCommentVoteId(comment: comment)
                completion()
            }) { (msg, code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg)
        }
    }
    //MARK:添加书架成功
    @objc func addShelfSuc(_ noti: Notification) {
        if let notiBook = noti.userInfo?["book"] as? MQIEachBook,
            let book = book {
            if book.book_id == notiBook.book_id {
                shelfBtn.isSelected = true
            }
        }
    }
    //打赏
    @objc func toReward() {
        if let _ = book {
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.showRewardView()
                    }
                })
            }else {
                showRewardView()
            }
        }
    }
    //MARK:点赞按钮
    func toLike() {
        if let _ = book {
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.requestToLike()
                    }
                })
            }else {
                requestToLike()
            }
        }
    }
    func requestToLike() {
        GYBookInfoToVoteRequest(user_id: MQIUserManager.shared.user!.user_id, book_id: book!.book_id, toVote: false, vote_num: "10")
            .request({(request, response, result: MQIBaseModel) in
                MQILoadManager.shared.makeToast(kLocalized("TenPress"))
                //                if let weakSelf = self {
                //                    weakSelf.book?.vote_number = "\(Int(weakSelf.book!.vote_number)!+10)"
                //                    weakSelf.gtableView.reloadData()
                //                }
            }) { (err_msg, err_code) in
                MQILoadManager.shared.makeToast(kLocalized("TomorrowCome"))
        }
    }
    //MARK:打赏请求
    func rewardRequest(_ coin: Int) {
        if let book = book {
            MQILoadManager.shared.addProgressHUD(kLocalized("Exceptioning"))
            GYUserRewardRequest(book_id: book.book_id, coin: "\(coin)")
                .request({ (request, response, result: MQIBaseModel) in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(kLocalized("ExceptionSuccess"))
                    UserNotifier.postNotification(.refresh_coin)
                }) { (err_msg, err_code) in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(err_msg)
                    let readOperation = MQIReadOperation()
                    readOperation.operationWrong(type:readOperation.getWrong(code: err_code), completion: {
                        
                    })
            }
        }
    }
    
    @objc func look_pushComment() {
        let allCommentsVC = MQICommentsVC.create() as! MQICommentsVC
        guard let _ = book else {
            MQILoadManager.shared.makeToast(kLocalized("WrongBookInfo"))
            return
        }
        allCommentsVC.book = book
        pushVC(allCommentsVC)
    }
    
    func toChapterList() {
        if let book = book {
            let vc = MQIBookOriginalInfoChapterListViewController.create() as!MQIBookOriginalInfoChapterListViewController
            vc.book = book
            pushVC(vc)
        }
    }
    @objc func toReader() {
        if let book = book {
            MQIUserOperateManager.shared.toReader(book.book_id, book: book)
            MQIEventManager.shared.appendEventData(eventType: .detail_read, additional: ["book_id" : book.book_id])
        }
    }
    @objc func toAddShelf() {
        if let book = book {
            if  MQIUserManager.shared.checkIsLogin(){
                MQIUserOperateManager.shared.addShelf(book, completion: {[weak self]() -> Void in
                    if let strongSelf = self {
                        strongSelf.shelfBtn.isSelected = true
                    }
                })
            }else{
                MQIloginManager.shared.toLogin(nil) {
                    MQIUserOperateManager.shared.addShelf(book, completion: {[weak self]() -> Void in
                        if let strongSelf = self {
                            strongSelf.shelfBtn.isSelected = true
                        }
                    })
                }
            }
            
        }
    }
    
    
    
}


