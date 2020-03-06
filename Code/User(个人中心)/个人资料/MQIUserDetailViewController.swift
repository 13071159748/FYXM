//
//  MQIUserDetailViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/3.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import SDWebImage
import Photos

class MQIUserDetailViewController: MQIBaseViewController{

    
    var tableView: UITableView!
    /// 本地分类数据
    fileprivate var infoDatas = [[[String:String]]]()
    
    var loginOutBlock: (() -> ())?
    /// 不可用上传功能
    var isUploadeIcon:Bool = false
    var imagePickerController:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserNotifier.addObserver(self, selector: #selector(MQIUserDetailViewController.refreshtableView), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQIUserDetailViewController.refreshtableView), notification: .login_out)
        title = kLocalized("ThePersonalData")
        
        tableView = UITableView ()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithHexString("#F6F6F6")
        tableView.separatorStyle = .none
        tableView.frame = contentView.bounds
        contentView.addSubview(tableView)
        tableView.register(MQIUserDetailIconCell.self, forCellReuseIdentifier: "MQIUserDetailIconCellName")
        tableView.register(MQIUserInfoLoginOutCell.self, forCellReuseIdentifier: "MQIUserInfoLoginOutCellName")
        tableView.register(MQIUserDetailCell.self, forCellReuseIdentifier: "MQIUserDetailCellName")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        infoConfig()
        
    }
     @objc func refreshtableView(){
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         infoConfig()
    }
    
    func loginOut() {
        MQILoadManager.shared.addAlert(kLocalized("Warn"), msg: kLocalized("AreYouSureYouWantToChangeYourAccount"), block: {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.popVC()
                weakSelf.loginOutBlock?()
                
            }
        })
    }
    
    func toVC(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    deinit {
        mqLog("🍎 userDetail dealloc")
    }
    
    func initImagePickerController(_ type:UIImagePickerController.SourceType) {
        if imagePickerController == nil {
            imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
        }
        
        getImageFromPhone(type:type)
    }
    func getImageFromPhone(type:UIImagePickerController.SourceType) {
        
        if type == .photoLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = type
                self.present(imagePickerController, animated: true, completion: nil)
            }else {
                mqLog("不支持打开相册")
            }
        }else if type == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = type
                self.present(imagePickerController, animated: true, completion: nil)
            }else {
                mqLog("不支持相机")
                MQILoadManager.shared.addAlert_oneBtn(kLocalized("Warn"), msg: kLocalized("CamerasAreNotSupportedOnCurrentDevices"), block: {
                    
                })
                
            }
        }
        
        
    }
    
}

