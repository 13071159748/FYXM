//
//  SectionFlowLayout.swift
//  SuperView
//
//  Created by L on 16/8/16.
//  Copyright © 2016年 c0ming. All rights reserved.
//

import UIKit


// SB = Section Background

private let SectionBackground = "SBCollectionReusableView"

protocol SBCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
    //设置需要变的section的背景颜色范围
    func gdCollectionView(_ collectionView:UICollectionView, section:Int) -> CGRect
}

extension SBCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.clear
    }
    func gdCollectionView(_ collectionView:UICollectionView, section:Int) -> CGRect{
        return CGRect(origin: CGPoint.zero, size: CGSize.zero)
    }
}

private class SBCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.white

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SBCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SBCollectionViewLayoutAttributes else {
            return false
        }
        
        if !self.backgroundColor.isEqual(rhs.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
}

private class SBCollectionReusableView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? SBCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
}

class SBCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    // MARK: - Init
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        // 1、注册
        self.register(SBCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }
    
    // MARK: -
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? SBCollectionViewDelegateFlowLayout
            else {
                return
        }
        
        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            var sectionFrame = firstItem.frame.union(lastItem.frame)
//            sectionFrame.origin.x = 10
            sectionFrame.origin.x = delegate.gdCollectionView(self.collectionView!, section: section).origin.x
            
            sectionFrame.origin.y -= sectionInset.top
            
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                let needWidth = delegate.gdCollectionView(self.collectionView!, section: section).size.width
                if needWidth > 0 {
                    sectionFrame.size.width = needWidth
                }else {
                    sectionFrame.size.width = self.collectionView!.frame.width
                }
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            // 2、定义
            let attr = SBCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            
            self.decorationViewAttrs.append(attr)
        }
    }
    //gd 1.返回rect中的所有的元素的布局属性
    //2. 返回的是包含UICollectionViewLayoutAttributes 的 array
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            return rect.intersects($0.frame)
        })
        return attrs // 3、返回
    }
    //gd 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SectionBackground {
            return self.decorationViewAttrs[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}

