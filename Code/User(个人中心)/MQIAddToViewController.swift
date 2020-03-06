//
//  MQIAddToViewController.swift
//  XSDQReader
//
//  Created by moqing on 2018/12/27.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit
import MJRefresh

class MQIAddToViewController: MQIBaseViewController {
    
    fileprivate var gcollectionView: MQICollectionView!
    fileprivate var type: shelfShowType = .tiled
    fileprivate var books = [MQIEachBook]() {
        didSet {
            if books.count <= 0{
                addWrongViewNew(nil) { [weak self] in
                    self?.tabBarController?.selectedIndex = 1
                    self?.popVC()
                }
            }else {
                removeWrongViewNew()
                saveIds =  books.map({$0.book_id})
            }
            
        }
        
    }
    fileprivate var saveIds = [String]()
    fileprivate var delIds = [String](){
        didSet(oldValue) {
            chooseBtn.isSelected  = (delIds.count >= books.count) ? true:false
        }
    }
    fileprivate var rightBtn:UIButton!
    /// 选中按钮下部状态栏
    fileprivate  var bottomToolView: UIView!
    /// 全选btn
    fileprivate  var chooseBtn:UIButton!
    ///编辑状态
    var isEdit = false {
        didSet(oldValue) {
            if isEdit {
                bottomToolView.isHidden = false
               bottomAnimate(view: bottomToolView, state:    bottomToolView.isHidden)
                gcollectionView.height = contentView.height - bottomToolView.height
            }else{
                 bottomToolView.isHidden = true
                bottomAnimate(view: bottomToolView, state:  bottomToolView.isHidden)
                gcollectionView.height = contentView.height
            }
            gcollectionView.reloadData()
        }
    }
    ///编辑中的书籍

    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("MyCollection")
        rightBtn = addRightBtn(nil, imgStr: "CHK_ditor_image")
        rightBtn.setImage(UIImage(named: "CHK_close_image"), for: .selected)
        addBottomView()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        gcollectionView = MQICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        gcollectionView.backgroundColor = UIColor.white
        gcollectionView.gyDelegate = self
        gcollectionView.alwaysBounceVertical = true
        gcollectionView.registerCell(MQIShelfTiledsCell.self, xib: false)
        gcollectionView.registerCell(MQIShelfListCell.self, xib: false)
        gcollectionView.register(MQIShelfHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDSHelfHeader")
 
        contentView.addSubview(gcollectionView)
        
        gcollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
           strongSelf.requestUpdate(strongSelf.saveIds, delete: strongSelf.delIds, alert: true, completion: nil)
            }
        })
        addPreloadView()
        requestUpdate(nil, delete: nil, alert: false, completion: nil)
        
        
    }
    
    override func rightBtnAction(_ button: UIButton) {
        if books.count == 0 {return } 
        button.isSelected = !button.isSelected
        self.isEdit =  button.isSelected
        gcollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         gcollectionView.reloadData()
    }
    
    func requestUpdate(_ ids: [String]?,delete:[String]?, alert: Bool, completion: ((_ suc: Bool) -> ())?) {
        MQIShelfManager.shared.syncShelf(save: ids, del: delete) {[weak self]  (suc, msg) in
            if let strongSelf = self {
                if suc {
                    strongSelf.books =  MQIShelfManager.shared.books
                     strongSelf.requestFinish()
                    if alert == true {
                        MQILoadManager.shared.makeToast(msg)
                    }
                    completion?(true)
                }else{
                   MQILoadManager.shared.makeToast(msg)
                    completion?(false)
                    if let strongSelf = self {
                        strongSelf.dismissPreloadView()
                        strongSelf.gcollectionView.mj_header.endRefreshing()
                        completion?(false)
                    }
                }
            }
        }
       
    }
    
    func requestFinish() {
        dismissPreloadView()
        dismissWrongView()
        gcollectionView.mj_header.endRefreshing()
        gcollectionView.reloadData()
    }
    fileprivate var wrongViewNew: MQIWrongView?
    func addWrongViewNew(_ text: String?, refresh: @escaping (() -> ())) {
        if wrongViewNew == nil {
            wrongViewNew = MQIWrongView(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
            wrongViewNew!.icon.contentMode = .scaleAspectFit
            wrongViewNew!.button.snp.removeConstraints()
            wrongViewNew!.button.snp.makeConstraints { (make) in
                make.centerX.equalTo(wrongViewNew!)
                make.top.equalTo(wrongViewNew!.titleLabel.snp.bottom).offset(15)
                make.width.equalTo(kUIStyle.scale1PXW(120))
                make.height.equalTo(kUIStyle.scale1PXH(38))
            }
        }
        wrongViewNew!.setRefresh(refresh)
        self.view.addSubview(wrongViewNew!)
        wrongViewNew?.loadingText = kLocalized("GoToTheBookCity")
        wrongViewNew?.button.setTitleColor(mainColor, for: .normal)
        wrongViewNew?.button.setTitle(kLocalized("GoToTheBookCity"), for: .normal)
         wrongViewNew?.button.dsySetCorner(radius: 5)
        wrongViewNew?.button.dsySetBorderr(color: mainColor, width: 1)
        wrongViewNew?.icon.image = UIImage(named: "info_collection_image")
        wrongViewNew?.titleLabel.text = kLocalized("NotYetAddedToTheCollection")
       
    }
    
    func removeWrongViewNew() {
        wrongViewNew?.removeFromSuperview()
        wrongViewNew = nil
        
    }

}

