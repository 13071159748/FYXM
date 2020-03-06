//
//  MQIRankDetailViewController.swift
//  CQSC
//
//  Created by moqing on 2019/3/6.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

import MJRefresh
class MQIRankDetailViewController: MQIBaseViewController {

    @IBOutlet weak var nameBacView: UIView!
    var rank_id:String = "" {
        didSet {
            xCollectionView.mj_header?.beginRefreshing()
        }
    }
    var rankSelectedBlock: ((_ rankid:String,_ bookid:String) -> ())?
    
    var xCollectionView:MQICollectionView!
    
    var rank_array = [MQIMainEachRecommendModel]()
    
    var isRefresh: Bool = false
    
    var limit: Int = 20
    
    var isFooterRefresh = false
    override func viewWillLayoutSubviews() {
        xCollectionView.frame = self.view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNav()
        nameBacView.backgroundColor = UIColor.white
        view.sendSubviewToBack(nameBacView)
        addXCollectionView()
        xCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.net_rankListRequest(offset: "0", limit: "\(strongSelf.rank_array.count)")
            }
        })
        
    }
    
    
    func  addXCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        xCollectionView = MQICollectionView(frame: view.bounds,collectionViewLayout: layout)
        xCollectionView.gyDelegate = self
        xCollectionView.alwaysBounceVertical = true
        xCollectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        view.addSubview(xCollectionView)
        xCollectionView.backgroundColor = UIColor.white
    }
    func loadfailedFunc(_ ish:Bool) {
        xCollectionView.isHidden = ish
        addWrongView(kLocalized("NewError"),refresh:{[weak self]()-> Void in
            if let weakSelf = self {
                weakSelf.xCollectionView.isHidden = false
                weakSelf.net_rankListRequest(offset: "0", limit: "\(weakSelf.limit)")
                weakSelf.wrongView?.setLoading()
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//网络请求
extension MQIRankDetailViewController {
    func net_rankListRequest(offset: String, limit: String) {
        
        var limitNew = limit.integerValue()
        limitNew =  limitNew-5
        limitNew = limitNew+5

        GDRankListRequest(type: rank_id, offset: offset, limit: "\(limitNew)").requestCollection({ [weak self](request, response, result:[MQIMainEachRecommendModel]) in
            
            if let strongSelf = self {
                strongSelf.dismissWrongView()
                strongSelf.xCollectionView.mj_header.endRefreshing()
                if strongSelf.isFooterRefresh == true {
                    strongSelf.isFooterRefresh = false
                    for each in result {
                        strongSelf.rank_array.append(each)
                    }
                }else {
                    strongSelf.rank_array = result
                }
                strongSelf.xCollectionView.reloadData()

            }
            
        }) {[weak self] (err_msg, err_code) in
            if let strongSelf = self {
                strongSelf.xCollectionView.mj_header.endRefreshing()
                strongSelf.xCollectionView.mj_footer.endRefreshing()
                strongSelf.loadfailedFunc(true)
            }
            
        }
        
    }
    
}
//MARK:collection代理
extension MQIRankDetailViewController : MQICollectionViewDelegate {
    
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return rank_array.count
    }
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 10
    }
    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.5*gdscale, left: 21*gdscale, bottom: 0, right: 21*gdscale)
        
    }
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        return MQIBookTypeTwoCollectionCellABC.getSize()
    }
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let eachModel = rank_array[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
        cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
        cell.book_nameLabel?.text = eachModel.book_name
        cell.statusText = (eachModel.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
        cell.classText = eachModel.book_words
        cell.bookcontentText = eachModel.book_intro
        cell.book_authorText = eachModel.subclass_name
        
        //        if indexPath.row <= 9 {
        //            cell.sortingText = "\(indexPath.row+1)"
        //        }else{
        //            cell.sortingText = ""
        //        }
        return cell
    }
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let eachModel = rank_array[indexPath.row]
        MQIUserOperateManager.shared.toBookInfo(eachModel.book_id)
        MQIEventManager.shared.appendEventData(eventType: .ranking_book, additional: ["book_id":eachModel.book_id,"ranking_type": rank_id])
    }
    
}
