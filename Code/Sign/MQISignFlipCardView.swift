//
//  MQISignFlipCardView.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/11.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
 /*
  拉拉
  */
//翻牌
class MQISignFlipCardView: UIView {

    //    Sign_FlipCardImg
    
    
    var headerImageView:UIImageView!
    
    var topBackView:UIView!//top背景
    
    var closeButton:UIButton!//close
    
    var FlipCardSelectedIndex:((_ index: Int)->())?//选择的index
    var signSuccess:((_ suc:Bool,_ err_code:String?)->())?
    var cardCenterFrame = CGRect.zero
    
    var pockerArray:[MQIPockerView] = [MQIPockerView]()
    
    var inBagButton:UIButton!
    var CongratulationLabel:UILabel!
    //    var bindPhoneLabel:UILabel!
    
    var isDouble = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0.7)
        createFlipCardView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    func createFlipCardView() {
        topBackView = UIView(frame: CGRect.zero)
        //        topBackView.backgroundColor = RGBColor(0, g: 151, b: 167)
        topBackView.backgroundColor = mainColor
        topBackView.layer.cornerRadius = 6
        topBackView.clipsToBounds = true
        self.addSubview(topBackView)
        topBackView.translatesAutoresizingMaskIntoConstraints = false
        topBackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(52/2*gdscale)
            make.right.equalTo(self.snp.right).offset(-52/2*gdscale)
            make.height.equalTo(topBackView.snp.width).multipliedBy(750.0/646)
            make.top.equalTo(self.snp.top).offset(277/2*gdscale)
        }
//        topBackView.layer.addDefineLayer(CGRect (x: 0, y: 0, width: self.width - 52, height: (self.height - 52)*750.0/646))
        topBackView.backgroundColor = mainColor
        //close
        closeButton = UIButton(type: .custom)
        let image = UIImage(named:Sign_closeBtnName)?.withRenderingMode(.alwaysTemplate)
        closeButton.setBackgroundImage(image, for: UIControlState())
        self.addSubview(closeButton)
        closeButton.tintColor = mainColor
//        closeButton.backgroundColor = mainColor
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom).offset(83/2*gdscale)
            make.width.equalTo(36)
            make.height.equalTo(36)
            make.left.equalTo(self.snp.left).offset((screenWidth-36)/2)
        }
        closeButton.addTarget(self, action: #selector(MQISignFlipCardView.closeButtonClick(_:)), for: .touchUpInside)
        
        
        let whiteBgView = UIView(frame: CGRect.zero)
        whiteBgView.layer.cornerRadius = 6
        whiteBgView.clipsToBounds = true
        whiteBgView.backgroundColor = UIColor.white
        topBackView.addSubview(whiteBgView)
        whiteBgView.snp.makeConstraints { (make) in
            make.left.equalTo(topBackView.snp.left).offset(5)
            make.right.equalTo(topBackView.snp.right).offset(-5)
            make.bottom.equalTo(topBackView.snp.bottom).offset(-5)
            make.top.equalTo(topBackView.snp.top).offset(104/2*gdscale)
        }
        
        
        //恭喜您中奖了 。。。。
        headerImageView = UIImageView(frame: CGRect.zero)
        headerImageView.image = UIImage.init(named: "Sign_headerImg")
        topBackView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(topBackView.snp.left).offset(24*gdscale)
            make.right.equalTo(topBackView.snp.right).offset(-24*gdscale)
            make.top.equalTo(topBackView.snp.top).offset(24*gdscale)
            make.height.equalTo(headerImageView.snp.width).multipliedBy(117.0/552)
        }
        
        //牌  30上下
        let interVal = 38/2*gdscale
        var x = 36/2*gdscale
        var y = 108/2 * gdscale
        
        for i in 0...5 {
            let pockerView = MQIPockerView(frame: CGRect (x: x, y: y, width: 158/2*gdscale, height: 198/2*gdscale))
            whiteBgView.addSubview(pockerView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(MQISignFlipCardView.tapClick(_:)))
            pockerView.addGestureRecognizer(tap)
            pockerView.tag = 1000 + i
            pockerArray.append(pockerView)
            
            if i%3 == 2,i>1{
                x = 36/2*gdscale
                y += (198/2*gdscale + 30*gdscale)
            }else {
                x += (158/2*gdscale + interVal)
            }
            if i == 1 {
                cardCenterFrame = pockerView.frame
            }
            
        }
        let cardHMaxY = cardCenterFrame.origin.y + 198/2*gdscale
        
        CongratulationLabel = UILabel(frame: CGRect.zero)
        CongratulationLabel.textColor = UIColor.colorWithHexString("#333333")
        CongratulationLabel.font = UIFont.systemFont(ofSize: 13*gdscale)
        CongratulationLabel.numberOfLines  = 0
        whiteBgView.addSubview(CongratulationLabel)
        CongratulationLabel.textAlignment = .center
        CongratulationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(whiteBgView.snp.left)
            make.right.equalTo(whiteBgView.snp.right)
            make.top.equalTo(cardHMaxY + 23*gdscale)