extension MQIAddToViewController {
    //MARK:  添加Bottom视图
    func addBottomView() -> Void {
        bottomToolView =  UIView(frame: CGRect(x: 0, y:kUIStyle.kScrHeight-kUIStyle.kTabBarHeight, width: kUIStyle.kScrWidth, height: kUIStyle.kTabBarHeight))
        bottomToolView.backgroundColor = UIColor.white
        bottomToolView.layer.shadowColor = UIColor.black.cgColor // 阴影颜色
        bottomToolView.layer.shadowOffset = CGSize.init(width: 0, height: 0) // 偏移距离
        bottomToolView.layer.shadowOpacity = 0.5 // 不透明度
        bottomToolView.layer.shadowRadius = 5.0 // 半径
        bottomToolView.isHidden = true
        self.view.addSubview(bottomToolView)
        
        let deleteBtn  = UIButton(frame: CGRect.init(x:kUIStyle.kScrWidth*0.5, y:0, width: kUIStyle.kScrWidth*0.5, height: bottomToolView.height-kUIStyle.kTabBarSafeBottomHeight))
        bottomToolView.addSubview(deleteBtn)
        deleteBtn.addTarget(self, action:  #selector(bottomBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        deleteBtn.setTitle(  kLocalized("Delete"), for: .normal)
        deleteBtn.setImage(UIImage(named: "shelf_del_image"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteBtn.setTitleColor(mainColor, for: .normal)
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        chooseBtn  = UIButton(frame: CGRect.init(x: 0, y:0, width: kUIStyle.kScrWidth*0.5, height: deleteBtn.height))
        chooseBtn.setTitle(  kLocalized("FutureGenerations"), for: .normal)
        chooseBtn.setImage(UIImage(named: "CHK_shelf_edit_no_image"), for: .normal)
        chooseBtn.setImage(UIImage(named: "shelf_xz_image"), for: .selected)
        chooseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        chooseBtn.setTitleColor(mainColor, for: .normal)
        bottomToolView.addSubview(chooseBtn)
        chooseBtn.addTarget(self, action:  #selector(bottomBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        chooseBtn.tag = 100
        chooseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        
        let line  = UIView(frame: CGRect.init(x:kUIStyle.kScrWidth*0.5-0.5, y:8, width: 1, height: deleteBtn.height-16 ))
        line.backgroundColor = mainColor
        bottomToolView.addSubview(line)
        
     
    }
    
    
    /// 下部按钮点击方法 true全选
    @objc func bottomBtnClick(btn:UIButton) -> Void {
        if btn.tag == 100 { /// 全选
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                delIds = books.map({$0.book_id})
            }else{
                delIds.removeAll()
            }
             gcollectionView.reloadData()
        }else{
            if delIds.count == 0 {
                MQILoadManager.shared.makeToast(kLocalized("PleaseSelectTheBookToDelete"))
                return
            }
            
            self.isEdit = false
            MQILoadManager.shared.addProgressHUD("")
            requestUpdate(nil, delete: delIds, alert: false) {[weak self] (suc) in
                 MQILoadManager.shared.dismissProgressHUD()
                    if suc {
                        self?.removeBooksFromBooks()
                         self?.rightBtn.isSelected = false
                        MQILoadManager.shared.makeToast(kLocalized("DeleteSuccess"))
                }
            }
        }
        
    }
    
    func removeBooksFromBooks() {
        var userbooks =  MQIShelfManager.shared.books
        if delIds.count == userbooks.count {
            userbooks =  [MQIEachBook]()
        }else{
            for book_id in delIds {
                userbooks = userbooks.filter({$0.book_id != book_id})
            }
        }
        delIds.removeAll()
        MQIShelfManager.shared.updateBooks(userbooks)
        
    }
    /// 下部视图动画
    func  bottomAnimate(view:UIView , state:Bool) -> Void {
        let bounds = view.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        if state {
            UIView.animate(withDuration: 0.3) {
                view.frame = CGRect.init(x: 0, y: screenHeight, width: width, height: height)
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                view.frame = CGRect.init(x: 0, y: screenHeight-height, width: width, height: height)
            }
        }
        
    }
}

extension MQIAddToViewController:MQICollectionViewDelegate {
     func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    
     func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {

        return books.count
    }
    
    //横向距离
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        if type == .tiled {
            return 9
        }else {
            return 0
        }
    }
    
    //四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        if type == .tiled {
            return UIEdgeInsets(top: 20,left: 20,bottom: 0,right: 20)
        }else {
            return UIEdgeInsets.zero
        }
        
    }
//    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
//
//        return CGSize(width: screenWidth, height: 20)
//    }
//     func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
//        if indexPath.section == 0 {
//            if kind == UICollectionView.elementKindSectionHeader {
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDSHelfHeader", for: indexPath) as! MQIShelfHeaderCollectionReusableView
//
//                return header
//            }
//            return UICollectionReusableView()
//
//        }
//        return  UICollectionReusableView()
//    }
    

//
     func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        
        if type == .tiled {
            return  MQIShelfTiledsCell.getSize()
        }else{
            return  MQIShelfListCell.getSize()
        }
    }
    
     func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if type == .tiled {
            let book = books[indexPath.row]
            let cell = collectionView.dequeueReusableCell(MQIShelfTiledsCell.self, forIndexPath: indexPath)
            cell.backgroundColor = collectionView.backgroundColor
            cell.book = book
            cell.isEdit(self.isEdit)
            cell.editMaskBtn.isSelected = delIds.contains(book.book_id)
            return cell
        }else {
            let book = books[indexPath.row]
            let cell = collectionView.dequeueReusableCell(MQIShelfListCell.self, forIndexPath: indexPath)
            cell.backgroundColor = collectionView.backgroundColor
            cell.isEdit(self.isEdit)
            cell.editMaskBtn.isSelected = delIds.contains(book.book_id)
            cell.book = book
            return cell
            
        }
        
        
    }
     func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        if self.isEdit {
            
            if self.type == .tiled {
                let cell = collectionView.cellForItem(at: indexPath) as! MQIShelfTiledsCell
                cell.editMaskBtn.isSelected = !cell.editMaskBtn.isSelected
                if cell.editMaskBtn.isSelected {
                    delIds.append(cell.book.book_id)
                }else{
                    delIds = delIds.filter({$0 != cell.book.book_id})
                    
                }
                
            }else{
                let cell = collectionView.cellForItem(at: indexPath) as! MQIShelfListCell
                cell.editMaskBtn.isSelected = !cell.editMaskBtn.isSelected
                if cell.editMaskBtn.isSelected {
                    delIds.append(cell.book.book_id)
                }else{
                     delIds = delIds.filter({$0 != cell.book.book_id})
                    
                }
            }
            
        }else{
            let book = books[indexPath.row]
            toRead(book)
        }
        
        
    }
    
    func toRead(_ book: MQIEachBook) {
      MQIUserOperateManager.shared.toReader(book.book_id)
    }

    
}
