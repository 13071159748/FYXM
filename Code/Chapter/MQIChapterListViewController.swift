//
//  MQIChapterListViewController.swift
//  Reader
//
//  Created by _CHK_  on 16/8/2.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

import UIKit

let listVC_width: CGFloat = screenWidth*4/5
class MQIChapterListViewController: MQIRootTableVC,ICSDrawerControllerChild,ICSDrawerControllerPresenting {
    
    weak var readVC: MQIReadViewController!
    
    var book: MQIEachBook! {
        didSet {
            if header != nil {
                header.text = book.book_name
            }
        }
    }
    var chapterList = [MQIEachChapter]() {
        didSet {
            
            if currentChapterIndex < chapterList.count {
                currentChapterId = chapterList[currentChapterIndex].chapter_id
            }else if gtableView != nil {
                gtableView.reloadData()
            }
        }
    }
    weak var drawer: ICSDrawerController?
    
    var titleColor: UIColor = RGBColor(151, g: 151, b: 151)
    var titleSelColor: UIColor = mainColor
    var isReader: Bool = true
    
    var headerView: UIView!
    var header: UILabel!
    var downloadBtn: UIButton!
    
    var topLine: GYLine!
    var downloadLine: GYLine!
    
    var chapterSel: ((_ index: Int, _ chapter: MQIEachChapter) -> ())?
    var downloadBlock: (() -> ())?
    
