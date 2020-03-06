//
//  MQIReadEndViewController.swift
//  Reader
//
//  Created by CQSC  on 2018/1/23.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class GDReadEndViewC: MQIBaseViewController//,SBCollectionViewDelegateFlowLayout//,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    var bookId:String?
    var book:MQIEachBook?
//    fileprivate var gdCollectionView:MQICollectionView!
    
    var gdCollectionView: MQICollectionView!
    fileprivate var navBgView:UIView!
    fileprivate var authorOtherBooks = [MQIEachBook]()
    fileprivate var gussLikeBooks = [MQIChoicenessListModel]()
    var maskView_: UIView!
    var rewardView: GYUserRewardView!//打赏弹窗
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.alpha = 0
        status.alpha = 0
        
        maskView_ = UIView(frame: view.bounds)
        maskView_.backgroundColor = UIColor.black
        maskView_.alpha = 0.5
        maskView_.isUserInteractionEnabled = true
        maskView_.isHidden = true
        addTGR(self, action: #selector(GDReadEndViewC.tgrClick), view: maskView_)
        view.addSubview(maskView_)
        addComment_rewardView()
        setupNavigationView()
        addCollectionView()
        addPreloadView()
        check_Book_IsExist()
    }
  
    func setupNavigationView() {
        navBgView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        navBgView.backgroundColor = UIColor.white
        
        view.addSubview(navBgView)
        
        let backBtn = createBackBtn()
        navBgView.addSubview(backBtn)
        
    }
    func createBackBtn() -> UIButton {
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 10,
                               y: root_status_height,
                               width: root_nav_height,
                               height: root_nav_height)
        let image = UIImage(named: "nav_back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(image, for: .normal)
        backBtn.addTarget(self, action: #selector(GDReadEndViewC.backBtnClick), for: .touchUpInside)
        backBtn.tintColor = UIColor.black
        return backBtn
    }
    @objc func backBtnClick() {
//        self.navigationController?.popViewController(animated: true)
        popVC()
    }
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        
        gdCollectionView.backgroundColor = UIColor.colorWithHexString("#ededed")
        contentView.addSubview(gdCollectionView)
        gdCollectionView.registerCell(AAReadEndFirstCell.self, xib: false)
        gdCollectionView.registerCell(GDReadEndSecondCell.self, xib: false)
        gdCollectionView.registerCell(MQICollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(GDReadEndGuessLikeCell.self, xib: false)
        
        gdCollectionView.register(YQPHBReadEndHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: gdreadendHeaderCollectionID)
        gdCollectionView.register(GDReadEndFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: gdreadendFooterCollectionID)
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.collectionViewLayout = SBCollectionViewFlowLayout()
        
    }
    
    func check_Book_IsExist() {
        guard let _ = book else {
            //书不存在
            check_bookid_isExist()
            return
        }
        rewardView.book = book
        requestOthers()
    }
    func check_bookid_isExist() {
        guard let _ = bookId else {
            //请求不了书id，直接请求other，上面空着
            requestOthers()
            return
        }
        net_readEndVCRequestHeader()
    }
    func requestOthers() {
        net_otherAlbumRequest()
        net_gussYouLikeRequest()
         dismissPreloadView()
    }
    //MARK:根据id 找书信息
    func net_readEndVCRequestHeader() {
        
        GYBookManager.shared.requestBookInfo(bookId!) { [weak self] (book, err_msg,code) in
            if let weakSelf = self {
                guard let result = book else  {
                    weakSelf.dismissPreloadView()
                    return
                }
                weakSelf.book = result
                weakSelf.rewardView.book = result
                weakSelf.requestOthers()
                weakSelf.gdCollectionView.reloadData()
                after(1, block: {
                    weakSelf.dismissPreloadView()
                })
            }
            
        }
        
        
        //        GYBookInfoRequest(book_id: bookId!).request({ [weak self](request, response, result: MQIEachBook) in
        //            if let weakSelf = self {
        //                weakSelf.book = result
        //                weakSelf.rewardView.book = result
        //                weakSelf.requestOthers()
        //                GYBookManager.shared.addDownloadBook(result)
        //                weakSelf.gdCollectionView.reloadData()
        //                after(1, block: {
        //                    weakSelf.dismissPreloadView()
        //                })
        //            }
        //
        //        }) { [weak self](err_meg, err_code) in
        //            if let weakSelf = self {
        //                weakSelf.dismissPreloadView()
        //            }
        //        }
        //
    }
    //MARK:作者其他专辑
    func net_otherAlbumRequest() {
        guard let book = book else {
            return
        }
        if book.user_id == "0" {
            return
        }
        GYBookInfoOtherBooksRequest(user_id: book.user_id, book_id: book.book_id)
            .requestCollection({[weak self] (request, response, result: [MQIEachBook]) in
                if let strongSelf = self {
                    strongSelf.authorOtherBooks = result
                    strongSelf.gdCollectionView.reloadData()
                }
                }, failureHandler: { (err_msg, err_code) in
                    
            })
    }
    //MARK:菜腻喜欢
    func net_gussYouLikeRequest() {
        var book_id = ""
        if let book = book {
            book_id = book.book_id
        }else if let bookId = bookId {
            book_id = bookId
        }else {
            return
        }
        GDGetChoicenessByBookRequest(book_id: book_id).requestCollection({ [weak self](request, response, result:[MQIChoicenessListModel]) in
            if let weakSelf = self {
                weakSelf.gussLikeBooks = result
                weakSelf.gdCollectionView.reloadData()
            }
        }) { (err_msg, err_code) in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func toLike() {
        if let _ = book {
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.requestToLike()
                    }
                })
            }else {
                requestToLike()
            }
        }
    }
    func requestToLike() {
        GYBookInfoToVoteRequest(user_id: MQIUserManager.shared.user!.user_id, book_id: book!.book_id, toVote: false, vote_num: "10")
            .request({ (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.makeToast(kLocalized("TenPress"))
//                if let weakSelf = self {
//                    weakSelf.book?.vote_number = "\(Int(weakSelf.book!.vote_number)!+10)"
//                }
            }) { (err_msg, err_code) in
                MQILoadManager.shared.makeToast(kLocalized("TomorrowCome"))
        }
    }
    
    
}
extension GDReadEndViewC {
    func dealWithHeaderAction(_ type:BookHeaderCellBtnType) {
        if type == .likeBtn {
            toLike()
        }else if type == .rewardBtn {
            toReward()
        }else if type == .commentBtn {
            let allCommentsVC = MQICommentsVC()
            guard let _ = book else {
                MQILoadManager.shared.makeToast(kLocalized("WrongBookInfo"))
                return
            }
            allCommentsVC.book = book
            pushVC(allCommentsVC)
        }else if type == .sharedBtn {
            if let book = book {
                MQISocialManager.shared.sharedBook(book)
            }
        }
    }
    @objc func tgrClick() {
        dismissRewardView()
    }
    func addComment_rewardView() {
        let width = view.bounds.width
        let height = view.bounds.height
        rewardView = GYUserRewardView(frame: CGRect(x: 0, y: height, width: width, height: GYUserRewardView.getHeight()))
        rewardView.isHidden = true
        rewardView.rewardCoin = {[weak self]coin -> Void in
            if self != nil {
                MQILoadManager.shared.addAlert(kLocalized("Exception"), msg: "\(kLocalized("MakeSureException"))\(coin)\(COINNAME)？", block: {[weak self]()->Void in
                    if let strongSelf = self
                    {
                        strongSelf.rewardRequest(coin)
                    }
                    }, cancelBlock: {
                })
            }
        }
        view.addSubview(rewardView)
        
    }
    func rewardRequest(_ coin: Int) {
        if let book = book {
            MQILoadManager.shared.addProgressHUD(kLocalized("Exceptioning"))
            GYUserRewardRequest(book_id: book.book_id, coin: "\(coin)")
                .request({ (request, response, result: MQIBaseModel) in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(kLocalized("ExceptionSuccess"))
                    UserNotifier.postNotification(.refresh_coin)
                }) { (err_msg, err_code) in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(err_msg)
            }
        }
    }
    //打赏
    func toReward() {
        if let _ = book {
            if MQIUserManager.shared.checkIsLogin() == false {
                MQIloginManager.shared.toLogin(nil, finish: {[weak self] in
                    if let strongSelf = self {
                        strongSelf.showRewardView()
                    }
                })
            }else {
                showRewardView()
            }
        }
    }
    func showRewardView() {
        rewardView.isHidden = false
        maskView_.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.maskView_.alpha = 0.5
                strongSelf.contentView.bringSubviewToFront(strongSelf.maskView_)
                
                strongSelf.rewardView.frame.origin.y = strongSelf.view.height-GYUserRewardView.getHeight()
                strongSelf.contentView.bringSubviewToFront(strongSelf.rewardView)
            }
            }, completion: { (suc) in
                
        })
    }
    
    func dismissRewardView() {
        UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rewardView.frame.origin.y = strongSelf.view.height
                strongSelf.maskView_.alpha = 0
            }
            }, completion: {[weak self] (suc) in
                if let strongSelf = self {
                    strongSelf.rewardView.isHidden = true
                    strongSelf.maskView_.isHidden = true
                }
        })
    }
}
extension GDReadEndViewC: MQICollectionViewDelegate {
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 3
    }
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return authorOtherBooks.count
        }else {
            return gussLikeBooks.count
        }
        
    }
    func minimumLineSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 0
    }
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 37*gdscale, bottom: 0, right: 37*gdscale)
        }
        return UIEdgeInsets(top: 0, left: 24.5*gdscale, bottom: 0, right: 24.5*gdscale)
    }
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: gdreadendHeaderCollectionID, for: indexPath) as! YQPHBReadEndHeaderCollectionReusableView
            header.headerLabel.text = kLocalized("TheAuthorAlsoWrote")
            return header
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: gdreadendFooterCollectionID, for: indexPath) as! GDReadEndFooterReusableView
            return footer
        }
        
        return UICollectionReusableView()
    }
    func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        if section == 1 {
            if authorOtherBooks.count > 0{
                return GDReadEndFooterReusableView.getFooterSize()
            }
        }
        return CGSize(width: 0, height: 0)
    }
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        
        if section == 1 {
            if authorOtherBooks.count > 0{
                return YQPHBReadEndHeaderCollectionReusableView.getHeaderSize()
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return AAReadEndFirstCell.getFirstCellSize()
        case 1:
            return GDReadEndSecondCell.getSize()
        case 2:
            let eachModel = gussLikeBooks[indexPath.row]
            return GDReadEndGuessLikeCell.getGuessSize(eachModel.width, height: eachModel.height)
        default:
            break
        }
        return AAReadEndFirstCell.getFirstCellSize()
    }
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(AAReadEndFirstCell.self, forIndexPath: indexPath)
            if let book = book {
                cell.book = book
            }
            cell.headerBtnClick = {[weak self](type)->Void in
                if let weakSelf = self {
                    weakSelf.dealWithHeaderAction(type)
                }
            }
            return cell
        case 1:
            let model = authorOtherBooks[indexPath.row]
            let cell = collectionView.dequeueReusableCell(GDReadEndSecondCell.self, forIndexPath: indexPath)
            cell.book = model
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(GDReadEndGuessLikeCell.self, forIndexPath: indexPath)
            let model = gussLikeBooks[indexPath.row]
            cell.eachbookModel = model
            return cell
        default:
            break
        }
        
        return MQICollectionViewCell()
    }
    
    
    func gd_setSectionBackgroundColor(_ collectionView: MQICollectionView, section: Int) -> UIColor {
        
        if section == 1 {
            return UIColor.white
        }
        return UIColor.clear
    }
    func gd_setSectionBackgroundFrame(collectionView: MQICollectionView, section: Int) -> CGRect {
        if section == 1 {
            return CGRect(x: 24.5*gd_scale, y: 0, width: screenWidth - 49*gd_scale, height: 0)
        }
        return CGRect.zero
    }
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
//        MQLog(indexPath.row)
        switch indexPath.section {
        case 0:
            break
        case 1:
            let eachModel = authorOtherBooks[indexPath.row]
            AAEnterReaderType.shared.enterType = .enterType_0
            MQIUserOperateManager.shared.toReader(eachModel.book_id)
            MQIEventManager.shared.appendEventData(eventType: .end_page_book, additional: ["book_id":eachModel.book_id])
            break
        case 2:
            let eachModel = gussLikeBooks[indexPath.row]
            AAEnterReaderType.shared.enterType = .enterType_0
            MQIUserOperateManager.shared.toReader(eachModel.book_id)
            MQIEventManager.shared.appendEventData(eventType: .end_page_book, additional: ["book_id":eachModel.book_id])
            break
        default:
            break
        }
        
        
    }
    
}
