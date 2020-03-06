//
//  MQ_DoneBookViewController.swift
//  XSSC
//
//  Created by moqing on 2018/12/11.
//  Copyright © 2018 XSSC. All rights reserved.
//

import UIKit
import MJRefresh

class MQIDoneBookViewController: MQIBaseViewController {
    
    @IBOutlet weak var bacLabel: UILabel!
    
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
    var m_status:String?
    var m_order:String?
    var m_update:String?
    fileprivate  var offset:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(bacLabel)
        contentView.backgroundColor = UIColor.white
        setxCollectionView()
        addPreloadView()
        request()
    }

}
extension MQIDoneBookViewController:MQICollectionViewDelegate {
    
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
        
        return MQIBookTypeTwoCollectionCellABC.getSize()
        
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let eachModel = datas[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
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

extension   MQIDoneBookViewController {
    func request(_ offset:String = "0") {
        
        MQ_Complete_bookRequest.init(offset: offset, limit: "10", status: m_status, order: m_order,update:m_update).request({[weak self] (request, response, resultNEW:MQIMainEachRecommendDataModel) in
            if let  weakSelf = self  {
                let result = resultNEW.data1
                if offset == "0" {
                    weakSelf.datas.removeAll()
                    if result.count > 0 {
                      weakSelf.datas = result
                    }else{
                    weakSelf.datas = result
                    }
                   
                }else{
                    weakSelf.datas.append(contentsOf: result)
                }
                weakSelf.dismissPreloadView()
                weakSelf.dismissWrongView()
                weakSelf.collectionView.mj_header.endRefreshing()
                weakSelf.collectionView.mj_footer.endRefreshing()
                weakSelf.collectionView.reloadData()
                mqLog("\(result)")
            }
            
            
        }) { [weak self] (msg, code) in
            if let  weakSelf = self  {
                weakSelf.collectionView.mj_header.endRefreshing()
                weakSelf.collectionView.mj_footer.endRefreshing()
                weakSelf.dismissPreloadView()
                weakSelf.addWrongView(msg, refresh: {
                    weakSelf.request(offset)
                })
            }
        }
    }
}

////添加视图
extension   MQIDoneBookViewController {
    
    func setxCollectionView()  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let manger:CGFloat = 0
        collectionView = MQICollectionView(frame: CGRect(x: manger, y: manger, width: contentView.width-manger*2, height: contentView.height-manger*2),collectionViewLayout: layout)
        collectionView.gyDelegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.registerCell(MQIClassificationCollectionViewCell.self, xib: false)
        collectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        contentView.addSubview(collectionView)
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.offset = 0
                weakSelf.request()
            }
        })
        collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            if let weakSelf = self {
                weakSelf.request("\(weakSelf.datas.count)")
            }
            
        })
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
}


