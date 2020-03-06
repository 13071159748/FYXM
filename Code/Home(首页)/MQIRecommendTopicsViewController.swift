//
//  MQIRecommendTopicsViewController.swift
//  CQSC
//
//  Created by BigMac on 2019/12/19.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh

class MQIRecommendTopicsViewController: MQIBaseViewController {
    
    var collectionView:MQICollectionView!
    var mainRecommendArray = [MQIMainRecommendModel]() {
        didSet(oldValue) {
            if mainRecommendArray.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
        }
    }
    //    var titleString: String? {
    //        didSet {
    //            if let titleString = titleString {
    //                self.title = titleString
    //            }
    //        }
    //    }
    
    var id: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kLocalized("recommendText")
        contentView.backgroundColor = UIColor.white
        setxCollectionView()
        addPreloadView()
        requestData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - 请求
extension MQIRecommendTopicsViewController {
    func requestData() {
        RecommendsItemRequest("\(id)").request({[weak self] (request, response, result: MQIRecommendSecondItemModel) in
            guard let weakSelf = self else { return }
            weakSelf.dismissPreloadView()
            weakSelf.mainRecommendArray.removeAll()
            weakSelf.mainRecommendArray.append(contentsOf: result.data)
            weakSelf.collectionView.reloadData()
            weakSelf.collectionView.mj_header?.endRefreshing()
            
        }) {[weak self] (err_msg, err_code) in
            guard let weakSelf = self else { return }
            weakSelf.dismissPreloadView()
            weakSelf.collectionView.mj_header?.endRefreshing()
        }
    }
}

//MARK: - aciton
extension MQIRecommendTopicsViewController {
    
    /// 书籍详情
    fileprivate func pushBookInfo(_ bookId: String) {
        
        MQIUserOperateManager.shared.toBookInfo(bookId)
        MQIEventManager.shared.appendEventData(eventType: .home_recommend_book, additional: ["book_id":bookId])
    }
    
    fileprivate func openLink(url: String) {
        MQIOpenlikeManger.openLike(url)
    }
    
}


//MARK: - addSubViews
extension MQIRecommendTopicsViewController {
    func setxCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let manger:CGFloat = 0
        collectionView = MQICollectionView(frame: CGRect(x: manger, y: manger, width: contentView.width-manger*2, height: contentView.height-manger*2),collectionViewLayout: layout)
        collectionView.gyDelegate = self
        collectionView.alwaysBounceVertical = true
        contentView.addSubview(collectionView)
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.requestData()
            }
        })
        //        collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
        //            if let weakSelf = self {
        //                weakSelf.request("\(weakSelf.mainRecommendArray.count)")
        //            }
        //
        //        })
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.registerCell(MQIBookTypeOneCollectionCellABC.self, xib: false)
        collectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        collectionView.registerCell(MQIBookTypeThreeCollectionCellABC.self, xib: false)
        collectionView.registerCell(MQIBookTypeOneImgDescriptionCollectionCellABC.self, xib: false)
        collectionView.registerCell(MQIBookTypeBannerCollectionCellABC.self, xib: false)
        collectionView.registerCell(MQIRecommendTopicsCollectionViewCell.self, xib: false)
        collectionView.registerCell(MQIRecommendTopicsTwoCollectionViewCell.self, xib: false)
        
        collectionView.register(MQIBookStoreFooterCollectionReusableViewABC.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MQIBookStore_FooterCellID)
        collectionView.register(MQIBookStoreHeaderCollectionReusableViewABC.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MQIBookStore_HeaderCellID)
        
    }
}


//MARK: - delegate
extension MQIRecommendTopicsViewController: MQICollectionViewDelegate {
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
                header.rightBtn?.isHidden = false
                header.rightBtn?.setTitle("更多免费", for: .normal)
            }else if   commendModel.type == "dsy" {
                header.newLabel.isHidden = true
                header.newTitleLabel?.isHidden = true
                header.dsc_title?.isHidden = true
                header.rightBtn?.isHidden = false
                header.rightBtn?.setTitle("", for: .normal)
            }
            else{
                header.newLabel.isHidden = true
                header.newTitleLabel?.isHidden = true
                header.dsc_title?.isHidden = false
//                header.rightBtn?.setTitle("查看更多", for: .normal)
                header.rightBtn?.isHidden = true
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
        let eachModel:MQIMainEachRecommendModel = commendModel.books[indexPath.row]
        if commendModel.type == "127" || commendModel.type == "128" {return}
        pushBookInfo(eachModel.book_id)
    }
    
}
