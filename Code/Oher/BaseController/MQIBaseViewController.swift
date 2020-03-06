//
//  MQIBaseViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/26.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let root_status_height: CGFloat = x_StatusBarHeight
let root_nav_height: CGFloat = 44
let root_bottomTool_height: CGFloat = ipad == true ? 55 : 45

let bacTag: NSInteger = 1001

let info_btnSide: CGFloat = 40

let bottomTool_btnTopSpace: CGFloat = 2
let bottomTool_btnHeight: CGFloat = root_bottomTool_height-2*bottomTool_btnTopSpace

let nav_rightBtn_tag: Int = 10001
let nav_leftBtn_tag: Int = 10002

let nav_btn_side: CGFloat = 34
let nav_btn_space: CGFloat = 10

let nav_button_textColor: UIColor = RGBColor(201, g: 201, b: 201)

class MQIBaseViewController: UIViewController {
    public var bottomTool: UIView!
    public var preloadView: MQIPreloadView?
    public var wrongView: MQIWrongView?
    public var wrongFullPageView: MQIFullPageWrongView?
    public var noDataView: MQINoDataView?
    public var status: UIView!
    public var nav: UIView!
    public var titleLabel: UILabel!
    public var contentView: UIView!
    public var navBacColor: UIColor = RGBColor(194, g: 115, b: 204)
    public var navTintFont: UIFont = boldFont(17)
    public var navTintColor: UIColor = UIColor.black
    public var navAlignment: NSTextAlignment = .center
    public var successView:MQIPayResultView!
    override var title: String! {
        didSet {
            if titleLabel != nil {
                titleLabel.text = title
            }
        }
    }
    var popBlock: (() -> ())?
    
