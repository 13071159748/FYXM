//
//  GYSearchHeader.swift
//  Reader
//
//  Created by CQSC  on 2017/6/8.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYSearchHeader: MQICollectionReusableView {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    var titleLable:UILabel!
    var cleanBtn:UIButton!
    var cleanBlock:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLable = UILabel()
        titleLable.font = kUIStyle.boldSystemFont1PXDesignSize(size: 15)
        titleLable.textColor = UIColor.black
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(leftImage)
        }
        cleanBtn = UIButton()
        cleanBtn.setImage(UIImage(named: "shelf_del_image"), for: .normal)
        cleanBtn.addTarget(self, action: #selector(clickCleanBtn), for: UIControl.Event.touchUpInside)
        cleanBtn.isHidden = true
        cleanBtn.imageView?.contentMode = .scaleAspectFit
        cleanBtn.contentHorizontalAlignment = .right
        self.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(cleanBtn)
            make.width.equalTo(100)
            make.height.equalToSuperview()
        }
        
    }
    @objc  func clickCleanBtn(){
        cleanBlock?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 45)
    }
}
