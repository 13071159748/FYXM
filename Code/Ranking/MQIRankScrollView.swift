//
//  GDRankScrollView.swift
//  Reader
//
//  Created by CQSC  on 2017/11/1.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIRankScrollView: UIScrollView ,UIGestureRecognizerDelegate{

//    override func touchesShouldCancel(in view: UIView) -> Bool {
//        if view.isKind(of: UIButton.self){
//            return true
//        }
//        return super.touchesShouldCancel(in: view)
//    }
//    
//    //解决点击效果延迟 或者//topNavScrollView.delaysContentTouches = false
//    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
//        if view.isKind(of: UIButton.self){
//            
//            return true
//        }
//        return super.touchesShouldBegin(touches, with: event, in: view)
//    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (touch.view?.isKind(of: UIButton.self))!{
//            return false
//        }
//        return true
//    }
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (gestureRecognizer.view?.isKind(of: UIButton.self))!{
//            return false
//        }
//        return true
//    }
//    func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
//        let touch = touches.
//    }

    
    func panBack(gestureRecognizer:UIGestureRecognizer)->Bool {
        let location_X:CGFloat = 100;
        if gestureRecognizer == panGestureRecognizer {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in: self)
            let state = gestureRecognizer.state
            if state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.possible {
                let location = gestureRecognizer.location(in: self)
                if point.x > 0 && location.x < location_X && contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
    //解决与导航冲突 一
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
       
        let classCode = String(describing: gestureRecognizer.view!.classForCoder.self)
    
        if panBack(gestureRecognizer: gestureRecognizer) {
            return false
        }
        return true
    }
    //解决与导航冲突 二
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        var hitView = super.hitTest(point, with: event)
//        if point.x <= 10 {
//            hitView = nil
//        }else {
//            hitView = super.hitTest(point, with: event)
//        }
//        return hitView
//    }
}
