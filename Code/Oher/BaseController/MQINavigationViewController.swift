//
//  MQINavigationViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/26.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQINavigationViewController: UINavigationController,UINavigationControllerDelegate, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    func pushVC(_ vc: UIViewController) {
        pushViewController(vc, animated: true)
    }
    
    
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() -> Void)) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewControllerAnimated(animated: Bool, completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }

}
