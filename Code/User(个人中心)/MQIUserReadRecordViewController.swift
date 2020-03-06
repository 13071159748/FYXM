//
//  MQIUserReadRecordViewController.swift
//  CQSCReader
//
//  Created by moqing on 2019/2/22.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIUserReadRecordViewController: MQIBaseViewController {

    var books  = [MQIUserReadRecordItemModel](){
        didSet(oldValue) {
            if books.count > 0 {
                dismissNoDataView()
            }else{
                addNoDataView()
            }
        }
    }
    
    override func addNoDataView() {
        super.addNoDataView()
        self.noDataView?.icon.image = UIImage(named: "shujia_no_data_img")
        self.noDataView?.titleLabel.text = kLocalized("go_find_good_books")
    }
    
    
    var gdCollectionView:MQICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView()
        DSYVCTool.dsyAddMJNormalHeade(gdCollectionView, refreshHFTarget:self, mjHeaderAction:   #selector(mj_refreshAction), model: nil)
        DSYVCTool.dsyAddMJNormalFooter(gdCollectionView, refreshHFTarget: self, mjFooterAction: #selector(mj_refreshAction), model: nil)
        
        addPreloadView()
        request(offset: "0")
    }
    
    @objc func mj_refreshAction() -> Void {
        if gdCollectionView.mj_header.isRefreshing {
             request(offset: "0")
        }else{
             request(offset:"\(books.count)")
        }
       
    }
    
    func addCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame:contentView.bounds, collectionViewLayout: layout)
        contentView.addSubview(gdCollectionView)

        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQICollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQIUserReadRecordCollectionViewCell.self, xib: false)
      
        
    }
    
    
    func request(offset: String) {
        GDGet_network_read_logRequest(limit: "20", offset: offset)
            .request({[weak self] (request, response, result: MQIUserReadRecordModel) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.dismissWrongView()
                    if strongSelf.gdCollectionView.mj_header.isRefreshing {
                       strongSelf.books = result.data
                    }else{
                        strongSelf.books.append(contentsOf: result.data)
                    }
                    strongSelf.gdCollectionView.mj_header.endRefreshing()
                    strongSelf.gdCollectionView.mj_footer.endRefreshing()
                    strongSelf.gdCollectionView.reloadData()
                }
            }) {[weak self] (msg, code) in
                if let strongSelf = self {
                    strongSelf.dismissPreloadView()
                    strongSelf.gdCollectionView.mj_header.endRefreshing()
                    strongSelf.gdCollectionView.mj_footer.endRefreshing()
                    strongSelf.addWrongView(msg, refresh: {
                        strongSelf.request(offset: "0")
                    })
                    
                }
        }
    }

}

extension MQIUserReadRecordViewController:MQICollectionViewDelegate{
    //MARK: Delegate
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return 1
        
    }
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return books.count
        
    }
    //横向距离   每个cell的
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 20
        
    }
    
    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,left: 0, bottom: 0,right: 0)
        
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
       return MQIUserReadRecordCollectionViewCell.getSize()
        
    }

    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(MQIUserReadRecordCollectionViewCell.self, forIndexPath: indexPath)
        cell.backgroundColor = collectionView.backgroundColor
        cell.book = books[indexPath.row]
        return cell
        
    }
    
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let book = books[indexPath.row]
        MQIUserOperateManager.shared.toReader(book.book_id, toIndex:   book.chapter_code.integerValue()-1)
        
        
    }
    
}
