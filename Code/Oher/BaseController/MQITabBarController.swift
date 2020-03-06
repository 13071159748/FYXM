//
//  MQITabBarController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/26.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit



class MQITabBarController: UITabBarController {
  
    var currentVC: UIViewController!
    //书架
    let shelfVC = MQIShelfVC()
    // 推荐
    let bookStoreVC = MQIBookStoreViewController()
    //个人中心
    let userVC = MQIUserViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        addChildVC(shelfVC, title: kLocalized("BookShelf"), image: UIImage (named: "tab_Bookshelf_no") ?? UIImage(), selectedImg: UIImage (named: "tab_Bookshelf_sel") ?? UIImage())

        addChildVC(bookStoreVC, title: kLocalized("BookStore"), image: UIImage (named: "tab_recommended_no") ?? UIImage(), selectedImg: UIImage (named: "tab_recommended_sel") ?? UIImage())

     
        addChildVC(userVC, title: kLocalized("mine"), image: UIImage (named: "tab_me_no") ?? UIImage(), selectedImg: UIImage (named: "tab_me_sel") ?? UIImage())
        
//        addChildVC(MQILoginViewController.create()!, title: kLocalized("BookStore"), image: UIImage (named: "tab_recommended_no") ?? UIImage(), selectedImg: UIImage (named: "tab_recommended_sel") ?? UIImage())

        self.selectedIndex = 1
        
        self.tabBar.backgroundColor = UIColor.colorWithHexString("ffffff")
//        self.tabBar.tintColor = tabbarSelectColor
        self.tabBar.isTranslucent = false
        DownNotifier.addObserver(self, selector: #selector(MQITabBarController.goAction(_ :)), notification: .clickTabbar)
        NotificationCenter.default.addObserver(self, selector: #selector(switchLanguage), name: NSNotification.Name(rawValue: DSYLanguageControl.SETLANGUAHE), object: nil)
    }

    @objc func switchLanguage()  {
        shelfVC.title =  kLocalized("BookShelf")
        bookStoreVC.title =  kLocalized("BookStore")
        userVC.title =  kLocalized("mine")
    }
    
    @objc func goAction(_ noti: Notification){
        if let index = noti.userInfo?["index"] as? NSInteger{
            self.selectedIndex = index
        }
    }
    func addChildVC(_ vc:UIViewController,title:String,image:UIImage,selectedImg:UIImage) {
        let nav = MQINavigationViewController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.tabBarItem.title =  title
    nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabbarSelectColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: .selected)
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabbarSelectColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: .normal)
    
        nav.tabBarItem.selectedImage =  selectedImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal);
        nav.tabBarItem.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal);
        
        self.addChild(nav)
        
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
