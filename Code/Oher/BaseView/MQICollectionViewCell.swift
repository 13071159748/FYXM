//
//  MQICollectionViewCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQICollectionViewCell: UICollectionViewCell {

    var titleLabel: UILabel?
    var disclosureIndicator: UIImageView?

    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
    var bottomLine: GYLine?

    var rightSpace: CGFloat = 0
    let left: CGFloat = 15
    let space: CGFloat = 10

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func addTitleLabel() {
        if titleLabel == nil {
            titleLabel = createLabel(CGRect(x: left, y: 0, width: self.bounds.width - 2 * left, height: self.bounds.height), font: titleFont, bacColor: nil, textColor: blackColor, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: nil)
            self.addSubview(titleLabel!)
        }
    }

    func addBottomLine() {
        if bottomLine == nil {
            bottomLine = GYLine(frame: CGRect.zero)
            self.addSubview(bottomLine!)
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
    }

    func addDisclosureIndicator() {
        let dSide: CGFloat = 15
        disclosureIndicator = UIImageView(image: UIImage(named: "arrow_right"))
        self.addSubview(disclosureIndicator!)

        disclosureIndicator!.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator!.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp.right).offset(-space)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(dSide)
            make.height.equalTo(dSide)
        }

        if let titleLabel = titleLabel {
            titleLabel.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(self.snp.left).offset(left)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(disclosureIndicator!).offset(-space)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomLine?.frame = CGRect(x: space, y: self.bounds.height - gyLine_height, width: self.bounds.width - space - rightSpace, height: gyLine_height)
        
    }
}
