//
//  MQClassificationViewController.swift
//  Reader
//
//  Created by moqing on 2018/11/6.
//  Copyright © 2018 Moqing. All rights reserved.
//

import UIKit
import MJRefresh

class MQIClassificationViewController: MQIBaseViewController {

    @IBOutlet weak var moneyBacImg: UIImageView!
    
    @IBOutlet weak var bacTitleLabel: UILabel!
    var collectionView:MQICollectionView!
//    var dataModel = MQ_ClassificationModel()
    
    var datas = [MQIClassificationItemModel](){
        didSet(oldValue) {
            if datas.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(moneyBacImg)
        view.sendSubviewToBack(bacTitleLabel)
        
        contentView.backgroundColor = kUIStyle.colorWithHexString("F7F7F7")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        let manger:CGFloat = 0
        collectionView = MQICollectionView(frame: CGRect(x: manger, y: manger, width: contentView.width-manger*2, height: contentView.height-manger*2),collectionViewLayout: layout)
        collectionView.gyDelegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.registerCell(MQIClassificationCollectionViewCell.self, xib: false)
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.colorWithHexString("F4F7FA")
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.request()
            }
        })
        
   
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        addPreloadView()
        request()
    }
    func request() {
        
        MQIBookClassListRequest().requestCollection({[weak self] (request, response, result:[MQIClassificationItemModel]) in
            if let  weakSelf = self  {
                weakSelf.datas = result
                weakSelf.dismissPreloadView()
                weakSelf.dismissWrongView()
                weakSelf.collectionView.mj_header.endRefreshing()
                weakSelf.collectionView.reloadData()
            }
           mqLog("\(result)")
            
        }) { [weak self] (msg, code) in
            if let  weakSelf = self  {
                weakSelf.collectionView.mj_header.endRefreshing()
                weakSelf.dismissPreloadView()
                weakSelf.addWrongView(msg, refresh: {
                    weakSelf.request()
                })
            }
        }
    }
   

}

extension MQIClassificationViewController:MQICollectionViewDelegate {
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
         return datas.count
    }
//    //横向距离   每个cell的
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {

        return kUIStyle.scale1PXW(9)
    }
////    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: kUIStyle.scale1PXW(15), bottom: 0,right: kUIStyle.scale1PXW(15))
    }

    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
    
        return MQIClassificationCollectionViewCell.getSize()
            
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MQIClassificationCollectionViewCell.self, forIndexPath: indexPath)
        cell.itemModel = datas[indexPath.item]

        return cell
        
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let infoVC  = MQIClassificationInfoViewController.create() as! MQIClassificationInfoViewController
        let modle = datas[indexPath.item]
        infoVC.title = modle.name
        infoVC.id = modle.class_type
        infoVC.class_id = modle.target_class_id
        pushVC(infoVC)
       
    }
  
    
    
    
}
