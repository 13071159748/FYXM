//
//  GYRMLightView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMLightView: GYRMBaseView {
    
    /// 进度条
    private(set) var slider: UISlider!
    
    override func addSubviews() {
        super.addSubviews()
        slider = UISlider(frame: CGRect.zero)
        slider.maximumValue = GYReadStyle.shared.styleModel.maxBookBrightness
        slider.value = GYReadStyle.shared.styleModel.maxBookBrightness-GYReadStyle.shared.styleModel.bookBrightness
        slider.setThumbImage(UIImage(named: "tool_circle"), for: .normal)
        slider.setMinimumTrackImage(createImageWithColor(RGBColor(217, g: 62, b: 61)), for: .normal)
        slider.setMaximumTrackImage(createImageWithColor(RGBColor(76, g: 76, b: 76)), for: .normal)
        slider.addTarget(self, action:#selector(GYRMLightView.sliderValueChanged(_:)), for: .valueChanged)
        self.addSubview(slider)
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        let value = GYReadStyle.shared.styleModel.maxBookBrightness-slider.value
        GYReadStyle.shared.styleModel.bookBrightness = value
        readMenu.coverView.alpha = CGFloat(value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        slider.frame = CGRect(x: 20, y: 0, width: self.width-40, height: self.height)
    }
}