//            make.height.equalTo(13.5*gdscale)
        }
        //        bindPhoneLabel = UILabel(frame: CGRect.zero)
        //        bindPhoneLabel.text = "绑定手机号，别让您的豆飞了哦"
        //        bindPhoneLabel.textAlignment = .center
        //        bindPhoneLabel.textColor = UIColor.colorWithHexString("#666666")
        //        whiteBgView.addSubview(bindPhoneLabel)
        //        bindPhoneLabel.font = UIFont.systemFont(ofSize: 11)
        //        bindPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        //        bindPhoneLabel.snp.makeConstraints { (make) in
        //            make.top.equalTo(CongratulationLabel.snp.bottom).offset(73/2*gdscale)
        //            make.left.equalTo(whiteBgView.snp.left)
        //            make.right.equalTo(whiteBgView.snp.right)
        //            make.height.equalTo(11.5*gdscale)
        //        }
        
        
        
        inBagButton = UIButton(type: .custom)
        inBagButton.setTitle(kLocalized("pocket"), for: UIControlState())
        inBagButton.setTitleColor(UIColor.white, for: UIControlState())
        whiteBgView.addSubview(inBagButton)
        inBagButton.backgroundColor = mainColor
        //        inBagButton.layer.addDefineLayer(inBagButton.bounds)
        inBagButton.layer.cornerRadius = 75/4*gdscale
        inBagButton.clipsToBounds = true
        inBagButton.translatesAutoresizingMaskIntoConstraints = false
        inBagButton.snp.makeConstraints { (make) in
            make.left.equalTo(whiteBgView.snp.left).offset(104/2*gdscale)
            make.right.equalTo(whiteBgView.snp.right).offset(-104/2*gdscale)
            make.top.equalTo(whiteBgView.snp.top).offset(cardHMaxY + 182/2*gdscale)
            make.height.equalTo(75/2*gdscale)
        }
        //        inBagButton.layer.addDefineLayer(CGRect (x: 0, y: 0, width: whiteBgView.width - 104, height: 75/2*gdscale))
        
        inBagButton.alpha = 0
        CongratulationLabel.alpha = 0
        //        bindPhoneLabel.alpha = 0
        inBagButton.addTarget(self, action: #selector(MQISignFlipCardView.inBagButtonClick(_:)), for: .touchUpInside)
        
    }
    @objc func inBagButtonClick(_ sender:UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { (finish) in
            self.removeFromSuperview()
        })
    }
    //点击
    @objc func tapClick(_ tap:UITapGestureRecognizer) {
        Tap_AgreeOrforbid(false)//禁止点击
        if let tapView = tap.view {

//           let result = MQISignModel()
//            result.double = "1"
//            result.premium = "28"
//            result.lottery_list = ["28","28","28","28","28","28"]
//            self.isDouble = result.double
//           successToFlipCard(result,Tag: tapView.tag)
            MQISignManager.shared.gd_newsign("\(tapView.tag - 1000)", completion: {[weak self] (isSuccess,result,err_code)->Void in
                //签到成功给牌赋值，翻牌 Sign_headerImg_success
                if let weakSelf = self {
                 
                    if isSuccess {
                        if let result = result {
                            weakSelf.isDouble = result.double
                            weakSelf.successToFlipCard(result,Tag: tapView.tag)
                        }

                    }else {
                        //错误处理
                        weakSelf.signSuccess?(false,err_code)
                    }
                }
            })
            
        }
        
        
    }
    //签到成功
    func successToFlipCard(_ result:MQISignModel,Tag:Int) {
        CongratulationLabel.text = "\(kLocalized("CongratulationsOnYourSuccess"))\(result.premium)个\(COINNAME_PREIUM)"
        self.headerImageView.image = UIImage.init(named: "Sign_headerImg_success")
        if isDouble == "1" {
            let premium = result.premium.integerValue()*2
            let  t1 =  kLongLocalized("NewUserSigned", replace: COINNAME_PREIUM)
            let  t2 = "\(premium)"
            let  t3 = "个\(COINNAME_PREIUM)"
            let t = t1+t2+t3
            let att = NSMutableAttributedString(string: t)
            att.addAttributes(
                [NSAttributedStringKey .font: UIFont.systemFont(ofSize: 23*gdscale)
                ,NSAttributedStringKey.foregroundColor:mainColor
                ], range: NSRange.init(location: t1.count, length: t2.count))
        
            CongratulationLabel.attributedText = att
            
        }else{
            CongratulationLabel.text = "\(kLocalized("CongratulationsOnYourSuccess"))\(result.premium)个\(COINNAME_PREIUM)"
        }
        
        signSuccess?(true,nil)
        for index in 0..<pockerArray.count{
            let pockerView = pockerArray[index]
            guard index < result.lottery_list.count else {
                continue
            }
            if pockerView.tag == Tag{
                self.perform(#selector(MQISignFlipCardView.move_TapCardToCenter(_:)), with: pockerView, afterDelay: 1.5)
                
            }
            animationToShowCard(pockerView, coin: "\(result.lottery_list[index])")
            
        }
    }
    //MARK:翻牌动画
    func animationToShowCard(_ popView:MQIPockerView,coin:String = "0") {
        let option = UIViewAnimationOptions.transitionFlipFromLeft
        UIView.transition(with: popView, duration: 0.5, options: option, animations: {
            
            popView.placeholderImgView?.removeFromSuperview()
            popView.premiumLabel.text = coin
            popView.addSubview(popView.contentimageView!)
            
        }) {(finish) in
            
        }
    }
    //MARK:全部反过来之后移动到中间
    @objc func move_TapCardToCenter(_ popView:MQIPockerView?) {
        for pockerView in pockerArray {
            
            if pockerView.tag == popView?.tag {
                
                UIView.animate(withDuration: 0.5, animations: {
                    if self.isDouble == "1" { /// 新用户签到
                        pockerView.frame = self.cardCenterFrame
                        pockerView.x -= 30
                        
                        let la2 = UILabel()
                        la2.textColor = mainColor
                        la2.font = UIFont.boldSystemFont(ofSize: 60*gdscale)
                        la2.text = "2"
                        pockerView.superview!.addSubview(la2)
                        la2.frame = CGRect(x: pockerView.maxX+30*gdscale, y: 0, width: 60*gdscale, height: 60*gdscale)
                        la2.centerY = pockerView.centerY
                        
            
                        let la1 = UILabel()
                        la1.textColor = mainColor
                        la1.font = UIFont.systemFont(ofSize: 16*gdscale)
                        la1.text = "x"
                        pockerView.superview!.addSubview(la1)
                        la1.frame = CGRect(x: la2.x-15*gdscale, y: 0, width: 16*gdscale, height: 16*gdscale)
                        la1.centerY = pockerView.centerY
                        
                    }else{
                       pockerView.frame = self.cardCenterFrame
                    }
                }, completion: { (finish) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.inBagButton.alpha = 1
                        self.CongratulationLabel.alpha = 1
                        //                        self.bindPhoneLabel.alpha = 1
                    })
                })
                
            }else {
                UIView.animate(withDuration: 0.5, animations: {
                    pockerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    pockerView.alpha = 0
                })
                
            }
            
        }
        
        
        
    }
    
    
    //MARK:全部禁止点击
    func Tap_AgreeOrforbid(_ isAgree:Bool) {
        if isAgree {
            for pockerView in pockerArray {
                pockerView.isUserInteractionEnabled = true
            }
        }else {
            for pockerView in pockerArray {
                pockerView.isUserInteractionEnabled = false
            }
        }
    }
    
    
    
    
    //选择卡牌
    func cardSelectedClick(_ sender:UIButton) {
        
        FlipCardSelectedIndex?(Int(sender.tag))
    }
    //关闭
    @objc func closeButtonClick(_ sender:UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { (finish) in
            self.removeFromSuperview()
        })
    }
    
    deinit {
        mqLog("GDSignFlopCardView dealloc")
    }

}
