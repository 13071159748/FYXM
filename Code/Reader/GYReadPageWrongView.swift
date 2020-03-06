//
//  MQIReadPageWrongView.swift
//  Reader
//
//  Created by _CHK_  on 2017/6/27.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

enum GYReadWrongType {
    case needCoin
    case getChapterFaild
    case needLogin
    case needSubscribeChapter
    case needSubscribeBook
    case needNetWork
    case other
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
        configUI(wrongType, wrongMsg: msg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI(_ wrongType: GYReadWrongType, wrongMsg: String) {
        
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
        case .other:
            addOtherView(wrongMsg)
        }
    }
    
    func addNeedCoinView() {
        guard book.checkIsWholdSubscribe() == false else {
            createView(deTitle: kLocalized("NeedLogin"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("Recharge"), needCoinView: (true, unSubscribeChapter?.price))
            return
        }
        addNeedSubscribeChapterView(kLocalized("Recharge"))
    }

    func addNeedLoginView() {
        createView(deTitle: kLocalized("NeedLog"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("TheLogin"), needCoinView: (false, nil))
    }
    func addChapterFailedView() {
        createView(deTitle: kLocalized("AAA"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("Refrash"), needCoinView: (false, nil))
    }
    //IsVIP
    func addNeedSubscribeChapterView(_ btnTitle: String? = nil) {
    
        createView(deTitle: kLocalized("IsVIP"), summary: unSubscribeChapter?.summary, btnTitle: btnTitle == nil ? kLocalized("SureBook") : btnTitle!)
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
        let attStr = NSMutableAttributedString(string: kLocalized("MoreBook"), attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font:deTitleFont])
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
        createView(deTitle: kLocalized("NeedBookRead"), summary: unSubscribeChapter?.summary, btnTitle: kLocalized("ConfirmTheSubscription"), needCoinView: (true, unSubscribeChapter?.price))
    }
    
    func addNeedNetWorkView() {
        createView(deTitle: kLocalized("CheckInt"), btnTitle: kLocalized("Refrash"), needCoinView: (false, nil))
    }
    
    func addOtherView(_ wrongMsg: String) {
        createView(deTitle: wrongMsg, btnTitle: kLocalized("Refrash"))
    }
    
    func createView(deTitle: String, summary: String? = nil, btnTitle: String, needCoinView: (Bool, String?) = (true, nil)) {

        
        var originY: CGFloat = self.center.y-labelHeight
        if needCoinView.0 == false {
            originY = self.center.y-labelHeight/2
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
            [NSAttributedStringKey.font : deTitleFont,
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : themeModel!.statusColor,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: kLocalized("THKBook"), attributes:
            [NSAttributedStringKey.font : systemFont(11),
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : themeModel!.statusColor,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        
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
    
    func getReadAttribute() ->[NSAttributedStringKey: NSObject] {
        let textColor = themeModel?.textColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = CGFloat(0.5)*20
        paragraphStyle.lineHeightMultiple = CGFloat(GYReadLineStyle.mid.rawValue)
        paragraphStyle.alignment = NSTextAlignment.justified
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        // 返回
        return [NSAttributedStringKey.foregroundColor : textColor!,
                NSAttributedStringKey.font : contentFont,
                NSAttributedStringKey.paragraphStyle : paragraphStyle,
                NSAttributedStringKey.kern : NSNumber(value: 0)]
    }
    
    func getPriceAttstr(_ label: UILabel, price: String? = nil) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attStr = NSMutableAttributedString(string: wrongType == .needSubscribeBook ? kLocalized("HullBookPrice") : kLocalized("Price"), attributes:
            [NSAttributedStringKey.font : label.font,
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : themeModel!.statusColor!,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        
    //TODO: 价格价格  价格价格 价格价格 价格价格 价格价格
        var allPrice = 0
        if let Price = unSubscribeChapter?.price, Price != ""{
            allPrice = Price.integerValue()
        }else{
         allPrice =  price == nil ? chapter.chapterPrice(book) : price!.integerValue()
        }

        let attStr2 = NSMutableAttributedString(string: allPrice <= 0 ? "0.05/"+kLocalized("ThousandWords") : "\(allPrice)\(COINNAME_MERGER)", attributes:
            [NSAttributedStringKey.font : label.font,
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : selColor,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        
        let attStr3 = NSMutableAttributedString(string: kLocalized("AbovePrice"), attributes:
            [NSAttributedStringKey.font : label.font,
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : themeModel!.statusColor!,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        
        let user = MQIUserManager.shared.user
        attStr.append(attStr2)
        attStr.append(attStr3)
        if user == nil {
            let attStr4 = NSMutableAttributedString(string:"0", attributes:
                [NSAttributedStringKey.font : label.font,
                 NSAttributedStringKey.paragraphStyle : paragraph,
                 NSAttributedStringKey.foregroundColor : selColor,
                 NSAttributedStringKey.backgroundColor : UIColor.clear])
            attStr.append(attStr4)
            return attStr
        }
        let attStr4 = NSMutableAttributedString(string: user!.user_coin+COINNAME+"（\(user!.user_premium)\(COINNAME_PREIUM)）", attributes:
            [NSAttributedStringKey.font : label.font,
             NSAttributedStringKey.paragraphStyle : paragraph,
             NSAttributedStringKey.foregroundColor : selColor,
             NSAttributedStringKey.backgroundColor : UIColor.clear])
        attStr.append(attStr4)
        return attStr
    }
    
    @objc func btnAction(_ btn: UIButton) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
