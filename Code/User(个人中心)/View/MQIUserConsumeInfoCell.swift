//
//  MQIUserConsumeInfoCell.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserConsumeInfoCell: MQIUserLogRootCell {
    var  is_batch:String = ""
    var consume: MQIEachConsumeInfo! {
        didSet {
            dateLabel.text = consume.cost_month2
            timeLabel.text = consume.cost_date
            
            titleLabel.text = consume.chapter_title
            if is_batch  != "" {
                if consume.coin != ""  &&   consume.coin != "0"{
                    coinLabel.text = consume.coin+COINNAME
                }
                if consume.premium != "" &&   consume.premium != "0"{
                    preiumLabel.text = consume.premium+COINNAME_PREIUM
                }
            }else{
                coinLabel.text = consume.coin+COINNAME
                preiumLabel.text = consume.premium+COINNAME_PREIUM
            }
            
            if MQIPayTypeManager.shared.isAvailable() {
                if consume.reduction_coin.integerValue() != 0 {
                    self.logoImg.isHidden = false
                }else{
                    self.logoImg.isHidden = true
                }
            }else{
                 self.logoImg.isHidden = true
            }

        }
        
    }
    
    var rightImg:UIImageView!
    var logoImg:UIImageView!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func addcellContents() {
        super.addcellContents()
        self.rightImg = UIImageView()
        self.rightImg.image = UIImage(named: "arrow_right")
        self.rightImg.contentMode = .scaleAspectFit
        self.rightView.addSubview( self.rightImg)
        
        self.logoImg = UIImageView()
        self.logoImg.image = UIImage(named: "dzk_z_img")
        self.logoImg.contentMode = .scaleAspectFit
        self.rightView.addSubview( self.logoImg)
        self.logoImg.isHidden = true
        
        
    }
    override func layoutSubviews() {
        
        if consume?.is_batch == "1" {
            leftView.frame = CGRect (x: 0, y: 0, width: 80, height: self.height)
            rightView.frame = CGRect (x: leftView.maxX, y: 0, width: self.width - leftView.maxX, height: self.height)
            dateLabel.frame = CGRect (x: 0, y: (self.height - 40)/2, width: leftView.width, height: 20)
            timeLabel.frame = CGRect (x: 0, y: dateLabel.maxY, width: leftView.width, height: 20)
            coinLabel.frame = CGRect (x: rightView.width - 110, y: (self.height - 40)/2, width: 70, height: 20)
            preiumLabel.frame = CGRect (x: rightView.width - 110, y: coinLabel.maxY, width: coinLabel.width, height: 20)
            if logoImg.isHidden {
                titleLabel.frame = CGRect (x: 14, y: 0, width: rightView.width - 14 - 80, height: 60)
            }else{
                logoImg.frame = CGRect (x: 2, y: 0, width: 20, height: 20)
                titleLabel.frame = CGRect (x: logoImg.maxX+2, y: 0, width: rightView.width - logoImg.maxX-2 - 80, height: 60)
                 logoImg.centerY = titleLabel.centerY
            }
           
            rightImg.frame = CGRect (x: rightView.width-30, y: coinLabel.maxY, width:20, height: 20)
            rightImg.centerY = rightView.centerY
            
            
        }else{
            super.layoutSubviews()
            if logoImg.isHidden {
                titleLabel.frame = CGRect (x: 14, y: 0, width: rightView.width - 14 - 80, height: 60)
            }else{
                logoImg.frame = CGRect (x: 2, y: 0, width: 20, height: 20)
                titleLabel.frame = CGRect (x: logoImg.maxX+2, y: 0, width: rightView.width - logoImg.maxX-2 - 80, height: 60)
                 logoImg.centerY = titleLabel.centerY
            }
            
        }
    }
    
}
