//
//  MQIUserInfoMoneyUITableViewCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserInfoMoneyUITableViewCell: MQITableViewCell {

    var coinLabel:UILabel!
    var premiumLabel:UILabel!
    var goSignBlock:(() -> ())?
    var signBtnLabel:UILabel!
    var signImg:UIImageView!
    var lineView:UIView!
    
    var moneyUser:MQIUserModel! {
        didSet{
            if moneyUser.user_coin == "" {
                coinLabel.text = "0"
            }else {
                coinLabel.text = moneyUser.user_coin
            }
            if moneyUser.user_premium == "" {
                premiumLabel.text = "0"
            }else {
                premiumLabel.text = moneyUser.user_premium
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        lineView.frame = CGRect(x: self.width*0.5-0.5, y:self.height-kUIStyle.scaleH (40), width: 1, height: kUIStyle.scaleH (40))
    }
    func configUINew() {
        let vWidth = screenWidth / 2
        
        for i in 0..<2 {
            let rect = CGRect (x: vWidth * CGFloat(i) ,y: 0, width: vWidth, height: self.height)
            if i==0 {
                coinLabel = createCoinView(rect,title: COINNAME)
            }else if i == 1{
                premiumLabel = createCoinView(rect,title: COINNAME_PREIUM)
              
            }
        }
        lineView = UIView()
        lineView.backgroundColor = kUIStyle.colorWithHexString("#EDEDEF")
        self.addSubview(lineView)

 
    }
    
    func configUI() {
        let vWidth = screenWidth / 3
        
        for i in 0..<3 {
            let rect = CGRect (x: vWidth * CGFloat(i) ,y: 0, width: vWidth, height: self.height)
            if i==0 {
                coinLabel = createCoinView(rect,title: COINNAME)
            }else if i == 1{
                premiumLabel = createCoinView(rect,title: COINNAME_PREIUM)
            }else {
                let  signView = createSignBtn(rect)
                signBtnLabel = signView.0
                signImg = signView.1
            }
        }
    }
    @discardableResult func createSignBtn(_ rect:CGRect) -> (UILabel,UIImageView){
        let superBtn = UIButton(type: .custom)
        superBtn.frame = rect
        superBtn.addTarget(self, action: #selector(MQIUserInfoMoneyUITableViewCell.moneyCell_GoSign(_:)), for: .touchUpInside)
        self.addSubview(superBtn)
        
        let messageFont = (12*mqscale) > 15 ? 15 : 12*mqscale
        let messageLabel = UILabel (frame: CGRect (x: 0, y: rect.height-3, width: superBtn.width, height: messageFont))
        messageLabel.font = UIFont.systemFont(ofSize: messageFont)
        messageLabel.textColor = UIColor.colorWithHexString("2E2F35")
        messageLabel.textAlignment = .center
        messageLabel.text = kLocalized("SignIn")
        superBtn.addSubview(messageLabel)
        
        let icon = UIImageView(frame: CGRect (x: 0, y: messageLabel.y-27-3, width: 27, height: 27))
        icon.image = UIImage.init(named: "CHK_info_Sign_sel_image")
        superBtn.addSubview(icon)
        icon.centerX = superBtn.width/2
  
        return (messageLabel,icon)
    }
    @objc func moneyCell_GoSign(_ button:UIButton) {
        goSignBlock?()
    }
    @discardableResult func createCoinView(_ rect:CGRect,title:String) -> UILabel{
        let superView = UIView(frame: rect)
        self.addSubview(superView)
        
        let moneyFont = (20*mqscale) > 22 ? 22 : 20*mqscale
   
        
        let moneyLabel = UILabel (frame: CGRect (x: 0, y: 15, width: superView.width, height: moneyFont))
        moneyLabel.textAlignment = .center
        moneyLabel.text = "0"
        moneyLabel.font = UIFont.boldSystemFont(ofSize: moneyFont)
        moneyLabel.textColor = UIColor.black
        
        superView.addSubview(moneyLabel)
        let messageFont = (12*mqscale) > 15 ? 15 : 12*mqscale
        let messageLabel = UILabel(frame: CGRect (x: 0, y: moneyLabel.maxY + 3, width: superView.width, height: messageFont))
        messageLabel.font = UIFont.systemFont(ofSize: messageFont)
        messageLabel.textColor = UIColor.colorWithHexString("2E2F35")
        
        messageLabel.textAlignment = .center
        messageLabel.text = title
        superView.addSubview(messageLabel)
        
        return moneyLabel
    }
    

    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 63
    }


}
