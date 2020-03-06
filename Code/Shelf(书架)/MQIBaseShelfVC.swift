//
//  MQIBaseShelfVC.swift
//  Reader
//
//  Created by CQSC  on 16/9/27.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit

import Spring

let SHELFPUSHTIME = "SHELFPUSHTIME"
let KSHELFSHOWTYPE = "KSHELFSHOWTYPE"
enum shelfShowType: String {
    case tiled = "tiled" //平铺
    case list = "list" //列表
}

enum shelfBooksType: String {
    case recent = "recent"
    case fav = "fav"
    case subscribe = "subscribe"
}

let MQIBaseShelfVC_tiledFooterCellNew = "MQIBaseShelfVC_tiledFooterCellNew"
let MQIBaseShelfVC_Tiled_Edge_Space : CGFloat = 17.5

class MQIBaseShelfVC: MQIBaseViewController {
    
    public var type: shelfShowType = .tiled
    public var isHistory: Bool = false
    
    public var gcollectionView: MQICollectionView!
    public var sign_Redcaution:UIView! //签到边的提醒
    public var editBookIds = [String]()
    public var isNewUser: Bool = true
    public var editBookIsNowRead = [MQIEachBook]()
    public var window: UIWindow!
    public var maskView_: UIView!
    public var shelfActionViewHeader: MQIShelfHeaderView!

    
    public let titleFont = UIFont.boldSystemFont(ofSize: 13)
    public let titleColor = RGBColor(201, g: 201, b: 201)
    public let titleColorSel = UIColor.black
    public let bacColor: UIColor = UIColor.white
    public var tiledBooks = [[MQIEachBook]]()
    public var bookStoreArray = [MQIEachBook]()
    
    public var contentScrView:UIScrollView!
    public var historyCollectionView: MQICollectionView!

    public var books = [MQIEachBook]() {
        didSet {
            if books.count <= 0{
                addNoBook()
            }else {
                removeNoBook()
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        navTintFont = boldFont(17)
        navTintColor = UIColor.white
        super.viewDidLoad()

        self.type = .tiled
        //        }
        contentView.backgroundColor = bacColor
        
        window = getWindow()
        maskView_ = getMaskView(window.bounds)
   
        addCollectionView()
    }
    
    public func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        gcollectionView = MQICollectionView(frame: CGRect (x: 0, y: 41 * hdscale, width: contentView.bounds.size.width, height: contentView.height - 71 * hdscale), collectionViewLayout: layout)
        gcollectionView.backgroundColor = bacColor
        gcollectionView.gyDelegate = self
        gcollectionView.alwaysBounceVertical = true
        gcollectionView.registerCell(MQIShelfTiledsCell.self, xib: false)
        gcollectionView.registerCell(MQIShelfListCell.self, xib: false)
        gcollectionView.register(MQIShelfHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GDSHelfHeader")
        contentView.addSubview(gcollectionView)
        
    }
    
    fileprivate var nothingView: MQINoDataBookView?
    func addNoBook() {
        if nothingView == nil {
            nothingView = MQINoDataBookView()
            contentScrView.addSubview(nothingView!)
            contentScrView.bringSubviewToFront(nothingView!)
            nothingView?.noBook(kLocalized("go_find_good_books"), imgName: "shujia_no_data_img")
            
        }
       nothingView!.frame = gcollectionView.frame
    }
    
  
    func removeNoBook() {
        if nothingView != nil {
            nothingView!.removeFromSuperview()
            nothingView = nil
        }
        
    }
    
    fileprivate var nothingHistoryView: MQINoDataBookView?
    func addNoHistoryBook( ) {
        if nothingHistoryView == nil {
            nothingHistoryView = MQINoDataBookView()
            contentScrView.addSubview(nothingHistoryView!)
            contentScrView.bringSubviewToFront(nothingHistoryView!)
            nothingHistoryView?.noBook(kLocalized("go_find_good_books"), imgName: "shujia_no_data_img")

        }
        nothingHistoryView!.frame = historyCollectionView.frame
    }
    
    func removeNoHistoryBook() {
        if nothingHistoryView != nil {
            nothingHistoryView!.removeFromSuperview()
            nothingHistoryView = nil
        }
        
    }
 
    
    func deleteFinish() {
        editBookIds.removeAll()
        editBookIsNowRead.removeAll()
        //        isEdit = false
        gcollectionView.reloadData()
       
    }

    
}



extension MQIBaseShelfVC: MQICollectionViewDelegate {
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
            return 1
    }
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        if type == .tiled {
                return tiledBooks[section].count
        }else {
                return books.count
        }
        
    }
    //横向距离
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 0
    }
    //四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        if type == .tiled {
            return UIEdgeInsets(top: 0,left: 20.5*gdscale,bottom: 0,right: 20.5*gdscale)
        }else {
            return UIEdgeInsets.zero
        }
        
    }
    //设置footer View
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        if type == .tiled {
            return CGSize.zero
        }else {
            return CGSize.zero
        }
    }
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 14)
        
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize{
        if type == .tiled {
                return MQIShelfTiledsCell.getSize()
        }else {
            return MQIShelfListCell.getSize()
        }
        
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
                let cell = collectionView.dequeueReusableCell(MQIShelfTiledsCell.self, forIndexPath: indexPath)
               return cell
    }
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        
    }
}
