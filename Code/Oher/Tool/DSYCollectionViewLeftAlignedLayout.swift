//
//  DSYCollectionViewLeftAlignedLayout.swift
//  DSYlearning
//
//  Created by moqing on 2019/5/29.
//  Copyright © 2019 DSY. All rights reserved.
//

import UIKit

protocol DSYCollectionViewLeftAlignedLayoutDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    /// 是否开启左对齐
    func openleftAlignFrame(section:Int) -> Bool
    
}

class DSYCollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let delegate = self.collectionView?.delegate as? DSYCollectionViewLeftAlignedLayoutDelegateFlowLayout else {
            return super.layoutAttributesForElements(in: rect)
        }
        guard   let  originalAttributes = super.layoutAttributesForElements(in: rect)  else{
            return super.layoutAttributesForElements(in: rect)
        }
        var updatedAttributes = originalAttributes
        for (index, attributes)  in updatedAttributes.enumerated()  {
            if attributes.representedElementKind == nil {
                if !delegate.openleftAlignFrame(section: attributes.indexPath.section) { continue }
                updatedAttributes[index] = self.layoutAttributesForItem(at: attributes.indexPath) ?? attributes
            }
        }
        return updatedAttributes
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let  currentItemAttributes =  super.layoutAttributesForItem(at: indexPath)
        let  sectionInset = self.evaluatedSectionInset(of: indexPath.section)
        let  isFirstItemInSection:Bool = indexPath.item == 0
        let  layoutWidth = self.collectionView!.frame.width  - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            return leftAlignFrame(currentItemAttributes, sectionInset: sectionInset, maxWidth: layoutWidth)
        }
        
        let previousIndexPath = IndexPath.init(item: indexPath.item-1, section: indexPath.section)
        
        guard let previousFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame else {
            return currentItemAttributes
        }
        
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
        guard let  currentFrame = currentItemAttributes?.frame else {
            return currentItemAttributes
        }
        
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y:  currentFrame.origin.y, width: layoutWidth, height:  currentFrame.size.height)
        
        let  isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        
        if (isFirstItemInRow) {
            return leftAlignFrame(currentItemAttributes, sectionInset: sectionInset, maxWidth: layoutWidth)
        }
        
        guard var  frame = currentItemAttributes?.frame else {
            return currentItemAttributes
        }
        
        frame.origin.x = previousFrameRightPoint + self.evaluatedMinimumInteritemSpacing(of: indexPath.section)
        
        currentItemAttributes?.frame = frame
        
        return currentItemAttributes
    }
    
    fileprivate func evaluatedMinimumInteritemSpacing(of section:Int) -> CGFloat {
        guard let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout,let minSpacing = delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) else {
            return self.minimumInteritemSpacing
        }
        return minSpacing
    }
    
    fileprivate  func  evaluatedSectionInset(of section:Int) -> UIEdgeInsets {
        
        guard let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout,let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) else {
            
            return self.sectionInset
        }
        //        self.scrollDirection == .horizontal
        
        return inset
    }
    
    fileprivate  func leftAlignFrame(_ attributes:UICollectionViewLayoutAttributes? ,sectionInset:UIEdgeInsets,maxWidth:CGFloat) ->  UICollectionViewLayoutAttributes?{
        guard var frame = attributes?.frame else {
            return attributes
        }
        frame.origin.x = sectionInset.left
        /// 判断最大边界
        if frame.width >= maxWidth {frame.size.width = maxWidth}
        attributes?.frame = frame
        return attributes
    }
    
}

