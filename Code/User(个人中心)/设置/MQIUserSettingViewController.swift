//
//  MQIUserSettingViewController.swift
//  CQSC
//
//  Created by moqing on 2019/3/6.
//  Copyright © 2019年 _CHK_. All rights reshttps://lanhuapp.com/web/#/item/project/board?pid=19732c76-eb3c-4f91-86bd-fd8c811d74eberved.
//

import UIKit
/*
 拉拉
 */
import PSAlertView
import SDWebImage

class MQIUserSettingViewController: MQIBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var datas = [String]()
    var window: UIWindow! {
        return getWindow()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        switchLanguage()
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
    }
    override func switchLanguage() {
        super.switchLanguage()
        title = kLocalized("Set")
        datas = [kLocalized("AutomaticSubscriptionSettings"),
                 kLocalized("ReadThePageTurningEffect"),
                 kLocalized("ClearImageCache"),
                 "\(kLocalized("about"))\(COPYRIGHTNAME)",
            /* "多语言设置"*/
           
        ]
        tableView.reloadData()
    }
    //切换阅读效果
    func changeReaderEffect(_ effectType:GYReadEffectType) {
        guard GYReadStyle.shared.styleModel.effectType != effectType else { return }
        GYReadStyle.shared.styleModel.effectType = effectType
        GYReadStyle.shared.saveStyleModel()
        
        tableView.reloadData()
        
    }
    func showReaderEffect() {
        let alert = PSPDFActionSheet(title: kLocalized("ChooseTourReadingStyle"))
        
        alert?.setCancelButtonWithTitle(kLocalized("Cancel"), block: { (index) in
            
        })
        alert?.addButton(withTitle: kLocalized("TheSimulation")) { [weak self](index) in
            self?.changeReaderEffect(.simulation)
        }
        alert?.addButton(withTitle: kLocalized("contracted"), block: { [weak self](index) in
            self?.changeReaderEffect(.translation)
        })
        alert?.addButton(withTitle: kLocalized("UpAndDown"), block: { [weak self](index) in
            self?.changeReaderEffect(.upAndDown)
        })
        alert?.addButton(withTitle: kLocalized("ThereIsNo"), block: { [weak self](index) in
            self?.changeReaderEffect(.none)
        })
        alert?.showWithSender(window, fallbackView: window, animated: true)
        
    }
    func getSizeUnit_Withbites(_ size:CGFloat) -> String {
        guard (size/1024 > 1)  else {
            return "0KB"
        }
        guard (size/1024 > 100) else {
            let kbSize = String(format: "%.1f",size/1024)
            return "\(kbSize)KB"
        }
        guard size/(1024*1024) > 1024 else {
            let msize = String(format: "%.1f",size/(1024*1024))
            return "\(msize)MB"
        }
        let gsize = String(format:"%.1f",size/(1024*1024*1024))
        return "\(gsize)GB"
    }
    
    func switchLanguages(_ cell:UITableViewCell) {
        let alertController = UIAlertController(title: "",  message:"选择当前语言", preferredStyle: .actionSheet)
        
        
        /// 适配ipd
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = cell
            popoverController.sourceRect = CGRect.init(x:screenWidth*0.25, y: screenHeight-100, width: screenWidth*0.5 , height: screenWidth*0.3)
        }
        
        let cancelAction = UIAlertAction(title: kLocalized("Cancel"), style: .cancel, handler:{
            action in
         
        })
        
        let action1 = UIAlertAction(title:"简体中文", style: .default,handler:{ action in
            MQILoadManager.shared.addProgressHUD("")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                DSYLanguageControl.dsySwitchLanguage(.createType("简体中文"), success: { (su) in
                changeLogo()
                MQILoadManager.shared.dismissProgressHUD()
               
                })
            }
       
        })
        let action2 = UIAlertAction(title:"繁體中文", style: .default,handler:{ action in
            MQILoadManager.shared.addProgressHUD("")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                DSYLanguageControl.dsySwitchLanguage(.createType("繁體中文"), success: { (su) in
                changeLogo()
                MQILoadManager.shared.dismissProgressHUD()
                 
                })
            }
                                        
        })
    
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    deinit {
        mqLog("set dealloc")
        
    }
}
private let cellIdentifier = "cellIdentifier"
extension MQIUserSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        if indexPath.row == 1{
            cell.detailTextLabel?.text = GYReadStyle.shared.styleModel.effectType.conversion()
        }
        if indexPath.row == 2 {
            cell.detailTextLabel?.text = "\(getSizeUnit_Withbites(CGFloat(SDImageCache.shared().getSize())))"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: 
            pushVC(MQIUserAutoReaderSetVC())
            break
        case 1:
            showReaderEffect()
            break
        case 2:
            MQILoadManager.shared.addAlert(msg: kLocalized("AreYouSureToDeleteTheImageCache"), block: {[weak self]()->Void in
                if let weakSelf = self {
                    SDImageCache.shared().clearDisk()
                    MQILoadManager.shared.makeToast(kLocalized("ClearSuccess"))
                    weakSelf.tableView.reloadData()
                }
            })
            break
        case 3:
            pushVC(MQIAboutViewController.create()!)
            break
        case 4:
            switchLanguages(tableView.cellForRow(at: indexPath)!)
            break
        default:
            break
        }
    }
}


extension UIViewController {
    class func create() -> UIViewController? {
        guard let sbname = NSStringFromClass(self).components(separatedBy: ".").last else { return nil }
        let vc = UIStoryboard.init(name: sbname, bundle: Bundle.main).instantiateInitialViewController()
        return vc
    }
}


