//
//  MQIBookTypeBannerCollectionCellABC.swift
//  CQSC
//
//  Created by moqing on 2019/8/29.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIBookTypeBannerCollectionCellABC: MQICollectionViewCell {
 var gdNewBannerView:NewPagedFlowView!
    
    /// 数据
    var banners = [MQIMainEachRecommendModel](){
        didSet(oldValue) {
            gdNewBannerView?.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
    }
    
    func setupUI()  {
        
        gdNewBannerView = NewPagedFlowView(frame:  CGRect (x: 0, y: 6, width: screenWidth-2*Book_Store_Manger, height: self.height-12))
        gdNewBannerView.delegate = self
        gdNewBannerView.dataSource = self
        gdNewBannerView.minimumPageAlpha = 0
        gdNewBannerView.isOpenAutoScroll = true
        gdNewBannerView.leftRightMargin = 0
        //      gdNewBannerView.dsySetCorner(radius: 8)
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = mainColor
//        pageControl.pageIndicatorTintColor = UIColor.colorWithHexString("D8D8D8")
//        gdNewBannerView.pageControl = pageControl
//        gdNewBannerView.addSubview(pageControl)
//        gdNewBannerView.backgroundColor = UIColor.white
//        pageControl.snp.makeConstraints { (make) in
//            make.bottom.equalTo(gdNewBannerView).offset(-10)
//            make.centerX.equalTo(gdNewBannerView)
//            make.height.equalTo(8)
//        }
        contentView.addSubview(gdNewBannerView)
    }
    static let bi:CGFloat = 100/320
    static let w = screenWidth-2*Book_Store_Manger
    class func getSize() -> CGSize {
        return CGSize(width:w, height:w*bi)
    }
    
}


extension MQIBookTypeBannerCollectionCellABC:NewPagedFlowViewDelegate,NewPagedFlowViewDataSource{
    func didSelectCell(_ subView: PGIndexBannerSubiew!, withSubViewIndex subIndex: Int) {
        gdbannerSelected(subIndex)
    }
    //    func sizeForPage(in flowView: NewPagedFlowView!) -> CGSize {
    //        return CGSize (width: bannerItemW, height: flowView.height)
    //    }
    func numberOfPages(in flowView: NewPagedFlowView!) -> Int {
        return banners.count
    }
    func flowView(_ flowView: NewPagedFlowView!, cellForPageAt index: Int) -> PGIndexBannerSubiew! {
        var bannerView = flowView.dequeueReusableCell()
        if bannerView == nil {
            bannerView = PGIndexBannerSubiew()
            bannerView?.tag = index
            bannerView!.mainImageView.contentMode = .scaleAspectFit
        }
        
        bannerView!.mainImageView.sd_setImage(with: URL(string:banners[index].image), placeholderImage: UIImage.init(named: banner_PlaceholderImg))
        return bannerView
        
    }
    
    //MARK:banner Click
    func gdbannerSelected(_ index:NSInteger) {
        if index < banners.count {
            MQIOpenlikeManger.openLike(banners[index].link)
        }

    }

}
