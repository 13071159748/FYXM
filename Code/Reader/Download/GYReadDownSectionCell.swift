//
//  GYReadDownSectionCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadDownSectionCell: UITableViewHeaderFooterView {

    public var baseView: GYReadDownBaseView!
    
    public var isSpread: Bool = false {
        didSet {
            baseView.transFromIcon(isSpread)
        }
    }
    
    var sparedBlock: ((_ spared: Bool) -> ())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        contentView.backgroundColor = UIColor.white
        
        baseView = GYReadDownBaseView(frame: contentView.bounds)
        baseView.addIcon()
        contentView.addSubview(baseView)
        
        baseView.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GYReadDownSectionCell.sparedAction), view: baseView)
        
        addLine(0, lineColor: GYReadDownVC_lineColor, directions: .bottom)
    }
    
    @objc func sparedAction() {
        isSpread = !isSpread
        sparedBlock?(isSpread)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.frame = contentView.bounds
    }
    
    class func getHeight() -> CGFloat {
        return 50
    }

}

class GYReadDownAllFinishSectionCell: GYReadDownSectionCell {
    override func configUI() {
        super.configUI()
        baseView.configDown()
        baseView.layoutSubviews()
    }
}
