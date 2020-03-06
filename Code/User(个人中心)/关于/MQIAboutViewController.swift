//
//  MQIAboutVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIAboutViewController: MQIBaseViewController {

    var  termsView:UIView!
 
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var version: UILabel!
    
    let animateTimeInterval: TimeInterval = 0.5
    var maskView: MQIQRCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maskView = MQIQRCodeView()
        maskView.frame = UIScreen.main.bounds
        maskView.isHidden = true
        view.addSubview(maskView)
        maskView.touchBgView = { [weak self] in
            guard let sf = self else { return }
            UIView.animate(withDuration: sf.animateTimeInterval, animations: {
                sf.maskView.alpha = 0
            }, completion: { (_) in
                sf.maskView.isHidden = true
            })
        }
        
        title = "\(kLocalized("about"))\(COPYRIGHTNAME)"
        version.text = "\(kLocalized("version"))\(getCurrentVersion())" + " (" + String(buildVersion) + ")"
        message.text = APP_Ownership_Text
    }
    
    
    let  termsTitle:[[Any]] = {
        return [
            [kLocalized("TheTermsOfService"),UIImage.init(named: "arrow_right") ?? UIImage()],
            [kLocalized("PrivacyPolicy"),UIImage.init(named: "arrow_right") ?? UIImage()],
            [kLocalized("BusinessQQ"),"m1234594"],
//            [kLocalized("MicroSignal"),"jiuyuemoqing"],
            ]
    }()
    
    
}
private let cellIdentifier = "cellIdentifier"
extension MQIAboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = termsTitle[indexPath.row][0] as? String
        if indexPath.row == 2 {
            cell.detailTextLabel?.text = termsTitle[2][1] as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController!
        switch indexPath.row {
        case 0:
            let webvc = MQIWebVC()
            webvc.url = The_Terms_Of_Service
            vc = webvc
            break
        case 1:
            let webvc = MQIWebVC()
            webvc.url = Privacy_Agreement
            vc = webvc
            break
        case 2:
            maskView.isHidden = false
            UIView.animate(withDuration: animateTimeInterval) {
                self.maskView.alpha = 1
            }
//            let pas = UIPasteboard.general
//            pas.string = termsTitle[2][1] as? String
//            MQILoadManager.shared.makeToast(kLocalized("CopySuccess"))
            return
        default:
            return
        }
        
        pushVC(vc)
    }
}


extension MQIAboutViewController {
    
    class MQIQRCodeView: UIView {
        
        
        var touchBgView: (() -> ())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configUI()
        }
        
        func configUI() {
            backgroundColor = .clear
            let mask = UIControl()
            mask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            mask.frame = UIScreen.main.bounds
            mask.addTarget(self, action: #selector(cilckBgView), for: .touchUpInside)
            addSubview(mask)
            
            let image = UIImageView(image: UIImage(named: "lineQRCodeImage"))
            image.contentMode = .scaleAspectFit
            addSubview(image)
            image.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            
        }
        @objc func cilckBgView() {
            touchBgView?()
        }
        
    }
    
    
    
    
}
