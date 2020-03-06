//
//  MQIBookStoreHeaderCollectionReusableViewABC.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
/*
 拉拉
 */
//首页商城collection的header
let Header_Timer_Notification = "Header_Timer_Notification"
class MQIBookStoreHeaderCollectionReusableViewABC: UICollectionReusableView {
    var header_ImgColor:String = "#02b2cc"
    
    var header_TitleColor:String = "#1C1C1E"
    
    var header_title:UILabel?//标题
//    var sub_title: UILabel?
    var dsc_title:UILabel?
    var rightBtn:DSYRightImgBtn?
    var clickRightBtn_block:((_ id:String?)->())?
    var title_Text:String = ""{
        didSet(oldValue) {
            header_title?.text = title_Text
        }
    }
    var headImg:UIView? //左边蓝块
    
    var  commendModel:MQIMainRecommendModel?
    //    var time_label: UILabel?
    
    var newLabel:MQITimeLabel!
    
    var newTitleLabel:UILabel?
    
    var secondsCountDown:Int? = -1
    //时间戳 秒
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addheaderView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addheaderView()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(Header_Timer_Notification), object: nil)
        
    }
    
    func addheaderView() {
        
        if header_title == nil {
            header_title = createLabel(CGRect.zero ,font: kUIStyle.boldSystemFont1PXDesignSize(size: 18), bacColor: nil, textColor: UIColor.colorWithHexString(header_TitleColor), adjustsFontSizeToFitWidth: true, textAlignment: .left, numberOfLines: 1)
            self.addSubview(header_title!)
            header_title?.centerY = self.height*0.5
            
        }
        
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
            newTitleLabel = createLabel(newLabel.frame, font: UIFont.systemFont(ofSize: 16), bacColor: nil, textColor: UIColor.colorWithHexString(header_TitleColor), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
            self.addSubview(newTitleLabel!)
            newTitleLabel?.isHidden = true
        }
        if dsc_title == nil {
            dsc_title = createLabel(newLabel.frame, font: UIFont.systemFont(ofSize: 12), bacColor: nil, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
            self.addSubview(dsc_title!)
        }
    
        
        if rightBtn == nil {
            rightBtn = DSYRightImgBtn()
            rightBtn?.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
            rightBtn?.setTitleColor(UIColor.colorWithHexString("#999999"), for: .normal)
            rightBtn?.setImage(UIImage(named: "arrow_right"), for: .normal)
            rightBtn?.titleLabel?.adjustsFontSizeToFitWidth = true
            rightBtn?.addTarget(self, action: #selector(clickRightBtn(_:)), for: .touchUpInside)
            self.addSubview(rightBtn!)
        }
        
       
        
        header_title?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(Book_Store_Manger)
            make.centerY.equalToSuperview().offset(5)
        })
        
        rightBtn?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-Book_Store_Manger)
            make.centerY.equalTo(header_title!)
//            make.height.equalTo(40)
            make.width.lessThanOrEqualTo(80)
        })
        
        newLabel.snp.makeConstraints { (make) in
            make.right.lessThanOrEqualToSuperview().offset(-Book_Store_Manger-80)
            make.centerY.equalTo(header_title!)
            make.width.equalTo(120)
            make.height.equalTo(20)
            make.left.equalTo(header_title!.snp.right).offset(5)
        }
        newTitleLabel?.snp.makeConstraints({ (make) in
            make.edges.equalTo(newLabel!)
        })
        
        dsc_title?.text = ""
        dsc_title?.snp.makeConstraints { (make) in
            make.left.equalTo(header_title!.snp.right).offset(5)
            make.centerY.equalTo(header_title!)
            make.right.lessThanOrEqualToSuperview().offset(-Book_Store_Manger-80)
        }
        
    }
    
    @objc func clickRightBtn(_ btn:UIButton) {
        clickRightBtn_block?(commendModel?.pos_id)
    }
    
    func registerNSNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(MQIBookStoreHeaderCollectionReusableViewABC.countDownAction), name: NSNotification.Name(rawValue: Header_Timer_Notification), object: nil)
    }
    func removeNSNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(Header_Timer_Notification), object: nil)
        
    }
    
    
}
