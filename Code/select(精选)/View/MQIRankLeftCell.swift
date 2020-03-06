//
//  GDRankLeftCell.swift
//  Reader
//
//  Created by _CHK_  on 2018/1/19.
//  Copyright © 2018年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIRankLeftCell: MQITableViewCell {
    
    var celltitleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addCellView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addCellView() {
        celltitleLabel = UILabel(frame: CGRect.zero)
        celltitleLabel.textColor = UIColor.colorWithHexString("#17191E")
        celltitleLabel.font = systemFont(15)
        celltitleLabel.textAlignment = .center
        contentView.addSubview(celltitleLabel)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        celltitleLabel.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        //        super.setHighlighted(highlighted, animated: animated)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        celltitleLabel.backgroundColor = UIColor.white
        
        // Configure the view for the selected state
    }
    
}
