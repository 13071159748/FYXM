//
//  GYReadDownVC.swift
//  Reader
//
//  Created by CQSC  on 2017/6/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


let GYReadDownVC_rightSpace: CGFloat = 20
let GYReadDownVC_leftSpace: CGFloat = 20
let GYReadDownVC_lineColor: UIColor = RGBColor(239, g: 239, b: 239)

struct ReadDownListStruct {
    var name: String!
    var list: [MQIEachChapter]!
    var unDownList: [MQIEachChapter]!
    var downList: [MQIEachChapter]!
    var selList: [MQIEachChapter]!
    var isSpread: Bool!
    var allCoin: Int!
    var isAllSubscribe: Bool!
    var isFree: Bool!
}

let GYReadDownVCRefresh_header = "GYReadDownVCRefresh_header"
class GYReadDownVC: MQIRootTableVC {
    
    public var book: MQIEachBook!
    public var chapterList = [MQIEachChapter]()
    
    fileprivate var allVIPSelChapters = [MQIEachChapter]()
    
    fileprivate var list = [ReadDownListStruct]()
    fileprivate let groupNum: Int = 20
    
    fileprivate var bottomView: GYReadDownBottomView!
    
    public var updateBook: ((_ book: MQIEachBook) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configList()
        
        DownNotifier.addObserver(self, selector: #selector(GYReadDownVC.bookDownloadFinish(_:)), notification: .download_finish)
        UserNotifier.addObserver(self, selector: #selector(GYReadDownVC.refreshCoin(_: )), notification: .refresh_coin)
        UserNotifier.addObserver(self, selector: #selector(GYReadDownVC.loginIn(_: )), notification: .login_in)
        
        title = book.book_name
        contentView.backgroundColor = UIColor.white
        
        gtableView.bounces = false
        gtableView.registerHeaderFooter(GYReadDownSectionCell.self, xib: false)
        gtableView.registerHeaderFooter(GYReadDownAllFinishSectionCell.self, xib: false)
        gtableView.registerCell(GYReadDownCell.self, xib: false)
        gtableView.registerCell(GYReadDownAllFinishCell.self, xib: false)
        gtableView.separatorColor = RGBColor(229, g: 229, b: 229)
        gtableView.separatorInset = UIEdgeInsets.zero
        
        
        addBottomTool()
       let btn =  addRightBtn(kLocalized("AllSelect"), imgStr: nil)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        if book.buyTids.count <= 0 &&
            MQIUserManager.shared.checkIsLogin() == true {
            requestSubscribe()
        }
    }
    
    func requestSubscribe() {
        if chapterList.count <= 0 {
            return
        }
        
    
        GYAllSubscribeChapterRequest(book_id: book.book_id, start_chapter_id: chapterList[0].chapter_id)
            .request({[weak self] (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("AlreadyUpDateBookingInfo"))
                if let strongSelf = self {
                    if let tids = result.dict["chapter_ids"] {
                        if tids is [String] {
                            strongSelf.book.buyTids = tids as!  [String]
                        }else if tids is [NSNumber] {
                            let newIDs = tids as!  [NSNumber]
                            for i in newIDs {
                            strongSelf.book.buyTids.append(i.stringValue)
                            }
                        }
                    }
                    GYBookManager.shared.buyTids =  strongSelf.book.buyTids
                    strongSelf.configList()
                    strongSelf.gtableView.reloadData()
                    strongSelf.updateBook?(strongSelf.book)
                }
            }) { (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
        }
    }
    
    override func addBottomTool() {
        let bottomHeight = GYReadDownBottomView.getHeight()
        bottomView = UIView.loadNib(GYReadDownBottomView.self)
        bottomView.frame = CGRect(x: 0, y: contentView.height-bottomHeight, width: contentView.width, height: bottomHeight)
        bottomView.book = book
        bottomView.addLine(0, lineColor: nil, directions: .top)
        contentView.addSubview(bottomView)
        
        bottomView.payBlock = {[weak self]() -> Void in
            self?.downloadBooks()
        }
        
        bottomView.toPayVC = {() -> Void in
            MQIUserOperateManager.shared.toPayVC(nil)
        }
        
        gtableView.height -= bottomHeight
    }
    
    override func rightBtnAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected == true {
            for i in 0..<list.count {
                list[i].selList.removeAll()
                list[i].selList.append(contentsOf: list[i].unDownList)
            }
            gtableView.reloadData()
            checkAllSelChapters()
        }else {
            for i in 0..<list.count {
                list[i].selList.removeAll()
            }
            gtableView.reloadData()
            checkAllSelChapters()
        }
    }
    
    fileprivate func configList() {
        list.removeAll()
        allVIPSelChapters.removeAll()
        
        var allFrees = [MQIEachChapter]()
        var frees = [MQIEachChapter]()
        var freeDowns = [MQIEachChapter]()
        
        var allVIPs = [MQIEachChapter]()
        var VIPs = [MQIEachChapter]()
        var VIPDowns = [MQIEachChapter]()
        
        var isAllSubscribe: Bool = false
        
        var index: Int = 0
        var coin: Int = 0
        
        for i in 0..<chapterList.count {
            let chapter = chapterList[i]
            if chapterList[i].chapter_vip == false {
                
                if chapter.isDown == true {
                    freeDowns.append(chapter)
                }else {
                    frees.append(chapter)
                }
                
                allFrees.append(chapter)
            }else {
                
                if chapter.isDown == true {
                    VIPDowns.append(chapter)
                }else {
                    if book.buyTids.contains(chapter.chapter_id) {
                         chapter.isSubscriber = true
                    }else {
                        
                        chapter.isSubscriber = false
                        coin += chapter.chapterPrice(book)
                        isAllSubscribe = false
                    }
                    
                    VIPs.append(chapter)
                }
                
                allVIPs.append(chapter)
                index += 1
                
                if index >= groupNum {
                    let downStruct = ReadDownListStruct(name: "\(kLocalized("No"))\(i-groupNum+2)\(kLocalized("Chapter")) - \(kLocalized("No"))\(i+1)\(kLocalized("Chapter"))",
                        list: allVIPs,
                        unDownList: VIPs,
                        downList: VIPDowns,
                        selList: [MQIEachChapter](),
                        isSpread: false,
                        allCoin: coin,
                        isAllSubscribe: isAllSubscribe,
                        isFree: false)
                    
                    list.append(downStruct)
                    VIPs.removeAll()
                    VIPDowns.removeAll()
                    allVIPs.removeAll()
                    
                    coin = 0
                    index = 0
                    isAllSubscribe = true
                }
            }
        }
        
        if allFrees.count > 0 {
            let downStruct = ReadDownListStruct(name: "\(kLocalized("No"))1\(kLocalized("Chapter")) - \(kLocalized("No"))\(allFrees.count)\(kLocalized("Chapter"))",
                list: allFrees,
                unDownList: frees,
                downList: freeDowns,
                selList: [MQIEachChapter](),
                isSpread: false,
                allCoin: 0,
                isAllSubscribe: false,
                isFree: true)
            
            list.insert(downStruct, at: 0)
        }
    }
    
    func checkAllSelChapters()  {
        allVIPSelChapters.removeAll()
        var allCoin: Int = 0
        for i in 1..<list.count {
            if list[i].selList.count > 0 {
                allVIPSelChapters.append(contentsOf: list[i].selList)
                allCoin += list[i].allCoin
            }
        }
        
        bottomView.selChapters = (list[0].selList, allVIPSelChapters, allCoin)
    }
    
    //    fileprivate func checkSectionAllDownload(_ section: Int) {
    //        if section < list.count {
    //
    //            var isAllDown: Bool = true
    //            let array = list[section].list
    //
    //            for i in 0..<array!.count {
    //                if array![i].isDown == false {
    //                    isAllDown = false
    //                    break
    //                }
    //            }
    //
    //            list[section].isAllDown = isAllDown
    //        }
    //    }
    
    fileprivate func checkChapterIsDownload(_ indexPath: IndexPath) -> Bool {
        let selList = list[indexPath.section].selList
        let chapter = list[indexPath.section].list[indexPath.row]
        for c in selList! {
            if c.chapter_id == chapter.chapter_id {
                return true
            }
        }
        return false
    }
    
    fileprivate func cellSelected(_ sel: Bool, indexPath: IndexPath) {
        var selList = list[indexPath.section].selList
        let chapter = list[indexPath.section].list[indexPath.row]
        if sel == true {
            if checkChapterIsDownload(indexPath) == false {
                list[indexPath.section].selList!.append(chapter)
            }
        }else {
            for i in 0..<selList!.count {
                if selList![i].chapter_id == chapter.chapter_id {
                    list[indexPath.section].selList!.remove(at: i)
                    break
                }
            }
        }
        UIView.performWithoutAnimation {
            self.gtableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }
    
    //查看是否全部选中 一个 section
    fileprivate func checkIsSelectedSection(_ section: Int) -> Bool {
        return (list[section].selList.count+list[section].downList.count) == list[section].list.count
    }
    
    
    //MARK: --
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return list.count
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        if list[section].isSpread == true {
            return list[section].list.count
        }else {
            return 0
        }
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return GYReadDownCell.getHeight(nil)
    }
    
    override func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return GYReadDownSectionCell.getHeight()
    }
    
    override func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        var header: GYReadDownSectionCell!
        
        if list[section].downList.count == list[section].list.count {
            header = tableView.dequeueReusableHeaderFooter(GYReadDownAllFinishSectionCell.self)
        }else {
            header = tableView.dequeueReusableHeaderFooter(GYReadDownSectionCell.self)
            header.baseView.isSelected = checkIsSelectedSection(section)
            
            if list[section].isAllSubscribe == true {
                header.baseView.configSubsribe()
            }else if list[section].allCoin == 0 {
                if list[section].isFree == false {
                    header.baseView.configSubsribe()
                }else {
                    header.baseView.configFree()
                }
            }else {
                header.baseView.configCoin("\(list[section].allCoin!)")
            }
            
            
            header.baseView.selBlock = {[weak self](sel) -> Void in
                if let strongSelf = self {
                    if sel == true {
                        strongSelf.list[section].selList.removeAll()
                        strongSelf.list[section].selList.append(contentsOf: strongSelf.list[section].unDownList)
                    }else {
                        strongSelf.list[section].selList.removeAll()
                    }
                    strongSelf.checkAllSelChapters()
                    UIView.performWithoutAnimation {
                        tableView.reloadSections(IndexSet(integer: section), with: .none)
                    }
                }
            }
            
        }
        header.isSpread = list[section].isSpread
        header.baseView.titleLabel.text = list[section].name
        header.sparedBlock = {[weak self](spread) -> Void in
            if let strongSelf = self {
                strongSelf.list[section].isSpread = spread
                UIView.performWithoutAnimation {
                    tableView.reloadSections(IndexSet(integer: section), with: .none)
                }
                
            }
        }
        
        return  header
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        let chapter = list[indexPath.section].list[indexPath.row]
        
        if chapter.isDown == true {
            let cell = tableView.dequeueReusableCell(GYReadDownAllFinishCell.self, forIndexPath: indexPath)
            
            cell.baseView.titleLabel.text = chapter.chapter_title
            cell.baseView.indexPath = indexPath
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(GYReadDownCell.self, forIndexPath: indexPath)
            
            cell.baseView.titleLabel.text = chapter.chapter_title
            cell.baseView.indexPath = indexPath
            
            
            if checkIsSelectedSection(indexPath.section) {
                cell.baseView.isSelected = true
            }else {
                cell.baseView.isSelected = checkChapterIsDownload(indexPath)
            }
            
            if chapter.chapter_vip == false {
                cell.baseView.configFree()
            }else {
                if chapter.isSubscriber == true {
                    cell.baseView.configSubsribe()
                }else {
//                    cell.baseView.configCoin("\(chapter.chapterPrice(book))")
                    cell.baseView.configCoin("\(chapter.chapterPrice(book))")

                }
                
            }
            
            //            cell.baseView.selBlock = {[weak self](sel) -> Void in
            //                if let strongSelf = self {
            //                    strongSelf.cellSelected(sel, indexPath: indexPath)
            //                    strongSelf.checkAllSelChapters()
            //                }
            //            }
            return cell
        }
    }
    
    override func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        
    }
    
