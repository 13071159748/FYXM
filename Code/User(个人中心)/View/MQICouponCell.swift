//
//  MQICouponCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let GYCouponCellLeftSpace: CGFloat = 10

class MQICouponCell: MQITableViewCell {

    public var eachCouponView: MQIEachCouponView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configUI() {
        eachCouponView = MQIEachCouponView(frame: CGRect.zero)
        contentView.addSubview(eachCouponView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eachCouponView.frame = CGRect(x: GYCouponCellLeftSpace,
                                      y: 5,
                                      width: contentView.width-2*GYCouponCellLeftSpace,
                                      height: contentView.height-10)
    }
    
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        let width = screenWidth-2*GYCouponCellLeftSpace
        let height = MQIEachCouponView.getEachCouponViewSize(width).height
        return height+10
    }
}
