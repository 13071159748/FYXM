//
//  GYRMStatusView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMStatusView: UIView {
    
    /// 电池
    private(set) var batteryView: MQIBatteryView!
    
    /// 时间
    private(set) var timeLabel:UILabel!
    
    /// 标题
    private(set) var titleLabel:UILabel!
    
    /// 计时器
    private(set) var timer:Timer?
    
    
    var textColor: UIColor! {
        didSet {
            batteryView.tintColor = textColor
            timeLabel.textColor = textColor
            titleLabel.textColor = textColor
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
        let tColor = RGBColor(127, g: 136, b: 138)
        let tFont = systemFont(12)
        // 电池
        batteryView = MQIBatteryView()
        batteryView.tintColor = tColor
        addSubview(batteryView)
        
        // 时间
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = tFont
        timeLabel.textColor = tColor
        addSubview(timeLabel)
        
        // 标题
        titleLabel = UILabel()
        titleLabel.font = tFont
        titleLabel.textColor = tColor
        addSubview(titleLabel)
        
        // 初始化调用
        didChangeTime()
        
        // 添加定时器
        addTimer()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 电池
        batteryView.origin = CGPoint(x: width - GYBatterySize.width, y: (height - GYBatterySize.height)/2)
        
        // 时间
        let timeLabelW:CGFloat = 50*screenHeight/375
        timeLabel.frame = CGRect(x: batteryView.frame.minX - timeLabelW, y: 0, width: timeLabelW, height: height)
        
        // 标题
        titleLabel.frame = CGRect(x: 0, y: 0, width: timeLabel.frame.minX, height: height)
    }
    
    // MARK: -- 时间相关
    
    /// 添加定时器
    func addTimer() {
        
        if timer == nil {
            
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(GYRMStatusView.didChangeTime), userInfo: nil, repeats: true)
            
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
    
    /// 时间变化
    @objc func didChangeTime() {
        
        timeLabel.text = GetCurrentTimerString(dateFormat: "HH:mm")
        
        batteryView.batteryLevel = UIDevice.current.batteryLevel
    }
    
    /// 销毁
    deinit {
        removeTimer()
    }
}

