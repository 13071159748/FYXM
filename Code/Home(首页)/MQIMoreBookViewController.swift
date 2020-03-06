//
//  MQIMoreBookViewController.swift
//  CQSC
//
//  Created by moqing on 2019/8/29.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh
class MQIMoreBookViewController: MQIBaseViewController {
    
    var tj_id:String = ""
    var collectionView:MQICollectionView!
    var datas = [MQIMainEachRecommendModel](){
        didSet(oldValue) {
            if datas.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
        }
    }
    var offset = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.white
        setxCollectionView()
        addPreloadView()
        request()
    }
}

extension MQIMoreBookViewController:MQICollectionViewDelegate {
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return datas.count
    }
    //横向距离   每个cell的
    
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.5*gdscale, left: 21*gdscale, bottom: 0, right: 21*gdscale)
    }
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 10
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        
        return MQIBookTypeTwoCollectionCellABC2.getSize()
        
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let eachModel = datas[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC2.self, forIndexPath: indexPath)
        cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named:  book_PlaceholderImg))
        cell.book_nameLabel?.text = eachModel.book_name
        cell.statusText = eachModel.subclass_name
        cell.classText = eachModel.book_words
        cell.bookcontentText = eachModel.book_intro
        return cell
        
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        
        MQIUserOperateManager.shared.toBookInfo(datas[indexPath.row].book_id)
    }
    
}

extension   MQIMoreBookViewController {
    
    func request(_ offset:String = "0") {
        
        MQIbook_get_moreRequest(tj_id: self.tj_id).request({[weak self] (request, response,resultNEW:MQIMainRecommendModel) in
            if let  weakSelf = self  {
                weakSelf.title = resultNEW.name
                let result = resultNEW.books
                if offset == "0" {
                    weakSelf.datas = result
                }else{
                    weakSelf.datas.append(contentsOf: result)
                }
                weakSelf.dismissPreloadView()
                weakSelf.dismissWrongView()
                weakSelf.collectionView.mj_header?.endRefreshing()
                weakSelf.collectionView.mj_footer?.endRefreshing()
                weakSelf.collectionView.reloadData()
                mqLog("\(result)")
            }
            
            
        }) { [weak self] (msg, code) in
            if let  weakSelf = self  {
                weakSelf.collectionView.mj_header?.endRefreshing()
                weakSelf.collectionView.mj_footer?.endRefreshing()
                weakSelf.dismissPreloadView()
                weakSelf.addWrongView(msg, refresh: {
                    weakSelf.request(offset)
                })
            }
        }
    }
}

////添加视图
extension   MQIMoreBookViewController {
    
    func setxCollectionView()  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let manger:CGFloat = 0
        collectionView = MQICollectionView(frame: CGRect(x: manger, y: manger, width: contentView.width-manger*2, height: contentView.height-manger*2),collectionViewLayout: layout)
        collectionView.gyDelegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.registerCell(MQIBookTypeTwoCollectionCellABC2.self, xib: false)
        contentView.addSubview(collectionView)
        
//        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
//            if let weakSelf = self {
//                weakSelf.offset = 0
//                weakSelf.request()
//            }
//        })
//        collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
//            if let weakSelf = self {
//                weakSelf.request("\(weakSelf.datas.count)")
//            }
//
//        })
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
}


