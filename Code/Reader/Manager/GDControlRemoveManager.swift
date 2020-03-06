//
//  GDControlRemoveManager.swift
//  Reader
//
//  Created by CQSC  on 2018/1/11.
//  Copyright © 2018年  CQSC. All rights reserved.
//
//这类啊只能意会，不用言传
import UIKit


class GDControlRemoveManager: NSObject {
    
    
    static var shared: GDControlRemoveManager {
        struct Static {
            static let instance: GDControlRemoveManager = GDControlRemoveManager()
        }
        return Static.instance
    }
    func judge_naviViewsIsNeedRemove(_ navigation:UINavigationController?){
        /*有一个阅读器的时候GYReaderICSDrawerController不退出
         有两个阅读器的时候，关掉第一个阅读器跟第二个阅读器之间的所有视图 remove = nil
         在进入阅读器的时候遍历
        */
        if let viewArray = navigation?.viewControllers {
            guard viewArray.count > 0 else{
                return
            }
            let readVCs = viewArray.filter({$0 is MQIReaderICSDrawerViewController})
            //判断是否有两个阅读器
            guard readVCs.count >= 2 else {
                return
            }
            var arrs = [NSInteger]()
            for i in 0..<viewArray.count {
                if viewArray[i] is MQIReaderICSDrawerViewController {
                    arrs.append(i)
                }
            }
            //找第一个阅读器和最后一个阅读器脚标，把从第一个阅读器到（包含1）最后一个阅读器之间的都删了
            if var last = arrs.last, let first = arrs.first {
                while last > first {
                    var singleVC = navigation?.viewControllers[last-1]
                    navigation?.viewControllers.remove(at: last-1)
                    if singleVC != nil {
                        singleVC?.removeFromParent()
                        singleVC = nil
                    }
                    last -= 1

                }
            }
            
            
            
            
            
//            for index in 0..<arrs.count-1 {
//                let singleVC = navigation?.viewControllers[arrs[index]]
//                navigation?.viewControllers.remove(at: arrs[index])
//
//            }
            
        }
        
        
    }
    
    
}
