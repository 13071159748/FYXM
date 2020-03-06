//
//  MQIPaymentDetailsView.swift
//  CQSC
//
//  Created by moqing on 2019/5/9.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit

class MQIPaymentDetailsView: UIView {
    
    
    private var p_payModel: MQIApplePayModelNew?
    
    private var p_payItemModel: MQIApplePayItemModel?
    
    var payModel: (MQIApplePayModelNew?, MQIApplePayItemModel?) {
        get {
            return (p_payModel, p_payItemModel)
        }
        set {
            p_payModel = newValue.0
            p_payItemModel = newValue.1
            order_id.text = newValue.0?.order_id
            var  money = (newValue.1?.currencyStr ?? "") + "\((newValue.1?.priceValue.floatValue() ?? 0)/100)"
            if newValue.0?.order_fee.count ?? 0 > 0 {
                money = (newValue.0?.currencyStr ?? "") + (newValue.0?.order_fee ?? "")
            }
            topUp_amount.text = money
            topUp_moCoin.text = "\(newValue.0?.order_coin ?? "")\(kLongLocalized("MoB"))"
            giving_moCoin.text = "\(newValue.0?.order_premium ?? "")\(kLongLocalized("MoD"))"
            timeAlert.timeInterval =  (newValue.0?.expiry_time.doubleValue() ?? 0) - Date().timeIntervalSince1970
            total_money.text = kLongLocalized("totalPayment", replace: money)
        }
    }
    
    
    ///倒计时视图
    private var timeAlert: TimeAlertView!
    
