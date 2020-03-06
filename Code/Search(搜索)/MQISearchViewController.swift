//
//  MQISearchViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MJRefresh

class MQISearchViewController: MQIBaseViewController {

    var searchView: MQISearchView!
    var noBookView: MQISearchNoBookView!
    var searchTF: UITextField!
    
    var books = [MQIEachBook]()
    
    var isRefresh: Bool = false
    var limit: Int = 20
    var keyword: String = ""
    
    var rightBtn:UIButton!
    var gcollectionView: MQICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        searchView = MQISearchView(frame: contentView.bounds)
        searchView.toVC = {vc -> Void in
            self.pushVC(vc)
        }
        searchView.toSearch = {key -> Void in
            self.searchTF.text = key
            self.keyword = key
            self.books.removeAll()
            MQILoadManager.shared.addProgressHUD(kLocalized("HardWorkInSearch"))
            self.requestKeyword(key: key, offset: "0", limit: "\(self.limit)")
        }
        contentView.addSubview(searchView)
        
        setTabAtt()
        addSearch()
        addSearchNoBook()
        
        rightBtn = addRightBtn(kLocalized("Search"), imgStr: nil)
        rightBtn.setTitleColor(UIColor.colorWithHexString("339AFF"), for: .normal)
        rightBtn.x += 10;
//        rightBtn.setTitle(kLocalized("Cancel"), for: .selected)
        
        
    }
    
    
    override func popVC() {
        if searchView.isHidden {
            searchView.isHidden = false
            return
        }
        super.popVC()
        
    }
   
    
    override func rightBtnAction(_ button: UIButton) {
        if button.isSelected {
            
        }else{
          checkTextValue()
        }
        
    }
    
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gcollectionView = MQICollectionView(frame: view.bounds, collectionViewLayout: layout)
        gcollectionView.backgroundColor = UIColor.white
        gcollectionView.gyDelegate = self
        gcollectionView.alwaysBounceVertical = true
        contentView.addSubview(gcollectionView)
    }
    
 
    
}


extension MQISearchViewController : MQICollectionViewDelegate {

    //MARK: --
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
    }
    
     func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return books.count
    }
    
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableHeaderFooter(GYSearchHeader.self, kind: UICollectionView.elementKindSectionHeader, indexPath: indexPath)
            header.titleLable.text = "  搜索结果"
            return header
        }else {
            return UICollectionReusableView()
            
        }
    }
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {
        if books.count > 0{
            return GYSearchHeader.getSize()
        }
        return CGSize.zero
    }
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 10
    }
    
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
//        return GYSearchResultCell.getSize()
        return  MQIBookTypeTwoCollectionCellABC.getSize()
    }
    
     func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(GYSearchResultCell.self, forIndexPath: indexPath)
//        cell.book = books[indexPath.row]
        let eachModel = books[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQIBookTypeTwoCollectionCellABC.self, forIndexPath: indexPath)
        cell.coverImageView.imageView.sd_setImage(with: URL(string:eachModel.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
        cell.book_nameLabel?.text = eachModel.book_name
        //            cell.statusText = eachModel.subclass_name
        cell.statusText = (eachModel.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
        cell.classText = eachModel.book_words
        cell.bookcontentText = eachModel.book_intro
        cell.book_authorText = eachModel.subclass_name
        return cell
    }

    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        if books.count > 0 {
            let book = books[indexPath.row]
            //            let bookInfoVC = GYBookOriginalInfoVC()
            MQIUserOperateManager.shared.toBookInfo(book.book_id)
            MQIEventManager.shared.appendEventData(eventType: .search_book, additional: ["book_id":book.book_id])
        }
    }

}
extension MQISearchViewController : UITextFieldDelegate {
    
    //    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchView.isHidden = false
        noBookView.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return checkTextValue()
    }
}

extension MQISearchViewController {
    
    func addSearchNoBook() {
        noBookView = MQISearchNoBookView(frame: contentView.bounds)
        noBookView.isHidden = true
        contentView.addSubview(noBookView)
    }
    func setTabAtt()  {
        
        gcollectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-x_statusBarAndNavBarHeight-x_TabbatSafeBottomMargin)
        
