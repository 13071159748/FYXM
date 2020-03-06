//
//  MQIBookOriginalInfoChapterListViewController.swift
//  CQSC
//
//  Created by moqing on 2019/3/7.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh

class MQIBookOriginalInfoChapterListViewController: MQIBaseViewController {

    var tableView: MQITableView!
    var book: MQIEachBook!
    var chapterList = [MQIEachChapter]()
    var titleColor: UIColor = RGBColor(31, g: 31, b: 31)
    var titleSelColor: UIColor = mainColor
    var normalSort: Bool = true
    /// 订阅过的id
    var buyTids:[String]?
    ///全本订阅
    var whole_subscribe:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("Directory")
        addBottomTool()
        addtab()
        setTabAtt()
        addPreloadView()
        createDate()
        tableView.width -= 14
        tableView.showsVerticalScrollIndicator = false
        tableView.scrollsToTop = false
        addSlidingView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = tableView, let _ = book {
            reloadChapterList()
        }
    }
    
    
    deinit {
        DownNotifier.removeObserver(self, notification: .download_finish)
    }
    
    
    override func addBottomTool() {
        bottomTool = UIView(frame: CGRect(x: 0,
                                          y: contentView.bounds.height-root_bottomTool_height,
                                          width: contentView.bounds.width,
                                          height: root_bottomTool_height))
        bottomTool.isUserInteractionEnabled = true
        bottomTool.addLine(0, lineColor: nil, directions: .top)
        contentView.addSubview(bottomTool)
        
        let width = bottomTool.bounds.width*0.5
        let height = bottomTool.bounds.height
        let btnFont = UIFont.systemFont(ofSize: 15)
        let sequenceBtn = createButton(CGRect(x: 0, y: 0, width: width, height: height),
                                       normalTitle: " 排序",
                                       normalImage: UIImage(named: "chapter_sequence2"),
                                       selectedTitle: nil,
                                       selectedImage: UIImage(named: "chapter_sequence2_sel"),
                                       normalTilteColor: titleColor,
                                       selectedTitleColor: nil,
                                       bacColor: UIColor.clear,
                                       font: btnFont,
                                       target: self,
                                       action: #selector(MQIBookOriginalInfoChapterListViewController.toSequence))
        sequenceBtn.addLine(0, lineColor: nil, directions: .right)
        bottomTool.addSubview(sequenceBtn)
        
        let downloadBtn = createButton(CGRect(x: width, y: 0, width: width, height: height),
                                       normalTitle: " "+kLocalized("Down"),
                                       normalImage: UIImage(named: "chapterlist_download"),
                                       selectedTitle: nil,
                                       selectedImage: nil,
                                       normalTilteColor: titleColor,
                                       selectedTitleColor: nil,
                                       bacColor: UIColor.clear,
                                       font: btnFont,
                                       target: self,
                                       action: #selector(MQIBookOriginalInfoChapterListViewController.toDownload))
        bottomTool.addSubview(downloadBtn)
        
    }
    var slidingView:UIButton!
    var isClickSlidingView:Bool = false
    var slidingViewMaxHeight:CGFloat = 0
    func addSlidingView() {
        let  slidingBacView = UIView(frame: CGRect(x: tableView.maxX, y: tableView.y, width: 14, height: tableView.height))
        contentView.addSubview(slidingBacView)
        slidingViewMaxHeight = slidingBacView.height
        slidingBacView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.1)
        slidingView = UIButton(frame: CGRect(x:  0, y:0, width: 14, height: 42))
        slidingView.setImage(UIImage(named: "Chapter_sliding_img_no"), for: .normal)
        slidingView.setImage(UIImage(named: "Chapter_sliding_img_sel"), for: UIControl.State.highlighted)
        slidingView.setImage(UIImage(named: "Chapter_sliding_img_sel"), for: .selected)
        slidingBacView.addSubview(slidingView)
        slidingView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(changePostion(sender:))))
        contentView.bringSubviewToFront(slidingBacView)
        
        
    }
    
    /// 滑动操作
    @objc func changePostion(sender:UIPanGestureRecognizer) -> Void {
        
        func changeY() {
            let offset = sender.translation(in: self.slidingView)
            sender.setTranslation(CGPoint.zero, in: self.slidingView)
            self.slidingView.y +=  offset.y
            if self.slidingView.y <= 0{
                self.slidingView.y = 0
                if tableView.contentOffset.y <= 0 { return}
                tableView.setContentOffset(CGPoint(x: 0, y:0), animated: false)
                return
            }
            if self.slidingView.maxY >= tableView.height{
                self.slidingView.maxY = tableView.height
                if tableView.contentOffset.y >= tableView.contentSize.height-tableView.height {return}
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height-tableView.height), animated: false)
                return
            }
            
            let than =   (tableView.contentSize.height-tableView.height)/tableView.height
            tableView.setContentOffset(CGPoint(x: 0, y: self.slidingView.maxY*than), animated: false)
            
        }
        if sender.state == .changed {
            slidingView.isSelected = true
            isClickSlidingView = true
            changeY()
            
        }else if sender.state == .ended {
            slidingView.isSelected = false
            changeY()
        }else{
            slidingView.isSelected = false
            isClickSlidingView = false
        }
        
    }
    
    func gScrollViewDidScroll(_ tableView: MQITableView) {
        if isClickSlidingView  { return}
        let than =   tableView.contentOffset.y/(tableView.contentSize.height-tableView.height)
        slidingView.y = than*tableView.height
        if self.slidingView.y <= 0 {
            self.slidingView.y = 0
        }
        if self.slidingView.maxY >= tableView.height{
            self.slidingView.maxY = tableView.height
        }
//        var   new_y = than*tableView.height
//        if new_y <= 0 {
//            new_y = 0
//        }
//        if new_y >= tableView.height-slidingView.height{
//           new_y = tableView.height-slidingView.height
//        }
//        slidingView.y = new_y
    }

    func gScrollViewWillBeginDragging(_ tableView: MQITableView) {
        slidingView.isSelected = false
        isClickSlidingView = false
    }
    
    //MARK: --
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
}

