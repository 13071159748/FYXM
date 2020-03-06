//
//  MQIUserInfoHeaderView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserInfoHeaderView: UIView {

    var nameLabel:UILabel!
    var user_idLabel:UILabel!
    var headIconImg:UIImageView!
    var tapActionBlock:(() -> ())?
    var tapActionPayBlock:(() -> ())?
    var tapActionSignBlock:(() -> ())?
    var tapActionCardBlock:(() -> ())?
    var tapActionGivingBlock:(() -> ())?
    var loginLabel:UILabel!
    var idLabel:UILabel!
//    var dateLabel:UILabel!
//    var vipLabel:UILabel!
    var coinLabel:UILabel!
    var premiumLabel:UILabel!
    var coinTitleLabel:UILabel!
    var premiumTitleLabel:UILabel!
    var payBtnLabel:UILabel!
    var signBtnLabel:UILabel!
    var signLable:UILabel!
    var signImage:UIImageView!
    var vipImage:UIImageView!
    
    var topBackView: UIView!
    var dcImage: UIImageView!
//    var line: UIView!
    var describeVie :UserHeaderDescribeView!
    
    var isLogin:Bool = false {
        didSet{
            if !isLogin {
                nameLabel.isHidden = true
                idLabel.isHidden = false
//                dateLabel.isHidden = true
                loginLabel.isHidden = false
//                vipLabel.isHidden = true
                headIconImg.image = UIImage(named: "mine_header")
//                idLabel.text = "编辑个人资料"
                coinLabel.text = "0"
                premiumLabel.text = "0"
                signLable.text = kLocalized("SignIn")
                signImage.image = UIImage(named: "CHK_info_Sign_sel_image")
                vipImage?.isHidden = true
                dcImage?.isHidden = true
            }else {
                nameLabel.isHidden = false
//                vipLabel.isHidden = false
                idLabel.isHidden = false
//                dateLabel.isHidden = false
                loginLabel.isHidden = true
                headIconImg.image = UIImage(named: "mine_header")
                idLabel.text = ""
                coinLabel.text = "0"
                premiumLabel.text = "0"
                signLable.text = kLocalized("SignIn")
                signImage.image = UIImage(named: "CHK_info_Sign_sel_image")
                vipImage?.isHidden = false
                dcImage?.isHidden = false
            }
              loginLabel.text = kLocalized("NotLoggedIn")
              coinTitleLabel.text = COINNAME
              premiumTitleLabel.text = COINNAME_PREIUM
              reloadView()
        }
        
        
    }
    
    var user: MQIUserModel! {
        didSet{
            headIconImg.sd_setImage(with: URL(string: user.user_avatar),
                                    placeholderImage: UIImage(named: "mine_header"),
                                    options: .allowInvalidSSLCertificates,
                                    completed: { (i, error, type, u) in
                                        
            })
            nameLabel.text = user.user_nick
//            idLabel.text = "ID: "+user.user_id
            coinLabel.text = user.user_coin
            premiumLabel.text = user.user_premium
            if user.sign_in {
                signLable.text = kLocalized("AlreadySignedIn")
               signImage.image = UIImage(named: "CHK_info_Sign_image")
            }else{
                signLable.text = kLocalized("SignIn")
                signImage.image = UIImage(named: "CHK_info_Sign_sel_image")
            }
            
            vipImage.image = user.user_vip_level.int32Value() > 0 ?   UIImage(named: "super_vip") : UIImage(named: "general_vip")
            
        }
    }
    
    
    
    func reloadView() {
      
        if  !MQIPayTypeManager.shared.isAvailable() {
            describeVie.isHidden = true
            dcImage.isHidden =  true
            return
        }
      
        let dc = MQIUserDiscountCardInfo.default
        if dc?.isVip ?? false {
            dcImage.isHidden =  false
        }else{
            dcImage.isHidden =  true
        }
        describeVie.isHidden = false
        describeVie.titie.text =  dc?.desc
        


        if dc?.cardState == "1" {
            describeVie.clickBtn.setTitle(kLocalized("Immediately_a_renewal"), for: .normal)
            describeVie.bacImg.image = UIImage(named: "dzk_bg2_img")
        }else if  dc?.cardState == "2" {
            describeVie.clickBtn.setTitle(kLocalized("Check_it_now"), for: .normal)
            describeVie.bacImg.image = UIImage(named: "dzk_bg1_img")
        }else{
            describeVie.clickBtn.setTitle(kLocalized("Open_immediately"), for: .normal)
            describeVie.bacImg.image = UIImage(named: "dzk_bg2_img")
            if  describeVie.titie.text == nil ||  describeVie.titie.text?.count == 0 {
                describeVie.titie.text = kLongLocalized("开通打折卡8折看全站", replace: "开通打折卡 8折看全站")
            }
        }
        if !MQIUserManager.shared.checkIsLogin() {
            describeVie.titie.text = kLongLocalized("subscribeReadthewhole_station", replace: "开通畅读打折卡")
        }
     
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createInfoHeaderViewNew()
    }
    
    @objc func moneyCell_GoPay(tap:UITapGestureRecognizer) {
        if tap.view?.tag == 100 {
           tapActionPayBlock?()
        }else{
            tapActionGivingBlock?()
        }
        
    }
    @objc func moneyCell_GoSign(_ button:UIButton) {
        tapActionSignBlock?()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createInfoHeaderViewNew() {
        self.backgroundColor  = UIColor.colorWithHexString("F4F7FA")
      
        topBackView = UIImageView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: self.height-10))
        topBackView.isUserInteractionEnabled = true
        topBackView.backgroundColor = UIColor.white
        addTGR(self, action: #selector(MQIUserInfoHeaderView.infoHeaderTap), view: topBackView)
        self.addSubview(topBackView)
        
        let bottomView =  createMoneyView(frame: CGRect(x:0, y: self.height-64-20, width: screenWidth, height: 64))
        addSubview(bottomView)
        
        
        let iconW:CGFloat = kUIStyle.scale1PXW(76)
        
        headIconImg = UIImageView(frame: CGRect (x: 21, y:10+x_statusBarAndNavBarHeight, width: iconW, height: iconW))
        headIconImg.layer.cornerRadius = iconW*0.5
        headIconImg.clipsToBounds = true
        headIconImg.image = UIImage(named: "mine_header")
        topBackView.addSubview(headIconImg)
//        headIconImg.centerX = topBackView.width*0.5
      
        let nameFont:CGFloat =  kUIStyle.size1PX(18)
        nameLabel = createLabel(CGRect (x:  headIconImg.maxX+10, y: headIconImg.maxY + 7, width: self.width-headIconImg.maxX-20, height: nameFont), font: UIFont.boldSystemFont(ofSize: nameFont), bacColor: UIColor.clear, textColor: kUIStyle.colorWithHexString("1C1C1E"), adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: 1)
        nameLabel.text = ""
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8;
        topBackView.addSubview(nameLabel)
        nameLabel.maxY = headIconImg.centerY-5
        
        
        loginLabel = UILabel (frame: nameLabel.frame)
        loginLabel.text = kLocalized("NotLoggedIn")
        loginLabel.textColor = kUIStyle.colorWithHexString("#1C1C1E")
        loginLabel.font = UIFont.boldSystemFont(ofSize: nameFont)
        loginLabel.textAlignment = .left
        topBackView.addSubview(loginLabel)
        loginLabel.isHidden = true
        loginLabel.centerY = headIconImg.centerY
        
        idLabel = UILabel (frame: CGRect(x: nameLabel.x, y: nameLabel.maxY+10, width: nameLabel.width, height: 16))
        idLabel.textColor = kUIStyle.colorWithHexString("#1C1C1E")
        idLabel.font = UIFont.systemFont(ofSize: 12)
        idLabel.textAlignment = .left
        topBackView.addSubview(idLabel)
        idLabel.y = nameLabel.maxY+2
        
        vipImage =  UIImageView()
        vipImage.contentMode = .scaleAspectFit
        topBackView.addSubview(vipImage)
        vipImage.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(19)
            make.width.equalTo(51)
            make.left.equalTo(nameLabel)
        }
        
        dcImage =  UIImageView()
        dcImage.image = UIImage(named: "dc_icon")
        dcImage.contentMode = .scaleAspectFit
        topBackView.addSubview(dcImage)
        dcImage.snp.makeConstraints { (make) in
            make.left.equalTo(vipImage.snp.right).offset(5)
            make.centerY.width.height.equalTo(vipImage)
        }
        
        describeVie = UserHeaderDescribeView()
        describeVie.backgroundColor = UIColor.white
        topBackView.addSubview(describeVie)
        describeVie.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.88267)
            make.height.equalTo(topBackView.snp.width).multipliedBy(0.0933)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        describeVie.isHidden = dcImage.isHidden
        describeVie.clickBlock = { [weak self] in
            self?.tapActionCardBlock?()
        }
      
        reloadView()
       
    }
    

    
    func createMoneyView(frame:CGRect) -> UIView{
        let bottomView = UIView(frame: frame)
//        bottomView.layer.shadowOpacity = 1
//        bottomView.layer.shadowColor = UIColor.colorWithHexString("D6D6D6", alpha: 1).cgColor
//        bottomView.layer.shadowOffset = CGSize(width: 0, height:3 )
//        bottomView.layer.shadowRadius = 4
//        bottomView.clipsToBounds = false
      
        
        let  bacView = UIView(frame: bottomView.bounds)
//        bacView.layer.cornerRadius = 5
        bacView.backgroundColor = UIColor.white
        bottomView.addSubview(bacView)
        
        let vWidth = bottomView.width / 3
        let vheight = bottomView.height
        for i in 0..<3 {
            let rect = CGRect (x: vWidth * CGFloat(i) ,y: 0, width: vWidth, height: vheight)
            if i==0 {
                let r = createCoinView(rect,title: COINNAME,superView: bottomView, tag: 100)
                coinLabel = r.0
                coinTitleLabel = r.1
            }else if i == 1{
                 let r = createCoinView(rect,title: COINNAME_PREIUM,superView: bottomView, tag: 101)
                premiumLabel = r.0
                premiumTitleLabel =  r.1
            }else {
                let  signView = createSignBtn(rect,superView: bottomView)
                signLable = signView.0
                signImage = signView.1
             
            }
        }
       
        let  lineView1   = UIView(frame: CGRect(x: coinLabel.maxX, y: 0, width: 1, height: 32))
        lineView1.backgroundColor = UIColor.colorWithHexString("D4D7EA")
        bottomView.addSubview(lineView1)
        lineView1.centerY = bottomView.height*0.5
        
        let  lineView2   = UIView(frame: CGRect(x: premiumLabel.maxX, y: 0, width: 1, height: 32))
        lineView2.backgroundColor = UIColor.colorWithHexString("D4D7EA")
        bottomView.addSubview(lineView2)
        lineView2.centerY = lineView1.centerY
        
        return bottomView
    }
    
   @objc func infoHeaderTap() {
        tapActionBlock?()
    }
    @discardableResult func createSignBtn(_ rect:CGRect,superView:UIView) -> (UILabel,UIImageView){
        let superBtn = UIButton(type: .custom)
        superBtn.frame = rect
        superBtn.addTarget(self, action: #selector(moneyCell_GoSign(_:)), for: .touchUpInside)
        superView.addSubview(superBtn)
        
        let messageFont = kUIStyle.sysFontDesign1PXSize(size: 14)
        let messageLabel = UILabel (frame: CGRect (x: 0, y: rect.height-messageFont.pointSize-8, width: messageFont.pointSize*5, height: messageFont.pointSize+5))
        messageLabel.font = messageFont
        messageLabel.textColor = UIColor.colorWithHexString("9DA0A9")
        messageLabel.textAlignment = .center
        messageLabel.text = kLocalized("SignIn")
        superBtn.addSubview(messageLabel)
//        messageLabel.dsySetCorner(radius: 5)
//        messageLabel.backgroundColor = UIColor.colorWithHexString("F65F59")
        
        let icon = UIImageView(frame: CGRect (x: 0, y: messageLabel.y, width: 17, height: 19))
        icon.image = UIImage.init(named: "CHK_info_Sign_sel_image")
        icon.contentMode = .scaleAspectFit
        superBtn.addSubview(icon)
        icon.centerX = rect.width*0.5
        messageLabel.centerX =   icon.centerX
        messageLabel.y = rect.height*0.5+2
        icon.maxY = rect.height*0.5
        return (messageLabel,icon)
    }
    

    @discardableResult func createCoinView(_ rect:CGRect,title:String,superView:UIView,tag:Int) -> (UILabel,UILabel){
   
        let moneyFont = kUIStyle.sysFontDesign1PXSize(size: 18)
        let moneyLabel = UILabel (frame: CGRect (x: rect.origin.x, y: 15, width:rect.size.width, height: moneyFont.pointSize+5))
        moneyLabel.textAlignment = .center
        moneyLabel.text = "0"
        moneyLabel.font = moneyFont
        moneyLabel.textColor = UIColor.colorWithHexString("1C1C1E")
        
        superView.addSubview(moneyLabel)
        let messageFont = kUIStyle.sysFontDesign1PXSize(size: 14)
        let messageLabel = UILabel(frame: CGRect (x: moneyLabel.x, y: moneyLabel.maxY + 3, width: rect.size.width, height: messageFont.pointSize+5))
        messageLabel.font = messageFont
        messageLabel.textColor = UIColor.colorWithHexString("9DA0A9")
        messageLabel.textAlignment = .center
        messageLabel.text = title
        superView.addSubview(messageLabel)
        messageLabel.y = rect.height*0.5+2
        moneyLabel.maxY = rect.height*0.5
        moneyLabel.dsyAddTap(self, action: #selector(moneyCell_GoPay(tap:)))
        messageLabel.dsyAddTap(self, action: #selector(moneyCell_GoPay(tap:)))
        messageLabel.tag = tag
        moneyLabel.tag = tag
        return (moneyLabel,messageLabel)
    }
    
    
    class UserHeaderDescribeView: UIView {

        var bacImg:UIImageView!
        var titie:UILabel!
        var iconImg:UIImageView!
        var clickBtn:DSYRightImgBtn!
        var clickBlock:(()->())?
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI()  {
            
            bacImg = UIImageView()
            bacImg.contentMode = .scaleAspectFit
            addSubview(bacImg)
            bacImg.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            bacImg.dsyAddTap(self, action: #selector(clickBacImg))
            
            iconImg = UIImageView()
            iconImg.contentMode = .scaleAspectFit
            iconImg.image = UIImage(named: "dzk_hg_img")
            addSubview(iconImg)
            iconImg.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(22)
                make.width.height.equalTo(15)
                
            }
            
            
            titie = UILabel()
            titie.font = kUIStyle.sysFontDesign1PXSize(size: 12)
            titie.textColor = UIColor.colorWithHexString("FEDC61")
            titie.textAlignment = .left
            titie.adjustsFontSizeToFitWidth = true
            titie.numberOfLines = 0
            addSubview(titie)
            titie.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(iconImg.snp.right).offset(5)
            }
            
            
            clickBtn = DSYRightImgBtn()
            clickBtn.titleX  = 5
            clickBtn.backgroundColor = UIColor.colorWithHexString("FEDC61")
            clickBtn.dsySetCorner(radius: 10 )
            clickBtn.setTitleColor(UIColor.colorWithHexString("0C1346"), for: .normal)
            clickBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            clickBtn.setTitle(kLocalized("Check_it_now"), for: .normal)
            clickBtn.setImage(UIImage(named: "dzk_jt2_img"), for: .normal)
            addSubview(clickBtn)
            clickBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-29)
                make.centerY.equalToSuperview()
                make.height.equalTo(20)
                make.width.greaterThanOrEqualTo(60)
                make.left.greaterThanOrEqualTo(titie.snp.right).offset(5)
            }
            clickBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: UIControl.Event.touchUpInside)
            
        }
        
       @objc func clickBtnAction(_ btn:UIButton)  {
            clickBlock?()
        }
        
        
        @objc func clickBacImg () {
            clickBlock?()
        }
        
    }

}
