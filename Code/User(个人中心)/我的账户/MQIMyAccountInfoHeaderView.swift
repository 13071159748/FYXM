//
//  MQIMyAccountInfoHeaderView.swift
//  TSYQKReader
//
//  Created by moqing on 2018/10/23.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

class MQIMyAccountInfoHeaderView: UIView {
    var coinLabel:UILabel!
    var premiumLabel:UILabel!
    var to_PayBlock:(() -> ())?
    
    var moneyUser:MQIUserModel? {
        didSet{
            if let user = moneyUser {
                if user.user_coin == "" {
                    coinLabel.text = "0"
                }else {
                    coinLabel.text = user.user_coin
                }
                if user.user_premium == "" {
                    premiumLabel.text = "0"
                }else {
                    premiumLabel.text = user.user_premium
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.white
        configUserMoneyBacViewUI(self)
        
        let payBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kUIStyle.scale1PXW(204), height:  kUIStyle.scale1PXH(40)))
        payBtn.centerX = self.width*0.5
        payBtn.y = self.height - payBtn.height - 12
        payBtn.backgroundColor = kUIStyle.colorWithHexString("F26862")
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 18)
        payBtn.dsySetCorner(radius: payBtn.height*0.5)
        addSubview(payBtn)
        payBtn.setTitle(kLocalized("topUp"), for: .normal)
        payBtn.addTarget(self, action: #selector(to_payAction(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
       @objc func to_payAction(_ btn:UIButton) {
            to_PayBlock?()
        }
    
    func configUserMoneyBacViewUI(_ bacView:UIView) {
        let vWidth = bacView.width / 2
        for i in 0..<2 {
            let rect = CGRect (x: vWidth * CGFloat(i) ,y: 12, width: vWidth, height: 64)
            if i==0 {
                coinLabel = createCoinView(rect,title: COINNAME,bacView:bacView )
            }else {
                premiumLabel = createCoinView(rect,title: COINNAME_PREIUM,bacView:bacView )
            }
        }
    }
    
    @discardableResult func createCoinView(_ rect:CGRect,title:String,bacView:UIView) -> UILabel{
        let superView = UIView(frame: rect)
        bacView.addSubview(superView)
        
        let moneyFont = kUIStyle.size1PX(40)
        let moneyLabel = UILabel (frame: CGRect (x: 0, y: 15, width: superView.width, height: moneyFont))
        moneyLabel.textAlignment = .center
        moneyLabel.text = "0"
        moneyLabel.font = UIFont.boldSystemFont(ofSize: moneyFont)
        moneyLabel.textColor = UIColor.black
        
        superView.addSubview(moneyLabel)
        let messageFont =  kUIStyle.size1PX(12)
        let messageLabel = UILabel(frame: CGRect (x: 0, y: moneyLabel.maxY + 3, width: superView.width, height: messageFont))
        messageLabel.font = UIFont.systemFont(ofSize: messageFont)
        messageLabel.textColor = UIColor.colorWithHexString("666666")
        messageLabel.textAlignment = .center
        messageLabel.text = title
        superView.addSubview(messageLabel)
        
        return moneyLabel
    }
    
    
    
}
