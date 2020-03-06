 //
 //  DSYScrollOperation.swift
 //  Audio
 //
 //  Created by CQSC  on 2018/6/8.
 //  Copyright © 2018年 DSY. All rights reserved.
 //
 
import UIKit

 
 enum DSYScrollStyle:Int {
    /// 默认样式
    case None = 0
    /// 动态样式
    case Dynamic
    
 }
 
 class DSYScrollOperation: NSObject {
    
    /// 滑动样式
    var style:DSYScrollStyle = .None
    /// 指标动态视图
    var indicatorView:UIView!
    /// 导航视图集合
    var navArr:[UIView]!
    /// 导航视图宽度
    var navViewWidth:CGFloat = UIScreen.main.bounds.width
    /// 开始距离
    var startOffsetX:CGFloat = 0
    /// 指标动态宽度 /// 默认 40
    var indicatorWidth:CGFloat = 40
    /// 是否需要改变位置 当点击标题时防止乱跑
    var isScroll:Bool = false
    
    init(style:DSYScrollStyle = .None) {
        super.init()
        self.style = style
    }
    
    deinit {
        mqLog("销毁")
        navArr.removeAll()
        indicatorView = nil
    }
    ///开始滑动
    func startScroll(_ scrollView:UIScrollView) -> Void {
        if isScroll {return }
        if navArr !=  nil {
            getProgress(scrollView: scrollView, startOffsetX: startOffsetX, navArr: navArr)
        }
        
    }
    
    
    //滑动视图
    private  func getProgress(scrollView:UIScrollView,startOffsetX:CGFloat,navArr:[UIView]) -> Void {
        let currentOffsetX:  CGFloat  = scrollView.contentOffset.x
        if  currentOffsetX < 0  {
            return
        }
        var progress: CGFloat  = 0;
        var originalIndex: NSInteger  = 0;
        var targetIndex: NSInteger  = 0;
        let scrollViewW :CGFloat  = scrollView.bounds.size.width
        if (currentOffsetX > startOffsetX) { // 左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            originalIndex = NSInteger(currentOffsetX / scrollViewW);
            targetIndex = originalIndex + 1
            if (targetIndex >= navArr.count) {
                progress = 1
                targetIndex = originalIndex
            }
            if (currentOffsetX - startOffsetX == scrollViewW) {
                progress = 1;
                targetIndex = originalIndex
            }
        }else{
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            targetIndex = NSInteger(currentOffsetX / scrollViewW);
            originalIndex = targetIndex+1
            if (originalIndex >= navArr.count) {
                originalIndex = navArr.count-1
            }
            
        }
        
        if style == .Dynamic {
            dynamicScrollToView(progress: progress,navArr:navArr, originalIndex: originalIndex, targetIndex: targetIndex, changeView: indicatorView,indicatorWidth:indicatorWidth)
        }else{
            noneScrollToView(progress: progress,navArr:navArr, originalIndex: originalIndex, targetIndex: targetIndex, changeView: indicatorView,indicatorWidth:indicatorWidth,navViewWidth:navViewWidth )
        }
        
    }
    
    private  func dynamicScrollToView(progress:CGFloat,navArr:[UIView],originalIndex:NSInteger,targetIndex:NSInteger,changeView:UIView,indicatorWidth:CGFloat) -> Void {
        
        let targetView:UIView = navArr[targetIndex]
        let originalView:UIView = navArr[originalIndex]
        if originalIndex <= targetIndex  { // 往左滑
            // targetView 与 originalView 中心点之间的距离
            let ViewCenterXDistance :CGFloat  = targetView.center.x - originalView.center.x
            
            if (progress <= 0.5) {
                changeView.frame.size.width =  2 * progress * ViewCenterXDistance+indicatorWidth
                
            }else{
                
                let targetViewX: CGFloat  =  targetView.frame.maxX - indicatorWidth - 0.5 * (targetView.frame.size.width - indicatorWidth)
                changeView.frame.origin.x =  targetViewX + 2 * (progress - 1) * ViewCenterXDistance
                changeView.frame.size.width =  2 * (1 - progress)*ViewCenterXDistance+indicatorWidth
            }
        }else{
            // originalView 与 targetView 中心点之间的距离
            let ViewCenterXDistance: CGFloat  = originalView.center.x - targetView.center.x
            if (progress <= 0.5) {
                let originalViewX: CGFloat  = originalView.frame.maxX - indicatorWidth - 0.5 * (originalView.frame.size.width - indicatorWidth)
                changeView.frame.origin.x = originalViewX - 2 * progress * ViewCenterXDistance
                changeView.frame.size.width = 2 * progress * ViewCenterXDistance + indicatorWidth
            }else{
                let targetViewX: CGFloat  = targetView.frame.maxX - indicatorWidth - 0.5 * (targetView.frame.size.width - indicatorWidth)
                changeView.frame.origin.x = targetViewX
                changeView.frame.size.width = 2 * (1 - progress) * ViewCenterXDistance+indicatorWidth
            }
        }
    }
    
    
    private  func noneScrollToView(progress:CGFloat,navArr:[UIView],originalIndex:NSInteger,targetIndex:NSInteger,changeView:UIView,indicatorWidth:CGFloat,navViewWidth:CGFloat) -> Void {
        
        let targetView:UIView = navArr[targetIndex]
        let originalView:UIView = navArr[originalIndex]
        let count = CGFloat(navArr.count)
        let targetViewIndicatorX: CGFloat  = targetView.frame.maxX - 0.5 * (navViewWidth/count - indicatorWidth) - indicatorWidth
        let originalViewIndicatorX: CGFloat  = originalView.frame.maxX - 0.5 * (navViewWidth/count - indicatorWidth) - indicatorWidth
        let totalOffsetX:CGFloat  = targetViewIndicatorX - originalViewIndicatorX
        changeView.frame.origin.x = originalViewIndicatorX + progress * totalOffsetX;
        
    }
    
    
 }
 
 
