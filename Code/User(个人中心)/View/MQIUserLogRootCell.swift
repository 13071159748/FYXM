//
//  MQIUserLogRootCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserLogRootCell: MQITableViewCell {

    var leftView: UIView!
    var rightView: UIView!
    
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    
    var titleLabel: UILabel!
    var coinLabel: UILabel!
    var preiumLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addcellContents()
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addcellContents()
        self.selectionStyle = .none
    }
    func addcellContents() {
        
        let dateFont = systemFont(16)
        let dateColor = UIColor.colorWithHexString("#666666")
        
        let timeFont = systemFont(12)
        let timeColor = UIColor.colorWithHexString("#999999")
        
        let titleFont = systemFont(14)
        let titleColor = UIColor.colorWithHexString("#333333")
        
        let coinFont = systemFont(15)
//        let coinColor = UIColor.colorWithHexString("#41B6D6")
         let coinColor = mainColor
        let viewColor = UIColor.colorWithHexString("#E5E5E5")
        contentView.addLine(15, lineColor: viewColor, directions: .bottom)
        leftView = UIView(frame: CGRect.zero)
        contentView.addSubview(leftView)
        leftView.addLine(5, lineColor: viewColor, directions: .right)
        
        
        rightView = UIView(frame: CGRect.zero)
        contentView.addSubview(rightView)
        
        dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.font = dateFont
        dateLabel.textColor = dateColor
        dateLabel.textAlignment = .center
        leftView.addSubview(dateLabel)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.font = timeFont
        timeLabel.textColor = timeColor
        timeLabel.textAlignment = .center
        leftView.addSubview(timeLabel)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.numberOfLines = 2
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        rightView.addSubview(titleLabel)
        
        coinLabel = UILabel(frame: CGRect.zero)
        coinLabel.font = coinFont
        coinLabel.textColor = coinColor
        coinLabel.textAlignment = .right
        rightView.addSubview(coinLabel)
        coinLabel.adjustsFontSizeToFitWidth = true
        preiumLabel = UILabel(frame: CGRect.zero)
        preiumLabel.font = coinFont
        preiumLabel.textColor = coinColor
        preiumLabel.textAlignment = .right
        rightView.addSubview(preiumLabel)
        preiumLabel.adjustsFontSizeToFitWidth = true
        //        coinLabel.backgroundColor = UIColor.yellow
        //        preiumLabel.backgroundColor = UIColor.yellow
        
    }
    override func layoutSubviews() {
        leftView.frame = CGRect (x: 0, y: 0, width: 80, height: self.height)
        rightView.frame = CGRect (x: leftView.maxX, y: 0, width: self.width - leftView.maxX, height: self.height)
        
        dateLabel.frame = CGRect (x: 0, y: (self.height - 40)/2, width: leftView.width, height: 20)
        timeLabel.frame = CGRect (x: 0, y: dateLabel.maxY, width: leftView.width, height: 20)
        coinLabel.frame = CGRect (x: rightView.width - 80, y: (self.height - 40)/2, width: 70, height: 20)
        preiumLabel.frame = CGRect (x: rightView.width - 80, y: coinLabel.maxY, width: coinLabel.width, height: 20)
        titleLabel.frame = CGRect (x: 14, y: 0, width: rightView.width - 14 - 80, height: 60)
    }
    override class func getHeight<T:MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 70
    }


}
