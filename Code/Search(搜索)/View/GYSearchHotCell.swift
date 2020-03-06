//
//  GYSearchHotCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/8.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYSearchHotCell: MQICollectionViewCell {

    var hotView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        addTitleLabel()
        self.backgroundColor = UIColor.colorWithHexString("F4F4F5")
        titleLabel!.textAlignment = .center
        self.dsySetCorner(radius: 13)
        titleLabel?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func addHot() {
//        if hotView == nil {
//            hotView = UIImageView(frame: CGRect(x: 0, y: (self.height-20)/2, width: 20, height: 20))
//            hotView!.image = UIImage(named: "search_hot")
//            self.addSubview(hotView!)
//        }
//        titleLabel!.frame = CGRect(x: hotView!.maxX+2,
//                                  y: 0,
//                                  width: self.width-hotView!.maxX-2,
//                                  height: self.height)
//        titleLabel!.frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: self.width,
//                                   height: self.height)
        titleLabel?.textColor = UIColor.colorWithHexString("FF4E5E")
    }
    
    func removeHot() {
//        if let _ = hotView {
//            hotView?.removeFromSuperview()
//            hotView = nil
//        }
//        titleLabel!.frame = self.bounds
        titleLabel?.textColor = UIColor.colorWithHexString("A9A9B0")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        
    }

    class func getSize(key: MQIEaMQIeyword, index: Int) -> CGSize {
        let titleFont = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
        let width = getAutoRect(key.key, font: titleFont, maxWidth: CGFloat(MAXFLOAT), maxHeight: titleFont.pointSize+10).size.width
        if index == 0 || index == 1 {
            return CGSize(width: width+15, height: titleFont.pointSize+10)
        }else {
            return CGSize(width: width+15, height: titleFont.pointSize+10)
        }

    }

    class func getSize2(key: String) -> CGSize {
        let titleFont = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
        let width =   kUIStyle.getTextSizeWidth(text: key, font: titleFont, maxHeight:  titleFont.pointSize+10)
        var  newW = width+15
     
        if newW < 40 {newW = 40}
        return CGSize(width: newW, height: titleFont.pointSize+10)
    }

}
