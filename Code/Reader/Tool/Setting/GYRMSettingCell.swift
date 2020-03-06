//
//  GYRMSettingCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/24.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMSettingCell: MQITableViewCell {
    
    weak var readMenu: GYReadMenu!
    public var titleLabel: UILabel!
    public var actionView: GDRMSettingScrollView!
    
    public var slider: UISlider?
    public var sw: UISwitch?
    
    public let titleFont = UIFont.boldSystemFont(ofSize: 12)
    public let titleColor = RGBColor(202, g: 202, b: 202)
    public let titleColorSel = RGBColor(183, g: 73, b: 14)
    public let borderColor = RGBColor(202, g: 202, b: 202)
    public var bacColor = UIColor.clear
    
    public var effectBtns = [UIButton]()
    public var fontBtns = [UIButton]()
    public var lineBtns = [UIButton]()
    public var bacBtns = [UIButton]()
    public var simpleBtn: UIButton?
    
    fileprivate let selectedColor = RGBColor(252, g: 98, b: 22)
    public var isSubscribe: Bool! {
        didSet {
            if isSubscribe == true {
                titleLabel.text = "已订阅"
                titleLabel.textColor = selectedColor
            }else {
                titleLabel.text = readMenu.vc.book.checkIsWholdSubscribe() == true ? kLocalized("CompleteTheSubscription") : "自动订阅"
                titleLabel.textColor = UIColor.white
            }
            if sw!.isOn != isSubscribe {
                sw!.isOn = isSubscribe
            }
        }
    }
    
    lazy var style: GYReadStyle! = {
        return GYReadStyle.shared
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        //"翻页", "字号", "排版", "背景" 标题
        titleLabel = createLabel(CGRect.zero, font: titleFont, bacColor: bacColor, textColor: titleColor, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: nil)
        contentView.addSubview(titleLabel)
        
        actionView = GDRMSettingScrollView(frame: CGRect.zero)
        actionView.backgroundColor = UIColor.clear
        contentView.addSubview(actionView)
    }

    
    //MARK: Action
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    
    //MAERK: --
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelWidth: CGFloat = 60
        titleLabel.frame = CGRect(x: 15, y: 0, width: labelWidth, height: self.bounds.height)
        actionView.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: self.bounds.width-titleLabel.frame.maxX, height: self.bounds.height)
        let leftSpace: CGFloat = 15
        let btnHeight: CGFloat = 30
        var btnWidth: CGFloat = 0
        let originY = (actionView.bounds.height-btnHeight)/2
        var originX = leftSpace
        
        if effectBtns.count > 0 {
            btnWidth = (actionView.bounds.width-CGFloat(effectBtns.count+1)*leftSpace)/CGFloat(effectBtns.count)
            for i in 0..<effectBtns.count {
                effectBtns[i].frame = CGRect(x: originX, y: originY, width: btnWidth, height: btnHeight)
                originX = effectBtns[i].frame.maxX+leftSpace
                effectBtns[i].layer.cornerRadius = btnHeight/2
            }
        }
        
        if fontBtns.count > 0 {
            btnWidth = (actionView.bounds.width-CGFloat(fontBtns.count+1)*leftSpace)/CGFloat(fontBtns.count)
            for i in 0..<fontBtns.count {
                fontBtns[i].frame = CGRect(x: originX, y: originY, width: btnWidth, height: btnHeight)
                originX = fontBtns[i].frame.maxX+leftSpace
                fontBtns[i].layer.cornerRadius = btnHeight/2
            }
        }
        
        btnWidth = btnHeight
        var space: CGFloat = 8
        let moreBtnWidth: CGFloat = 80
        space = (actionView.bounds.width-moreBtnWidth-4*btnWidth)/6
        originX = leftSpace
        
        if lineBtns.count > 0 {
            
            for i in 0..<lineBtns.count {
                
                if i < lineBtns.count-1 {
                    lineBtns[i].frame = CGRect(x: originX, y: originY, width: btnWidth, height: btnHeight)
                    lineBtns[i].layer.cornerRadius = 5
                    lineBtns[i].layer.masksToBounds = true
                    originX = lineBtns[i].frame.maxX+space
                }
                if i == lineBtns.count-1 {
                    lineBtns[i].frame = CGRect(x: originX, y: originY, width: moreBtnWidth, height: btnHeight)
                    lineBtns[i].layer.cornerRadius = btnHeight/2
                    lineBtns[i].layer.masksToBounds = true
                }
            }
        }
        
        if bacBtns.count > 0 {
            let allCount = CGFloat(bacBtns.count)
            let allWidth = btnWidth*allCount+allCount*space+10
            if allWidth > actionView.bounds.width {
                actionView.contentSize = CGSize(width: allWidth, height: 0)
            }
            
            for i in 0..<bacBtns.count {
                bacBtns[i].frame = CGRect(x: originX, y: originY, width: btnWidth, height: btnHeight)
                bacBtns[i].layer.cornerRadius = btnWidth/2
                bacBtns[i].layer.masksToBounds = true
                
                originX = bacBtns[i].frame.maxX+space
            }
        }
        if let slider = slider {
            slider.frame = CGRect(x: originX, y: 0, width: actionView.width-originX-leftSpace, height: actionView.bounds.height)
        }
        if let sw = sw {
            sw.frame = CGRect(x: originX, y:(height-31)/2, width: 51, height: 31)
        }
    }
}

