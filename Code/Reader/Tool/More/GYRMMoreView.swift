//
//  GYRMMoreView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/26.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMMoreView: GYRMBaseView {

    fileprivate var simpleLabel: UILabel!
    fileprivate var simpleIcon: UIImageView!
    fileprivate var simpleSwitch : UISwitch!
    
    fileprivate var subscribeLabel: UILabel!
    fileprivate var subscribeIcon: UIImageView!
    fileprivate var subscribeSwitch : UISwitch!
    
    fileprivate let titleFont = systemFont(12)
    fileprivate let titleColor = UIColor.white
    
    fileprivate let lineColor = RGBColor(51, g: 51, b: 51)
    fileprivate let selectedColor = RGBColor(252, g: 98, b: 22)
    
    public var isSubscribe: Bool! {
        didSet {
            if isSubscribe == true {
                subscribeLabel.text = "书籍已订阅"
                subscribeLabel.textColor = selectedColor
                subscribeIcon.tintColor = selectedColor
            }else {
                subscribeLabel.text = readMenu.vc.book.checkIsWholdSubscribe() == true ? kLocalized("CompleteTheSubscription") : "自动订阅下一章节"
                subscribeLabel.textColor = titleColor
                subscribeIcon.tintColor = titleColor
            }
            if subscribeSwitch.isOn != isSubscribe {
                subscribeSwitch.isOn = isSubscribe
            }
        }
    }
    
    fileprivate var simpleFontStyle: GYReadFontStyle! {
        didSet {
            if simpleFontStyle == .zh_hans {
                simpleIcon.image = UIImage(named: "reader_more_hans")
                simpleLabel.text = "简体"
                simpleSwitch.isOn = false
            }else {
                simpleIcon.image = UIImage(named: "reader_more_hant")
                simpleLabel.text = "繁体"
                simpleSwitch.isOn = true
            }
        }
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        var height: CGFloat = 120
        var originY: CGFloat = 0
        addHeader(CGRect(x: 0, y: originY, width: self.width, height: height), action: #selector(GYRMMoreView.headerViewAction(_:)))
        
        originY += height
        height = (self.height-height)/3
//        let title = readMenu.vc.book.checkIsWholdSubscribe() == true ? "全本订阅" : "自动订阅下一章节"
        let subscribeView = addBacView(CGRect(x: 0, y: originY, width: self.width, height: height), iconStr: "reader_more_buy", title: "", action: #selector(GYRMMoreView.subscribeViewAction(tgr:)))
        subscribeView.0.addLine(0, lineColor: lineColor, directions: .bottom)
        subscribeSwitch = createSwitch(CGRect(x: subscribeView.0.width-65, y:(subscribeView.0.height-31)/2, width: 51, height: 31))
        subscribeSwitch.addTarget(self, action: #selector(GYRMMoreView.subscribeAction(_:)), for: .valueChanged)
        subscribeView.0.addSubview(subscribeSwitch)
        
        subscribeLabel = subscribeView.2
        subscribeIcon = subscribeView.1
        subscribeIcon.image = UIImage(named: "reader_more_buy")?.withRenderingMode(.alwaysTemplate)
        
        originY += height
        
        let simpleView = addBacView(CGRect(x: 0, y: originY, width: self.width, height: height), iconStr: "reader_more_hans", title: "简繁体", action: #selector(GYRMMoreView.simpleViewAction(tgr:)))
        simpleView.0.addLine(0, lineColor: lineColor, directions: .bottom)
        simpleSwitch = createSwitch(CGRect(x:simpleView.0.width-65, y:(simpleView.0.height-31)/2, width: 51, height: 31))
        simpleSwitch.addTarget(self, action: #selector(GYRMMoreView.simpleAction(_:)), for: .valueChanged)
        simpleView.0.addSubview(simpleSwitch)
        
        simpleIcon = simpleView.1
        simpleLabel = simpleView.2
        simpleFontStyle = GYReadStyle.shared.styleModel.simpleFontStyle
        
        originY += height
        
//        let fontView = addBacView(CGRect(x: 0, y: originY, width: self.width, height: height), iconStr: "reader_more_font", title: "更多字体", action: #selector(GYRMMoreView.fontViewAction(tgr:)))
//        fontView.0.addLine(0, lineColor: lineColor, directions: .bottom)
//        
//        originY += height
        
        addBacView(CGRect(x: 0, y: originY, width: self.width, height: height), iconStr: "reader_more_shelf", title: kLocalized("AddShelf"), action: #selector(GYRMMoreView.shelfViewAction(tgr:)))
        
        checkSubscribe()
    }
    
    @discardableResult func addBacView(_ bFrame: CGRect, iconStr: String, title: String, action: Selector) -> (UIView, UIImageView, UILabel) {
        let bacView = UIView(frame: bFrame)
        bacView.backgroundColor = UIColor.clear
        bacView.isUserInteractionEnabled = true
        addTGR(self, action: action, view: bacView)
        self.addSubview(bacView)
        
        let iconSide: CGFloat = 22
        let icon = UIImageView(image: UIImage(named: iconStr))
        icon.frame = CGRect(x: 20, y: (bacView.height-iconSide)/2, width: iconSide, height: iconSide)
        icon.contentMode = .scaleAspectFit
        bacView.addSubview(icon)
        
        let titleLabel = createLabel(CGRect(x: icon.maxY+15, y: 0, width: 150, height: bFrame.height),
                                     font: titleFont,
                                     bacColor: UIColor.clear,
                                     textColor: titleColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .left,
                                     numberOfLines: 1)
        titleLabel.text = title
        bacView.addSubview(titleLabel)
        return (bacView, icon, titleLabel)
    }
    
    func addHeader(_ bFrame: CGRect, action: Selector) {
        let bacView = UIView(frame: bFrame)
        bacView.backgroundColor = UIColor.clear
        bacView.isUserInteractionEnabled = true
        addTGR(self, action: action, view: bacView)
        bacView.addLine(0, lineColor: lineColor, directions: .bottom)
        self.addSubview(bacView)
        
        let space: CGFloat = 30
        let iconHeight = bFrame.height-34
        let icon = UIImageView(frame: CGRect(x: space, y: 17, width: iconHeight*3/4, height: iconHeight))
        icon.sd_setImage(with: URL(string: readMenu.vc.book.book_cover), placeholderImage: bookPlaceHolderImage)
        bacView.addSubview(icon)
        
        let labelHeight: CGFloat = 30
        let titleLabel = createLabel(CGRect(x: icon.maxY+10, y: (bFrame.height-2*labelHeight)/2, width: bFrame.width-space-icon.maxY-10, height: labelHeight),
                                     font: systemFont(14),
                                     bacColor: UIColor.clear,
                                     textColor: titleColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .left,
                                     numberOfLines: 1)
        titleLabel.text = readMenu.vc.book.book_name
        bacView.addSubview(titleLabel)
        
        let authorLabel = createLabel(CGRect(x: titleLabel.x, y: titleLabel.maxY, width: titleLabel.width, height: titleLabel.height),
                                     font: systemFont(13),
                                     bacColor: UIColor.clear,
                                     textColor: titleColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .left,
                                     numberOfLines: 1)
        authorLabel.text = readMenu.vc.book.author_name
        bacView.addSubview(authorLabel)
        
    }
    
    func createSwitch(_ bFrame: CGRect) -> UISwitch {
        let sw = UISwitch(frame: bFrame)
        sw.onTintColor = selectedColor
        sw.tintColor = UIColor.lightGray//边缘
        sw.backgroundColor = UIColor.lightGray
        sw.layer.cornerRadius = sw.bounds.height/2.0
        sw.layer.masksToBounds = true
        return sw
    }
    
    func checkSubscribe() {
        guard readMenu.vc.book.checkIsWholdSubscribe() == true else {
            return
        }
        
        let bool = GYBookManager.shared.checkIsSubscriber(readMenu.vc.book, type: .book)
        subscribeSwitch.isOn = bool
        subscribeSwitch.isHidden = bool
        isSubscribe = bool
    }
    
    //MARK: --
    @objc func headerViewAction(_ tgr: UITapGestureRecognizer) {
        
    }
    
    
    @objc func subscribeViewAction(tgr: UITapGestureRecognizer) {
        
    }
    
    @objc func simpleViewAction(tgr: UITapGestureRecognizer) {
        
    }
    
    @objc func subscribeAction(_ sw: UISwitch) {
        guard MQIUserManager.shared.checkIsLogin() == true else {
            sw.isOn = false
            MQILoadManager.shared.makeToast(kLocalized("SorryYouHavenLoggedInYet"))
            return
        }
        
        guard readMenu.vc.book.checkIsWholdSubscribe() == false else {
            readMenu.delegate?.readMenuClickBuyBook?(readMenu: readMenu)
            return 
        }
        
        isSubscribe = !isSubscribe
        readMenu.delegate?.readMenuClickSubscribe?(readMenu: readMenu, isSubscribe: isSubscribe)
    }
    
    @objc func simpleAction(_ sw: UISwitch) {
        if simpleFontStyle == .zh_hans {
            simpleFontStyle = .zh_hant
        }else {
            simpleFontStyle = .zh_hans
        }
        GYReadStyle.shared.styleModel.simpleFontStyle = simpleFontStyle
        readMenu.delegate?.readMenuClickSimple?(readMenu: readMenu)
    }
    
    @objc func shelfViewAction(tgr: UITapGestureRecognizer) {
        readMenu.delegate?.readMenuClickAddShelf?(readMenu: readMenu)
    }
    
    func fontViewAction(tgr: UITapGestureRecognizer) {

    }
}
