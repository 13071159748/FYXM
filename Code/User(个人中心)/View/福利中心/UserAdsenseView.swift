//
//  UserAdsenseView.swift
//  CQSC
//
//  Created by moqing on 2019/12/24.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import FSPagerView

class UserAdsenseView: UIView {
    var currentVC = UIViewController()
    
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.frame = CGRect(x: 20, y: 20, width: screenWidth - 40, height: 99)
        viewPager.dsySetCorner(radius: 6)
        viewPager.dataSource = currentVC as? FSPagerViewDataSource
        viewPager.delegate = currentVC as? FSPagerViewDelegate
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cellId")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //        //设置转场的模式
        //        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)

        return viewPager
    }()

    lazy var pagerControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: 50, y: 70, width: 80, height: 20))
        //设置下标的个数
        pageControl.numberOfPages = 8
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .selected)
        return pageControl

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()

    }

    func setupUI() {
        addSubview(viewPager)
        addSubview(pagerControl)
    }
}