extension GYRMSettingCell {
    //添加翻页方式
    func addEffect() {
        if effectBtns.count > 0 {
            return
        }
        let titles = [GYReadEffectType.simulation.rawValue, GYReadEffectType.translation.rawValue, GYReadEffectType.upAndDown.rawValue, GYReadEffectType.none.rawValue]
        
        for i in 0..<titles.count {
            
            let button = createButton(CGRect.zero, normalTitle: titles[i], normalImage: nil, selectedTitle: nil, selectedImage: nil, normalTilteColor: titleColor, selectedTitleColor: nil, bacColor: nil, font: titleFont, target: self, action:  #selector(GYRMSettingCell.effectBtnAction(_:)))
            
            button.setTitleColor(titleColorSel, for: .highlighted)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = titleFont
            button.tag = btnTag+i
            actionView.addSubview(button)
            effectBtns.append(button)
            
            if titles[i] == GYReadStyle.shared.styleModel.effectType.rawValue {
                button.isSelected = true
                button.layer.borderColor = titleColorSel.cgColor
            }
            
        }
        
        layoutSubviews()
        
    }
    
    @objc func effectBtnAction(_ button: UIButton) {
        for btn in effectBtns {
            if btn == button {
                btn.isSelected = true
                btn.layer.borderColor = titleColorSel.cgColor
            }else {
                btn.isSelected = false
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
        let effectType: GYReadEffectType!
        switch button.tag-btnTag {
        case 0:
            effectType = .simulation
        case 1:
            effectType = .translation
        case 2:
            effectType = .upAndDown
        case 3:
            effectType = GYReadEffectType.none
        default:
            effectType = .translation
        }
        
        if style.styleModel.effectType == effectType {
            return
        }
        style.styleModel.effectType = effectType
        
        readMenu.delegate?.readMenuClicksetupEffect?(readMenu: readMenu, type: style.styleModel.effectType.rawValue)
    }
}

extension GYRMSettingCell {
    func addFont() {
        if fontBtns.count > 0 {
            return
        }
        let titles = ["A-", "A+", "简繁体"]
        for i in 0..<titles.count {
            
            let button = createButton(CGRect.zero, normalTitle: titles[i], normalImage: nil, selectedTitle: nil, selectedImage: nil, normalTilteColor: titleColor, selectedTitleColor: nil, bacColor: nil, font: titleFont, target: self, action:  #selector(GYRMSettingCell.fontBntAction(_:)))
            
            button.setTitleColor(titleColorSel, for: .highlighted)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = titleFont
            button.tag = btnTag+i
            
            if i == 2 {
                button.setTitle("简体", for: .normal)
                button.setTitle("繁体", for: .selected)
                button.isSelected =  GYReadStyle.shared.styleModel.simpleFontStyle == .zh_hans ? true : false
                simpleBtn = button
            }
            
            actionView.addSubview(button)
            fontBtns.append(button)
        }
        
        layoutSubviews()
    }
    
    @objc func fontBntAction(_ button: UIButton) {
        let index = button.tag-btnTag
        
        guard index != 2 else {
            button.isSelected = !button.isSelected
            GYReadStyle.shared.styleModel.simpleFontStyle = button.isSelected == true ? .zh_hans : .zh_hant
            readMenu.delegate?.readMenuClickSimple?(readMenu: readMenu)
            return
        }
        
        
        button.layer.borderColor = borderColor.cgColor
        
        let plus = index == 0 ? false : true
        if plus == true {
            if style.styleModel.bookFontSize <= DEFAULT_FONT+8 {
                style.styleModel.bookFontSize += 1
            }
        }else {
            if style.styleModel.bookFontSize >= DEFAULT_FONT-4 {
                style.styleModel.bookFontSize -= 1
            }
        }
        
        readMenu.delegate?.readMenuClicksetupFontSize?(readMenu: readMenu,
                                                       fontSize: CGFloat(style.styleModel.bookFontSize))
    }
}

extension GYRMSettingCell {
    //排版样式，行高
    func addLineHights() {
        
        for btn in lineBtns {
            btn.removeFromSuperview()
        }
        
        lineBtns.removeAll()
        
        let titles = ["无"]
        let imgs = ["reader_lineHeight_max", "reader_lineHeight_mid", "reader_lineHeight_min"]
        for i in 0..<(titles.count+imgs.count) {
            let button = UIButton(type: .custom)
            if i <= 2 {
                button.setBackgroundImage(UIImage(named: imgs[i]), for: .normal)
            }else {
                button.setTitle(titles[i-3], for: .normal)
            }
            
            button.setTitleColor(titleColor, for: .normal)
            button.setTitleColor(titleColorSel, for: .highlighted)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = titleFont
            button.addTarget(self, action: #selector(GYRMSettingCell.lineHeightAction(_:)), for: .touchUpInside)
            button.tag = btnTag+i
            actionView.addSubview(button)
            lineBtns.append(button)
        }
        
        var button: UIButton?
       
            switch GYReadStyle.shared.styleModel.bookLineHeight {
            case GYReadLineStyle.max.rawValue:
                button = lineBtns[2]
            case GYReadLineStyle.mid.rawValue:
                button = lineBtns[1]
            case GYReadLineStyle.min.rawValue:
                button = lineBtns[0]
            case GYReadLineStyle.original.rawValue:
                button = lineBtns[3]
            default:
                break
        }
        
        if let button = button {
            button.isSelected = true
            button.layer.borderColor = titleColorSel.cgColor
        }
        
        layoutSubviews()
    }
    
    @objc func lineHeightAction(_ button: UIButton) {
        let index = button.tag-btnTag
        
        for btn in lineBtns {
            if button == btn {
                btn.isSelected = true
                btn.layer.borderColor = titleColorSel.cgColor
            }else {
                btn.isSelected = false
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
        for btn in bacBtns {
            if button == btn {
                btn.isSelected = true
                btn.layer.borderColor = titleColorSel.cgColor
            }else {
                btn.isSelected = false
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
        var s = GYReadLineStyle.mid
        if index == 0 {
            s = .min
        }else if index == 1 {
            s = .mid
        }else if index == 2{
            s = .max
        }else{
            s = .original
        }
        
//         if index == 0 {
//         s = .min
//         }else if index == 1 {
//         s = .mid
//         }else if index == 2{
//         s = .max
//         }else if index == 3{
//         s = .original
//         }else {
//         s = .custom
//         style.styleModel.bookLineStyle = s
//         //changeRStyle?()
//         return
//         }
 
        
        if style.styleModel.bookLineStyle == s {
            return
        }
        
        style.styleModel.bookLineStyle = s
        style.styleModel.bookLineHeight = s.rawValue
        
        readMenu.delegate?.readMenuClicksetupLineHeight?(readMenu: readMenu, linHeight: CGFloat(s.rawValue))
    }
}

extension GYRMSettingCell {
    //更换主题背景
    func addBacs() {
        if bacBtns.count > 0 {
            return
        }
        
        let themeList = GYReadStyle.shared.styleModel.bookThemeList!//获取配置列表
        for i in 0..<themeList.count {
            let button = UIButton(type: .custom)
            
            button.setTitleColor(titleColor, for: .normal)
            button.setTitleColor(titleColorSel, for: .selected)
            button.setBackgroundImage(themeList[i].iconImage, for: .normal)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1.5
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(GYRMSettingCell.bacAction(_:)), for: .touchUpInside)
            button.tag = btnTag+i
            button.titleLabel?.font = titleFont
            
            if i == GYReadStyle.shared.styleModel.bookThemeIndex {
                button.isSelected = true
                button.layer.borderColor = titleColorSel.cgColor
            }
            
            actionView.addSubview(button)
            bacBtns.append(button)
        }
        
        layoutSubviews()
    }
    
    @objc func bacAction(_ button: UIButton) {
        let index = button.tag-btnTag
        
        for btn in lineBtns {
            if button == btn {
                btn.isSelected = true
                btn.layer.borderColor = titleColorSel.cgColor
            }else {
                btn.isSelected = false
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
        for btn in bacBtns {
            if button == btn {
                btn.isSelected = true
                btn.layer.borderColor = titleColorSel.cgColor
            }else {
                btn.isSelected = false
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
        if index < style.styleModel.bookThemeList.count {
            style.styleModel.bookThemeIndex = index
            readMenu?.delegate?.readMenuClicksetupColor?(readMenu: readMenu, index: index)
        }
    }
}

extension GYRMSettingCell {
    func addLights() {
        slider = UISlider(frame: CGRect.zero)
        slider!.maximumValue = GYReadStyle.shared.styleModel.maxBookBrightness
        slider!.value = GYReadStyle.shared.styleModel.maxBookBrightness-GYReadStyle.shared.styleModel.bookBrightness
        slider!.setThumbImage(UIImage(named: "tool_circle"), for: .normal)
        slider!.setMinimumTrackImage(createImageWithColor(RGBColor(217, g: 62, b: 61)), for: .normal)
        slider!.setMaximumTrackImage(createImageWithColor(RGBColor(76, g: 76, b: 76)), for: .normal)
        slider!.addTarget(self, action:#selector(GYRMSettingCell.sliderValueChanged(_:)), for: .valueChanged)
        actionView.addSubview(slider!)
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        let value = GYReadStyle.shared.styleModel.maxBookBrightness-slider.value
        GYReadStyle.shared.styleModel.bookBrightness = value
        readMenu.coverView.alpha = CGFloat(value)
    }
}

extension GYRMSettingCell {
    func addDingYue() {
        if sw == nil {
            sw = UISwitch(frame: CGRect.zero)
            sw!.onTintColor = RGBColor(252, g: 98, b: 22)
            sw!.tintColor = UIColor.lightGray//边缘
            sw!.backgroundColor = UIColor.clear
            sw!.addTarget(self, action: #selector(GYRMSettingCell.subscribeAction(_:)), for: .valueChanged)
            actionView.addSubview(sw!)
        }
        
        checkSubscribe()
    }
    
    func checkSubscribe() {
        guard readMenu.vc.book.checkIsWholdSubscribe() == true else {
            isSubscribe = GYBookManager.shared.checkIsSubscriber(readMenu.vc.book, type: .chapter)
            return
        }
        
        let bool = GYBookManager.shared.checkIsSubscriber(readMenu.vc.book, type: .book)
        sw!.isOn = bool
        isSubscribe = bool
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
}
