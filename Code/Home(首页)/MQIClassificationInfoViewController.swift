//
//  MQ_ClassificationInfoViewController.swift
//  XSSC
//
//  Created by moqing on 2018/11/9.
//  Copyright © 2018 XSSC. All rights reserved.
//

import UIKit
import MJRefresh

class MQIClassificationInfoViewController: MQIBaseViewController {
    
    
    @IBOutlet weak var bacTitleLable: UILabel!
    var id:String = ""
    var class_id:String = ""
    var gdCollectionView:MQICollectionView!
    var books = [MQIClassificationItemModel]()
    
    fileprivate let limit = "10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(bacTitleLable)
        contentView.backgroundColor = UIColor.white
        addgdCollectionView()
        setCollectionView()
        let  lineView = UIView(frame: CGRect(x: 0, y: gdCollectionView.y, width: contentView.width, height: 1))
        lineView.backgroundColor = kUIStyle.colorWithHexString("F9F9F9")
        contentView.addSubview(lineView)
        
        addPreloadView()
        xrequestFunc(offset: "0", limit: limit)
    }
    
 
 
    
}

//MARK:  网络请求
extension MQIClassificationInfoViewController {
    
    func xrequestFunc(offset: String, limit: String) {
        
        MQIBookClassListInfoRequest.init(id:id,class_id:class_id, offset: offset, limit: limit)
            .request({[weak self] (request, response, result:MQ_ClassificationModel) in
                
                if let  weakSelf = self  {
                    weakSelf.dismissPreloadView()
                    weakSelf.dismissWrongView()
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                    if result.data.count > 0{
                        if offset == "0" {
                            weakSelf.books.removeAll()
                            if result.data.count > 0 {
                                weakSelf.books = result.data
                            }else{
                                weakSelf.books = result.data
                            }
                        }else{
                            weakSelf.books.append(contentsOf: result.data)
                        }
                        weakSelf.gdCollectionView.reloadData()
                    }else{
                        weakSelf.gdCollectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    
                }
            }) { [weak self] (msg, code) in
                if let  weakSelf = self  {
                    weakSelf.gdCollectionView.mj_header.endRefreshing()
                    weakSelf.gdCollectionView.mj_footer.endRefreshing()
                    weakSelf.dismissPreloadView()
                    weakSelf.addWrongView(msg, refresh: {
                        weakSelf.xrequestFunc(offset: offset, limit: limit)
                    })
                }
        }
    }
}
extension  MQIClassificationInfoViewController  {
    func addgdCollectionView()   {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: contentView.bounds,collectionViewLayout: layout)
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        contentView.addSubview(gdCollectionView)
        gdCollectionView.backgroundColor = UIColor.white
        gdCollectionView.registerCell(MQIClassificationInfoCollectionViewCell.self, xib: false)
        
    }
    func setCollectionView()  {
        
        if #available(iOS 11.0, *) {
            gdCollectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        gdCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.xrequestFunc(offset: "0", limit: weakSelf.limit)
            }
        })
        
        gdCollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.xrequestFunc(offset: "\(weakSelf.books.count)", limit: weakSelf.limit)
            }
        })
    }
}
extension MQIClassificationInfoViewController:MQICollectionViewDelegate {
    
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return books.count
    }
    
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 10
    }
//    
//    func minimumLineSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
//        
//        return  50
//    }
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 0, bottom: 0,right: 0)
    }

    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        return MQIClassificationInfoCollectionViewCell.getSize()
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MQIClassificationInfoCollectionViewCell.self, forIndexPath: indexPath)
        let  eachModel = books[indexPath.item]
        cell.coverImageView?.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
        cell.book_nameLabel?.text = eachModel.book_name
        cell.statusText = eachModel.book_status
        cell.classText = eachModel.book_words
        cell.bookcontentText = eachModel.book_intro
   
        return cell
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
//        MQIUserOperateManager.shared.toReader(books[indexPath.item].book_id )
        let book_id = books[indexPath.item].book_id
        MQIUserOperateManager.shared.toBookInfo(book_id)
        MQIEventManager.shared.appendEventData(eventType: .genre_book, additional: ["book_id":book_id,"class_id": class_id])
    }
    
}
