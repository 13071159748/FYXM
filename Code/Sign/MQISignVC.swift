//
//  MQISignVC.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/11.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQISignVC: MQIBaseViewController {

    var books:[MQIEachBook] = [MQIEachBook]()
    
    var signButton:UIButton?
    //推荐书籍
    var recommandsArray = [MQIEachBook]()
    
    var gdCollectionView:MQICollectionView!
    
    var dataModel:MQRecommendInfoModel?
    var topView:UIView!
    
    /// 状态label
    var stateLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MQIEventManager.shared.eCheckIn()
        
        title = kLocalized("SignInForBenefits")
        contentView.backgroundColor = UIColor.colorWithHexString("#ffffff")
        sign_addSignButton()//签到按钮部分
        
        if let user = MQIUserManager.shared.user {
            if user.sign_in {
                stateLabel.text = kLocalized("CheckiInStatus")
                MQIUserManager.shared.updateUserInfo {[weak self] (suc, msg) in
                    self?.stateLabel.text = ""
                    MQILoadManager.shared.makeToast(kLocalized("ToObtainComplete"))
                    if let user = MQIUserManager.shared.user {
                        if user.sign_in {
                            self?.didSigned_in()
                        }
                    }
                }
            }
        }
    
        //推荐书籍请求
        createSignCollection()
        
       
    }
    //添加签到按钮
    func sign_addSignButton() {

        topView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: 268))
//        topView.layer.addDefineLayer(topView.bounds)
//        let imgae = UIImage(named: "sign_bac_image") ?? UIImage()
//        topView.layer.contents  =  imgae.cgImage
        topView.backgroundColor  = mainColor
        contentView.addSubview(topView)
        
        let squireImageView = UIImageView(frame: CGRect (x: 0, y: 0, width: 120*1.27, height:120))
          squireImageView.center = CGPoint(x: topView.width*0.5, y: topView.height*0.5-10)
        squireImageView.image = UIImage.init(named: "Sign_backround")
        contentView.addSubview(squireImageView)
        squireImageView.isUserInteractionEnabled = true
        
        stateLabel =  UILabel(frame: CGRect(x: 0, y:10, width:topView.width , height: 20))
        stateLabel.font = UIFont.systemFont(ofSize: 13)
        stateLabel.textColor = UIColor.white
        stateLabel.textAlignment = .center
        stateLabel.text = ""
        topView.addSubview(stateLabel)
        
        //放sign按钮
        signButton = UIButton()
        contentView.addSubview(signButton!)
        let signBtnW = squireImageView.height*0.7
        signButton?.bounds = CGRect(x: 0, y: 0, width: signBtnW, height: signBtnW)
        signButton?.center = squireImageView.center
        signButton?.setTitle(kLocalized("SignIn"), for: UIControlState())
        signButton?.backgroundColor = UIColor.white
        signButton?.setTitleColor(mainColor, for: UIControlState())
        signButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        signButton?.layer.cornerRadius = signButton!.height*0.5
        signButton?.clipsToBounds = true
        signButton?.addTarget(self, action: #selector(MQISignVC.signButtonClickToSignRequest), for: .touchUpInside)
        
        
        //波浪
        let waveImageView = UIImageView(frame: CGRect (x: 0, y: topView.height - 50, width: screenWidth, height: 50))
        contentView.addSubview(waveImageView)
        waveImageView.image = UIImage.init(named: "Sign_wave")
        
        ///  福利l标签
        let welfareLabel  = UILabel(frame: CGRect(x: 0, y:waveImageView.y-10, width:topView.width , height: 20))
        welfareLabel.font = UIFont.systemFont(ofSize: 14)
        welfareLabel.textColor = UIColor.white
        welfareLabel.textAlignment = .center
        welfareLabel.text = "每天签到，免费领福利"
        contentView.addSubview(welfareLabel)
        if let user = MQIUserManager.shared.user {
            if user.sign_in {
                didSigned_in()
            }
        }
    }
    
    @objc func signButtonClickToSignRequest() {
       
        if MQIUserManager.shared.checkIsLogin() == false {
            MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: {[weak self]()->Void in
                if let weakSelf = self {
                    if (MQIUserManager.shared.user?.sign_in)! {
                        weakSelf.didSigned_in()
                    }else {
                        weakSelf.startToAppear_FlipCard()
                    }

                }
            })
        }else {
            startToAppear_FlipCard()
        }