extension MQIUserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDatas[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
        switch jumpLogo {
        case  "icon":
              return MQIUserDetailIconCell.getHeight(nil)
        case  "login":
            return MQIUserInfoLoginOutCell.getHeight(nil)
        
        default:
            return MQIUserDetailCell.getHeight(nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return  0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 1 {return 0}
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  view = UIView()
        
        let titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 14)
        titleLable.textColor  =  UIColor.colorWithHexString("333333")
        view.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(23)
            make.centerY.right.equalToSuperview()
        }
        if section == 0 {
           titleLable.text = "基本信息"
        }else{
          titleLable.text = "账户安全"
        }
        
        return view
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  data = infoDatas[indexPath.section][indexPath.row]
        let jumpLogo = data["jumpLogo"]
        switch jumpLogo {
            
        case "icon":
            let cell = tableView.dequeueReusableCell(withIdentifier: "MQIUserDetailIconCellName", for: indexPath) as! MQIUserDetailIconCell
            cell.backgroundColor = UIColor.white
            cell.infoTitle.text = data["title"]
            /// 解决有些服务器不可上传头像问题
            if isUploadeIcon {
                cell.nextImg?.isHidden = true
                cell.isUserInteractionEnabled = false
            }
            if let user = MQIUserManager.shared.user {
                cell.UDUser = user
            }
            cell.addLine(0, lineColor: UIColor.colorWithHexString("#F6F6F6"), directions: .bottom,lineHeight: 1)
              return cell
          case "login":
                let cell = tableView.dequeueReusableCell(withIdentifier: "MQIUserInfoLoginOutCellName", for: indexPath) as! MQIUserInfoLoginOutCell
                      cell.backgroundColor = UIColor.clear
                cell.toLoginOut = {[weak self]()->Void in
                    if let weakSelf = self { weakSelf.loginOut() }
                }
                 cell.addLine(0, lineColor: UIColor.colorWithHexString("#F6F6F6"), directions: .bottom,lineHeight: 1)
                return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MQIUserDetailCellName", for: indexPath) as! MQIUserDetailCell
                cell.backgroundColor = UIColor.white
            cell.infoTitle.text = data["title"]
            let jumpLogo =  data["jumpLogo"]
            if data["right_img"] != nil {
               cell.addUserInfoNext()
            }
            cell.addLine(0, lineColor: UIColor.colorWithHexString("#F6F6F6"), directions: .bottom,lineHeight: 1)
            
            if let user = MQIUserManager.shared.user {
              
                if jumpLogo == "nick" {
                      cell.contentsBtn.setTitle(user.user_nick, for: .normal)
                }else  if jumpLogo == "vip" {
                    cell.contentsBtn.setTitle( (user.user_vip_level.integerValue() > 0) ?
                        kLocalized("VIPMembers") : kLocalized("ordinarMembers"), for: .normal)
                }else  if jumpLogo == "email" {
                    
                    if user.isNewEmail.count  > 1 {
                         cell.contentsBtn.setTitle( user.isNewEmail, for: .normal)
                    }else{
                        cell.contentsBtn.setTitle("去绑定", for: .normal)
                    }
                }
              else  if jumpLogo == "id" {
                    cell.contentsBtn.setTitle("  "+user.user_id, for: .normal)
                    var longNanme:String!
                    let type = LoginType.createType("\(user.lastLoginType)")
                    switch type {
                    case .Google:
                        longNanme = "Bind_G_img"
                        break
                    case .Wechat:
                        longNanme = "Bind_W_img"
                        break
                    case .Facebook:
                        longNanme = "Bind_Fb_img"
                        break
                    case .Twitter:
                        longNanme = "Bind_T_img"
                        break
                    case .Linkedin:
                        longNanme = "Bind_line_img"
                        break
                    case .Email:
                        longNanme = "login_mail_img"
                        break
                    default:
                        longNanme  = ""
                        break
                    }
                    
                    cell.contentsBtn.setImage(UIImage(named: longNanme), for: .normal)
                } else{
                    cell.contentsBtn.setTitle("", for: .normal)
                }
            }else{
                cell.contentsBtn.setTitle("", for: .normal)
                cell.contentsBtn.setImage(nil, for: .normal)
            }
   
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
        switch jumpLogo {
            
        case "icon":
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            /// 适配ipd
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect.init(x:screenWidth*0.5 - 50, y: screenHeight, width: 100, height: 300)
            }
            
//            let takePhoto = UIAlertAction(title: kLocalized("TakingPictures"), style: .default) { [weak self](action) in
//                if let weakSelf = self {
//                    weakSelf.initImagePickerController(.camera)
//                }
//            }
            let photoLib = UIAlertAction(title: kLocalized("SelectFromPhotoAlbums"), style: .default) { [weak self](action) in
                if let weakSelf = self {
                    let authStatus = PHPhotoLibrary.authorizationStatus()
                    if authStatus == .notDetermined {
                        
                        PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                            
                            if status == .authorized {
                                weakSelf.initImagePickerController(.photoLibrary)
                                
                            }else{
                                mqLog("取消授权\(status.rawValue)")
                            }
                            
                        }
                        
                    } else if authStatus == .authorized {
                        weakSelf.initImagePickerController(.photoLibrary)
                    }
                    
                }
            }
            let cancel = UIAlertAction(title: kLocalized("Cancel"), style: .cancel) { (action) in
                
            }
//            alertController.addAction(takePhoto)
            alertController.addAction(photoLib)
            alertController.addAction(cancel)
     
            self.present(alertController, animated: true, completion: nil)

            return
        case "id":
            UIPasteboard.general.string = MQIUserManager.shared.user?.user_id
            MQILoadManager.shared.makeToast(kLocalized("CopySuccess"))
            return
        case "nick":
            let nickVC = MQIUserDetailNickNameVC()
            pushVC(nickVC)
            return
        case "email":
            let bindVC = MQIBindEmailViewController()
              var tostStr = "邮箱已绑定完成！"
            if MQIUserManager.shared.user?.isNewEmail.count ?? 0 > 1 {
                 bindVC.type = .change_email
                tostStr = "邮箱已修改完成！"
            }else{
                 bindVC.type = .bind_email
            }
          
            pushVC(bindVC)
            bindVC.loginSuccess = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.infoConfig()
                weakSelf.tableView.reloadData()
                MQILoadManager.shared.makeToast(tostStr)
            }
            
            return
        case "pwd":
            if MQIUserManager.shared.user?.user_email.count ?? 0 > 1 {
                let bindVC = MQIBindEmailViewController()
                bindVC.type = .reset_Pwd
                pushVC(bindVC)
                bindVC.loginSuccess = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.infoConfig()
                    weakSelf.tableView.reloadData()
                    MQILoadManager.shared.makeToast("已成功修改密码")
                }
                
            }
            return
        case "login":
            return
        default:
          
            return
            
        }
      
    }
    
    
    func getEmail() -> String {
        return  MQIUserManager.shared.user?.isNewEmail ?? ""
    }

}

extension MQIUserDetailViewController {
  
