//
//  MQIShadowImageView.swift
//  XSDQReader
//
//  Created by moqing on 2018/10/17.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

class MQIShadowImageView: UIView {
    var imageView:UIImageView!
    var radius:CGFloat = -1
    var isShadow = false
    var isShowTitle = false{
        didSet(oldValue) {
            titleBtn.isHidden = !isShowTitle
        }
    }
    var title:String?{
        didSet(oldValue) {
            titleBtn.setTitle(title, for: .normal)
            
        }
    }
    override var backgroundColor: UIColor?{
        didSet(oldValue) {
            self.imageView.backgroundColor  = backgroundColor
        }
    }
    fileprivate var titleBtn:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        createdCoverImage()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createdCoverImage()
    }
    
    func createdCoverImage()  {
        imageView = UIImageView()
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleBtn = UIButton()
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        titleBtn.setTitleColor(UIColor.white, for: .normal)
        addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(15)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        titleBtn.setBackgroundImage(UIImage(named: "level_index_img"), for: .normal)
        titleBtn.isHidden = !isShowTitle
        
        if isShadow {
            self.layer.shadowOpacity = 1
            self.layer.shadowColor = kUIStyle.colorWithHexString("000000", alpha: 0.2).cgColor
            self.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.layer.shadowRadius = 5
            self.clipsToBounds = false
            imageView.layer.masksToBounds = true
        }
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if radius > 0 {
            imageView.layer.cornerRadius = radius
        }
    }
    
    
}
