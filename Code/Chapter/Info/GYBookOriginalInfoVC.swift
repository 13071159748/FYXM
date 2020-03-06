//
//  GYBookOriginalInfoVC.swift
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

import MJRefresh
import UITableView_FDTemplateLayoutCell

let GYBookOriginalInfoVC_footerColor = RGBColor(235, g: 235, b: 235)
let GYBookOriginalInfoVC_headerFont = UIFont.systemFont(ofSize: 17)
let GYBookOriginalInfoVC_headerHeight: CGFloat = 40
let GYBookOriginalInfoVC_headerColor = blackColor
class GYBookOriginalInfoVC: MQIRootTableVC {
    
    var bookId: String = ""
    var book: MQIEachBook? {
        didSet {
            if let book = book {
                title = book.book_name
            }
        }
    }
    var otherBooks = [MQIEachBook]()
    var comments = [GYEachComment]()

    var recommendBooks = [[MQIEachBook]]()
    
    var shelfBtn: UIButton!
    
    let bacImageViewHeight: CGFloat = GYBookOriginalHeaderCell_minHeight+50
    
    var isSpared: Bool = false {
        didSet {
            headerCellHeight = 0
            gtableView.reloadData()
        }
    }
    
    var recommendIndex: Int = 0
    var maskView_: UIView!
    var rewardView: GYUserRewardView!
//    var commentView: GYCommentView!
    fileprivate var limit_freeModel = GDQueryFreelimitModel()

    fileprivate var bacImageView: GYBookOriginalInfoVCGaussianView!
    fileprivate var keyboardShow: Bool = false
    
    fileprivate let footerHeight: CGFloat = 5
    
    fileprivate var moreComments: Bool = false
    fileprivate var commentRequestLoding: Bool = false
    
    fileprivate var currenPage: Int = 0
    fileprivate var perPage = "\(DEFAULT_PER_PAGE)"
    
    fileprivate var headerCellHeight: CGFloat = 0
    fileprivate var likeCellHeight: CGFloat = 0
    fileprivate var commentHeights = [IndexPath : CGFloat]()
    fileprivate var commentReplyHeights = [IndexPath : CGFloat]()
    
    var gaussianBacBool: Bool = false {
        didSet {
            if gaussianBacBool == true {
                UIView.animate(withDuration: 0.25, animations: {[weak self] () -> Void in
                    if let strongSelf = self {
                        strongSelf.status.backgroundColor = UIColor.clear
                        strongSelf.nav.backgroundColor = UIColor.clear
                    }
                })
            }
        }
    }
    var timer_Update:Timer!//定时器

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = kLocalized("BookInfo")
        titleLabel.textAlignment = .left
        addBottomTool()
        
        maskView_ = UIView(frame: view.bounds)
        maskView_.backgroundColor = UIColor.black
        maskView_.alpha = 0.5
        maskView_.isUserInteractionEnabled = true
        maskView_.isHidden = true
        addTGR(self, action: #selector(GYBookOriginalInfoVC.tgrClick), view: maskView_)
        view.addSubview(maskView_)
        
        addRightBtn(nil, imgStr: "info_shared")
        
        ShelfNotifier.addObserver(self, selector: #selector(GYBookOriginalInfoVC.addShelfSuc(_:)), notification: .refresh_shelf)
//        NotificationCenter.default.addObserver(self, selector: #selector(addShelfSuc(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(GYBookOriginalInfoVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
        bacImageView = GYBookOriginalInfoVCGaussianView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: bacImageViewHeight))
        bacImageView.vibrancyView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.addSubview(bacImageView)
        view.sendSubviewToBack(bacImageView)
        
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
        
//        commentView = GYCommentView(frame: CGRect(x: 0, y: height, width: width, height: GYCommentView.getHeight()))
//        commentView.bookId = bookId
//        commentView.completion = {[weak self]() -> Void in
//            if let strongSelf = self {
//                strongSelf.commentView.textView.endEditing(true)
//                strongSelf.dismissCommentView()
//                strongSelf.commentView.textView.text = ""
//                strongSelf.commentView.placeHolder.isHidden = false
//            }
//        }
//        view.addSubview(commentView)
        
        gtableView.height -= root_bottomTool_height-footerHeight
        gtableView.separatorColor = RGBColor(218, g: 218, b: 218)
        gtableView.backgroundColor = UIColor.clear
        
