//
//  YPBannerView.swift
//  YPFinance
//
//  Created by ZMJ on 2019/6/28.
//  Copyright © 2019 YeePBank. All rights reserved.
//

import UIKit
//import Kingfisher

enum YPBannerScrollDirection {
    case Horizontal, Vertical
}

enum YPBannerDataType {
    case ImageData, TextData
}

class YPBannerView: UIView {
    
    var textColor: UIColor = UIColor.colorWithHexString("#7187FF")
    var textFont: UIFont = kUIStyle.boldSystemFont1PXDesignSize(size: 12)
    var placeholder: String?
    var duration = 4.0
    var selectHandler: ((IndexPath)->())?
    var dataArray: [String]? {
        didSet {
            guard dataArray!.count > 1 else {
                collectionView.isScrollEnabled = false
                return
            }
            scrollTo(currentPage: 0 + 1 , animated: false)
            if isAutoScroll == true {
                addTimer()
            }
            pageControl.numberOfPages = (dataArray?.count)!
            collectionView.reloadData()
        }
    }
    var scrollDirection: YPBannerScrollDirection = .Horizontal {
        didSet {
            if scrollDirection == .Horizontal {
                layout.scrollDirection = .horizontal
            } else {
                layout.scrollDirection = .vertical
                pageControl.removeFromSuperview()
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    var dataType: YPBannerDataType = .TextData
    var isAutoScroll = true
    
    private let cellID = "bannerCell"
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var timer: Timer?

    lazy fileprivate var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize.init(width: frame.size.width, height: frame.size.height)
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    
    func setupConfig() {
//        backgroundColor = UIColor.white
        setupCollectionView()
        setupPageControl()
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.register(YPBannerCollectionCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
    }
    
    fileprivate func setupPageControl() {
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: frame.size.height - 22, width: frame.size.width, height: 22))
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.contentHorizontalAlignment = .center
        addSubview(pageControl)
        pageControl.hidesForSinglePage = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = CGSize.init(width: frame.size.width, height: frame.size.height)
        pageControl.frame = CGRect.init(x: 0, y: frame.size.height - 22, width: frame.size.width, height: 22)
        collectionView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview != nil else {
            return
        }
        super.willMove(toSuperview: newSuperview)
        if dataArray == nil {
            return
        }
        guard (dataArray?.count)! > 1 else {
            collectionView.isScrollEnabled = false
            return
        }
        scrollTo(currentPage: 0 + 1 , animated: false)
        if isAutoScroll == true {
            addTimer()
        }
    }
    
    fileprivate func addTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func nextPage() {
        if (dataArray?.count)! > 1 {
            var currentPage = 0
            if scrollDirection == .Horizontal {
                currentPage = lroundf(Float(collectionView.contentOffset.x / frame.size.width))
            } else {
                currentPage = lroundf(Float(collectionView.contentOffset.y / frame.size.height))
            }
            scrollTo(currentPage: currentPage + 1, animated: true)
        }
    }
    
    fileprivate func scrollTo(currentPage: Int, animated: Bool) {
        if scrollDirection == .Horizontal {
            collectionView.setContentOffset(CGPoint.init(x: frame.size.width * CGFloat(currentPage), y: 0), animated: animated)
        } else {
            collectionView.setContentOffset(CGPoint.init(x: 0, y: frame.size.height * CGFloat(currentPage)), animated: animated)
        }
    }
}

extension YPBannerView: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataArray?.count {
            if count > 1 {
                return count + 2
            }
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! YPBannerCollectionCell
        cell.placeholder = placeholder
        cell.textFont = textFont
        cell.textColor = textColor
//        switch dataType {
//        case .ImageData:
//            cell.imgUrl = dataArray?[actualDataIndexPath(indexPath).item]
//        case .TextData:
            cell.textString = dataArray?[actualDataIndexPath(indexPath).item]
//        }
        
        return cell
    }
    
    func actualDataIndexPath(_ indexPath: IndexPath) -> IndexPath{
        
        if let array = dataArray {
            if indexPath.row == 0 {
                return IndexPath(item: array.count - 1, section: 0)
            } else if indexPath.row == array.count + 1 {
                return IndexPath(item: 0, section: 0)
            } else {
                return IndexPath(item: indexPath.item - 1, section: 0)
            }
        }
        return indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let handler = selectHandler {
            handler(actualDataIndexPath(indexPath))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = CGFloat(0)
        if scrollDirection == .Horizontal {
            offset = scrollView.contentOffset.x
        } else {
            offset = scrollView.contentOffset.y
        }
        
        let x = scrollDirection == .Horizontal ? frame.size.width : frame.size.height
        
        if offset == 0 {
            
            scrollTo(currentPage: (dataArray?.count)!, animated: false)
            pageControl.currentPage = (dataArray?.count)! - 1
            
        } else if offset == CGFloat((dataArray?.count)! + 1) * x {
            
            scrollTo(currentPage: 1, animated: false)
            pageControl.currentPage = 0
        } else {
            let distance = scrollDirection == .Horizontal ? frame.size.width : frame.size.height
            pageControl.currentPage = lroundf(Float(offset / distance)) - 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // pause
        timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // resume
        timer?.fireDate = Date.init(timeIntervalSinceNow: duration)
    }
}


fileprivate class YPBannerCollectionCell: UICollectionViewCell {
    
    var textColor: UIColor! {
        didSet {
            lable.textColor = textColor
        }
    }
    
    var textFont: UIFont! {
        didSet {
            lable.font = textFont
        }
    }
    var placeholder: String?
    var imgView: UIImageView!
    var lable: UILabel!
//    var imgUrl: String? {
//        didSet {
//            guard let string = imgUrl else { return }
//            let url = URL(string: string)
//            imgView.kf.setImage(with: url, placeholder: UIImage(named: placeholder ?? "nil"))
//            lable.isHidden = true
//            imgView.isHidden = false
//            imgView.contentMode = .scaleAspectFill
//        }
//    }
    var textString: String? {
        didSet {
            lable.text = textString ?? ""
            imgView.isHidden = true
            lable.isHidden = false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.white
        setupContent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupContent()
    }
    
    fileprivate func setupContent() {
        
        imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imgView)
        imgView.contentMode = .center
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "home_banner_default")
        
        lable = UILabel(frame: CGRect.init(x: 0, y: 0, width: frame.size.width - 30, height: frame.size.height))
        contentView.addSubview(lable)
    }
}