    //MARK:  固定数据配置
    func infoConfig() -> Void {
        if MQIUserManager.shared.user?.isNewEmail.count ?? 0 > 1 {
        
            infoDatas = [
                [
                    ["title":kLocalized("HeadPortrait", describeStr: "头像"),
                     "jumpLogo":"icon"
                    ],
                    ["title": kLocalized("IDAccount", describeStr: "id"),
                     "jumpLogo":"id"
                    ],
                    ["title": kLocalized("nickname", describeStr: "昵称"),
                     "jumpLogo":"nick",
                     "right_img": "1"
                    ],
                    
                    ],
                
                [
                    [
                        
                        "title": kLocalized("Replace_the_email", describeStr: "更换邮箱"),
                        "jumpLogo":"email",
                        "right_img": "1"
                    ],
                    ["title": kLocalized("Reset_password", describeStr: "重置密码"),
                     "jumpLogo": "pwd",
                     "right_img": "1"
                    ],
                    ["title": kLocalized("TheLogin", describeStr: "登录"),
                     "jumpLogo":"login"
                    ]
                ],
                
            ]
       
        
        }else {
            
            infoDatas = [
                [
                    ["title":kLocalized("HeadPortrait", describeStr: "头像"),
                     "jumpLogo":"icon"
                    ],
                    ["title": kLocalized("IDAccount", describeStr: "id"),
                     "jumpLogo":"id"
                    ],
                    ["title": kLocalized("nickname", describeStr: "昵称"),
                     "jumpLogo":"nick",
                     "right_img": "1"
                    ],
                    
                    ],
                
                [
                    [
                        
                        "title": kLocalized("Binding_email", describeStr: "绑定邮箱"),
                        "jumpLogo":"email",
                        "right_img": "1"
                    ],
                    ["title": kLocalized("TheLogin", describeStr: "登录"),
                     "jumpLogo":"login"
                    ]
                ],
                
            ]
            
        }
        
       
    }
        

}

extension MQIUserDetailViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate ,HQImageEditViewControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let type = (info[.mediaType] as! String)
         if type == "public.image" {
             //let img = info[UIImagePickerControllerOriginalImage] as? UIImage
             let img  = info[.editedImage] as? UIImage
//
     
            guard let image = img  else{ return}
            let editvc =  HQImageEditViewController()
            editvc.originImage = image
            editvc.delegate = self
            editvc.maskViewAnimation = false
            pushVC(editvc)
            
            
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    
    func editControllerDidClickCancel(_ vc: HQImageEditViewController) {
          vc.navigationController?.popViewController(animated: true)
    }
    
    func edit(_ vc: HQImageEditViewController, finishiEditShotImage image: UIImage, originSizeImage: UIImage) {
         updateUserAvatar(image)
        vc.navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateUserAvatar(_ image:UIImage) {
     
        guard var  jpegData =   image.jpegData(compressionQuality: 1.0) else {
             MQILoadManager.shared.makeToast("上传失败")
            return
        }
        
        jpegData =  resetSizeOfImageData(sourceImage: image, maxSize: 50) as Data
        
        MQILoadManager.shared.addProgressHUD("正在上传")
        GDUpdateAvatarRequest().gd_UploadRequest(imgdata: jpegData, completion: { (result) in
            MQILoadManager.shared.dismissProgressHUD()
            mqLog(result)

            if let user = MQIUserManager.shared.user {
                user.user_avatar = result
            }
            MQIUserManager.shared.saveUser()

            SDImageCache.shared().removeImage(forKey: result, fromDisk: true, withCompletion: {
                UserNotifier.postNotification(.login_in)
            })

        }) { (errmsg, errcode) in
            MQILoadManager.shared.dismissProgressHUD()
            mqLog("\(errmsg) \(errcode)")
            MQILoadManager.shared.makeToast(errmsg)
        }
    }
    
    func reduceImageSize(_ image:UIImage) -> UIImage{
        let newSize = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect (x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg!
    }
    
    
}




extension MQIUserDetailViewController {
    
    // MARK: - 降低质量
    func resetSizeOfImageData(sourceImage: UIImage!, maxSize: Int) -> NSData {
        
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = sourceImage.jpegData(compressionQuality: 1.0)
        let sizeOrigin      = finallImageData?.count
        let sizeOriginKB    = sizeOrigin! / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData! as NSData
        }
        
        //获取原图片宽高比
        let sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024/sourceImageAspectRatio)
        let newImage = self.newSizeImage(size: defaultSize, sourceImage: sourceImage)
        
        finallImageData = newImage.jpegData(compressionQuality: 1.0);
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData?.count == 0 {
            //每次降100分辨率
            let reduceWidth = 100.0
            let reduceHeight = 100.0/sourceImageAspectRatio
            if (defaultSize.width-CGFloat(reduceWidth)) <= 0 || (defaultSize.height-CGFloat(reduceHeight)) <= 0 {
                break
            }
            defaultSize = CGSize(width: (defaultSize.width-CGFloat(reduceWidth)), height: (defaultSize.height-CGFloat(reduceHeight)))
            let image = self.newSizeImage(size: defaultSize, sourceImage: UIImage.init(data: newImage.jpegData(compressionQuality: compressionQualityArr.lastObject as! CGFloat)!)!)
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: image.jpegData(compressionQuality: 1.0)!, maxSize: maxSize)
        }
        
        return finallImageData! as NSData
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    func newSizeImage(size: CGSize, sourceImage: UIImage) -> UIImage {
        var newSize = CGSize(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 二分法
    func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = image.jpegData(compressionQuality: arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
    }
    
}
