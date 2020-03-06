//
//  MQIReadPageWrongView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/27.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


enum GYReadWrongType {
    case needCoin
    case getChapterFaild
    case needLogin
    case needSubscribeChapter
    case needSubscribeBook
    case needNetWork
    case other
    case newBook
    case chapterError
}

class MQIReadPageWrongView: UIView {
    
    fileprivate var titleLabel: UILabel!
    fileprivate var contentLabel: UILabel!
    fileprivate var deTitleLabel: UILabel!
    fileprivate var actionBtn: UIButton!
    
    fileprivate var priceLabel: UILabel?
    
    fileprivate var agreeBtn: UIButton?
    fileprivate var protocolLabel: UILabel?
    
    fileprivate var wrongType: GYReadWrongType!
    
    
    fileprivate var book: MQIEachBook!
    fileprivate var chapter: MQIEachChapter!
    
    fileprivate var unSubscribeChapter: MQIUnSubscribeChapter?
    
    fileprivate let labelHeight: CGFloat = 35
    fileprivate let titleFont = boldFont(18)
    fileprivate let contentFont = systemFont(14)
    fileprivate let deTitleFont = systemFont(13)
    
    fileprivate let btnTitleColor = UIColor.white
    fileprivate let btnFont = systemFont(14)
    fileprivate let btnHeight: CGFloat = 40
    fileprivate let btnWidth: CGFloat = 210
    
    fileprivate var selColor: UIColor = RGBColor(227, g: 81, b: 1)
//       fileprivate var selColor = RGBColor(18, g: 135, b: 117)
    
    let themeModel = GYReadStyle.shared.styleModel.themeModel
    
    var reloadBlock: (() -> ())?
    var subscribeChaptersBlock: (() -> ())?
    
