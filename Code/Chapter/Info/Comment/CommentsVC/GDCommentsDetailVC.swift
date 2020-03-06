//
//  GDCommentsDetailVC.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/4.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */
import MJRefresh

//全部  书评  章节说    全部评论
let gdCommentsHeaderID = "gdCommentsHeaderID"
class GDCommentsDetailVC: MQIBaseViewController {

    var book_id:String = ""
    
    var comments_type:Comment_Type = .comment_all {
        didSet {
//            MQLog("🍎--\(comments_type)")
            net_commentsRequest(offset: "0", limit: "\(limit)", comment_type: comments_type.rawValue, book_id: book_id)
        }
    }
    
    var gdcollectionView:MQICollectionView!
    
    var comment_array = [GYEachComment]()
    
    var limit:Int = 20
    
    var isFooterRefresh = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        status.isHidden = true
        nav.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        gdcollectionView = MQICollectionView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: screenHeight - x_statusBarAndNavBarHeight - 45 - 78 - 43 - 7 - x_TabbatSafeBottomMargin), collectionViewLayout: layout)
        gdcollectionView.gyDelegate = self
        gdcollectionView.alwaysBounceVertical = true
        gdcollectionView.registerCell(GDCommentsReplyCollectionCell.self, xib: false)
        gdcollectionView.register(GDCommentsHeaderCollectionCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: gdCommentsHeaderID)
        view.addSubview(gdcollectionView)
        gdcollectionView.backgroundColor = UIColor.white

        let ref_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GDCommentsDetailVC.mj_refreshAction))
        gdcollectionView.mj_header = ref_header

        
        gdcollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.isFooterRefresh = true
                var startID = "0"
                if let last = weakSelf.comment_array.last {
                    startID = last.comment_id
                }
                weakSelf.net_commentsRequest(offset: "\(startID)", limit: "\(weakSelf.limit)", comment_type: weakSelf.comments_type.rawValue, book_id: weakSelf.book_id)
            }
        })
        
    }
    @objc func mj_refreshAction() {
        net_commentsRequest(offset: "0", limit: "\(comment_array.count)", comment_type: comments_type.rawValue, book_id: book_id)
    }
    func loadfailed() {
        gdcollectionView.isHidden = true
        addWrongView(kLocalized("NewError"),refresh:{[weak self]()-> Void in
            if let weakSelf = self {
                weakSelf.gdcollectionView.isHidden = false
                //                    weakSelf.net_rankListRequest(offset: "0", limit: "\(weakSelf.limit)")
                weakSelf.wrongView?.setLoading()
            }
        })
    }

    func net_commentsRequest(offset:String,limit:String,comment_type:String = "0",book_id:String) {
        GYBookInfoCommentsRequest(start_id: offset, limit: limit, book_id: book_id, comment_type: comment_type).requestCollection({ [weak self](request, response, result:[GYEachComment]) in
            if let strongSelf = self {
                strongSelf.dismissWrongView()
                strongSelf.gdcollectionView.mj_header.endRefreshing()
                strongSelf.gdcollectionView.mj_footer.endRefreshing()
//                let dic = try? JSONSerialization.jsonObject(with: (response?.data!)!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                MQLog(dic)
//                for i in 0..<result.count {
//                
//                    let comment = result[i]
//                    
//                        MQLog(comment.chapter.chapter_title)
//                    
//                }
                                
                
                if strongSelf.isFooterRefresh == true {
                    strongSelf.isFooterRefresh = false
                    for each in result {
                        strongSelf.comment_array.append(each)
                    }
                }else {
                    strongSelf.comment_array = result
                }
                strongSelf.gdcollectionView.reloadData()
                if result.count < strongSelf.limit {
                    strongSelf.gdcollectionView.mj_footer.isHidden = true
                    strongSelf.gdcollectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            }
            
            
        }) { [weak self](err_msg, err_code) in
            if let strongSelf = self {
                strongSelf.gdcollectionView.mj_header.endRefreshing()
                strongSelf.gdcollectionView.mj_footer.endRefreshing()
                strongSelf.loadfailed()
            }
        }
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension GDCommentsDetailVC :MQICollectionViewDelegate {
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return comment_array.count
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        let comment = comment_array[section]
        return comment.reply.count
    }
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        let comment = comment_array[section]

//        let height = GYBookOriginalCommentCellHeader.getHeight(comment: comment)
        let height = GDCommetsHeaderView.getHeight(comment: comment)
        
        return CGSize(width: screenWidth, height: height)
    }
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: gdCommentsHeaderID, for: indexPath) as! GDCommentsHeaderCollectionCell
            header.header.toVote = {[weak self]comment -> Void in
                if let strongSelf = self {
                    strongSelf.toCommentVote(comment: comment, completion: {
                        strongSelf.gdcollectionView.reloadData()
                    })
                }
            }
//            header.fd_enforceFrameLayout = false
            header.comment = comment_array[indexPath.section]
            
//            let comment = comment_array[indexPath.section]
//            if comment.chapter != nil {
//                MQLog(comment.chapter?.chapter_title)
//            }
            
            return header
        }
        return UICollectionReusableView()
        
    }
    func toCommentVote(comment: GYEachComment, completion: @escaping (() -> ())) {
        if MQIUserManager.shared.checkIsLogin() == false {
            MQIloginManager.shared.toLogin(nil) {[weak self] in
                if let strongSelf = self {
                    strongSelf.requestCommentVote(comment: comment, completion: completion)
                }
            }
        }else {
            requestCommentVote(comment: comment, completion: completion)
        }
    }
    func requestCommentVote(comment: GYEachComment, completion: @escaping (() -> ())) {
        MQILoadManager.shared.addProgressHUD(kLocalized("HardPress"))
        GYCommentVoteRequest(comment_id: comment.comment_id)
            .request({ (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("PressSuccess"))
                MQICommentManager.shared.addCommentVoteId(comment: comment)
                completion()
            }) { (msg, code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg)
        }
    }
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 0
    }
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let comment = comment_array[indexPath.section]

        if comment.reply.count > 0 {
            let height = GYBookOriginalCommentCellReply.getHeight(reply: comment.reply[indexPath.row], width: screenWidth - 63)
            let size = CGSize(width: screenWidth, height: height)
            return size
            
        }else {
            return CGSize.zero
        }
    }
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let comment = comment_array[indexPath.section]
        let cell = collectionView.dequeueReusableCell(GDCommentsReplyCollectionCell.self,forIndexPath: indexPath)
        cell.reply = comment.reply[indexPath.row]
        return cell
    }
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        
    }
    
}
