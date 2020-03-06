//
//  MQICardTJTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/8.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

let MQICardTJTableViewCell_Timer_Notification = "MQICardTJTableViewCell_Timer_Notification"
class MQICardTJTableViewCell :MQICardBaseTableViewCell {
    
    var title1:UILabel!
    var newLabel:MQITimeLabel!
    var newTitleLabel:UILabel?
    var lineView:UIView!
    var clickBlock:((_ tag:Int)->())?
    var itmes = [CardTJItmeView]()
    override func setupUI() {
        bacImge.isHidden = true
        createHeader()
        createContentSubView()
        registerNSNotificationCenter()
        
    }
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 25+22+12+128+4+20
    }
    
    deinit {
        removeNSNotificationCenter()
        
    }
    func createContentSubView() {

        let bacView = UIView()
//        bacView.backgroundColor = UIColor.gray
        contentView.addSubview(bacView)
        bacView.snp.makeConstraints { (make) in
            make.top.equalTo(title1.snp.bottom).offset(15)
            make.left.equalTo(lineView)
            make.right.equalToSuperview().offset(-card_LeftMargin2)
            make.bottom.equalToSuperview().offset(-12)
            make.width.lessThanOrEqualTo(screenWidth-2*card_LeftMargin2)
        }
        
        let count:Int = 3
        for i in 0..<count {
            let item = CardTJItmeView()
            item.tag = 100+i
            bacView.addSubview(item)
            itmes.append(item)
            item.dsyAddTap(self, action: #selector(clickItme(tap:)))
            
        }
        
        itmes[1].snp.makeConstraints { (make) in
            make.bottom.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(kUIStyle.scale1PXW(96))
        }
        itmes[0].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
            make.left.equalToSuperview()
            
        }
        itmes[2].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
             make.right.equalToSuperview()
            
        }

    }
    @objc func clickItme(tap:UITapGestureRecognizer) {
        guard let view = tap.view else {
            return
        }
        clickBlock?( view.tag)
        
    }
    
    
    func createHeader() {
        lineView = UIView()
        lineView.backgroundColor = mainColor
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(card_LeftMargin2)
            make.top.equalToSuperview().offset(25)
            make.width.equalTo(2)
            make.height.equalTo(15)
        }
        
        title1  = UILabel()
        title1.font = UIFont.boldSystemFont(ofSize: 16)
        title1.textColor  = UIColor.colorWithHexString("#333333")
        title1.textAlignment = .left
        contentView.addSubview(title1)
       
        if newLabel == nil {
            newLabel = MQITimeLabel()
            self.addSubview(newLabel)
            newLabel.isHidden = true
            newLabel!.textColor = UIColor.white
            newLabel!.dayColor = mainColor
            newLabel!.strokeColor = mainColor
            newLabel!.fillColor = mainColor
            
        }
        if newTitleLabel == nil {
            newTitleLabel = createLabel(newLabel.frame, font: UIFont.systemFont(ofSize: 16), bacColor: nil, textColor:mainColor, adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
            self.addSubview(newTitleLabel!)
            newTitleLabel?.isHidden = true
        }
        title1.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(5)
            make.centerY.equalTo(lineView)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(50)
        }
     
        newLabel.snp.makeConstraints { (make) in
            make.right.lessThanOrEqualToSuperview().offset(-card_LeftMargin2)
            make.centerY.equalTo(title1)
            make.width.equalTo(120)
            make.height.equalTo(20)
            make.left.equalTo(title1.snp.right).offset(5)
        }
        newTitleLabel?.snp.makeConstraints({ (make) in
            make.edges.equalTo(newLabel!)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func registerNSNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(MQICardTJTableViewCell.countDownAction), name: NSNotification.Name(rawValue: MQICardTJTableViewCell_Timer_Notification), object: nil)
    }
    
    func removeNSNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(MQICardTJTableViewCell_Timer_Notification), object: nil)
        
    }
    var secondsCountDown:Int? = -1
    var timeIntervalSecond:String = "0" {
        didSet {
            
            let date = NSDate()
            let nowTime = date.timeIntervalSince1970
            let nowTimeInterval = Int(nowTime)
            let secondsCount = Int(timeIntervalSecond)! - nowTimeInterval//剩余秒
            if secondsCount > 0 {
                secondsCountDown = secondsCount//倒计时
                
                newLabel.addTimeText(getTime_Day(secondsCountDown!), hours: getTime_hour(secondsCountDown!), minutes: getTime_minute(secondsCountDown!), seconds: getTime_second(secondsCountDown!))
                
                newLabel.isHidden = false
                newTitleLabel?.isHidden = true
                
                
            }else {
                newLabel.isHidden = true
                newTitleLabel?.isHidden = false
                newTitleLabel?.text = kLocalized("ISEnd")
                newTitleLabel?.textColor = newLabel.strokeColor
            }
            
        }
        
    }
    @objc func countDownAction() {
        
        secondsCountDown? -= 1
        if secondsCountDown! >= 0 {
            
            DispatchQueue.main.async {
                self.newLabel.addTimeText(self.getTime_Day(self.secondsCountDown!), hours: self.getTime_hour(self.secondsCountDown!), minutes: self.getTime_minute(self.secondsCountDown!), seconds: self.getTime_second(self.secondsCountDown!))
                
            }
            
            newLabel.isHidden = false
            newTitleLabel?.isHidden = true
        }else{
            newLabel.isHidden = true
            newTitleLabel?.isHidden = false
            newTitleLabel?.text = kLocalized("ISEnd")
            
        }
        
    }
    
    func getTime_Day(_ secondCount:Int) -> String{
        let days = NSString.gd_timeInterval_Days(withSeconds: secondCount)
        return days!
    }
    func getTime_hour(_ secondCount:Int) -> String{
        let hour = NSString.gd_timeInterval_Hours(withSeconds: secondCount)
        return hour!
    }
    func getTime_minute(_ secondCount:Int) -> String{
        let minute = NSString.gd_timeInterval_Minutes(withSeconds: secondCount)
        return minute!
    }
    func getTime_second(_ secondCount:Int) -> String{
        let seconds = NSString.gd_timeInterval_seconds(withSeconds: secondCount)
        return seconds!
    }
    
}


extension MQICardTJTableViewCell {
    
    class CardTJItmeView: UIView {
        var imgView:UIImageView!
        var title:UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI()  {
            imgView = UIImageView()
            imgView.contentMode = .scaleAspectFit
            addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.width.left.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            title =  UILabel()
            title.font = UIFont.systemFont(ofSize: 13)
            title.textColor  = UIColor.colorWithHexString("#2C2B40")
            title.textAlignment = .left
            addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.right.equalTo(imgView).offset(5)
                make.top.equalTo(imgView.snp.bottom).offset(2)
                make.height.equalTo(16)
                make.bottom.equalToSuperview()
            }
        }
        
    }
}
