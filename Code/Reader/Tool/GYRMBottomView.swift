//
//  GYRMBottomView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMBottomView: GYRMBaseView, MQISliderPopoverDelegate {
    
    lazy var imgs: [String] = {
        //["readerTool_line", "readerTool_light", "readerTool_sun", "readerTool_font", "readerTool_more"]
        ["readerTool_line", "readerTool_sun", "readerTool_font"]
    }()
    
    lazy var titles: [String] = {
        //["目录", "亮度", "日间", "设置", "更多"]
        [kLocalized("Directory"), kLocalized("Daily"), kLocalized("Set")]
    }()
    
    fileprivate var buttons = [UIButton]()
    fileprivate var chapterBtns = [UIButton]()
    
    var slider: MQISliderPopover!
    
    fileprivate var titleColor = RGBColor(201, g: 201, b: 201)
    fileprivate var lineColor =  RGBColor(101, g: 101, b: 101)
    
    var lightBtn: UIButton! {
        if chapterBtns.count == titles.count {
            return chapterBtns[1]
        }else {
            return UIButton()
        }
    }
    
    var allPage: Int = 0 {
        didSet {
            if slider != nil {
                slider.minimumValue = 0.0
                slider.maximumValue = Float(allPage <= 1 ? 1 : allPage-1)
            }
        }
    }
    
    var sliderChapter: MQIEachChapter?
    
    override init(frame: CGRect, readMenu: GYReadMenu) {
        super.init(frame: frame, readMenu: readMenu)
        slider.popover.textLabel.backgroundColor = GYMenuUIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        let chapters = [kLocalized("LastChapter"), kLocalized("NextChapter")]
        for i in 0..<chapters.count {
            let button = createButton(nil, normalTitle: chapters[i], normalImage: nil, selectedTitle: nil, selectedImage: nil, normalTilteColor: titleColor, selectedTitleColor: nil, bacColor: nil, font: nil, target: self, action: #selector(GYRMBottomView.chapterBtnAction(_:)))
            button.tag = 2*btnTag+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            self.addSubview(button)
            chapterBtns.append(button)
        }
        
        for i in 0..<imgs.count {
            let button = createButton(nil,
                                      normalTitle: titles[i],
                                      normalImage: UIImage(named: imgs[i]),
                                      selectedTitle: nil,
                                      selectedImage: nil,
                                      normalTilteColor: titleColor,
                                      selectedTitleColor: nil,
                                      bacColor: nil,
                                      font: nil,
                                      target: self, action: #selector(GYRMBottomView.buttonAction(_:)))
            button.tag = btnTag+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            self.addSubview(button)
            buttons.append(button)
            
            if i == 1 {
                button.setImage(UIImage(named: "readerTool_moon"), for: .selected)
                button.setTitle(kLocalized("Night"), for: .selected)
                let index = GYReadStyle.shared.styleModel.bookThemeIndex
                if index == 0 || index == 1 || index == 2 || index == 3 || index == 4 {
                    button.isSelected = true
                }
            }
        }
        
        configSlider()
        reloadThemeModel()
        addTips()
    }
    
    func configSlider() {
        slider = MQISliderPopover(frame: CGRect.zero)
        slider.sDelegate = self
        slider.setThumbImage(UIImage(named: "tool_circle"), for: .normal)
        slider.setMinimumTrackImage(createImageWithColor(RGBColor(241, g: 241, b: 241)), for: .normal)
        slider.setMaximumTrackImage(createImageWithColor(RGBColor(76, g: 76, b: 76)), for: .normal)
        slider.addTarget(self, action:#selector(GYRMBottomView.sliderValueChanged(_:)), for: .valueChanged)
        self.addSubview(slider)
        
        updateSliderPopoverText()
    }
    
    /// 刷新 slider
    func sliderUpdate() {
        guard style.styleModel.effectType != .upAndDown else {
            slider.popover.isHidden = true
            return
        }
        
        slider.popover.alpha = 1
        if readMenu.vc.readModel.chapterList.count > 0 {
            let recordModel = readMenu.vc.readModel.readRecordModel
            
            if let chapter = recordModel!.readChapterModel {
                
                if let sliderChapter = sliderChapter {
                    if sliderChapter.chapter_id == chapter.chapter_id {
                        if recordModel!.page.floatValue == slider.value {
                            return
                        }
                    }
                }
                
                sliderChapter = chapter
                allPage = chapter.pageCount.intValue
                let index = recordModel!.page.intValue
                slider.value = Float(index)
                updateSliderPopoverText()

            }
        }
    }
    
    func UDSliderUpdate(_ currentOffsetY: CGFloat, maxOffsetY: CGFloat) {
        slider.popover.isHidden = true
        slider.maximumValue = Float(maxOffsetY)
        slider.minimumValue = 0
        slider.value = Float(currentOffsetY)
    }
    
    func sliderClear() {
        allPage = 0
        slider.value = 0
        updateSliderPopoverText()
    }

    func addTips()  {
        if  MQIUserDefaultsKeyManager.shared.reader_directory_isAvailable() {
            addTips1()
        }
        if  MQIUserDefaultsKeyManager.shared.reader_AdjusA_isAvailable() {
            addTips2()
        }
       
    }
    
    func addTips1() {
        let image = UIImage(named: "reader_ML_img")!
        let tips1 = UIView()
        tips1.layer.contents = image.cgImage
        tips1.tag = 100
        addSubview(tips1)
        tips1.dsyAddTap(self, action: #selector(clickTipsView(tap:)))
        
        let  tips1Label = UILabel ()
        tips1Label.font = UIFont.systemFont(ofSize: 11)
        tips1Label.textColor = UIColor.colorWithHexString("ffffff")
        tips1Label.text  = kLocalized("Stamp_here_to_view_directory",describeStr: "目录")
        tips1Label.adjustsFontSizeToFitWidth = true
        tips1.addSubview(tips1Label)
        tips1Label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-31)
        }
        tips1.snp.makeConstraints { (make) in
            make.width.equalTo(image.size.width)
            make.height.equalTo( image.size.height)
            make.bottom.equalTo(buttons[0].snp.top).offset(3)
            make.left.equalTo(buttons[0].snp.centerX).offset(-25)
        }
    }
    
    func addTips2() {
        let image2 = UIImage(named: "reader_Aa_img")!
        let tips2 = UIView()
        tips2.layer.contents = image2.cgImage
        tips2.tag = 101
        tips2.dsyAddTap(self, action: #selector(clickTipsView(tap:)))
        addSubview(tips2)
        
        let  tips2Label = UILabel ()
        tips2Label.font = UIFont.systemFont(ofSize: 11)
        tips2Label.textColor = UIColor.colorWithHexString("ffffff")
        tips2Label.text  = kLocalized("More_customizations_here_at_th_stamp", describeStr: "设置")
        tips2Label.adjustsFontSizeToFitWidth = true
        tips2.addSubview(tips2Label)
        tips2Label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-29)
        }
        tips2.snp.makeConstraints { (make) in
            make.width.equalTo(image2.size.width)
            make.height.equalTo( image2.size.height)
            make.bottom.equalTo(buttons[2].snp.top).offset(-5)
            make.centerX.equalTo(buttons[2].snp.centerX).offset(-22)
        }
        
    }
    
    @objc func clickTipsView(tap:UIGestureRecognizer)  {
     
        if tap.view?.tag  == 100 {
            MQIUserDefaultsKeyManager.shared.reader_directory_Save()
        }else{
            MQIUserDefaultsKeyManager.shared.reader_AdjusA_Save()
        }
       tap.view?.removeFromSuperview()
    }
    
    //MARK: --
    @objc func sliderValueChanged(_ slider: UISlider) {
        updateSliderPopoverText()
        readMenu.delegate?.readMenuSliderChangeScroll?(readMenu: readMenu, slider: self.slider)
    }
    
    func updateSliderPopoverText() {
        guard style.styleModel.effectType != .upAndDown else {
            slider.popover.isHidden = true
            return
        }
        
        if allPage == 0 {
            slider.popover.isHidden = true
        }else {
            slider.popover.isHidden = false
        }
        
        let index = Int(slider.value)
        
        if let chapter = sliderChapter {
            if index < allPage {
                self.slider.popoverTitle = "\(chapter.chapter_title) \(kLocalized("No"))\(index+1)\(kLocalized("Page"))"
            }
        }
    }
    
    func sliderSelectedValue(_ value: CGFloat) {
        if readMenu.vc.isCreating {return }
        updateSliderPopoverText()
        readMenu.delegate?.readMenuSliderEndScroll?(readMenu: readMenu, slider: self.slider)
    }
    
    //MARK: --
    
    @objc func chapterBtnAction(_ button: UIButton) {
        if readMenu.vc.isCreating {return }
        let tag = button.tag-btnTag*2
        if tag == 0 {
            readMenu.delegate?.readMenuClickPreviousChapter?(readMenu: readMenu)
        }else {
            readMenu.delegate?.readMenuClickNextChapter?(readMenu: readMenu)
        }
    }
    
    @objc func buttonAction(_ button: UIButton) {
        if readMenu.vc.isCreating {return }
        switch button.tag-btnTag {
        case 0:
             readMenu.delegate?.readMenuClickChapterList?(readMenu: readMenu)
        case 1:
            button.isSelected = !button.isSelected
            style.styleModel.bookLightMode = button.isSelected
            style.styleModel.reloadThemeIndexWithLightMode()
            readMenu.delegate.readMenuClickLightButton?(readMenu: readMenu, isDay: button.isSelected)
        case 2:
            readMenu.bottomView(isShow: false, completion: {[weak self] ()->Void in
                if let strongSelf = self {
                strongSelf.readMenu.novelsSettingView(isShow: true , completion: nil)
                }
            })
        default:
            break
        }
    }
    
    func reloadThemeModel() {
        if buttons.count > 2 {
            if style.styleModel.bookThemeIndex <= 4 {
                buttons[2].isSelected = true
            }else {
                buttons[2].isSelected = false
            }
            style.styleModel.bookLightMode = buttons[2].isSelected
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var btnWidth = self.width/CGFloat(chapterBtns.count)
        let btnHeight: CGFloat = 50
        
        let chapterBtnWidth: CGFloat = 70//章节按钮宽度
        slider.frame = CGRect(x: chapterBtnWidth, y: 1, width: self.bounds.width-2*chapterBtnWidth, height: btnHeight)
        for i in 0..<chapterBtns.count {
            if i == 0 {
                chapterBtns[i].frame = CGRect(x: 0, y: 0, width: chapterBtnWidth, height: btnHeight)
            }else {
                chapterBtns[i].frame = CGRect(x: self.bounds.width-chapterBtnWidth, y: 0, width: chapterBtnWidth, height: btnHeight)
            }
        }
        
        let leftSpace: CGFloat = 10
        btnWidth = (self.width-2*leftSpace)/CGFloat(buttons.count)
        
        for i in 0..<buttons.count {
            buttons[i].frame = CGRect(x: leftSpace+btnWidth*CGFloat(i), y: btnHeight, width: btnWidth, height: self.height-btnHeight-10-x_TabbatSafeBottomMargin)
            buttons[i].contentHorizontalAlignment = .center
            buttons[i].titleEdgeInsets = UIEdgeInsets(top: buttons[i].imageView!.frame.size.height+10, left: -buttons[i].imageView!.frame.size.width, bottom: 0.0,right: 0.0)
            buttons[i].imageEdgeInsets = UIEdgeInsets(top: -20, left: 0.0,bottom: 0.0, right: -buttons[i].titleLabel!.bounds.size.width)
        }
        
    }

}