        gtableView.registerCell(GYBookOriginalHeaderCell.self, xib: true)
        gtableView.registerCell(GYBookOriginalActionCell.self, xib: false)
        gtableView.registerCell(MQIBookOriginalOtherBooksCell.self, xib: false)
        gtableView.registerCell(GYBookOriginalOtherBooksHeaderCell.self, xib: false)
        gtableView.registerCell(GYBookOriginalLikesCell.self, xib: false)
        gtableView.registerCell(GYBookOriginalCommentCell.self, xib: false)
        gtableView.registerCell(MQITableViewCell.self, xib: false)
        
        gtableView.registerCell(GYBookOriginalCommentHeaderCell.self, xib: false)
        gtableView.registerCell(MQIBookOriginalCommentReplyCell.self, xib: false)
        gtableView.registerCell(UITableViewCell.self, xib: false)
        
        addPreloadView()
        requestBookInfo()
    }
    override func rightBtnAction(_ button: UIButton) {
        if let book = book {
            MQISocialManager.shared.sharedBook(book)
        }
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
    var bookInfoDisAppear:Bool = false
    override func viewDidDisappear(_ animated: Bool) {
        bookInfoDisAppear = true
    }
    override func addBottomTool() {
        bottomTool = UIView(frame: CGRect(x: 0, y: contentView.height-root_bottomTool_height, width: screenWidth, height: root_bottomTool_height))
        bottomTool.isUserInteractionEnabled = true
        bottomTool.backgroundColor = UIColor.white
        contentView.addSubview(bottomTool)
        
        let width = bottomTool.bounds.width/2
        let height = bottomTool.bounds.height
        let btnFont = UIFont.systemFont(ofSize: 16)
        let readerBtn = createButton(CGRect(x: 0, y: 0, width: width, height: height),
                                     normalTitle: kLocalized("BeginRead"),
                                     normalImage: nil,
                                     selectedTitle: nil,
                                     selectedImage: nil,
                                     normalTilteColor: UIColor.white,
                                     selectedTitleColor: nil,
                                     bacColor: mainColor,
                                     font: btnFont,
                                     target: self,
                                     action: #selector(GYBookOriginalInfoVC.toReader))
        bottomTool.addSubview(readerBtn)
        if MQIRecentBookManager.shared.books.map({$0.book_id}).contains(bookId) {
            readerBtn.setTitle(kLocalized("GoOnRead"), for: .normal)
        }
        
        shelfBtn = createButton(CGRect(x: width, y: 0, width: width, height: height),
                                normalTitle: kLocalized("AddShelf"),
                                normalImage: nil,
                                selectedTitle: kLocalized("AlreadyAddShelf"),
                                selectedImage: nil,
                                normalTilteColor: blackColor,
                                selectedTitleColor: nil,
                                bacColor: RGBColor(231, g: 231, b: 231),
                                font: btnFont,
                                target: self,
                                action: #selector(GYBookOriginalInfoVC.toAddShelf))
        shelfBtn.isSelected = MQIShelfManager.shared.checkIsExist(bookId)
        bottomTool.addSubview(shelfBtn)
    }
    
    func configBacImageView() {
        if let book = book {
            bacImageView.sd_setImage(with: URL(string: book.book_cover),
                                     placeholderImage: bookPlaceHolderImage,
                                     options: .allowInvalidSSLCertificates,
                                     completed:  {[weak self] (image, error, type, ulr) in
                                        if let strongSelf = self {
//                                        if let _ = image {
//                                            strongSelf.gaussianBacBool = true
//                                        }else {
//                                            strongSelf.gaussianBacBool = false
//                                        }
                                        strongSelf.gtableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
                                        }
            })
        }
    }
    
    override func dismissPreloadView() {
        super.dismissPreloadView()
        gaussianBacBool = true
    }

    
    //MARK: --
    var commentHeader: GYBookOriginalInfoCellHeaderView!
    func getCommentHeader() -> GYBookOriginalInfoCellHeaderView {
        if commentHeader == nil {
            commentHeader = GYBookOriginalInfoCellHeaderView(frame: CGRect(x: 0, y: 0, width: gtableView.width, height: GYBookOriginalInfoVC_headerHeight))
            commentHeader.title = kLocalized("NewComments")
            let image = UIImage(named: "comment_edit")?.withRenderingMode(.alwaysTemplate)
            commentHeader.btn.setTitle(kLocalized("Comments"), for: .normal)
            commentHeader.btn.setImage(image, for: .normal)
            commentHeader.btn.tintColor = mainColor
            commentHeader.btnBlock = {[weak self]() -> Void in
                if let strongSelf = self {
                strongSelf.showCommentView()
                }
            }
        }
        return commentHeader
    }
    
    func getTableVeiwNums() -> Int {
        var commentSections: Int = 0
        if comments.count <= 0 {
            commentSections = 1
        }else {
            commentSections = moreComments == true ? comments.count+1 : comments.count
        }
        
        return 5+commentSections
    }
    
    //MARK: --Delegate
    
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return getTableVeiwNums()
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        switch section {
        case 0,1,3:
            return 1
        case 2:
            return otherBooks.count <= 0 ? 0 : otherBooks.count+1
        case 4:
            return 1
        default:
            if comments.count <= 0 || comments.count == section-5 {
                return 1
            }else {
                return comments[section-5].reply.count+1
            }
        }
    }
    
    override func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        view.backgroundColor = GYBookOriginalInfoVC_footerColor

        switch section {
        case 0, 1:
            if let _ = book {
                return view
            }else {
                return UIView()
            }
        case 2:
            if otherBooks.count > 0 {
                return view
            }else {
                return UIView()
            }
        case 3:
            if recommendBooks.count > 0 {
                return view
            }else {
                return UIView()
            }
        case getTableVeiwNums()-1:
            return view
        default:
            return UIView()
        }
    }
    
    override func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        switch section {
        case 0, 1:
            if let _ = book {
                return footerHeight
            }else {
                return 0
            }
        case 2:
            if otherBooks.count > 0 {
                return footerHeight
            }else {
                return 0
            }
        case 3:
            if recommendBooks.count > 0 {
                return footerHeight
            }else {
                return 0
            }
        case getTableVeiwNums()-1:
            return footerHeight
        default:
            return 0
        }
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if let book = book {
                if headerCellHeight == 0 {
                    headerCellHeight = GYBookOriginalHeaderCell_minHeight+GYBookOriginalHeaderInfo.getHeight(book.book_intro, isSpared: isSpared)
                }
                return headerCellHeight
            }else {
                return 0
            }
        case 1:
            if MQIPayTypeManager.shared.type == .inPurchase{
                return 0
            }
            return 45
        case 2:
            if indexPath.row == 0 {
                return GYBookOriginalInfoVC_headerHeight
            }else {
                return 130
            }
        case 3:
            if likeCellHeight == 0 {
                likeCellHeight = GYBookOriginalLikesCell.getHeight(nil)+GYBookOriginalInfoVC_headerHeight
            }
            return likeCellHeight
        case 4:
            return GYBookOriginalInfoVC_headerHeight
        default:
            if comments.count <= 0 {
                return 70
            }else if indexPath.section-5 == comments.count {
                return 44
            }else {
                let comment = comments[indexPath.section-5]
                if indexPath.row == 0 {
//                    return tableView.g_heightForCell(GYBookOriginalCommentHeaderCell.self, configuration: { (cell) in
//                        if cell is GYBookOriginalCommentHeaderCell {
//                            configCommentCell(cell as! GYBookOriginalCommentHeaderCell,
//                                                   indexPath: indexPath)
//                        }
//                    })
                    if let height = commentHeights[indexPath] {
                        return height
                    }else {
                        let height = GYBookOriginalCommentCellHeader.getHeight(comment: comment)
                        commentHeights[indexPath] = height
                        return height
                    }
                }else {
                    
//                    return tableView.g_heightForCell(GYBookOriginalCommentReplyCell.self, configuration: { (cell) in
//                        if cell is GYBookOriginalCommentReplyCell {
//                            configReplyCell(cell as! GYBookOriginalCommentReplyCell,
//                                                 indexPath: indexPath)
//                        }
//                    })
                    
                    if let height = commentReplyHeights[indexPath] {
                        return height
                    }else {
                        let height = GYBookOriginalCommentCellReply.getHeight(reply: comment.reply[indexPath.row-1], width: screenWidth-63)
                        commentReplyHeights[indexPath] = height
                        return height
                    }
                }
            }
        }
        
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            return coinfigHeaderCell(indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(GYBookOriginalActionCell.self, forIndexPath: indexPath)
            //            cell.like_num = like_Num
            if MQIPayTypeManager.shared.type == .inPurchase{
                cell.rewardBtn.isHidden = true
                cell.likeBtn.isHidden = true
            }else {
                cell.rewardBtn.isHidden = false
                cell.likeBtn.isHidden = false
            }
            cell.toReward = {[unowned self]() -> Void in
                self.toReward()
            }
            cell.toLike = {[unowned self]() -> Void in
                //                like_Num = vote_num
                self.toLike()
            }
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(GYBookOriginalOtherBooksHeaderCell.self, forIndexPath: indexPath)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(MQIBookOriginalOtherBooksCell.self, forIndexPath: indexPath)
                cell.indexPath = indexPath
                cell.book = otherBooks[indexPath.row-1]
                return cell
            }
        case 3:
            return configLikeCell(indexPath)
        case 4:
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
            cell.contentView.addSubview(getCommentHeader())
            cell.selectionStyle = .none
            return cell
        default:
            if comments.count <= 0 || indexPath.section-5 == comments.count {
                let cell = tableView.dequeueReusableCell(MQITableViewCell.self, forIndexPath: indexPath)
                cell.textLabel?.text = comments.count <= 0 ? kLocalized("ComeFirstComments") : kLocalized("CheckAll")
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = systemFont(15)
                cell.textLabel?.textColor = RGBColor(135, g: 135, b: 135)
                return cell
            }else {
                if indexPath.row == 0 {
                    let cell = gtableView.dequeueReusableCell(GYBookOriginalCommentHeaderCell.self, forIndexPath: indexPath)
                    cell.header.toVote = {[weak self]comment -> Void in
                        if let strongSelf = self {
                            strongSelf.toCommentVote(comment: comment, completion: {
                                strongSelf.gtableView.reloadRows(at: [indexPath], with: .none)
                            })
                        }
                    }
                    configCommentCell(cell, indexPath: indexPath)
                    return cell
                }else {
                    let cell = gtableView.dequeueReusableCell(MQIBookOriginalCommentReplyCell.self, forIndexPath: indexPath)
                    configReplyCell(cell, indexPath: indexPath)
                    return cell
                }
            }
            
        }
    }
    
    func gScrollViewDidScroll(_ tableView: MQITableView) {
        let offsetY = tableView.contentOffset.y
        if -offsetY <= -(bacImageView.bounds.height-root_nav_height-root_status_height-45) {
            bacImageView.frame.origin.y = -(bacImageView.bounds.height-root_nav_height-root_status_height-45)
        }else if -offsetY >= 0 {
            bacImageView.frame.origin.y = 0
            bacImageView.frame.size.height = bacImageViewHeight-offsetY
        }else {
            bacImageView.frame.origin.y = -offsetY
            
        }
    }
 
    override func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            if indexPath.row > 0 {
                toBookInfo(otherBooks[indexPath.row-1])
            }
        case getTableVeiwNums()-1:
            if indexPath.section-5 == comments.count && comments.count > 0 {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = kLocalized("Loading")
                requestComments(startId: comments.last!.comment_id)
            }
        default:
            break
        }
        gtableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
 
    func coinfigHeaderCell(_ indexPath: IndexPath) -> GYBookOriginalHeaderCell {
        let cell = gtableView.dequeueReusableCell(GYBookOriginalHeaderCell.self, forIndexPath: indexPath)
        cell.removeNSNotificationCenter()
        cell.book = book
        if limit_freeModel.limit_free {
            cell.limit_freeTime = limit_freeModel.limit_time
            //            cell.limit_freeTime = "1506394172"
            createTimer()//定时器判断是否是限时免费的
            cell.registerNSNotificationCenter()
        }
        cell.infoView.isSpared = isSpared
        cell.infoView.toSpared = {[weak self]spared -> Void in
            if let strongSelf = self {
                strongSelf.isSpared = spared
            }
        }
        cell.toList = {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.toChapterList()
            }
        }
        cell.gaussianBacBool = gaussianBacBool
        return cell
    }
 
    func configLikeCell(_ indexPath: IndexPath) -> GYBookOriginalLikesCell {
        let cell = gtableView.dequeueReusableCell(GYBookOriginalLikesCell.self, forIndexPath: indexPath)
        if recommendBooks.count > 0 {
            cell.books = recommendBooks[recommendIndex]
        }
        cell.toChange = {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.otherBooksChange()
            }
        }
        cell.clickAction = {[weak self]cBook -> Void in
            if let strongSelf = self {
                strongSelf.toBookInfo(cBook)
            }
        }
        cell.changeBtn.isHidden = recommendBooks.count <= 1 ? true : false
        return cell
    }
    
    func configCommentCell(_ cell: GYBookOriginalCommentHeaderCell, indexPath: IndexPath) {
        cell.fd_enforceFrameLayout = false
        cell.comment = comments[indexPath.section-5]
    }
    
    func configReplyCell(_ cell: MQIBookOriginalCommentReplyCell, indexPath: IndexPath) {
        cell.fd_enforceFrameLayout = false
        cell.reply = comments[indexPath.section-5].reply[indexPath.row-1]
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
       
    }
    func createTimer() {
        if timer_Update == nil {
            timer_Update = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GYBookOriginalInfoVC.timerCountDown), userInfo: nil, repeats: true)
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
}

