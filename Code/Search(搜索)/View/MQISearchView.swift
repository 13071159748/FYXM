//
//  MQISearchView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQISearchView: UIView, MQICollectionViewDelegate {

    var gcollectionView: MQICollectionView!
    
    var historys = [String]()
    var hots = [MQIEaMQIeyword]()
    var recommends = [MQIEachBook]()
    
    var dataModel:MQRecommendInfoModel?
    
    var toSearch: ((_ key: String) -> ())?
    var toVC: ((_ vc: MQIBaseViewController) -> ())?
    
    lazy var headerImgs: [(String, String)] = {
        return [("search_history_text", "search_history_line"),
                ("search_hot_text", "search_hot_line"),
                ("search_look_text", "search_look_line")]
    }()
    lazy var headerTitle: [String] = {
        return [
            kLocalized("search_hot"),kLocalized("search_history"),kLocalized("HotbooksfromOthers")
        ]
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        historys = MQISearchResultsManager.shared.results
        
        let layout = DSYCollectionViewLeftAlignedLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        gcollectionView = MQICollectionView(frame: self.bounds, collectionViewLayout: layout)
        gcollectionView.backgroundColor = UIColor.white
        gcollectionView.gyDelegate = self
        gcollectionView.alwaysBounceVertical = true
        gcollectionView.keyboardDismissMode = .onDrag
        
        gcollectionView.registerCell(MQICollectionViewCell.self, xib: false)
        gcollectionView.registerCell(GYSearchHeaderCell.self, xib: true)
        gcollectionView.registerCell(GYSearchHotCell.self, xib: false)
        gcollectionView.registerCell(GYSearchBookCell.self, xib: true)
        gcollectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        gcollectionView.registerHeaderFooter(GYSearchHeader.self, kind: UICollectionView.elementKindSectionHeader, xib: true)
        gcollectionView.registerHeaderFooter(MQICollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader, xib: false)
        
        addSubview(gcollectionView)
        
        requestHot()
        requestLikes()
    }
    
    func reloadHistorys() {
        historys = MQISearchResultsManager.shared.results
//        gcollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
      reloadView()
    }
    
    func reloadView() {
         UIView.performWithoutAnimation {
            gcollectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gcollectionView.frame = self.bounds
    }
    
    //MARK: --
    func requestHot() {
        GYSearchHotRequest()
            .requestCollection({ (request, response, result: [MQIEaMQIeyword]) in
                self.hots = result
                  self.reloadView()
            }) { (msg, code) in
                
        }
    }
    
    func requestLikes() {
       GYBookInfoRecommendsRequest(tj_type: TYPE_SEARCH)
            .request({ (request, response, result: MQRecommendInfoModel) in
                self.dataModel = result
                self.recommends = result.data
//                self.gcollectionView.reloadSections(NSIndexSet(index: 2) as IndexSet)
                  self.reloadView()
            }) { (err_msg, err_code) in
                
        }
    }
    
    //MARK: --
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 3
    }
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        switch section {
        case 0:
            return hots.count
        case 1:
            return historys.count
        case 2:
            return recommends.count
        default:
            return 0
        }
    }
    
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableHeaderFooter(GYSearchHeader.self, kind: UICollectionView.elementKindSectionHeader, indexPath: indexPath)
            //                header.leftImage.image = UIImage(named: headerImgs[indexPath.section].1)
            //                header.rightImage.image = UIImage(named: headerImgs[indexPath.section].0)
            header.titleLable.text = headerTitle[indexPath.section]
            if indexPath.section == 1 {
                header.cleanBlock = { [weak self] in
                    if let weakSelf = self {
                        if weakSelf.historys.count > 0 {
                            MQISearchResultsManager.shared.removeAll()
                            weakSelf.reloadHistorys()
                        }
                    }
                    
                }
                header.cleanBtn.isHidden = (historys.count > 0) ? false:true
            }else{
                header.cleanBtn.isHidden = true
            }
            return header
        }else {
            return MQICollectionReusableView()
        }
    }
    
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        if (section == 0 ){
            if hots.count > 0{
                return GYSearchHeader.getSize()
            }
        } else  if (section == 1){
            return GYSearchHeader.getSize()
        }
        else  if (section == 2){
            if recommends.count > 0 {
              return GYSearchHeader.getSize()
            }
           
        }
      return CGSize.zero
    }
    
    func minimumLineSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            return 0
        }
    }
    
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        if section == 0 || section == 1{
            return 8
        }else {
            return 10
        }
    }
    
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        if section == 0 || section == 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }else {
            return UIEdgeInsets.zero
        }
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return GYSearchHotCell.getSize(key: hots[indexPath.row], index: indexPath.row)
        case 1:
            return GYSearchHotCell.getSize2(key: historys[indexPath.row])
        case 2:
            return MQIBookTypeTwoCollectionCellABC.getSize()
//            return GYSearchBookCell.getSize()
        default:
            return CGSize.zero
        }
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(GYSearchHotCell.self, forIndexPath: indexPath)
            cell.titleLabel?.text = hots[indexPath.row].key
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.addHot()
            }else {
                cell.removeHot()
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(GYSearchHotCell.self, forIndexPath: indexPath)
            cell.titleLabel?.text = historys[indexPath.row]
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.addHot()
            }else {
                cell.removeHot()
            }
            return cell
        case 2:
//            let cell = collectionView.dequeueReusableCell(GYSearchBookCell.self, forIndexPath: indexPath)
//            cell.book = recommends[indexPath.row]
//             return cell
            let eachModel = recommends[indexPath.row]
            let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
            cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            cell.book_nameLabel?.text = eachModel.book_name
            //            cell.statusText = eachModel.subclass_name
            cell.statusText = (eachModel.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
            cell.classText = eachModel.book_words
            cell.bookcontentText = eachModel.book_intro
            cell.book_authorText = eachModel.subclass_name
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row > historys.count-1 {
                if historys.count > 0 {
                    MQISearchResultsManager.shared.removeAll()
                    reloadHistorys()
                }
            }else {
                let keyword = historys[indexPath.row]
                toSearch?(keyword)
            }
        case 0:
            let keyword = hots[indexPath.row].key
            toSearch?(keyword)
        case 2:
            let book = recommends[indexPath.row]
            MQIUserOperateManager.shared.toBookInfo(book.book_id)
            MQIEventManager.shared.appendEventData(eventType: .search_recommend_book, additional: ["book_id":book.book_id,"position":  self.dataModel?.name ?? ""])
        default:
            mqLog("default")
        }
    }

    func openleftAlignFrame(section: Int) -> Bool {
        if section == 1 || section == 0 {
            return true
        }else{
            return false
        }
        
        
    }
    
}