    deinit {
        DownNotifier.removeObserver(self, notification: .download_finish)
        UserNotifier.removeObserver(self, notification: .login_in)
        UserNotifier.removeObserver(self, notification: .refresh_coin)
    }
    
}

extension GYReadDownVC {
    
    public func downloadBooks() {
        if list.count <= 0 {
            return
        }
        
        if allVIPSelChapters.count <= 0 {
            downloadFreeBooks()
        }else {
            GYBookDownloadManager.shared.downloadBooks(book,
                                                       allList: chapterList,
                                                       freeDownList: list[0].selList,
                                                       VIPDownList: allVIPSelChapters)
        }
    }
    
    func downloadFreeBooks() {
        if list.count <= 0 {
            return
        }
        if list[0].isFree == false || list[0].selList.count <= 0 {
            return
        }
        
        GYBookDownloadManager.shared
            .toDownloadFreeBooks(book,
                                 list: chapterList,
                                 freeList: list[0].selList,
                                 completion: nil) { (code, msg) in
                                    
                                    MQILoadManager.shared.makeToast(msg)
        }
    }
}

extension GYReadDownVC {
    @objc func bookDownloadFinish(_ noti: Notification) {
        if let userInfo = noti.userInfo {
            if let newList = userInfo["list"] as? [MQIEachChapter] {
                list.removeAll()
                chapterList = newList
                configList()
                gtableView.reloadData()
            }
            if let newBook = userInfo["book"] as? MQIEachBook {
                book = newBook
            }
            
            bottomView.selChapters = ([], [], 0)
        }
    }
    
    @objc func refreshCoin(_ noti: Notification) {
        bottomView.reloadUserCoin()
    }
    
    @objc func loginIn(_ noti: Notification) {
        bottomView.price = 0
        MQILoadManager.shared.addProgressHUD(kLocalized("UpDateBookingInfo"))
        requestSubscribe()
    }
}
