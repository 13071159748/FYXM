//
//  GDRMSettingScrollView.swift
//  Reader
//
//  Created by CQSC  on 2017/11/10.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

let gdrmsettingScrollView = "gdrmsettingScrollView"
class GDRMSettingScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(GDRMSettingScrollView.sliderTouchUp), name: NSNotification.Name(rawValue: gdrmsettingScrollView), object: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func sliderTouchUp() {
        self.isScrollEnabled = true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        MQLog("🍎🍎🍎🍎")
        let view = super.hitTest(point, with: event)
        if let view = view {
//            MQLog("🍌🍌")
            if view.isKind(of: UISlider.self) {
                self.isScrollEnabled = false
            }else {
//                self.isScrollEnabled = true
            }
        }

        return view
    }
//    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
//        if view.isKind(of: UISlider.self) {
//            MQLog("🍎🍎")
//            isScrollEnabled = false
//        }
//        return true
//    }
    
}
