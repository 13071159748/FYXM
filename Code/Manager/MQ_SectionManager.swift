//
//  MQ_SectionManager.swift
//  XSSC
//
//  Created by moqing on 2018/11/8.
//  Copyright © 2018 XSSC. All rights reserved.
//

import UIKit

enum SECTIONTYPE:String {
    case none = ""
    case Girl = "1"
    case Boy = "2"
    case Comic = "3"
    case Audio = "5"
    case English_Comics = "6"
    
    func conversion()->String {
        switch self {
        case .none:  return ""
        case .Girl: return "女生"
        case .Boy: return "男生"
        case .Comic:  return "漫画"
        case .Audio:  return  "音频"
        case .English_Comics:  return "英文版漫画"
        }
    }
    
 
    static  func createType(_ typeStr:String) -> SECTIONTYPE {
        switch typeStr {
        case "女生" , "1" : return .Girl
        case "男生" , "2": return .Boy
        case "漫画" , "3": return .Comic
        case "音频" , "5": return .Audio
        case "英文版漫画" , "6": return .English_Comics
        default:
        return .none
        }
    }
    
}




class MQ_SectionManager: NSObject {
    static let shared = MQ_SectionManager()
    var section_ID:SECTIONTYPE = .none {
        didSet(oldValue) {
            MQIEventManager.shared.appendEventData(eventType: .section_select, additional: ["id":section_ID.rawValue])
        }
        
    }
    override init() {super.init();
        section_ID =  SECTIONTYPE.createType(getSectionID())

    }
    
    ///1-女频 2-男频 3-漫画 5-音频 6-英文版漫画
    fileprivate let section_ID_key = "xsdq_section_ID_key"
    
    
    @discardableResult func changeSectionID(_ type:SECTIONTYPE? = nil,_ section_ID:String? = nil ) -> Bool
    {
        if  let typeNew = type  {
            if self.section_ID != typeNew {
            self.section_ID = typeNew
            return setSectionID(self.section_ID.rawValue)
            }else{
                return false
            }
        }
        if  let section_IDNew = section_ID  {
            if self.section_ID.rawValue != section_IDNew {
                self.section_ID = SECTIONTYPE.createType(section_IDNew)
                return setSectionID(self.section_ID.rawValue)
            }
        }else{
             return false
        }
        self.section_ID = .none
        return setSectionID(self.section_ID.rawValue)
    }
    
  @discardableResult private  func setSectionID(_ typeStr:String ) -> Bool
  {
        UserDefaults.standard.set(section_ID.rawValue, forKey: section_ID_key)
        let r = UserDefaults.standard.synchronize()
        if r { UserNotifier.postNotification(.changeSectionID)}
        return r
    }
    
    
    func getSectionID() -> String
    {
        if let section_ID = UserDefaults.standard.string(forKey: section_ID_key){return section_ID};return ""
        
    }
    
    func removeLocalSectionID()  {
        UserDefaults.standard.removeObject(forKey: section_ID_key)
    }
    