extension MQIBookOriginalInfoChapterListViewController: MQITableViewDelegate{
    //MARK: --
     func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
     func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return chapterList.count
    }
    
     func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQIBookOriginalInfoChapterListViewControllerCell.getHeight()
    }
    
     func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(MQIBookOriginalInfoChapterListViewControllerCell.self, forIndexPath: indexPath)
       let cell =  tableView.dequeueReusableCell(withIdentifier:   "MQIBookOriginalInfoChapterListViewControllerCellName", for: indexPath) as! MQIBookOriginalInfoChapterListViewControllerCell

        let chapter = chapterList[indexPath.row]
        cell.chapter = chapter
        return cell
    }
    
     func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        let index = normalSort == true ? indexPath.row : chapterList.count-indexPath.row-1
        
        MQIUserOperateManager.shared.toReader(book.book_id, book: book, toIndex: index)
        
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    
}

//MARK:  操作方法
extension  MQIBookOriginalInfoChapterListViewController {
    //MARK: --
    @objc func toSequence(_ button: UIButton) {
        button.isSelected = !button.isSelected
        chapterList = chapterList.reversed()
        normalSort = !normalSort
        tableView.reloadData()
    }
    
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
    
    @objc func refresh(_ noti: Notification) {
        
        if let list = noti.userInfo?["list"] as? [MQIEachChapter],
            let b = noti.userInfo?["book"] as? MQIEachBook {
            book = b
            chapterList = list
            tableView.reloadData()
        }
    }
    
    func reloadChapterList() {
        if let b = GYBookManager.shared.getDownloadBook(book.book_id) {
            book = b
        }
        
        for i in 0..<chapterList.count {
            if book.downTids.contains(chapterList[i].chapter_id) &&   !chapterList[i].isDown {
                chapterList[i].isDown = true
            }
        }
        tableView.reloadData()
    }
    
    
}
//MARK:  网络操作
extension MQIBookOriginalInfoChapterListViewController{
    func createDate() {
        
        if let result = GYBookManager.shared.getDownloadBook(book.book_id) {
            self.book = result
        }
        if let list = GYBookManager.shared.getChapterListFromLocation(book) {
            chapterList = list
        }
        request(false, alert: chapterList.count > 0)
        
        GYBookManager.shared.getSubscribeChapterIds(book_id: book.book_id) {[weak self] (msg) in
            self?.buyTids =  GYBookManager.shared.buyTids
            self?.whole_subscribe =  GYBookManager.shared.whole_subscribe
        }
    }
    
    func request(_ refresh: Bool, alert: Bool) {
     
        GYBookManager.shared.getChapterList(book, forceRefresh: refresh, completion: {[weak self] (list) in
            if let strongSelf = self {
                strongSelf.tableView.mj_header.endRefreshing()
                strongSelf.dismissPreloadView()
                strongSelf.dismissWrongView()
                if strongSelf.normalSort == false {
                    strongSelf.chapterList = list.reversed()
                }else {strongSelf.chapterList = list}
                strongSelf.tableView.reloadData()
                if alert == true {
                    MQILoadManager.shared.makeToast("章节目录信息更新成功")
                }
            }
        }) {[weak self] (err_code, err_msg) in
            if let strongSelf = self {
                strongSelf.dismissPreloadView()
                strongSelf.tableView.mj_header.endRefreshing()
                strongSelf.addWrongView(err_msg, refresh: {
                    strongSelf.request(refresh, alert: alert)
                })
            }
        }
    }
    
   
    
}
//MARK:  创建视图
extension MQIBookOriginalInfoChapterListViewController{

    func addtab()   {
        tableView = MQITableView(frame: contentView.bounds)
        tableView.gyDelegate = self
        tableView.backgroundColor = UIColor.white
        contentView.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "MQIBookOriginalInfoChapterListViewControllerCell", bundle: nil), forCellReuseIdentifier: "MQIBookOriginalInfoChapterListViewControllerCellName")
     
    }
    
    func setTabAtt()  {
        
        var frame = tableView.frame
        frame.size.height -= root_bottomTool_height
        tableView.frame = frame
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.request(true, alert: false)
            }
        })
        
    }
    
}
