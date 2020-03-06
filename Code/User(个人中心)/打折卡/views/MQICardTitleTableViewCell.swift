//
//  MQICardTitleTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardBaseTableViewCell: MQITableViewCell  {
    var bacImge:UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        bacImge = UIImageView()
        contentView.addSubview(bacImge)
        bacImge.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(card_LeftMargin)
            make.right.equalToSuperview().offset(-card_LeftMargin)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   open func setupUI()  {}
}



class MQICardTitleTableViewCell: MQICardBaseTableViewCell  {

    var subTitle : UILabel!

    override func setupUI()  {
        bacImge.image = UIImage(named: "Card_top_bg")
        bacImge.snp.updateConstraints { (make)in
            make.top.equalToSuperview().offset(12)
        }
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = UIColor.colorWithHexString("#2C2B40")
        title.textAlignment = .center
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(bacImge).offset(10)
            make.right.equalTo(bacImge).offset(-10)
            make.top.equalTo(bacImge).offset(20)
        }
        
        let subBacView = UIView()
        subBacView.backgroundColor = UIColor.colorWithHexString("#DBEBFF")
        contentView.addSubview(subBacView)
        
        title.text = kLocalized("Average_annual_savings_for_users")
        subTitle = UILabel()
        subTitle.font = UIFont.boldSystemFont(ofSize: 22)
        subTitle.textColor = mainColor
        subTitle.textAlignment = .center
        contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(2)
        }
      
        subBacView.snp.makeConstraints { (make) in
            make.left.equalTo(subTitle).offset(-10)
            make.right.equalTo(subTitle).offset(10)
            make.bottom.equalTo(subTitle)
            make.height.equalTo(subTitle).multipliedBy(0.3)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 100
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