    //点击背景视图
    var touchBGView: (() -> ())?
    ///点击取消
    var touchCancel: (() -> ())?
    ///点击确认
    var touchOK: (() -> ())?
    
    
    private var order_id: UILabel!
    private var topUp_amount: UILabel!
    private var topUp_moCoin: UILabel!
    private var giving_moCoin: UILabel!
    private var total_money: UILabel!
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timeAlert.removeTimer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = .clear
        let backView = UIControl()
        backView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        backView.addTarget(self, action: #selector(clickBGView(control:)), for: .touchUpInside)
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let alertBackView = UIView()
        alertBackView.backgroundColor = .white
        addSubview(alertBackView)
        alertBackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.top.equalToSuperview().offset(129)
            make.height.equalTo(446)
        }
        
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 19)
        title.textColor = .black
        
        title.text = kLocalized("outstandingPayment")
        alertBackView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(26)
        }
        
        timeAlert = TimeAlertView()
        timeAlert.timeInterval = 500
        alertBackView.addSubview(timeAlert)
        timeAlert.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
            make.height.equalTo(34)
        }
        
        let cell1 = ContrntView()
        cell1.name.text = kLocalized("orderNumber")
        order_id = cell1.content
        cell1.content.text = "2456899051"
        alertBackView.addSubview(cell1)
        cell1.snp.makeConstraints { (make) in
            make.top.equalTo(timeAlert.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let cell2 = ContrntView()
        cell2.name.text = kLocalized("topupAmount")
        topUp_amount = cell2.content
        alertBackView.addSubview(cell2)
        cell2.snp.makeConstraints { (make) in
            make.top.equalTo(cell1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let cell3 = ContrntView()
        cell3.name.text = kLocalized("topupMoCoin")
        topUp_moCoin = cell3.content
        alertBackView.addSubview(cell3)
        cell3.snp.makeConstraints { (make) in
            make.top.equalTo(cell2.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let cell4 = ContrntView()
        cell4.name.text = kLocalized("givingMoCoupons")
        giving_moCoin = cell4.content
        alertBackView.addSubview(cell4)
        cell4.snp.makeConstraints { (make) in
            make.top.equalTo(cell3.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let totalMoney = UILabel()
        totalMoney.textAlignment = .right
        totalMoney.font = UIFont.systemFont(ofSize: 18)
        totalMoney.textColor = #colorLiteral(red: 0.4431372549, green: 0.5294117647, blue: 1, alpha: 1)
        total_money = totalMoney
        alertBackView.addSubview(totalMoney)
        totalMoney.snp.makeConstraints { (make) in
            make.top.equalTo(cell4.snp.bottom).offset(19)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(25)
        }
        
        
        let cancelBtn = UIButton()
        let okBtn = UIButton()
        alertBackView.addSubview(cancelBtn)
        alertBackView.addSubview(okBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(totalMoney.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(okBtn.snp.left).offset(-15)
            make.height.equalTo(40)
            make.width.equalTo(okBtn.snp.width)
        }
        okBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cancelBtn.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        cancelBtn.setTitle(kLocalized("canceOrder"), for: .normal)
        cancelBtn.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1).cgColor
        cancelBtn.layer.borderWidth = 0.5
        cancelBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        cancelBtn.tag = 2
        okBtn.setTitle(kLocalized("okOrder"), for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.5294117647, blue: 1, alpha: 1)
        okBtn.layer.cornerRadius = 3
        okBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        okBtn.tag = 1
        
    }
    
    
    @objc func clickBGView(control: UIControl) {
        touchBGView?()
    }
    
    @objc func clickBtn(btn: UIButton) {
        let cBtn = btn.tag == 1 ? touchOK : touchCancel
        cBtn?()
    }

}
extension MQIPaymentDetailsView {
    fileprivate class ContrntView: UIView {
        var name: UILabel!
        
        var content: UILabel!
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configUI()
        }
        
        func configUI() {
            name = UILabel()
            name.font = UIFont.systemFont(ofSize: 15)
            name.textAlignment = .left
            name.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            addSubview(name)
            name.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(33)
                make.height.top.equalToSuperview()
            }
            content = UILabel()
            content.font = UIFont.systemFont(ofSize: 16)
            content.textAlignment = .right
            content.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            addSubview(content)
            content.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-38)
                make.height.top.equalToSuperview()
            }
            
            let line = UIView()
            line.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-23)
                make.height.equalTo(1)
                make.bottom.equalToSuperview()
            }
        }
    }
}
extension MQIPaymentDetailsView {
    fileprivate class TimeAlertView: UIView {
        
        private var timer: Timer?
        
        private var p_total_time: TimeInterval = 0
        
        private var minutes: UILabel!
        private var seconds: UILabel!
        
        var timeInterval: TimeInterval {
            set {
                guard newValue > 0 else { return }
                p_total_time = newValue
                addTimer()
            }
            get {
                return p_total_time
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configUI()
        }
        
        func configUI() {
            backgroundColor = #colorLiteral(red: 1, green: 0.9215686275, blue: 0.9294117647, alpha: 1)
            let icon = UIImageView(image: #imageLiteral(resourceName: "alert_ light"))
            addSubview(icon)
            icon.snp.makeConstraints { (make) in
                make.left.equalTo(36)
                make.width.equalTo(18)
                make.height.equalTo(19)
                make.centerY.equalToSuperview()
            }
            
            class rLabel: UILabel {
                override init(frame: CGRect) {
                    super.init(frame: frame)
                    textColor = #colorLiteral(red: 0.8156862745, green: 0.07058823529, blue: 0.1568627451, alpha: 1)
                    font = UIFont.systemFont(ofSize: 14)
                }
                
                required init?(coder aDecoder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }
            class bLabel: UILabel {
                override init(frame: CGRect) {
                    super.init(frame: frame)
                    textColor = .white
                    textAlignment = .center
                    font = UIFont.systemFont(ofSize: 11)
                    backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                    layer.cornerRadius = 2
                    layer.masksToBounds = true
                }
                required init?(coder aDecoder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }
            
            let label1 = rLabel()
            label1.text = kLocalized("pleaseU")
            let label2 = bLabel()
            minutes = label2
            label2.text = "29"
            let label3 = UILabel()
            label3.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
            label3.font = UIFont.systemFont(ofSize: 11)
            label3.text = ": "
            let label4 = bLabel()
            label4.text = "58"
            seconds = label4
            let label5 = rLabel()
            label5.text = kLocalized("completePayment")
            addSubview(label1)
            addSubview(label2)
            addSubview(label3)
            addSubview(label4)
            addSubview(label5)
            label1.snp.makeConstraints { (make) in
                make.left.equalTo(icon.snp.right).offset(8)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
            }
            
            label2.snp.makeConstraints { (make) in
                make.left.equalTo(label1.snp.right)
                make.height.equalTo(16)
                make.width.equalTo(16)
                make.centerY.equalToSuperview()
            }
            label3.snp.makeConstraints { (make) in
                make.left.equalTo(label2.snp.right)
                make.height.equalTo(label2)
                make.centerY.equalToSuperview()
            }
            label4.snp.makeConstraints { (make) in
                make.left.equalTo(label3.snp.right)
                make.height.equalTo(label2)
                make.top.equalTo(label2)
                make.width.equalTo(label2)
            }
            label5.snp.makeConstraints { (make) in
                make.left.equalTo(label4.snp.right)
                make.height.equalTo(label1)
                make.top.equalTo(label1)
            }
        }
        
        
        func addTimer() {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(didChangeTime), userInfo: nil, repeats: true)
                RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            }
        }
        
        /// 删除定时器
        func removeTimer() {
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
        }
        
        @objc func didChangeTime() {
            guard p_total_time > 0 else {
                removeTimer()
                return
            }
            p_total_time -= 1
            let m: Int = Int(p_total_time) / 60
            let s: Int = Int(p_total_time) % 60
            minutes.text = m < 10 ? "0\(m)" : "\(m)"
            seconds.text = s < 10 ? "0\(s)" : "\(s)"
        }
    }
    
    
    
}


