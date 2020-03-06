//
//  MQIUserDetailIconCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserDetailIconCell: MQITableViewCell {

    let titleFont = UIFont.systemFont(ofSize: (15*mqscale > 18 ? 18 : 15*mqscale))
    var nextImg:UIImageView?
    
    var icoBacColor = UIColor.red
    var UDUser:MQIUserModel! {
        didSet{
            
          
            infoHeaderIcon.sd_setImage(with: URL(string: UDUser.user_avatar.replacingOccurrences(of: " ", with: "")),
                                       placeholderImage: UIImage(named: "mine_header"),
                                       options: .allowInvalidSSLCertificates,
                                       completed: { (i, error, type, u) in
            })
          
        }
    }
    var infoTitle:UILabel!
    var infoHeaderIcon:UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    func configUI() {
        infoTitle = UILabel(frame: CGRect.zero)
        infoTitle.font = titleFont
        infoTitle.textAlignment = .left
        infoTitle.textColor = UIColor.colorWithHexString("#2E2F35")
        contentView.addSubview(infoTitle)
        
        infoHeaderIcon = UIImageView(frame: CGRect.zero)
        infoHeaderIcon.backgroundColor = icoBacColor
        infoHeaderIcon.image = UIImage(named: "mine_header")
        contentView.addSubview(infoHeaderIcon)
        infoHeaderIcon.layer.cornerRadius = 28
        infoHeaderIcon.clipsToBounds = true
        addUserInfoNext()
    }
    func addUserInfoNext() {
//        let nextImg = UIImageView(frame: CGRect (x: screenWidth - 30, y: 0, width: 12, height: 15))
//        nextImg.image = UIImage.init(named: "arrow_right")
//        nextImg.centerY = 96.5/2
//        contentView.addSubview(nextImg)
//        self.nextImg = nextImg
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        infoTitle.frame = CGRect (x: 23, y: 0, width: 150, height: 96.5)
        infoHeaderIcon.frame = CGRect (x: self.width - 40-56, y: 0, width: 56, height: 56)
        infoHeaderIcon.centerY = self.height*0.5
        infoTitle.centerY =  infoHeaderIcon.centerY
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                infoHeaderIcon.backgroundColor = icoBacColor
 
        
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        infoHeaderIcon.backgroundColor = icoBacColor
        
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 72
    }
    
    
}


class MQIUserDetailCell: MQITableViewCell {
    let titleFont = UIFont.systemFont(ofSize: 16)
    let contentFont = UIFont.systemFont(ofSize: 14)
    var infoTitle:UILabel!
    var contentsBtn:UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    func configUI() {
        infoTitle = UILabel(frame: CGRect.zero)
        infoTitle.font = titleFont
        infoTitle.textAlignment = .left
        infoTitle.textColor = UIColor.colorWithHexString("#333333")
        contentView.addSubview(infoTitle)
        infoTitle.frame = CGRect (x: 23, y: 0, width: 100, height: 45.5)
        
        
        contentsBtn = UIButton()
        contentsBtn.titleLabel?.font = contentFont
        contentsBtn.contentHorizontalAlignment = .right
        contentsBtn.imageView?.contentMode = .scaleAspectFit
        contentsBtn.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
        contentView.addSubview(contentsBtn)
        contentsBtn.frame = CGRect (x: infoTitle.maxX + 20, y: 15, width: screenWidth - (infoTitle.maxX + 20 )-40, height: 20)
        contentsBtn.isUserInteractionEnabled = false
       
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        contents.frame = CGRect (x: infoTitle.maxX + 20, y: 0, width: screenWidth - (infoTitle.maxX + 20 + 20), height: 45.5)
        
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 50
    }
    func addUserInfoNext() {
        let nextImg = UIImageView(frame: CGRect (x: screenWidth - 30, y: 0, width: 12, height: 15))
        nextImg.image = UIImage.init(named: "arrow_right")
        nextImg.centerY = 50/2
        contentView.addSubview(nextImg)
    }
}


class MQIUserInfoLoginOutCell: MQITableViewCell {
    
    var outBtn: UIButton!
    
    var toLoginOut: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        self.selectionStyle = .none
     
        outBtn = createButton(CGRect.zero,
                              normalTitle: kLocalized("SwitchAccount"),
                              normalImage: nil,
                              selectedTitle: nil,
                              selectedImage: nil,
//                              normalTilteColor: mainColor,
                              normalTilteColor: kUIStyle.colorWithHexString("ffffff"),
                              selectedTitleColor: nil,
                              bacColor: UIColor.colorWithHexString("#7187FF"),
                              font: systemFont(16),
                              target: self,
                              action: #selector(MQIUserInfoLoginOutCell.loginOutAction))
        outBtn.layer.cornerRadius = 20
        outBtn.layer.masksToBounds = true
//        outBtn.layer.borderColor = mainColor.cgColor
//        outBtn.layer.borderColor = kUIStyle.colorWithHexString("#EFEFEF").cgColor
//        outBtn.layer.borderWidth = 1
        contentView.addSubview(outBtn)
    }
    
   @objc func loginOutAction() {
        toLoginOut?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outBtn.frame = CGRect(x: (self.bounds.width-190)/2, y: 70, width: 190, height: 40)
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 110
    }
}