    var normalSort: Bool = true
    var currentChapterId: String = "" {
        didSet {
            if gtableView != nil {
                gtableView.reloadData()
            }
        }
    }
    var currentChapterIndex: Int = 0 //仅仅用于用户第一次开阅读器的时候
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DownNotifier.addObserver(self, selector: #selector(MQIChapterListViewController.refresh(_ :)), notification: .download_finish)
        //        self.drawer?.fd_interactivePopDisabled = false
        
        if isReader == true {
            removeNav()
            contentView.frame.size.width = listVC_width
            gtableView.frame = contentView.bounds
        }
        
        gtableView.registerCell(MQIChapterListViewConerollerCell.self, xib: false)
        contentView.frame = CGRect(x: 0, y: root_status_height, width: contentView.bounds.width, height: screenHeight - status.height)
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 50))
        gtableView.frame = contentView.bounds
        headerView.backgroundColor = RGBColor(206, g: 193, b: 173)
        contentView.addSubview(headerView)
        status.backgroundColor = headerView.backgroundColor
        self.view.backgroundColor = contentView.backgroundColor
        //        status.layer.removeFromSuperlayer()
        if let layers = status.layer.sublayers {
            for subLayer in layers {
                subLayer.removeFromSuperlayer()
            }
        }
        
        topLine = GYLine(frame: CGRect(x: 0, y: headerView.bounds.height-0.5, width: headerView.bounds.width, height: 0.5))
        headerView.addSubview(topLine)
        
        let btnSide: CGFloat = 40
        header = createLabel(CGRect(x: 0, y: 0, width: contentView.bounds.width-btnSide-5, height: 50),
                             font: UIFont.boldSystemFont(ofSize: 17),
                             bacColor: UIColor.clear,
                             textColor: RGBColor(47, g: 47, b: 47),
                             adjustsFontSizeToFitWidth: nil,
                             textAlignment: .center,
                             numberOfLines: nil)
        header.text = book.book_name
        headerView.addSubview(header)
        
        let sequenceBtn = createButton(CGRect(x: contentView.bounds.width-5-btnSide,
                                              y: (header.bounds.height-btnSide)/2,
                                              width: btnSide,
                                              height: btnSide),
                                       normalTitle: nil,
                                       normalImage: UIImage(named: "chapter_sequence"),
                                       selectedTitle: nil,
                                       selectedImage: UIImage(named: "chapter_sequence_sel"),
                                       normalTilteColor: nil,
                                       selectedTitleColor: nil,
                                       bacColor: nil,
                                       font: nil,
                                       target: self,
                                       action: #selector(MQIChapterListViewController.sequenceAction(_:)))
        
        headerView.addSubview(sequenceBtn)
        
        
        gtableView.frame.origin.y += 50
        gtableView.frame.size.height -= (50+x_TabbatSafeBottomMargin)
        gtableView.maxX -= 14
        gtableView.showsHorizontalScrollIndicator = false
        gtableView.showsVerticalScrollIndicator = false
        gtableView.scrollsToTop = false
        addBottomTool()
        changeBgType()
        addSlidingView()
    }
   
    
    var slidingView:UIButton!
    var isClickSlidingView:Bool = false
    var changeOffsetY:CGFloat = 0
    func addSlidingView() {
        let  slidingBacView = UIView(frame: CGRect(x: gtableView.maxX, y: gtableView.y, width: 14, height: gtableView.height))
        contentView.addSubview(slidingBacView)
        contentView.bringSubviewToFront(slidingBacView)
        slidingBacView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.1)
        slidingView = UIButton(frame: CGRect(x:  0, y:0, width: 14, height: 42))
        slidingView.setImage(UIImage(named: "Chapter_sliding_img_no"), for: .normal)
        slidingView.setImage(UIImage(named: "Chapter_sliding_img_sel"), for: .highlighted)
          slidingView.setImage(UIImage(named: "Chapter_sliding_img_sel"), for: .selected)
        slidingBacView.addSubview(slidingView)
        slidingView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(changePostion(sender:))))
      
        

    }
    
    /// 滑动操作
    @objc func changePostion(sender:UIPanGestureRecognizer) -> Void {

        func changeY() {
            let offset = sender.translation(in: self.slidingView)
            sender.setTranslation(CGPoint.zero, in: self.slidingView)
            self.slidingView.y +=  offset.y
            if self.slidingView.y <= 0{
                self.slidingView.y = 0
                if gtableView.contentOffset.y <= 0 { return}
                gtableView.setContentOffset(CGPoint(x: 0, y:0), animated: false)
                return
            }
            if self.slidingView.maxY >= gtableView.height{
                self.slidingView.maxY = gtableView.height
                if gtableView.contentOffset.y >= gtableView.contentSize.height-gtableView.height {return}
                gtableView.setContentOffset(CGPoint(x: 0, y: gtableView.contentSize.height-gtableView.height), animated: false)
                return
            }
            
            let than =   (gtableView.contentSize.height-gtableView.height)/gtableView.height
            gtableView.setContentOffset(CGPoint(x: 0, y: self.slidingView.maxY*than), animated: false)
            
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


    }
    func gScrollViewWillBeginDragging(_ tableView: MQITableView) {
        slidingView.isSelected = false
        isClickSlidingView = false
//        changeOffsetY = tableView.contentOffset.y
    }
    
    func gScrollViewDidEndDragging(_ tableView: MQITableView, willDecelerate decelerate: Bool) {
        changeOffsetY = tableView.contentOffset.y
    }

    override func addBottomTool() {
        let bottomHeight: CGFloat = 44
        bottomTool = UIView(frame: CGRect(x: 0,
                                          y: contentView.bounds.height-bottomHeight-x_TabbatSafeBottomMargin,
                                          width: contentView.bounds.width,
                                          height: bottomHeight))
        bottomTool.isUserInteractionEnabled = true
        bottomTool.addLine(0, lineColor: nil, directions: .top)
        contentView.addSubview(bottomTool)
        downloadBtn = createButton(bottomTool.bounds,
                                   normalTitle: kLocalized("DownLoadChapter"),
                                   normalImage: UIImage(named: "readerTool_download"),
                                   selectedTitle: nil,
                                   selectedImage: nil,
                                   normalTilteColor: titleColor,
                                   selectedTitleColor: titleSelColor,
                                   bacColor: UIColor.clear,
                                   font: UIFont.systemFont(ofSize: 14),
                                   target: self,
                                   action: #selector(MQIChapterListViewController.downloadAction))
        bottomTool.addSubview(downloadBtn)
        
        downloadLine = GYLine(frame: CGRect(x: 0, y: 0, width: bottomTool.bounds.width, height: 0.5))
        bottomTool.addSubview(downloadLine)
        
        //        gtableView.frame.size.height -= bottomHeight
        //MARK:  去掉下载
        bottomTool.isHidden = true
    }
    
    @objc func refresh(_ noti: Notification) {
        if let list = noti.userInfo?["list"] as? [MQIEachChapter],
            let b = noti.userInfo?["book"] as? MQIEachBook {
            book = b
            chapterList = list
            gtableView.reloadData()
        }
    }
    
    //刷新列表章节状态
    fileprivate let lock = NSLock()
    func reloadChapter(_ index: Int, chapter_id: String) {
        lock.lock()
        let vIndex = normalSort == true ? index : chapterList.count-index-1
        
        if vIndex > chapterList.count || vIndex <= -1 {
            lock.unlock()
            return
        }
        chapterList[vIndex].isDown = true
        book.addTidToDownTids(chapterList[vIndex].chapter_id)
        
        if gtableView != nil {
            gtableView.reloadRows(at: [IndexPath(row: vIndex, section: 0)], with: .none)
        }
        lock.unlock()
    }
    
    func changeBgType() {
        if gtableView == nil {
            return
        }
        
        //TODO:  添加新背景
        let index = GYReadStyle.shared.styleModel.bookThemeIndex
        if index == 0 || index == 2{
            contentView.backgroundColor = RGBColor(223, g: 214, b: 197)
            titleColor = RGBColor(103, g: 103, b: 103)
            titleSelColor =  RGBColor(185, g: 106, b: 65)
            gtableView.separatorColor = RGBColor(213, g: 204, b: 185)
            header.textColor = titleColor
            headerView.backgroundColor =  RGBColor(208, g: 195, b: 173)
        }else if  index == 1 {
            contentView.backgroundColor = RGBColor(229, g: 191, b: 122)
            titleColor = RGBColor(103, g: 103, b: 103)
            titleSelColor =  RGBColor(185, g: 106, b: 65)
            gtableView.separatorColor = RGBColor(213, g: 204, b: 185)
            header.textColor = titleColor
            headerView.backgroundColor =   contentView.backgroundColor
        }
        else if index == 5 || index == 3 || index == 4 {
            contentView.backgroundColor = RGBColor(236, g: 236, b: 236)
            titleColor = RGBColor(71, g: 71, b: 71)
            titleSelColor = mainColor
            gtableView.separatorColor = RGBColor(221, g: 221, b: 221)
            header.textColor = titleColor
            headerView.backgroundColor = contentView.backgroundColor
        }else {
            contentView.backgroundColor = RGBColor(31, g: 31, b: 31)
            titleColor = RGBColor(131, g: 131, b: 131)
            titleSelColor = RGBColor(210, g: 63, b: 61)
            gtableView.separatorColor = RGBColor(21, g: 21, b: 21)
            header.textColor = titleColor
            headerView.backgroundColor = contentView.backgroundColor
        }
        
        status.backgroundColor = headerView.backgroundColor
        downloadBtn.backgroundColor = contentView.backgroundColor
        gtableView.backgroundColor = contentView.backgroundColor
        

        let image = imageWithColor(UIImage(named: "readerTool_download")!, color: titleColor)
        downloadBtn.setImage(image, for: .normal)
        downloadBtn.setTitleColor(titleColor, for: .normal)
        downloadBtn.setTitleColor(titleSelColor, for: .selected)
        
        topLine.backgroundColor = titleColor
        downloadLine.backgroundColor = titleColor
        
        gtableView.reloadData()
        
        //        (weakSelf.currentReadViewController?.readRecordModel?.readChapterModel?.chapter_id)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let row = (readVC.currentReadViewController?.readRecordModel?.chapterIndex){
            if chapterList.count > Int(truncating: row) && Int(truncating: row) > -1 {
                let indexPathrow = IndexPath(row:NSInteger(truncating: row), section: 0)
                gtableView.scrollToRow(at: indexPathrow, at: .middle, animated: false)
            }else if chapterList.count == Int(truncating: row){
                let indexPathrow = IndexPath(row:NSInteger(Int(truncating: row)-1), section: 0)
                gtableView.scrollToRow(at: indexPathrow, at: .middle, animated: false)
            }
        }
    }
    @objc func downloadAction() {
        readVC?.toDownload()
    }
    
    @objc func sequenceAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        chapterList = chapterList.reversed()
        normalSort = !normalSort
        gtableView.reloadData()
    }
    
    
    
    
    //MARK: --
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return chapterList.count
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQIChapterListViewConerollerCell.getHeight(nil)
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = gtableView.dequeueReusableCell(MQIChapterListViewConerollerCell.self, forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.titleNormalColor = titleColor
        cell.titleSelColor = titleSelColor
        let chapter = chapterList[indexPath.row]
        cell.chapter = chapter
        cell.backgroundColor = contentView.backgroundColor
        cell.currentIndex = chapter.chapter_id == currentChapterId ? true : false
        return cell
    }
    
    override func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        let index = normalSort == true ? indexPath.row : chapterList.count-indexPath.row-1
        chapterSel?(index, chapterList[index])
        readVC.drawer?.close()
        readVC.readMenu.menuSH()
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    deinit {
        DownNotifier.removeObserver(self, notification: .download_finish)
    }
    
    //MARK: --
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
