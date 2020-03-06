//
//  MQICardRankCellTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardRankCellTableViewCell: MQICardBaseTableViewCell {

    var title:UILabel!
    var subTitle:UILabel!
    override func setupUI() {
        bacImge.isHidden = true
//        DSYDottedLineView * dottedLineView = [[DSYDottedLineView alloc]init];
//        dottedLineView.dashW = 10;
//        dottedLineView.dashSpacing = 3;
//        dottedLineView.dashColor = kColror88;
//        [dottedLineView setFrame:CGRectMake(kWSpacing5, _itemHeight, self.bounds.size.width-kWSpacing10, 1)];
//        [self addSubview:dottedLineView];
//
        let lineView = DSYDottedLineView()
        lineView.dashW = 5
        lineView.dashSpacing = 3
        lineView.dashColor =  UIColor.colorWithHexString("E3E6EE")
//        lineView.backgroundColor = UIColor.colorWithHexString("E3E6EE")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(card_LeftMargin2+5)
            make.right.equalToSuperview().offset(-card_LeftMargin2-5)
        }
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = UIColor.colorWithHexString("#333333")
        title.lineBreakMode = .byTruncatingMiddle
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(lineView)
            make.centerY.equalToSuperview()
        }
        subTitle = UILabel()
        subTitle.font = UIFont.systemFont(ofSize: 13)
        subTitle.textColor  = UIColor.colorWithHexString("#EB5567")
        subTitle.textAlignment = .left
        contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.right.lessThanOrEqualTo(lineView)
            make.left.greaterThanOrEqualTo(title.snp.right).priority(.low)
            make.left.equalTo(title.snp.right).priority(.high)
            
        }


        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 25
    }
    
}

