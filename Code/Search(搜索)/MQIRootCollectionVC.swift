//
//  MQIRootCollectionVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIRootCollectionVC: MQIBaseViewController,MQICollectionViewDelegate {

    var gcollectionView: MQICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = DSYCollectionViewLeftAlignedLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        gcollectionView = MQICollectionView(frame: view.bounds, collectionViewLayout: layout)
        gcollectionView.backgroundColor = UIColor.white
        gcollectionView.gyDelegate = self
        gcollectionView.alwaysBounceVertical = true
        contentView.addSubview(gcollectionView)
    }
    
    //MARK: GYCollectionViewDelegate
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return 0
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
