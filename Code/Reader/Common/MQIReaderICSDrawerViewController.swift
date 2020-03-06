//
//  MQIReaderICSDrawerViewController.swift
//  Reader
//
//  Created by CQSC  on 2017/4/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReaderICSDrawerViewController: ICSDrawerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: 重写父类pan手势 保证 不左划出页面
    func gestureRecognizerDidPan(_ panGesture: UIPanGestureRecognizer) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