    var isStatusBarHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
//    override func loadView() {
//        super.loadView()
//    }
    func addBottomTool() {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 200
        self.edgesForExtendedLayout = .all
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.isMultipleTouchEnabled = false
        status = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: root_status_height))
        status.backgroundColor = navBacColor
        status.layer.addDefineLayer(status.bounds)
        view.addSubview(status)
        view.bringSubviewToFront(status)
        nav = UIView(frame: CGRect(x: 0, y: root_status_height, width: screenWidth, height: root_nav_height))
        nav.backgroundColor = navBacColor
        nav.layer.addDefineLayer(nav.bounds)
        view.addSubview(nav)
        view.bringSubviewToFront(nav)
        
        titleLabel = createLabel(CGRect(x: 50, y: 0, width: screenWidth-100, height: root_nav_height),
                                 font: navTintFont,
                                 bacColor: UIColor.clear,
                                 textColor: navTintColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: navAlignment,
                                 numberOfLines: 1)
        titleLabel.text = title
        nav.addSubview(titleLabel)
        contentView = UIView(frame: CGRect(x: 0,
                                           y: root_nav_height+root_status_height,
                                           width: view.width,
                                           height: view.height-root_nav_height-root_status_height - x_TabbatSafeBottomMargin))
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        view.sendSubviewToBack(contentView)
        
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                addBackBtn()
            }
        }
        UserNotifier.addObserver(self, selector: #selector(MQIBaseViewController.setSectionID), notification: .changeSectionID)
        NotificationCenter.default.addObserver(self, selector: #selector(switchLanguage), name: NSNotification.Name(rawValue: DSYLanguageControl.SETLANGUAHE), object: nil)
    }
    

    deinit {
        UserNotifier.removeObserver(self, notification: .changeSectionID)
    }
    @objc func switchLanguage()  {}
    
    @objc public func setSectionID() {}
    /// 没有或者隐藏nav时的Frame
    func setContentViewNONavFrame() {
        let y = contentView.y
        contentView.y = 0
        contentView.height += y
    }
    ///隐藏nav
    func hiddenNav()  {
        nav.alpha = 0
        status.alpha = 0
    }
    func removeNav() {
        if nav != nil {
            nav.removeFromSuperview()
            nav = nil
        }
    }
    
    func removeStatus() {
        if status != nil {
            status.removeFromSuperview()
            status = nil
        }
    }
    func addNoDataView() {
        if noDataView == nil {
            noDataView = MQINoDataView(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
            self.view.addSubview(noDataView!)
            self.view.bringSubviewToFront(noDataView!)
        }
    }
    
    
    func dismissNoDataView() {
        if let noDataView = noDataView {
            noDataView.dismiss({() -> Void in
                self.noDataView = nil
            })
            
        }
    }
   
    func addPreloadView() {
        if preloadView == nil {
            preloadView = MQIPreloadView(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
        }
        self.view.addSubview(preloadView!)
    }
    func showLoadSuccessView(channel_id:String,price:String){
        if successView != nil {
            successView.removeFromSuperview()
            successView = nil
        }
        var pingtai = kLocalized("MicroLetterToPay")
        if channel_id == "20" || channel_id == "21" || channel_id == "16"{
         
            pingtai = kLocalized("APayment")
        }
        successView = MQIPayResultView.init(frame: CGRect.zero)
        successView.price = price
        successView.pingtai = pingtai
        successView.show()
    }
    func addWrongView(_ text: String?, refresh: @escaping (() -> ())) {
        if wrongView == nil {
            wrongView = MQIWrongView(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
        }
        if text != nil {
            wrongView!.configText(text!)
        }
        wrongView!.setRefresh(refresh)
        wrongView!.setLoad()
        self.view.addSubview(wrongView!)
    }
    func addWrongFullPageView(_ text: String?, refresh: @escaping (() -> ())) {
        if wrongFullPageView == nil {
            wrongFullPageView = MQIFullPageWrongView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: self.view.height))
        }
        if text != nil {
            wrongFullPageView!.configText(text!)
        }
        wrongFullPageView!.setRefresh(refresh)
        wrongFullPageView!.setLoad()
        self.view.addSubview(wrongFullPageView!)
    }
    func dismissPreloadView() {
        if let preloadView = preloadView {
            preloadView.dismiss({() -> Void in
                self.preloadView = nil
            })
        }
    }
    func dismissWrongView() {
        if let wrongView = wrongView {
            wrongView.dismiss({() -> Void in
                self.wrongView = nil
            })
        }
    }
    func dismissWrongFullPageView() {
        if let wrongView = wrongFullPageView {
            wrongView.dismiss({() -> Void in
                self.wrongFullPageView = nil
            })
        }
    }
    @discardableResult func addBackBtn() -> UIButton {
        if nav == nil {
            return UIButton()
        }
        
        let backBtn = getBackBtn()
        let image =  UIImage(named:"nav_back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(image, for: .normal)
        backBtn.tintColor = navTintColor
        backBtn.frame = CGRect(x: 15, y: 0, width: root_nav_height, height: root_nav_height)
        backBtn.addTarget(self, action: #selector(MQIBaseViewController.backAction), for: .touchUpInside)
        nav.addSubview(backBtn)
        return backBtn
    }
    
    @objc func backAction() {
        popVC()
    }
    
    @discardableResult func addLeftBtn(_ name: String?, imgStr: String?) -> UIButton {
        if nav == nil {
            return UIButton()
        }
        
        let newBtn = UIButton(frame: CGRect(x: 8, y: 0, width: root_nav_height, height: root_nav_height))
        newBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        newBtn.tag = nav_rightBtn_tag
        newBtn.addTarget(self, action: #selector(MQIBaseViewController.leftBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        if name != nil {
            newBtn.setTitle(name!, for: .normal)
            newBtn.setTitleColor(nav_button_textColor, for: .normal)
        }
        if imgStr != nil {
            newBtn.setImage(UIImage(named: imgStr!), for: .normal)
        }
        nav.addSubview(newBtn)
        return newBtn
    }
    
    @objc func leftBtnAction(_ button: UIButton) {
        
    }
    
    @discardableResult func addRightBtn(_ name: String?, imgStr: String?) -> UIButton {
        if nav == nil {
            return UIButton()
        }
        
        let newBtn = UIButton(frame: CGRect(x: view.bounds.width-8-root_nav_height-10, y: 0, width: root_nav_height, height: root_nav_height))
        newBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        newBtn.tag = nav_rightBtn_tag
        newBtn.addTarget(self, action: #selector(MQIBaseViewController.rightBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        if name != nil {
            newBtn.setTitle(name!, for: .normal)
            newBtn.setTitleColor(nav_button_textColor, for: .normal)
        }
        if imgStr != nil {
            newBtn.setImage(UIImage(named: imgStr!), for: .normal)
        }
        nav.addSubview(newBtn)
        return newBtn
    }
    
    @objc func rightBtnAction(_ button: UIButton) {
        
    }
    func pushVC(_ vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC(completion: (() -> ())?) {
        if let navigationController = navigationController {
            (navigationController as! MQINavigationViewController)
//                .popToRootViewControllerAnimated(animated: true) {
//                    completion?()
//            }
                .popViewController(animated: true, completion: {
                    completion?()
                })
        }
    }
    
    func popVC() {
        popVC {[weak self] in
            if let strongSelf = self {
                strongSelf.popBlock?()
            }
        }
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
