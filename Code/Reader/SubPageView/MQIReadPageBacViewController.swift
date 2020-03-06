//
//  MQIReadPageBacViewController.swift
//  Reader
//
//  Created by CQSC  on 2017/6/25.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadPageBacViewController: UIViewController {
    
    fileprivate var bacImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.layer.contents = bacImage.cgImage
    }
    
    func updateWithViewController(_ vc: UIViewController) {
        bacImage = captureView(vc.view)
    }
    
    func captureView(_ view: UIView) -> UIImage {
        let rect = view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            
            let transform = __CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0.0)
            context.concatenate(transform)
            context.setAlpha(0.8)
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image == nil ? UIImage() : image!
            
        }else {
            return UIImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
