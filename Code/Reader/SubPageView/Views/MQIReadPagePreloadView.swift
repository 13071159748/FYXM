//
//  MQIReadPagePreloadView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadPagePreloadView: UIView {
    
    open var activityView: UIActivityIndicatorView!
    fileprivate var loadLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0)
//TODO:  去掉在加载是不可交互状态 1.0.2新增 如若阅读器崩溃上升请还原这个代码
//        self.isUserInteractionEnabled = false
        activityView = UIActivityIndicatorView(style: .white)
        activityView.center = self.center
        self.addSubview(activityView)
        
        if GYReadStyle.shared.styleModel.bookThemeIndex == 3 ||
            GYReadStyle.shared.styleModel.bookThemeIndex == 0 {
            activityView.style = .gray
        }
        loadLabel = UILabel(frame: CGRect (x: 0, y: activityView.maxY + 10, width: screenWidth, height: 18))
        loadLabel.textColor = GYReadStyle.shared.styleModel.themeModel.statusColor
        loadLabel.text = kLocalized("Loadingin")
        self.addSubview(loadLabel)
        loadLabel.textAlignment = .center
        activityView.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.center = self.center
    }
    
    deinit {
        activityView.stopAnimating()
    }
    
}