    init(frame: CGRect, book: MQIEachBook, chapter: MQIEachChapter, msg: String, wrongType: GYReadWrongType, unSubscribeChapter: MQIUnSubscribeChapter? = nil,  refresh: (() -> ())?) {
        super.init(frame: frame)
        self.book = book
        self.chapter = chapter
        self.unSubscribeChapter = unSubscribeChapter
        self.wrongType = wrongType
        reloadBlock = refresh
        createUI(wrongType, wrongMsg: msg)
    }
    
    
    func createUI(_ wrongType: GYReadWrongType, wrongMsg: String) {
        switch wrongType {
        case .needCoin:
            addNeedCoinView()
        case .getChapterFaild:
            addChapterFailedView()
        case .needLogin:
            addNeedLoginView()
        case .needSubscribeChapter:
            addNeedSubscribeChapterView()
        case .needSubscribeBook:
            addNeedSubscribeBookView()
        case .needNetWork:
            addNeedNetWorkView()
        case .newBook:
            addNewBookView()
        case .other:
            addOtherView(wrongMsg)
        case .chapterError:
            addOtherView(wrongMsg)
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

//MARK:  编辑不同UI
extension MQIReadPageWrongView {
    func addNeedCoinView() {
        guard book.checkIsWholdSubscribe() == false else {
            createView(deTitle: kLocalized("NeedLogin"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("Recharge"), needCoinView: (true, unSubscribeChapter?.price),is_new:true,isSub:true,is_pay: true)
            return
        }
        addNeedSubscribeChapterView(kLocalized("Recharge"),is_pay:true)
    }
    
    func addNeedLoginView() {
        createView(deTitle: kLocalized("NeedLog"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("TheLogin"), needCoinView: (false, nil))
    }
    func addChapterFailedView() {
        createView(deTitle: kLocalized("AAA"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("Refrash"), needCoinView: (false, nil))
    }
    //IsVIP
    func addNeedSubscribeChapterView(_ btnTitle: String? = nil,is_pay:Bool = false) {
        
        createView(deTitle: kLocalized("IsVIP"), summary: unSubscribeChapter?.summary, btnTitle: btnTitle == nil ? kLocalized("SureBook") : btnTitle!,is_new:true,isSub:true,is_pay: is_pay)
        
        if MQIPayTypeManager.shared.isAvailable() {return}

        protocolLabel = createLabel(CGRect.zero,
                                    font: deTitleFont,
                                    bacColor: nil,
                                    textColor: themeModel?.statusColor,
                                    adjustsFontSizeToFitWidth: true,
                                    textAlignment: .left,
                                    numberOfLines: nil)
        protocolLabel!.text = kLocalized("AutoBook")
        addSubview(protocolLabel!)

        let label = createLabel(CGRect.zero,
                                font: deTitleFont,
                                bacColor: nil,
                                textColor: selColor,
                                adjustsFontSizeToFitWidth: false,
                                textAlignment: .center,
                                numberOfLines: 1)
        label.isUserInteractionEnabled = true
        let attStr = NSMutableAttributedString(string: kLocalized("MoreBook"), attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:deTitleFont])
        label.attributedText = attStr
        //        addTGR(self, action: #selector(GYReadPageWrongView.subscribeChaptersAction), view: label)
        addSubview(label)


        let manyButton = createButton(CGRect.zero, target: self, action: #selector(MQIReadPageWrongView.subscribeChaptersAction))
        manyButton.titleLabel?.attributedText = attStr
        label.addSubview(manyButton)

        agreeBtn = createButton(CGRect.zero,
                                normalTitle: nil,
                                normalImage: UIImage(named: "reader_protocol_unSel"),
                                selectedTitle: nil,
                                selectedImage: UIImage(named: "reader_protocol_sel"),
                                normalTilteColor: nil,
                                selectedTitleColor: nil,
                                bacColor: nil,
                                font: nil,
                                target: self, action: #selector(MQIReadPageWrongView.agreeBtnAction(_:)))
        agreeBtn!.isSelected = false
        addSubview(agreeBtn!)

        let btnSide: CGFloat = 40
        let space: CGFloat = 10

        //        label.frame = CGRect(x: (width-200)/2, y: actionBtn.maxY+space+5, width: 200, height: 20)
        label.frame = CGRect(x: 0, y: actionBtn.maxY+space+2, width: width, height: 23)

        manyButton.frame = label.bounds
        //        manyButton.backgroundColor = UIColor.yellow

        let protocolWidth = getAutoRect(protocolLabel!.text!, font: protocolLabel!.font, maxWidth: self.bounds.width-btnSide, maxHeight: CGFloat(MAXFLOAT)).size.width


        agreeBtn!.frame = CGRect(x: (self.width-protocolWidth-btnSide-space)/2,
                                 y: label.maxY+3,
                                 width: btnSide,
                                 height: btnSide)
        protocolLabel!.frame = CGRect(x: agreeBtn!.maxX, y: agreeBtn!.y, width: protocolWidth, height: btnSide)
    }
    
    func addNeedSubscribeBookView() {
        createView(deTitle: kLocalized("NeedBookRead"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("ConfirmTheSubscription"), needCoinView: (true, unSubscribeChapter?.price),is_new:true,isSub:true)
    
    }
    
    func addNeedNetWorkView() {
        createView(deTitle: kLocalized("CheckInt"), btnTitle: kLocalized("Refrash"), needCoinView: (false, nil), isNetWorkError: true)
    }
    
    func addOtherView(_ wrongMsg: String) {
        createView(deTitle: wrongMsg, btnTitle: kLocalized("Refrash"))
    }
    
    func addNewBookView() {
        
        let defaultColor = UIColor.colorWithHexString("E45100")
        
        let originY: CGFloat = self.center.y-labelHeight
        
        titleLabel = createLabel(CGRect(x: 0, y: 60, width: self.width, height: 40),
                                 font: titleFont,
                                 bacColor: UIColor.clear,
                                 textColor: themeModel?.titleColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .center,
                                 numberOfLines: 1)
        titleLabel.text = chapter.chapter_title
        addSubview(titleLabel)
        
        actionBtn = createButton(CGRect(x: (self.width-btnWidth)/2, y: originY, width: btnWidth, height: btnHeight),
                                 normalTitle: "",
                                 normalImage: nil,
                                 selectedTitle: nil,
                                 selectedImage: nil,
                                 normalTilteColor: btnTitleColor,
                                 selectedTitleColor: nil,
                                 bacColor: selColor,
                                 font: btnFont,
                                 target: self,
                                 action: #selector(MQIReadPageWrongView.btnAction(_:)))
        actionBtn.layer.cornerRadius = btnHeight/2
        actionBtn.layer.masksToBounds = true
        addSubview(actionBtn)
        
        let priceLabel = createLabel(CGRect(x: 0, y: originY, width: self.width, height: 25),
                                     font: deTitleFont,
                                     bacColor: UIColor.clear,
                                     textColor: defaultColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .center,
                                     numberOfLines: 2)
        addSubview(priceLabel)
        
        let pageLayout = GetPageVCLayout()
        if let summary = unSubscribeChapter?.summary {
            
            titleLabel.y = 60
            titleLabel.height = 40
            actionBtn.y = self.height-120
            
            
            
            contentLabel = createLabel(CGRect(x: pageLayout.margin_left, y: titleLabel.maxY, width: width-2*pageLayout.margin_left, height: priceLabel.y-titleLabel.maxY-30),
                                       font: contentFont,
                                       bacColor: UIColor.clear,
                                       textColor: themeModel?.textColor,
                                       adjustsFontSizeToFitWidth: false,
                                       textAlignment: .left,
                                       numberOfLines: 0)
            
            contentLabel.attributedText = NSMutableAttributedString(string: summary, attributes: getReadAttribute())
            addSubview(contentLabel)
        }
        
        
        let tittel2  = UILabel()
        tittel2.textColor = defaultColor
        tittel2.font = kUIStyle.boldSystemFont1PXDesignSize(size: 16)
        tittel2.textAlignment = .center
        addSubview(tittel2)
        tittel2.frame = CGRect(x: 0, y: priceLabel.maxY+30, width: self.width, height: tittel2.font.pointSize+2)
        
        
        let lineView1 = UIView(frame: CGRect(x: 0, y: 0, width: kUIStyle.scale1PXW(90), height: 1))
        lineView1.backgroundColor = defaultColor
        addSubview(lineView1)
        lineView1.x = pageLayout.margin_left
        lineView1.centerY = tittel2.centerY
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 4))
        lineView2.backgroundColor = lineView1.backgroundColor
        lineView2.layer.cornerRadius = 2
        lineView2.layer.masksToBounds = true
        addSubview(lineView2)
        lineView2.x = lineView1.maxX
        lineView2.centerY = lineView1.centerY
        
        let lineView4 = UIView(frame: CGRect(x: 0, y: 0, width: lineView1.width, height: lineView1.height))
        lineView4.backgroundColor = lineView1.backgroundColor
        addSubview(lineView4)
        lineView4.maxX = self.width-pageLayout.margin_right
        lineView4.centerY = lineView1.centerY
        
        let lineView3 = UIView(frame: CGRect(x: 0, y: 0, width: lineView2.width, height: lineView2.height))
        lineView3.backgroundColor = lineView1.backgroundColor
        lineView3.layer.cornerRadius =  lineView2.layer.cornerRadius
        lineView3.layer.masksToBounds = lineView2.layer.masksToBounds
        addSubview(lineView3)
        lineView3.maxX = lineView4.x
        lineView3.centerY = lineView1.centerY
        
        
        let  contentLabel2 = UILabel()
        contentLabel2.textColor = kUIStyle.colorWithHexString("6B391E")
        contentLabel2.font = kUIStyle.boldSystemFont1PXDesignSize(size: 14)
        contentLabel2.textAlignment = .left
        contentLabel2.numberOfLines = 0
        addSubview(contentLabel2)
        contentLabel2.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(pageLayout.margin_left)
            make.rightMargin.equalTo(-pageLayout.margin_right)
            make.top.equalTo(tittel2.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(actionBtn.snp.top).offset(-8)
        }
        
        
        protocolLabel = createLabel(CGRect.zero,
                                    font: deTitleFont,
                                    bacColor: nil,
                                    textColor: themeModel?.statusColor,
                                    adjustsFontSizeToFitWidth: true,
                                    textAlignment: .left,
                                    numberOfLines: nil)
        addSubview(protocolLabel!)
        
        
        agreeBtn = createButton(CGRect.zero,
                                normalTitle: nil,
                                normalImage: UIImage(named: "reader_protocol_unSel"),
                                selectedTitle: nil,
                                selectedImage: UIImage(named: "reader_protocol_sel"),
                                normalTilteColor: nil,
                                selectedTitleColor: nil,
                                bacColor: nil,
                                font: nil,
                                target: self, action: #selector(MQIReadPageWrongView.agreeBtnAction(_:)))
        agreeBtn!.isSelected = false
        addSubview(agreeBtn!)
        
        protocolLabel!.text = kLocalized("不再提示")
        contentLabel2.text = unSubscribeChapter?.read_tips
        tittel2.text = "新书抢先看"
        
        actionBtn.setTitle(kLocalized("继续阅读"), for: .normal)
        
        let price = unSubscribeChapter?.price ?? "--"
        let priceText = "价格：\(price)\(COINNAME_MERGER) (免费)"
        
        
        let priceAttStr = NSMutableAttributedString(string: priceText)
        
        priceAttStr.addAttributes([.foregroundColor : UIColor.colorWithHexString("5E432E"),
                                   .strikethroughStyle:NSUnderlineStyle.single.rawValue,
                                   .font:UIFont.boldSystemFont(ofSize: priceLabel.font.pointSize)
            ], range: NSRange.init(location: 3, length: price.count+COINNAME_MERGER.count))
        priceLabel.attributedText = priceAttStr
        
        
        let btnSide: CGFloat = 40
        let space: CGFloat = 10
        
        let protocolWidth = getAutoRect(protocolLabel!.text!, font: protocolLabel!.font, maxWidth: self.bounds.width-btnSide, maxHeight: CGFloat(MAXFLOAT)).size.width
        
        
        agreeBtn!.frame = CGRect(x: (self.width-protocolWidth-btnSide-space)/2,
                                 y: actionBtn.maxY+space+2,
                                 width: btnSide,
                                 height: btnSide)
        protocolLabel!.frame = CGRect(x: agreeBtn!.maxX, y: agreeBtn!.y, width: protocolWidth, height: btnSide)
        
        
        
    }
    
    
}

//MARK:  创建UI
extension MQIReadPageWrongView {
    
    /// 通用订阅视图
    ///
    /// - Parameters:
    ///   - deTitle: 信息标题
    ///   - summary: 章节tips
    ///   - btnTitle: 按钮标题
    ///   - needCoinView: 章节价格
    ///   - is_new: 是否是新的ye风格页面
    ///   - isSub: 订阅
    ///   - is_pay: 支付
    ///   - is_subscription: 订阅按钮
    func createView(deTitle: String, summary: String? = nil, btnTitle: String, needCoinView: (Bool, String?) = (true, nil),
                    is_new:Bool = false,isSub:Bool = false,is_pay:Bool = false,is_subscription:Bool = false, isNetWorkError: Bool = false) {
        
       
        
        if is_new  &&  MQIPayTypeManager.shared.isAvailable(){
            var originY: CGFloat = self.center.y-22
            if needCoinView.0 == false {
                originY = self.center.y-22/2
            }
            
            let dcModel = MQIUserDiscountCardInfo.default
            
            let  lineView1 = UIView(frame: CGRect(x: 0, y: originY, width: 60, height: 1))
            lineView1.backgroundColor =  UIColor.colorWithHexString("#B89467")
            lineView1.x = kUIStyle.scale1PXW(55)
            addSubview(lineView1)
            
            let  lineView2 = UIView(frame: CGRect(x: 0, y: originY, width: 60, height: 1))
            lineView2.backgroundColor = UIColor.colorWithHexString("#B89467")
            addSubview(lineView2)
            lineView2.maxX = self.width-kUIStyle.scale1PXW(55)
            lineView2.centerY = lineView1.centerY
            
            deTitleLabel = createLabel(CGRect(x: 0, y: originY, width: 120, height: 22),
                                       font: UIFont.boldSystemFont(ofSize: 16),
                                       bacColor: UIColor.clear,
                                       textColor:  UIColor.colorWithHexString("#B89467"),
                                       adjustsFontSizeToFitWidth: false,
                                       textAlignment: .center,
                                       numberOfLines: 1)
            addSubview(deTitleLabel)
            deTitleLabel.text =   kLocalized("Thank_youk_fork_yourk_support", describeStr: "感谢您支持正版")
            deTitleLabel.centerX = self.width*0.5
            deTitleLabel.centerY = lineView2.centerY
            
            
            originY = deTitleLabel.maxY
            
            titleLabel = createLabel(CGRect(x: 0, y: deTitleLabel.y-60, width: self.width, height: 60),
                                     font: titleFont,
                                     bacColor: UIColor.clear,
                                     textColor: themeModel?.titleColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .center,
                                     numberOfLines: 1)
            titleLabel.text = chapter.chapter_title
            addSubview(titleLabel)
            
            if titleLabel.text == "" {
                titleLabel.text = deTitle
                deTitleLabel.text = ""
            }
            
            originY = deTitleLabel.maxY+15
            
            if needCoinView.0 == true {
                originY = deTitleLabel.maxY
                priceLabel = createLabel(CGRect(x: 0, y: originY, width: self.width, height: 25),
                                         font: deTitleFont,
                                         bacColor: UIColor.clear,
                                         textColor: themeModel?.statusColor,
                                         adjustsFontSizeToFitWidth: false,
                                         textAlignment: .center,
                                         numberOfLines: 1)
//                priceLabel!.attributedText = getPriceAttstr(priceLabel!, price: needCoinView.1)
                addSubview(priceLabel!)
                
                let attStr = NSMutableAttributedString(string: wrongType == .needSubscribeBook ? kLocalized("HullBookPrice") : kLocalized("Price"), attributes:
                    [NSAttributedString.Key.font : priceLabel!.font,
                     NSAttributedString.Key.foregroundColor : themeModel!.statusColor!,
                     NSAttributedString.Key.backgroundColor : UIColor.clear])
            
                var allPrice = ""
                if  let  price = needCoinView.1 , price.count > 0{
                    allPrice = price
                }
                if let Price = unSubscribeChapter?.original_price, Price != ""{
                    allPrice = Price
                }
            
                if  dcModel?.cardState == "2" {
                    let attStr2 = NSMutableAttributedString(string: allPrice.count <= 0 ? "--"+kLocalized("ThousandWords") : "\(allPrice)\(COINNAME_MERGER)", attributes:
                        [NSAttributedString.Key.font : priceLabel!.font,
                         NSAttributedString.Key.foregroundColor : selColor,
                         NSAttributedString.Key.backgroundColor : UIColor.clear,
                           .strikethroughStyle:1])
                    attStr.append(attStr2)
                }else{
                    let attStr2 = NSMutableAttributedString(string: allPrice.count <= 0 ? "--"+kLocalized("ThousandWords") : "\(allPrice)\(COINNAME_MERGER)", attributes:
                        [NSAttributedString.Key.font : priceLabel!.font,
                         NSAttributedString.Key.foregroundColor : selColor,
                         NSAttributedString.Key.backgroundColor : UIColor.clear,
])
                    attStr.append(attStr2)
                }
               
                  priceLabel!.attributedText = attStr
                originY = priceLabel!.maxY+15
            }
            
            var  priceLabel2:UILabel?
            
            if let user = MQIUserManager.shared.user {
                priceLabel2 = createLabel(CGRect(x: 0, y: originY, width: self.width, height: 25),
                                          font: deTitleFont,
                                          bacColor: UIColor.clear,
                                          textColor: themeModel?.statusColor,
                                          adjustsFontSizeToFitWidth: false,
                                          textAlignment: .center,
                                          numberOfLines: 1)
                addSubview(priceLabel2!)
               
                let attStr = NSMutableAttributedString(string:  kLocalized("balance", describeStr: "余额"), attributes:
                    [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: priceLabel2!.font.pointSize),
                     NSAttributedString.Key.foregroundColor : themeModel!.statusColor!,
                     NSAttributedString.Key.backgroundColor : UIColor.clear])
                let attStr2 = NSMutableAttributedString(string: user.user_coin+COINNAME+"+\(user.user_premium)\(COINNAME_PREIUM)", attributes:
                    [NSAttributedString.Key.font : priceLabel!.font,
                     NSAttributedString.Key.foregroundColor : selColor,
                     NSAttributedString.Key.backgroundColor : UIColor.clear])
                attStr.append(attStr2)
                priceLabel2!.attributedText = attStr
                originY = priceLabel2!.maxY+15
            }
            
            
            
            var dcView: UIButton?
            
            if  dcModel == nil || dcModel?.cardState != "2" /*|| unSubscribeChapter?.if_discount_price == "0" */{
              
                dcView = UIButton(frame: CGRect(x: 0, y: originY, width: self.width, height: 23))
                addSubview(dcView!)
                dcView?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                dcView?.setTitleColor(UIColor.colorWithHexString("#3A6B00"), for: .normal)
                dcView?.setImage( UIImage(named: "dzk_z_img"), for: .normal)
                var   discount = "80"
                if  dcModel != nil {
                    if dcModel!.discount.count != 0 {
                        discount = dcModel!.discount
                    }
                }
               
                dcView?.setAttributedTitle(NSAttributedString(string: "\(discount.integerValue()/10)"+kLocalized("subscribe_and_open_immediately",describeStr: "立即开通"), attributes: [.underlineStyle:1,.foregroundColor:UIColor.colorWithHexString("#3A6B00")]) , for: .normal)
              
                originY = dcView!.maxY + 20
                dcView?.tag = 1001
                dcView?.addTarget(self, action: #selector(MQIReadPageWrongView.btnAction(_:)), for: .touchUpInside)
                
                priceLabel?.isHidden = true
            }
            
            actionBtn = createButton(CGRect(x: (self.width-270)/2, y: originY, width: 260, height: btnHeight),
                                     normalTitle: btnTitle,
                                     normalImage: nil,
                                     selectedTitle: nil,
                                     selectedImage: nil,
                                     normalTilteColor: btnTitleColor,
                                     selectedTitleColor: nil,
                                     bacColor: selColor,
                                     font: btnFont,
                                     target: self,
                                     action: #selector(MQIReadPageWrongView.btnAction(_:)))
            actionBtn.layer.cornerRadius = btnHeight/2
            actionBtn.layer.masksToBounds = true
            addSubview(actionBtn)
            
            var dz_image:UIImageView?
            
            if  dcModel?.cardState == "2" {
                let imgae = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
                imgae.image = UIImage(named: "dzk_z_img")
                actionBtn.addSubview(imgae)
                imgae.centerY = actionBtn.height*0.5
                imgae.x = actionBtn.width*0.5 + 10
                dz_image = imgae
                actionBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

            }
            
      
           
            if let summary = summary {
                
                titleLabel.y = 60
                titleLabel.height = 40
                deTitleLabel.y = center.y+30
                lineView1.centerY = deTitleLabel.centerY
                lineView2.centerY = deTitleLabel.centerY
                if is_pay {
                    priceLabel?.isHidden  = false
                }
                
                if wrongType == .needSubscribeChapter  {
                  
                    if priceLabel?.isHidden  == true {
                         actionBtn.y = deTitleLabel.maxY+80
                    }else{
                         actionBtn.y = deTitleLabel.maxY+100
                    }
                    if let priceLabel = priceLabel {
                        priceLabel.maxY = actionBtn.y-20
                    }
                   
                    var allPrice = "--"
                    if  let  price = needCoinView.1 , price.count > 0{
                        allPrice = price
                    }
                    if let  original_price = unSubscribeChapter?.original_price,original_price != ""  {
                        allPrice = original_price
                    }
                    
                    if dcModel?.cardState == "2" {
                        if let Price = unSubscribeChapter?.chapter_price, Price != ""{
                            allPrice = Price
                        }
                    }
                 
                    if is_pay {
                        actionBtn.setTitle(kLocalized("Prepaid_phone_immediately"), for: .normal)
                    }else{
                        actionBtn.setTitle("\(kLocalized("Subscribe_to_this_chapter"))：\(allPrice)\(COINNAME_MERGER)", for: .normal)
                       
                    }
//
                    
                }
                else if wrongType == .needSubscribeBook  {
                    actionBtn.y = deTitleLabel.maxY+40
                    var allPrice = "--"
                    if  let  price = needCoinView.1 , price.count > 0{
                        allPrice = price
                    }
                    if let  original_price = unSubscribeChapter?.original_price,original_price != ""  {
                        allPrice = original_price
                    }
                    if dcModel?.cardState == "2" {
                        if let Price = unSubscribeChapter?.chapter_price, Price != ""{
                            allPrice = Price
                        }
                    }
                    if is_pay {
                          actionBtn.setTitle(kLocalized("Prepaid_phone_immediately"), for: .normal)
                    }else{
                        actionBtn.setTitle("\(kLocalized("The_subscription_book"))：\(allPrice)\(COINNAME_MERGER)", for: .normal)
                    }
                  
                   
                     priceLabel?.isHidden = true
                 
                }
                else {
                    actionBtn.y = deTitleLabel.maxY+100
                    if let priceLabel = priceLabel {
                        priceLabel.maxY = actionBtn.y-20
                        
                    }
                }
                actionBtn.layoutIfNeeded()
                dz_image?.x += actionBtn.titleLabel!.frame.size.width*0.5
                
             
                if let dcViewN = dcView {
                    dcViewN.y = actionBtn.maxY+18
                }
                if let priceLabe2 = priceLabel2 {
                    
                    if dcView  == nil {
                      priceLabe2.y = actionBtn.maxY+30
                    }else{
                      priceLabe2.y = dcView!.maxY+18
                    }
                    
                }
               
                
                let pageLayout = GetPageVCLayout()
                contentLabel = createLabel(CGRect(x: pageLayout.margin_left, y: titleLabel.maxY, width: width-2*pageLayout.margin_left, height: deTitleLabel.y-titleLabel.maxY-10),
                                           font: contentFont,
                                           bacColor: UIColor.clear,
                                           textColor: themeModel?.textColor,
                                           adjustsFontSizeToFitWidth: false,
                                           textAlignment: .left,
                                           numberOfLines: 0)
                
                contentLabel.attributedText = NSMutableAttributedString(string: summary, attributes: getReadAttribute())
                addSubview(contentLabel)
                
                
                
                if  isSub {
                    
                    protocolLabel = createLabel(CGRect.zero,
                                                font: deTitleFont,
                                                bacColor: nil,
                                                textColor: themeModel?.statusColor,
                                                adjustsFontSizeToFitWidth: true,
                                                textAlignment: .left,
                                                numberOfLines: nil)
                    protocolLabel!.text = kLocalized("Automatically_subscribe_to_the_next_chapter",describeStr: "自动订阅下一章")
                    addSubview(protocolLabel!)
                    
                    let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 18))
                    lineView.backgroundColor = UIColor.colorWithHexString("#845930")
                    addSubview(lineView)
                    
                    lineView.centerX = actionBtn.centerX
                    lineView.y = deTitleLabel.maxY+30
                    

                    let attStr = NSMutableAttributedString(string:" "+kLocalized("MoreBook"), attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                                                           NSAttributedString.Key.font:deTitleFont,
                                                                                                        NSAttributedString.Key.foregroundColor : themeModel?.statusColor ?? UIColor.colorWithHexString("#845930")
                        ])

                    
                    
                    let manyButton = createButton(CGRect.zero, target: self, action: #selector(MQIReadPageWrongView.subscribeChaptersAction))
                    manyButton.setAttributedTitle(attStr, for: .normal)
                    manyButton.setTitleColor(themeModel?.statusColor, for: .normal)
                    addSubview(manyButton)
                    manyButton.titleLabel?.font = deTitleFont
                    manyButton.setTitle(kLocalized("MoreBook"), for: .normal)
                    manyButton.setImage(UIImage(named: "reader_sub_dy_img"), for: .normal)
                    
                    agreeBtn = createButton(CGRect.zero,
                                            normalTitle: nil,
                                            normalImage: UIImage(named: "reader_protocol_unSel"),
                                            selectedTitle: nil,
                                            selectedImage: UIImage(named: "reader_protocol_sel"),
                                            normalTilteColor: nil,
                                            selectedTitleColor: nil,
                                            bacColor: nil,
                                            font: nil,
                                            target: self, action: #selector(MQIReadPageWrongView.agreeBtnAction(_:)))
                    agreeBtn!.isSelected = false
                    addSubview(agreeBtn!)
                    
                    let btnSide: CGFloat = 40
                    let space: CGFloat = 10
                    manyButton.frame = CGRect(x:lineView.maxX+10, y: 0, width: 100, height: 23)
                    manyButton.centerY = lineView.centerY
                    
//                    manyButton.frame = label.bounds
                    
                    let protocolWidth = getAutoRect(protocolLabel!.text!, font: protocolLabel!.font, maxWidth: self.bounds.width-btnSide, maxHeight: CGFloat(MAXFLOAT)).size.width
                    
                    
                    agreeBtn!.frame = CGRect(x: (self.width-protocolWidth-btnSide-space)/2,
                                             y: manyButton.maxY+3,
                                             width: btnSide,
                                             height: btnSide)
                    protocolLabel!.frame = CGRect(x: agreeBtn!.maxX, y: agreeBtn!.y, width: protocolWidth, height: btnSide)
                    protocolLabel!.centerY = lineView.centerY
                    protocolLabel?.maxX = lineView.x - 10
                    agreeBtn?.centerY = protocolLabel!.centerY
                    agreeBtn?.maxX =  protocolLabel!.x+5
                    
                    if wrongType == .needSubscribeBook  {
                        manyButton.isHidden = true
                        lineView.isHidden = true
//                        protocolLabel?.centerX = lineView.centerX+5
//                        agreeBtn?.maxX =  protocolLabel!.x+5
                        protocolLabel?.isHidden = true
                        agreeBtn?.isHidden = true
                    }else if is_subscription {
                        manyButton.isHidden = true
                        lineView.isHidden = true
                        protocolLabel?.centerX = lineView.centerX+5
                        agreeBtn?.maxX =  protocolLabel!.x+5
                    }
                    
                    else{
                        manyButton.isHidden = false
                        lineView.isHidden = false
                    }
                    
                }
            }
            
            
            return
            
        }
        
        var originY: CGFloat = self.center.y-labelHeight
        if needCoinView.0 == false {
            originY = self.center.y-labelHeight/2
        }
        
        if isNetWorkError {
            let placehoder = UIImageView(image: UIImage(named: "jiaz_ym_error_img"))
            placehoder.frame = CGRect(x: (screenWidth - 129) / 2, y: 85, width: 129, height: 127)
            addSubview(placehoder)
            placehoder.centerX = centerX
        }
  
        deTitleLabel = createLabel(CGRect(x: 0, y: originY, width: self.width, height: labelHeight),
                                   font: deTitleFont,
                                   bacColor: UIColor.clear,
                                   textColor: themeModel?.statusColor,
                                   adjustsFontSizeToFitWidth: false,
                                   textAlignment: .center,
                                   numberOfLines: 2)
        addSubview(deTitleLabel)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attStr = NSMutableAttributedString(string: deTitle, attributes:
            [NSAttributedString.Key.font : deTitleFont,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : themeModel!.statusColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: kLocalized("THKBook"), attributes:
            [NSAttributedString.Key.font : systemFont(11),
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : themeModel!.statusColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        attStr.append(attStr2)
        deTitleLabel.attributedText =  attStr
        
        originY = deTitleLabel.y-labelHeight
        
        titleLabel = createLabel(CGRect(x: 0, y: deTitleLabel.y-60, width: self.width, height: 60),
                                 font: titleFont,
                                 bacColor: UIColor.clear,
                                 textColor: themeModel?.titleColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .center,
                                 numberOfLines: 1)
        titleLabel.text = chapter.chapter_title
        addSubview(titleLabel)
        
        if titleLabel.text == "" {
            titleLabel.text = deTitle
            deTitleLabel.text = ""
        }
        
        originY = deTitleLabel.maxY+15
        
        if needCoinView.0 == true {
            originY = deTitleLabel.maxY
            priceLabel = createLabel(CGRect(x: 0, y: originY, width: self.width, height: 25),
                                     font: deTitleFont,
                                     bacColor: UIColor.clear,
                                     textColor: themeModel?.statusColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .center,
                                     numberOfLines: 1)
            priceLabel!.attributedText = getPriceAttstr(priceLabel!, price: needCoinView.1)
            addSubview(priceLabel!)
            
            originY = priceLabel!.maxY+15
        }
        
        actionBtn = createButton(CGRect(x: (self.width-btnWidth)/2, y: originY, width: btnWidth, height: btnHeight),
                                 normalTitle: btnTitle,
                                 normalImage: nil,
                                 selectedTitle: nil,
                                 selectedImage: nil,
                                 normalTilteColor: btnTitleColor,
                                 selectedTitleColor: nil,
                                 bacColor: selColor,
                                 font: btnFont,
                                 target: self,
                                 action: #selector(MQIReadPageWrongView.btnAction(_:)))
        actionBtn.layer.cornerRadius = btnHeight/2
        actionBtn.layer.masksToBounds = true
        addSubview(actionBtn)
        
        if let summary = summary {
            
            titleLabel.y = 60
            titleLabel.height = 40
            deTitleLabel.y = center.y+60
            actionBtn.y = deTitleLabel.maxY+15
            if let priceLabel = priceLabel {
                priceLabel.y = deTitleLabel.maxY
                actionBtn.y = priceLabel.maxY+15
            }
            
            
            let pageLayout = GetPageVCLayout()
            contentLabel = createLabel(CGRect(x: pageLayout.margin_left, y: titleLabel.maxY, width: width-2*pageLayout.margin_left, height: deTitleLabel.y-titleLabel.maxY-10),
                                       font: contentFont,
                                       bacColor: UIColor.clear,
                                       textColor: themeModel?.textColor,
                                       adjustsFontSizeToFitWidth: false,
                                       textAlignment: .left,
                                       numberOfLines: 0)
            
            contentLabel.attributedText = NSMutableAttributedString(string: summary, attributes: getReadAttribute())
            addSubview(contentLabel)
        }
        
    }
    
    func getReadAttribute() ->[NSAttributedString.Key: NSObject] {
        let textColor = themeModel?.textColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = CGFloat(0.5)*20
        paragraphStyle.lineHeightMultiple = CGFloat(GYReadLineStyle.mid.rawValue)
        paragraphStyle.alignment = NSTextAlignment.justified
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        // 返回
        return [NSAttributedString.Key.foregroundColor : textColor!,
                NSAttributedString.Key.font : contentFont,
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.kern : NSNumber(value: 0)]
    }
    
    func getPriceAttstr(_ label: UILabel, price: String? = nil) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attStr = NSMutableAttributedString(string: wrongType == .needSubscribeBook ? kLocalized("HullBookPrice") : kLocalized("Price"), attributes:
            [NSAttributedString.Key.font : label.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : themeModel!.statusColor!,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        //TODO: 价格价格  价格价格 价格价格 价格价格 价格价格
        var allPrice = "0"
        if let Price = unSubscribeChapter?.price, Price != ""{
            allPrice =  Price
        }else{
            //            allPrice =  price == nil ? chapter.chapterPrice(book) :  Int(price!) ?? 0
            allPrice = "--"
        }
        let attStr2 = NSMutableAttributedString(string: allPrice  == "--" ? allPrice+"/"+kLocalized("ThousandWords") : "\(allPrice)\(COINNAME_MERGER)", attributes:
            [NSAttributedString.Key.font : label.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : selColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let attStr3 = NSMutableAttributedString(string: kLocalized("balance"), attributes:
            [NSAttributedString.Key.font : label.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : themeModel!.statusColor!,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let user = MQIUserManager.shared.user
        attStr.append(attStr2)
        attStr.append(attStr3)
        if user == nil {
            let attStr4 = NSMutableAttributedString(string:"0", attributes:
                [NSAttributedString.Key.font : label.font,
                 NSAttributedString.Key.paragraphStyle : paragraph,
                 NSAttributedString.Key.foregroundColor : selColor,
                 NSAttributedString.Key.backgroundColor : UIColor.clear])
            attStr.append(attStr4)
            return attStr
        }
        let attStr4 = NSMutableAttributedString(string: user!.user_coin+COINNAME+"（\(user!.user_premium)\(COINNAME_PREIUM)）", attributes:
            [NSAttributedString.Key.font : label.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : selColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        attStr.append(attStr4)
        return attStr
    }
    
    
    
}

//MARK:  操作方法
extension MQIReadPageWrongView {
    @objc func btnAction(_ btn: UIButton) {
        if btn.tag == 1001 {
            MQIOpenlikeManger.toDCVC()
            return
        }
        if let agreeBtn = agreeBtn {
            if agreeBtn.isSelected == true {
                GYBookManager.shared.addDingyueBook(book)
            }
        }
        reloadBlock?()
    }
    
    @objc func agreeBtnAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
    
    @objc func subscribeChaptersAction() {
        subscribeChaptersBlock?()
    }
    
    
    func reloadColor() {
        let themeModel = GYReadStyle.shared.styleModel.themeModel
        if let agreeBtn = agreeBtn {
            agreeBtn.setTitleColor(themeModel?.statusColor, for: .normal)
        }
        if let protocolLabel = protocolLabel {
            protocolLabel.textColor = themeModel?.statusColor
        }
        if let priceLabel = priceLabel {
            priceLabel.attributedText = getPriceAttstr(priceLabel)
        }
        titleLabel.textColor = themeModel?.titleColor
        deTitleLabel.textColor = themeModel?.statusColor
        
    }
}