extension GYBookOriginalInfoVC {
    
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
        requestRecommends()
        requestComments(startId: "0")
    }
    func requestQuery_freeLimit() {
//        GDQueryFreeLimitRequest(book_id: bookId).request({ [weak self](request, response, result:GDQueryFreelimitModel) in
//            if let weakSelf = self{
//                weakSelf.limit_freeModel = result
//                weakSelf.gtableView.reloadSections(IndexSet(integer: 0), with: .none)
//            }
//        }) { (msg, code) in
//            
//        }
    }
    func requestOtherBooks() {
        if book!.user_id == "0" {
            return
        }
        
        GYBookInfoOtherBooksRequest(user_id: book!.user_id, book_id: bookId)
            .requestCollection({[weak self] (request, response, result: [MQIEachBook]) in
                if let strongSelf = self {
                    let dic = try? JSONSerialization.jsonObject(with: (response?.data!)!, options: JSONSerialization.ReadingOptions.mutableContainers)

                    strongSelf.otherBooks = result
                    strongSelf.gtableView.reloadSections(IndexSet(integer: 2), with: .none)
                }
                }, failureHandler: { (err_msg, err_code) in
                
            })
    }
    //MARK:推荐书籍
    func requestRecommends() {
        
        GDBookInfoRecommendsRequest(book_id: book!.book_id).request({ [weak self](request, response, result: MQRecommendInfoModel) in
            if let strongSelf = self {
                strongSelf.configRecommends(result.data)
                strongSelf.gtableView.reloadSections(IndexSet(integer: 3), with: .none)
            }
        }) { (err_msg, err_code) in
            
        }
        
//        GYBookInfoRecommendsRequest(tj_type: "look_nice")
//            .requestCollection({[weak self] (request, response, result: [MQIEachBook]) in
//                if let strongSelf = self {
//                    strongSelf.configRecommends(result)
//                    strongSelf.gtableView.reloadSections(IndexSet(integer: 3), with: .none)
//                }
//            }) { (err_msg, err_code) in
//                
//        }
    }
    //MARK:评论
    func requestComments(startId: String) {
        if commentRequestLoding == true {return}
        commentRequestLoding = true
        GYBookInfoCommentsRequest(start_id: startId, limit: perPage, book_id: bookId,offset: "0")
            .requestCollection({[weak self] (request, response, result: [GYEachComment]) in
                if let strongSelf = self {
                    if result.count < DEFAULT_PER_PAGE {
                        strongSelf.moreComments = false
                    }else {
                        strongSelf.moreComments = true
                    }
                    strongSelf.comments.append(contentsOf: result)
                    strongSelf.commentRequestLoding = false
                    //                    strongSelf.gtableView.reloadSections(IndexSet(integer: 4), with: .none)
                    strongSelf.gtableView.reloadData()
                }
            }) {[weak self] (err_msg, err_code) in
                if let strongSelf = self {
                    strongSelf.commentRequestLoding = false
                    MQILoadManager.shared.makeToast(err_msg)
                }
        }
    }
    
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
    
    func configRecommends(_ result: [MQIEachBook]) {
        if result.count > 0 {
            
            var index: Int = 0
            for _ in 0..<result.count {
//                i = index
                var array = [MQIEachBook]()
                for _ in 0...2 {
                    array.append(result[index])
                    index += 1
                    if index > result.count-1 {
                        break
                    }
                }
                if index >= result.count-1 {
                    recommendBooks.append(array)
                    break
                }
                recommendBooks.append(array)
            }
        }
    }
    
    @objc func addShelfSuc(_ noti: Notification) {
        if let notiBook = noti.userInfo?["book"] as? MQIEachBook,
            let book = book {
            if book.book_id == notiBook.book_id {
                shelfBtn.isSelected = true
            }
        }
    }
    
    func toReward() {
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
            .request({[weak self] (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.makeToast(kLocalized("TenPress"))
                if let weakSelf = self {
                    weakSelf.book?.vote_number = "\(Int(weakSelf.book!.vote_number)!+10)"
                    weakSelf.gtableView.reloadData()
                }
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
    
}

extension GYBookOriginalInfoVC {
    //MARK: --
    func otherBooksChange() {
        if recommendBooks.count <= 1 {
            MQILoadManager.shared.makeToast(kLocalized("NoMoreBook"))
            return
        }
        recommendIndex += 1
        if recommendIndex >= recommendBooks.count {
            recommendIndex = 0
        }
        gtableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    func checkMoreComments() {
        
    }
    
    @objc func tgrClick() {
        if keyboardShow == true {
//            commentView.textView.endEditing(true)
        }else {
            dismissRewardView()
            dismissCommentView()
        }
    }
    
    func toBookInfo(_ cBook: MQIEachBook) {
        let bookInfoVC = GYBookOriginalInfoVC()
        bookInfoVC.bookId = cBook.book_id
        pushVC(bookInfoVC)
    }
    
    @objc func toReader() {
        if let book = book {
            MQIUserOperateManager.shared.toReader(book.book_id, book: book)
        }
    }
    
    func toChapterList() {
        if let book = book {
            let vc = MQIBookOriginalInfoChapterListViewController.create() as!MQIBookOriginalInfoChapterListViewController
            vc.book = book
            pushVC(vc)
        }
    }
    
    @objc func toAddShelf() {
        if let book = book {
            MQIUserOperateManager.shared.addShelf(book, completion: {[weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.shelfBtn.isSelected = true
                }
            })
        }
    }
}

extension GYBookOriginalInfoVC {
    
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
//        commentView.isHidden = false
//        maskView_.isHidden = false
//
//        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
//            if let strongSelf = self {
//                strongSelf.maskView_.alpha = 0.5
//                strongSelf.contentView.bringSubview(toFront: strongSelf.maskView_)
//
//                strongSelf.commentView.frame.origin.y = strongSelf.view.height-strongSelf.commentView.height
//                strongSelf.contentView.bringSubview(toFront: strongSelf.commentView)
//            }
//            }, completion: { (suc) in
//
//        })
    }
    
    func dismissCommentView() {
//        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
//            if let strongSelf = self{
//                strongSelf.commentView.frame.origin.y = strongSelf.view.height
//                strongSelf.maskView_.alpha = 0
//            }
//            }, completion: {[weak self] (suc) in
//                if let strongSelf = self {
//                strongSelf.commentView.isHidden = true
//                strongSelf.maskView_.isHidden = true
//                }
//        })
    }
    
    
}

extension GYBookOriginalInfoVC {
    
//    @objc func keyboardWillShow(_ noti: NSNotification) {
//        if let commentView = commentView {
//            keyboardShow = true
//            let userInfo = noti.userInfo
//            let frameNew = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//            
//            let keyboardHeight = frameNew.size.height
//            UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
//                if let strongSelf = self {
//                    commentView.frame.origin.y = strongSelf.view.height-commentView.height-keyboardHeight
//                    strongSelf.view.bringSubview(toFront: commentView)
//                }
//                }, completion: { (suc) in
//                    
//            })
//        }
//    }
    
//    @objc func keyboardWillHide(_ noti: NSNotification) {
//        if let commentView = commentView {
//            keyboardShow = false
//            UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
//                if let strongSelf = self {
//                    commentView.frame.origin.y = strongSelf.view.height-commentView.height
//                    strongSelf.view.bringSubview(toFront: commentView)
//                }
//                }, completion: { (suc) in
//
//            })
//        }
//    }
}

class GYBookOriginalInfoVCGaussianView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            if let _ = image {
                blurView.isHidden =  false
                vibrancyView.isHidden = false
            }else {
                blurView.isHidden =  true
                vibrancyView.isHidden = true
            }
        }
    }
    
    var blurView: UIVisualEffectView!
    var vibrancyView: UIVisualEffectView!
    
    var vibrancyViewBacColor: UIColor? {
        didSet {
            if let vibrancyViewBacColor = vibrancyViewBacColor {
                vibrancyView.backgroundColor = vibrancyViewBacColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        let imageMaskLayer = CALayer()
        let pattern = UIImage(named: "pattern")!
        imageMaskLayer.contents = pattern.cgImage
        imageMaskLayer.frame = bounds
        
        layer.mask = imageMaskLayer
        clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.isHidden = true
        addSubview(blurView)
        
        //创建并添加vibrancy视图
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect:vibrancyEffect)
        vibrancyView.frame = bounds
        vibrancyView.isHidden = true
        blurView.contentView.addSubview(vibrancyView)
        addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        vibrancyView.frame = bounds
    }
}