   @discardableResult   func showHobbyView() -> Bool {
        if section_ID != .none { return true }
    
        let window = UIApplication.shared.keyWindow!
        let hobbyView = UIView(frame: window.bounds)
        hobbyView.backgroundColor = kUIStyle.colorWithHexString("ffffff")
        window.addSubview(hobbyView)
    
        let titleLable = UILabel()
        titleLable.textColor = kUIStyle.colorWithHexString("333333")
        titleLable.font = kUIStyle.boldSystemFont1PXDesignSize(size: 22)
        titleLable.textAlignment = .center
        titleLable.text = "选择你的阅读偏好"
        hobbyView.addSubview(titleLable)
        titleLable.frame = CGRect(x: 0, y: kUIStyle.scale1PXH(120), width: hobbyView.width, height: titleLable.font.pointSize)
    
        let infoLable = UILabel()
        infoLable.textColor = kUIStyle.colorWithHexString("666666")
        infoLable.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        infoLable.textAlignment = .center
        infoLable.text = "这样有助于我们推荐最合适的作品给您"
        hobbyView.addSubview(infoLable)
        infoLable.frame = CGRect(x: 0, y: titleLable.maxY+10, width: hobbyView.width, height: infoLable.font.pointSize)
    
    
        let  boyBtn = Hobby_LeftImgBtn(frame: CGRect(x:0, y: titleLable.maxY+kUIStyle.scale1PXH(80), width: kUIStyle.scale1PXW(267), height: kUIStyle.scale1PXH(58)))
        boyBtn.setTitle(SECTIONTYPE.Boy.conversion()+"小说", for: .normal)
        boyBtn.setImage(UIImage(named: "Choose_Boy_img"), for: .normal)
        boyBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        boyBtn.setTitleColor(kUIStyle.colorWithHexString("646672"), for: .normal)
        boyBtn.centerX = hobbyView.width*0.5
        hobbyView.addSubview(boyBtn)
        boyBtn.contentHorizontalAlignment = .left
        boyBtn.backgroundColor = UIColor.colorWithHexString("F4F7FA")
    boyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let image1 = UIImageView(frame: CGRect(x: boyBtn.width-43, y: 0, width: 23, height: 15))
        image1.image =  UIImage(named: "Choose_DH_img")
        image1.tag = 100
        image1.isHidden = true
        boyBtn.addSubview(image1)
        image1.centerY = boyBtn.height*0.5
    
    
        let  girlBtn =  Hobby_LeftImgBtn(frame: CGRect(x:0, y: boyBtn.maxY+40, width: kUIStyle.scale1PXW(267), height: kUIStyle.scale1PXH(58)))
        girlBtn.setTitle(SECTIONTYPE.Girl.conversion()+"小说", for: .normal)
        girlBtn.setImage(UIImage(named: "Choose_Girl_img"), for: .normal)
        girlBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        girlBtn.setTitleColor(kUIStyle.colorWithHexString("646672"), for: .normal)
        girlBtn.centerX = boyBtn.centerX
        hobbyView.addSubview(girlBtn)
        girlBtn.backgroundColor = UIColor.colorWithHexString("F4F7FA")
        girlBtn.contentHorizontalAlignment = .left
    girlBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
        let image2 = UIImageView(frame: CGRect(x: boyBtn.width-43, y: 0, width: 23, height: 15))
        image2.tag = 100
        image2.image =  UIImage(named: "Choose_DH_img")
        image2.isHidden = true
        girlBtn.addSubview(image2)
        image2.centerY = girlBtn.height*0.5
    
        boyBtn.clickBlock = { (btn) in
            btn.viewWithTag(100)?.isHidden = false
            btn.dsySetBorderr(color: mainColor, width: 1)
             btn.superview?.isUserInteractionEnabled = false
            self.changeSectionID(.Boy)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                btn.superview?.removeFromSuperview()
            }
        

        }
        girlBtn.clickBlock = { (btn) in
            btn.viewWithTag(100)?.isHidden = false
            btn.dsySetBorderr(color: mainColor, width: 1)
            btn.superview?.isUserInteractionEnabled = false
            self.changeSectionID(.Girl)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                btn.superview?.removeFromSuperview()
            }
        }
    
        return false
        
    }
    
  
    /// 左边图片 右边文字 btn
    class Hobby_LeftImgBtn: UIButton {
         var spacing:CGFloat = 20
         var clickBlock:((_ btn:Hobby_LeftImgBtn) -> ())?
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        @objc func clickAction() {
            clickBlock?(self)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let oldRect: CGRect  = self.bounds;
            let oldRect2:CGRect  = (self.imageView?.frame)!;
            let oldRect3:CGRect = (self.titleLabel?.frame)!;
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.numberOfLines = 0;
            let X:CGFloat  = oldRect2.maxX;
            
            if (X>0) {
                if oldRect2 != CGRect.zero{
                    self.titleLabel?.frame = CGRect(x: X+self.spacing, y: 0, width: oldRect3.size.width, height: oldRect.size.height )
                }
            }
        }
        
    }
    
   
    
}