        gcollectionView.registerCell(MQICollectionViewCell.self, xib: false)
        gcollectionView.registerCell(GYSearchResultCell.self, xib: true)
        gcollectionView.registerCell(MQIBookTypeTwoCollectionCellABC.self, xib: false)
        gcollectionView.registerHeaderFooter(GYSearchHeader.self, kind: UICollectionView.elementKindSectionHeader, xib: true)
        gcollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.isRefresh = true
                strongSelf.requestKeyword(key: strongSelf.keyword,
                                          offset: "0",
                                          limit: "\(strongSelf.books.count)")
            }
        })
        
        gcollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.requestKeyword(key: strongSelf.keyword,
                                          offset: "\(strongSelf.books.count)",
                    limit: "\(strongSelf.limit)")
            }
        })
        
    }
    
    func addSearch() {
        let bacView = UIView(frame: CGRect(x: nav_btn_space*2+nav_btn_side, y: (root_nav_height-nav_btn_side)/2, width: nav.frame.size.width-4*nav_btn_space-2*nav_btn_side, height: nav_btn_side))
        bacView.backgroundColor = UIColor.colorWithHexString("F4F4F5")
        bacView.dsySetCorner(radius: bacView.height*0.5)
        //        bacView.dsySetBorderr(color: mainColor, width: 1)
        bacView.tag = bacTag
        nav.addSubview(bacView)
        
        
        let  searchImg = UIImageView(frame: CGRect(x: nav_btn_space, y: 0, width: 15, height: 15))
        searchImg.contentMode = .scaleAspectFit
        bacView.addSubview(searchImg)
        let image =  UIImage(named: "shelf_searchBtn")?.withRenderingMode(.alwaysTemplate)
        searchImg.image = image
        searchImg.tintColor = UIColor.colorWithHexString("9DA0A9")
        
        
        searchTF = UITextField(frame: CGRect(x: searchImg.maxX+10,
                                             y: nav_btn_space/2,
                                             width:  bacView.bounds.width-searchImg.maxX-2-nav_btn_space,
                                             height: nav_btn_side-nav_btn_space))
        searchTF.backgroundColor = UIColor.clear
        searchTF.delegate = self
        searchTF.placeholder = kLocalized("SearchForBooksYouAreInterestedIn")
        searchTF.layer.masksToBounds = true
        searchTF.clearButtonMode = .always
        searchTF.returnKeyType = UIReturnKeyType.search
        searchTF.font = UIFont.systemFont(ofSize: 14)
        bacView.addSubview(searchTF)
        
        searchImg.centerY = searchTF.centerY
        
    }
    
    func requestKeyword(key: String, offset: String, limit: String) {
        searchTF.endEditing(true)
        MQISearchResultsManager.shared.saveKey(key)
        searchView.reloadHistorys()
        noBookView.isHidden = true
        
        GYSearchRequest(keyword: key, offset: offset, limit: limit)
            .request({ (request, response, result: MQISearchDataModel) in
                MQILoadManager.shared.dismissProgressHUD()
                self.gcollectionView.mj_header.endRefreshing()
                self.gcollectionView.mj_footer.endRefreshing()
                self.searchView.isHidden = true
                
                if self.isRefresh == true {
                    self.isRefresh = false
                    self.books.removeAll()
                }
                
                self.books.append(contentsOf: result.data)
                self.noBookView.isHidden = self.books.count <= 0 ? false : true
                self.gcollectionView.reloadData()
                //                self.gcollectionView.contentOffset = CGPoint(x: 0, y: 0)
            }) { (msg, code) in
                self.noBookView.isHidden = true
                MQILoadManager.shared.dismissProgressHUD()
                self.gcollectionView.mj_header.endRefreshing()
                self.gcollectionView.mj_footer.endRefreshing()
                MQILoadManager.shared.makeToast(msg)
        }
    }
    
    @discardableResult func checkTextValue() -> Bool {
        if let text = searchTF.text {
            if text.count <= 0 {
                MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheSearchContent"))
                return false
            }else {
                let donotWant = CharacterSet.init(charactersIn:"@ / ：: ; ( ) ￥ []{}（#%-*+=_）\\|~(＜＞$%^&*)_+ ")
                keyword = text.trimmingCharacters(in: donotWant)
                if keyword == "" {
                    MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheCorrectSearchContent"))
                    return false
                }
                mqLog(keyword)
                books.removeAll()
                MQILoadManager.shared.addProgressHUD(kLocalized("HardWorkInSearch"))
                if (gcollectionView != nil) {
                    gcollectionView.reloadData()
                    self.gcollectionView.contentOffset = CGPoint(x: 0, y: 0)
                }
                
                requestKeyword(key: keyword, offset: "0", limit: "\(limit)")
                return true
            }
        }else {
            MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheSearchContent"))
            return false
        }
    }
    

}



class MQISearchNoBookView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = UIColor.white
        
        let width = self.width*406/1080
        let height = width*659/752
        let imageView = UIImageView(frame: CGRect(x: (self.width-width)/2,
                                                  y: (self.height*430/1775)/2+30,
                                                  width: width, height: height))
        imageView.image = UIImage(named: "searchNoBook")
        self.addSubview(imageView)
        
        let label = createLabel(CGRect(x: 0, y: imageView.maxY+10, width: self.width, height: 30),
                                font: systemFont(13),
                                bacColor: UIColor.clear,
                                textColor: RGBColor(131, g: 131, b: 131),
                                adjustsFontSizeToFitWidth: false,
                                textAlignment: .center,
                                numberOfLines: 0)
        label.text = kLocalized("ThereNothingHere")
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

