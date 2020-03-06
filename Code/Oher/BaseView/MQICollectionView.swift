//
//  MQICollectionView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


@objc protocol MQICollectionViewDelegate: NSObjectProtocol {
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int
    
    @objc optional func refreshData()
    @objc optional func loadMoreData()
    @objc optional func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int
    @objc optional func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize
    @objc optional func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize
    @objc optional func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize
    @objc optional func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView
    @objc optional func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets
    @objc optional func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat
    @objc optional func minimumLineSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat
    @objc optional func shouldHighlightItem(_ collectionView: MQICollectionView, indexPath: IndexPath) -> Bool
    @objc optional func didHighlightItem(_ collectionView: MQICollectionView, indexPath: IndexPath)
    @objc optional func didUnhighlightItem(_ collectionView: MQICollectionView, indexPath: IndexPath)
    @objc optional func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath)
    
    @objc optional func scrollViewWillBeginDragging(_ collectionView: MQICollectionView)
    @objc optional func scrollViewWillBeginDecelerating(_ collectionView: MQICollectionView)
    @objc optional func scrollViewDidScroll(_ collectionView: MQICollectionView)
    @objc optional func scrollViewDidEndDecelerating(_ collectionView: MQICollectionView)
    //gdimport
    @objc optional func gd_setSectionBackgroundColor(_ collectionView:MQICollectionView,section:Int) -> UIColor
    
    @objc optional func gd_setSectionBackgroundFrame(collectionView:MQICollectionView,section:Int) -> CGRect
    
        @objc optional func openleftAlignFrame(section:Int) -> Bool
}

class MQICollectionView:UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout ,SBCollectionViewDelegateFlowLayout {
    weak var gyDelegate: MQICollectionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.delegate = self
        self.dataSource = self
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clear
        self.delegate = self
        self.dataSource = self
    }
    func gdCollectionView(_ collectionView: UICollectionView, section: Int) -> CGRect {
        let rect = gyDelegate?.gd_setSectionBackgroundFrame?(collectionView: collectionView as! MQICollectionView, section: section)
        if rect != nil {
            return rect!
        }else {
            return CGRect(origin: CGPoint.zero, size: CGSize.zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        let color = gyDelegate?.gd_setSectionBackgroundColor?(collectionView as! MQICollectionView, section: section)
        if color != nil {
            return color!
        }else {
            return UIColor.clear
        }
        
    }
    
    //MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = gyDelegate?.numberOfCollectionView?(collectionView as! MQICollectionView)
        if count != nil {
            return count!
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = gyDelegate?.numberOfItems(collectionView as! MQICollectionView, section: section)
        if count != nil {
            return count!
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = gyDelegate?.sizeForItem?(collectionView as! MQICollectionView, layout: collectionViewLayout, indexPath: indexPath)
        if size != nil {
            return size!
        }else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = gyDelegate?.sizeForHeader?(collectionView as! MQICollectionView, layout: collectionViewLayout, section: section)
        if size != nil {
            return size!
        }else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = gyDelegate?.sizeForFooter?(collectionView as! MQICollectionView, layout: collectionViewLayout, section: section)
        if size != nil {
            return size!
        }else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = gyDelegate?.viewForSupplementaryElement?(collectionView as! MQICollectionView, kind: kind, indexPath: indexPath)
        if view != nil {
            return view!
        }else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edge = gyDelegate?.insetForSection?(collectionView as! MQICollectionView, layout: collectionViewLayout, section: section)
        if edge != nil {
            return edge!
        }else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let m = gyDelegate?.minimumInteritemSpacingForSection?(collectionView as! MQICollectionView, layout: collectionViewLayout, section: section)
        if m != nil {
            return m!
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let m = gyDelegate?.minimumInteritemSpacingForSection?(collectionView as! MQICollectionView, layout: collectionViewLayout, section: section)
        if m != nil {
            return m!
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let b = gyDelegate?.shouldHighlightItem?(collectionView as! MQICollectionView, indexPath: indexPath)
        if b != nil {
            return b!
        }else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        gyDelegate?.didHighlightItem?(collectionView as! MQICollectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        gyDelegate?.didUnhighlightItem?(collectionView as! MQICollectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gyDelegate?.cellForRow(collectionView as! MQICollectionView, indexPath: indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gyDelegate?.didSelectRowAtIndexPath?(collectionView as! MQICollectionView, indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gyDelegate?.scrollViewDidScroll?(scrollView as! MQICollectionView)
    }
    
}


extension MQICollectionView:DSYCollectionViewLeftAlignedLayoutDelegateFlowLayout {
    func openleftAlignFrame(section: Int) -> Bool {
        let b = gyDelegate?.openleftAlignFrame?(section: section)
        if b != nil {
            return b!
        }else {
            return false
        }
    }
    
}
extension MQICollectionView {
    
    func registerCell<T: MQICollectionViewCell>(_: T.Type, xib: Bool) //where T: ReusableView, T:LoadableView
    {
        if xib == true {
            let nib = UINib(nibName: T.nibName, bundle: nil)
            register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        }else {
            register(T.myClass, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func registerHeaderFooter<T: MQICollectionReusableView>(_: T.Type, kind: String, xib: Bool) //where T: ReusableView, T:LoadableView
    {
        if xib == true {
            let nib = UINib(nibName: T.nibName, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
        }else {
            register(T.myClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: MQICollectionViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T //where T:ReusableView
    {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: MQICollectionReusableView>(_: T.Type, kind: String, indexPath: IndexPath) -> T //where T:ReusableView
    {
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue SupplementaryView with identifier: \(T.reuseIdentifier)")
        }
        return header
    }
    
}
