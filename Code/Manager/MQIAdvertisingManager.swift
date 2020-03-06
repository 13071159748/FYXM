//
//  MQIAdvertisingManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import SDWebImage
class MQIAdvertisingManager: NSObject {

    var gdtimer : Timer!
    var number_time : NSInteger = 3
    var adView:GDAdView!
    static var shared:MQIAdvertisingManager {
        struct Static {
            static let instance:MQIAdvertisingManager = MQIAdvertisingManager()
        }
        return Static.instance
    }
    func judgeIsExistad(_ window:UIWindow?) {
        
        guard let adwindow = window  else {
            mqLog("windows没有")
            return
        }
        let adsModel = MQILocalSaveDataManager.shared.readData_advertise()
        if adsModel.type == "" {
            net_requestAD()
            return
        }
        
        
        //判断endtime
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let oldDate = formatter.date(from: adsModel.end_time)
        let nowDate = formatter.date(from: formatter.string(from: Date()))
        if let oldDate = oldDate ,let nowDate = nowDate {
            guard nowDate.timeIntervalSince(oldDate) < 0 else {
                net_requestAD()
                return
            }
        }else {
            net_requestAD()
            return
        }
        
        let manager = SDWebImageManager.shared()
        let key = manager.cacheKey(for: URL(string: adsModel.image))
        let localImage = SDImageCache.shared().imageFromCache(forKey: key)
        if localImage == nil {
            net_requestAD()
            return
        }
        
        //创建timer  创建view
        adView = GDAdView.init(frame: adwindow.bounds)
        adwindow.addSubview(adView)
        adwindow.bringSubviewToFront(adView)
        adView.adImageView.image = localImage
        
        adView.timerLabel.text = "跳过 "+"\(number_time)s"
        adView.adBlock = {[weak self]()->Void in
            //去详情页
            if let weakSelf = self {
                
                weakSelf.dealWithDetailOperation(adsModel)
            }
        }
        adView.adOverBlock = {[weak self]() -> Void in//跳过[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.shotdownTimer()
                weakSelf.removeAdView()
                
            }
        }
        createTimer()
        
        net_requestAD()
        
    }
    
    
    
    func createTimer() {
        if gdtimer == nil {
            gdtimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MQIAdvertisingManager.timerDown), userInfo: nil, repeats: true)
            RunLoop.main.add(gdtimer, forMode: RunLoop.Mode.common)
        }
    }
    @objc func timerDown() {
        number_time -= 1
        
        if adView != nil {
            adView.timerLabel.text = "跳过 "+"\(number_time)s"
        }
        
        if number_time <= 0 {
            shotdownTimer()
            removeAdView()
            return
        }
        
    }
    func shotdownTimer() {
        if gdtimer != nil {
            gdtimer.invalidate()
            gdtimer = nil
        }
    }
    func removeAdView(_ timeInterval:TimeInterval = 0.3) {
        guard adView != nil else {
            mqLog("adview = nil")
            return
        }
        UIView.animate(withDuration: timeInterval, animations: {[weak self]() in
            if let weakSelf = self {
                weakSelf.adView.alpha = 0
            }
        }) { [weak self](isFinish) in
            if let weakSelf = self {
                if weakSelf.adView != nil {
                    weakSelf.adView.removeFromSuperview()
                    weakSelf.adView = nil
                }
            }
        }
    }
    
}
extension MQIAdvertisingManager {
    
    func dealWithDetailOperation(_ model:MQISplashModel) {
        switch model.type {
        case "BOOK":
            shotdownTimer()
            removeAdView()
            let bookInfoVC = GDBookInfoVC()
            bookInfoVC.bookId = model.book_id
            bookInfoVC.hidesBottomBarWhenPushed = true
            gd_currentNavigationController().pushVC(bookInfoVC)
            
        case "LINK":
            shotdownTimer()
            removeAdView()
            let vc = MQIWebVC()
            vc.url = model.url
            vc.hidesBottomBarWhenPushed = true
            gd_currentNavigationController().pushVC(vc)
        case "SLOGAN":
            break
        default:
            break
        }
        
    }
    
    func net_requestAD() {
        GDSplashRequest().request({ (request, response, result:MQISplashModel) in
           MQILocalSaveDataManager.shared.SaveData_Advertising(result)
            mqLog("-----\(result.end_time)")
            let tempImgView = UIImageView()
            tempImgView.sd_setImage(with: URL(string:result.image))//下载
        }) { (err_msg, err_code) in
            //            mqLog("------\(err_msg)   \(err_code)")
        }
    }
}
//chuangjianguanggaoview
class GDAdView:UIView {
    
    
    var timerLabel:UILabel!
    var adImageView:UIImageView!
    var bottomDefaultView:UIView!//1/9
    
    var adBlock:(()->())?
    
    var adOverBlock:(()->())?
    
    fileprivate let ad_Size = CGSize.init(width: screenWidth, height: screenWidth/2*3)//2:3
    fileprivate let default_Size = CGSize(width: screenWidth, height: screenHeight-screenWidth*1.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createAdView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createAdView() {
        addAdImageView()
        addBottomView()
        addSubviewsControl()
    }
    func addSubviewsControl() {
        timerLabel = UILabel(frame: CGRect(x: screenWidth - 30 - 60, y: root_status_height + 10, width: 80, height: 30))
        timerLabel.font = systemFont(13)
        timerLabel.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0.6)
        timerLabel.textColor = UIColor.white
        timerLabel.textAlignment = .center
        timerLabel.layer.cornerRadius = 15
        timerLabel.clipsToBounds = true
        timerLabel.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GDAdView.skipViewClick), view: timerLabel)
        
        self.addSubview(timerLabel)
        
    }
    func addAdImageView() {
        adImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: ad_Size.height))
        adImageView.backgroundColor = UIColor.white
        adImageView.isUserInteractionEnabled = true
        //        adImageView.image = UIImage(named: "welfare_adbgImg")
        addTGR(self, action: #selector(GDAdView.tapToAdVC), view: adImageView)
        self.addSubview(adImageView)
    }
    func addBottomView() {
        
        guard default_Size.height > 0 else {
            return
        }
        //342 90  welfare_bottomReader
        bottomDefaultView = UIView(frame: CGRect(x: 0, y: ad_Size.height, width: screenWidth, height: default_Size.height))
        bottomDefaultView.backgroundColor = UIColor.white
        self.addSubview(bottomDefaultView)
        
        let logoImgView = UIImageView(frame: CGRect.zero)
        
        logoImgView.image = app_welfare_bottomlogoImage
        bottomDefaultView.addSubview(logoImgView)
        
        let bottomLabel = UILabel(frame: CGRect.zero)
        bottomLabel.font = systemFont(8)
        bottomLabel.textAlignment = .center
        bottomLabel.text = APP_Ownership_AD_Text
        
        bottomLabel.textColor = UIColor.colorWithHexString("#D1D1D1")
        bottomDefaultView.addSubview(bottomLabel)
        
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.snp.makeConstraints { (make) in
            make.width.equalTo(171)
            make.height.equalTo(45)
            make.centerX.equalTo(bottomDefaultView.width/2)
            make.centerY.equalTo(bottomDefaultView.height/2 - 13)
        }
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomDefaultView.snp.left)
            make.right.equalTo(bottomDefaultView.snp.right)
            make.top.equalTo(logoImgView.snp.bottom).offset(16*gdscale)
            make.height.equalTo(9)
        }
        
    }
    @objc func tapToAdVC() {//去广告页
        adBlock?()
    }
    @objc func skipViewClick() {//跳过
        adOverBlock?()
    }
    
    
}