//        startToAppear_FlipCard()
    }
    
    //已经签到过了
    func didSigned_in() {
        signButton?.setTitle(kLocalized("AlreadySignedIn"), for: UIControlState())
        signButton?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        signButton?.isEnabled = false
        
    }
    //翻牌
    func startToAppear_FlipCard() {
        let cardView = MQISignFlipCardView(frame: view.bounds)
        view.addSubview(cardView)
        cardView.alpha = 0
        cardView.signSuccess = {[weak self](suc,err_code)->Void in
            if let weakSelf = self {
                if suc{
                    if let user = MQIUserManager.shared.user {
                        user.sign_in = true
                    }
                    UserNotifier.postNotification(.refresh_coin)
                    UserNotifier.postNotification(.sign_finish)
                    
                    weakSelf.didSigned_in()
                }else {
                    if err_code == "11900" {
                        //已经签到过了
                        if let user = MQIUserManager.shared.user {
                            user.sign_in = true
                            UserNotifier.postNotification(.sign_finish)
                        }
                        weakSelf.didSigned_in()
                        UIView.animate(withDuration: 0.25, animations: {
                            cardView.alpha = 0
                        }, completion: { (finish) in
                            cardView.removeFromSuperview()
                        })
                    }else {
                        MQILoadManager.shared.makeToast(kLocalized("NewError"))
                        
                    }
                    
                }
            }
            
        }
        UIView.animate(withDuration: 0.25) {
            cardView.alpha = 1
        }
        
    }
    func createSignCollection() {
        
        let middleTitleLabel = UILabel(frame:CGRect (x: 20, y: topView.maxY+30, width: 80, height: 15))
//        middleTitleLabel.center = CGPoint (x: screenWidth/2, y: 193 + 30.5)
        middleTitleLabel.text = kLocalized("RecommendedReading")
        middleTitleLabel.textColor = UIColor.colorWithHexString("#333333")
        middleTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        middleTitleLabel.textAlignment = .center
        contentView.addSubview(middleTitleLabel)
        
        middleTitleLabel.centerX = contentView.centerX
        
        let line1 = UIView(frame: CGRect.zero)
        line1.backgroundColor = UIColor.colorWithHexString("#ECECEC")
        contentView.addSubview(line1)
        
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(30)
            make.right.equalTo(middleTitleLabel.snp.left)
            make.centerY.equalTo(middleTitleLabel)
            make.height.equalTo(1)
        }

        let line2 = UIView(frame: CGRect.zero)
        line2.backgroundColor = UIColor.colorWithHexString("#ECECEC")
        contentView.addSubview(line2)

        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-30)
            make.left.equalTo(middleTitleLabel.snp.right)
            make.centerY.equalTo(line1)
            make.height.equalTo(line1)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: CGRect (x: 0, y: middleTitleLabel.maxY + 10, width: screenWidth, height: screenHeight-middleTitleLabel.maxY - 74),collectionViewLayout: layout)
        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQISignRecommandCell.self, xib: false)
        
        contentView.addSubview(gdCollectionView)
        
        requestRecommends()
    }
    
    //MARK:推荐书籍
    func requestRecommends() {
        
        GYBookInfoRecommendsRequest(tj_type: TYPE_SIGN)
            .request({[weak self] (request, response, result:MQRecommendInfoModel) in
                if let strongSelf = self {
                    strongSelf.dataModel = result
                     strongSelf.recommandsArray = result.data
                    strongSelf.gdCollectionView.reloadData()
                }
            }) { (err_msg, err_code) in
                
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        mqLog("MQISignVC dealloc")
    }
    
}
extension MQISignVC:MQICollectionViewDelegate {
    
    
    //MARK: Delegate
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        
        return 1
        
    }
    
    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        
        return recommandsArray.count
        
    }
    //    //横向距离   每个cell的
    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
        return 0
    }
    
    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 17.5, 0, 17.5)
        
    }
    
    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        
        return MQISignRecommandCell.getSize()
        
    }
    
    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let currentBook = recommandsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MQISignRecommandCell.self, forIndexPath: indexPath)
        cell.book  = currentBook
        return cell
        
    }
    
    
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let currentBook = recommandsArray[indexPath.row]

        //        GYUserOperateManager.shared.toReader(currentBook.book_id)
        MQIUserOperateManager.shared.toBookInfo(currentBook.book_id)
        MQIEventManager.shared.appendEventData(eventType: .lottery_book, additional: ["book_id":currentBook.book_id,"position":dataModel?.name ?? ""])
    }
    

}
