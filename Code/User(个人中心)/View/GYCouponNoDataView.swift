//
//  GYCouponNoDataView.swift
//  Reader
//
//  Created by CQSC  on 2017/8/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYCouponNoDataView: UIView {

    @IBOutlet weak var deTitleLabel: UILabel!
    
    open var pushUnvaildCouponVC: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTGR(self, action: #selector(GYCouponNoDataView.deTitleAction), view: deTitleLabel)
    }

    
    @objc func deTitleAction() {
        pushUnvaildCouponVC?()
    }
}
