//
//  GYRMBaseView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMBaseView: UIView {
    
    /// 菜单
    weak var readMenu:GYReadMenu!
    
    lazy var style: GYReadStyle! = {
        return GYReadStyle.shared
    }()
    
    /// 初始化方法
    convenience init(readMenu:GYReadMenu) {
        
        self.init(frame:CGRect.zero,readMenu:readMenu)
    }
    
    /// 初始化方法
    init(frame:CGRect, readMenu:GYReadMenu) {
        
        self.readMenu = readMenu
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 初始化方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 添加子控件
    func addSubviews() {
        
        backgroundColor = GYMenuUIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

