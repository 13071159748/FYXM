//
//  GDReadEndView.swift
//  Reader
//
//  Created by CQSC  on 2018/1/18.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class GDReadEndView: UIView {
    
    var headerBtnClick:((_ type:BookHeaderCellBtnType) -> ())?

    var gdCollectionView:MQICollectionView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(gdCollectionView)
        gdCollectionView.registerCell(MQIBookTypeOneCollectionCellABC.self, xib: false)
        
        
    }

}
extension GDReadEndView {
    
}
