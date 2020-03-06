//
//  GDUserSubscribeChpaterView.swift
//  Reader
//
//  Created by _CHK_  on 2017/7/26.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit


class MQIUserSubscribeView: UIView {
    
    
    weak var delegate: UIViewController?
    
    var subScribeCount: ((_ count:Int)->())?
    var tapDismissAction: (() -> ())?
    
    var bgView : UIView?
    var finishView:UIView?
    
    let bgColor = RGBColor(244, g: 243, b: 240)
    let defaultGrayColor: UIColor = UIColor.colorWithHexString("#979797")
    let selOrangeColor: UIColor = RGBColor(227, g: 81, b: 1)
    
    open var book: MQIEachBook!
    open var chapter: MQIEachChapter?
    
    open weak var  readMenu:GYReadMenu?
    
    init(frame: CGRect, book: MQIEachBook) {
        super.init(frame: frame)
        self.book = book
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        
    }
    
    func addsubScribe_SuccessView(_ end_Chaper_Name:String ,coin:String) {
        
    }
    
    func dismissFinishView() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func getHeight() -> CGFloat {
        return 320
    }
    
    
    
}

class GDUserSubscribeChpaterView: MQIUserSubscribeView {
    
    fileprivate var buttons = [UIButton]()
    fileprivate var currentButton:UIButton?
    fileprivate var detailedView: ContentView!
    var maskDetailedViewView: UIView!
    
    fileprivate let titles = [kLongLocalized("Chapter_After", replace: "10"),kLongLocalized("Chapter_After", replace: "50"),kLongLocalized("Chapter_After", replace: "100")," "]
    
    fileprivate var titleLabel: UILabel!
    fileprivate var countLabel: UILabel {
        return detailedView.price
    }
//    var title1:UILabel! {
//        return detailedView.balanceLabel
//    }
    
    var itmeModes = [MQIMembershipCardItemModel]()
    
    
    
    
    override var chapter: MQIEachChapter? {
        didSet {
            guard chapter?.book_id != nil else { return }
            guard chapter?.book_id != oldValue?.book_id else { return }
            getBatch_list()
        }
        
        
    }
    
    override func configUI() {
        self.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GDUserSubscribeChpaterView.TapAction), view: self)
        bgView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: self.height))
        bgView?.backgroundColor = bgColor
        self.addSubview(bgView!)
        
        let space: CGFloat = 25
        var originY: CGFloat = 25
        
        
        
        
        titleLabel = createLabel(CGRect (x: 0, y: 16, width: screenWidth, height: 21),
                                 font: UIFont.systemFont(ofSize: 14),
                                 bacColor: nil,
                                 textColor: blackColor,
                                 adjustsFontSizeToFitWidth: nil,
                                 textAlignment: .center,
                                 numberOfLines: 1)
        titleLabel.text = kLocalized("BulkSubscriptionSection")
        bgView?.addSubview(titleLabel)
        
        originY = titleLabel.maxY + 20
        let btnSpace: CGFloat = 40
        let btnWidth = (self.width-2*space-btnSpace*2)/3
        let btnHeight: CGFloat = 48
        for i in 0..<titles.count {
            let frame = CGRect(x: space + (btnWidth+btnSpace) * CGFloat(i), y: originY, width: btnWidth, height: btnHeight)
            let button = createButton(frame,
                                      normalTitle: titles[i],
                                      normalTilteColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),
                                      selectedTitleColor: selOrangeColor,
                                      bacColor: UIColor.clear,
                                      font: systemFont(14),
                                      target: self,
                                      action: #selector(GDUserSubscribeChpaterView.btnClick(_:)))
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            if i == 0 {
                button.layer.borderColor = selOrangeColor.cgColor
                button.layer.borderWidth = 1.0
                currentButton = button
            }else{
                button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1).cgColor
                button.layer.borderWidth = 0.5
            }
            
            button.tag = i + 100
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            bgView?.addSubview(button)
            buttons.append(button)
        }
        originY += btnHeight+20
        
        let borderViewHeight: CGFloat = 9.0
        let borderView = UIView(frame: CGRect(x: 24, y: originY, width: screenWidth - 48, height: borderViewHeight))
        borderView.layer.cornerRadius = 4
        borderView.layer.masksToBounds = true
        borderView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        bgView?.addSubview(borderView)
        originY += borderViewHeight - 4
        
        let detailedViewHeight: CGFloat = 140.0
        detailedView = ContentView(frame: CGRect(x: 32, y: originY, width: screenWidth - 64, height: detailedViewHeight), book: book)
        bgView?.addSubview(detailedView)
        
        maskDetailedViewView = UIView(frame: detailedView.bounds)
        detailedView.addSubview(maskDetailedViewView)
        maskDetailedViewView.isHidden = true
        maskDetailedViewView.backgroundColor = .white
        let maskDetailedViewLabel = createLabel(maskDetailedViewView.bounds,
                                                font: UIFont.systemFont(ofSize: 14),
                                                bacColor: .clear,
                                                textColor: defaultGrayColor,
                                                adjustsFontSizeToFitWidth: nil,
                                                textAlignment: .center,
                                                numberOfLines: 0)
        maskDetailedViewView.addSubview(maskDetailedViewLabel)
        maskDetailedViewLabel.text = kLocalized("subscribeToThePrompt")
        
        originY += detailedViewHeight + 20
        
        let actionBtn = createButton(CGRect(x: (width-210)/2, y: originY, width: 210, height: 38),
                                     normalTitle: kLocalized("ConfirmTheSubscription"),
                                     normalTilteColor: UIColor.white,
                                     bacColor: #colorLiteral(red: 0.9215686275, green: 0.3333333333, blue: 0.4039215686, alpha: 1),
                                     font: systemFont(15),
                                     target: self,
                                     action:  #selector(GDUserSubscribeChpaterView.sureBtnClick(_:)))
        actionBtn.layer.cornerRadius = 20
        actionBtn.layer.masksToBounds = true
        bgView?.addSubview(actionBtn)
        
        originY = actionBtn.maxY + 36
        let bottomView = UIView(frame: CGRect(x: space, y: originY, width: width-2*space, height: height-originY))
        bottomView.backgroundColor = UIColor.clear
        bgView?.addSubview(bottomView)
        
        let title1 = UILabel(frame: CGRect(x: 10, y: 7, width: bottomView.width-20, height: 13))
        title1.text = "\(kLocalized("WarmPrompt"))："
        title1.textColor = blackColor
        title1.font = UIFont.systemFont(ofSize: 14)
        bottomView.addSubview(title1)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = NSTextAlignment.justified
        
        let attDict = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),
                       NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                       NSAttributedString.Key.paragraphStyle : paragraphStyle,
                       NSAttributedString.Key.kern : NSNumber(value: 0)]
        
        
        let title2 = UILabel(frame: CGRect(x: 10, y: title1.maxY + 8, width: bottomView.width-20, height: 40))
        title2.numberOfLines = 0
        title2.attributedText = NSMutableAttributedString(string: kLocalized("theyWillBeDownloadedTogether"), attributes: attDict)
        bottomView.addSubview(title2)
        
    
        let title3 = UILabel(frame: CGRect(x: 10, y: title2.maxY , width: bottomView.width-20, height: 40))
        title3.numberOfLines = 2
        title3.attributedText = NSMutableAttributedString(string: kLocalized("pleaseFeelFreeToSubscribe"), attributes: attDict)
        bottomView.addSubview(title3)
        
//        let title4 = UILabel(frame: CGRect(x: 10, y: title3.maxY , width: bottomView.width-20, height: 40))
//        title4.numberOfLines = 2
//        title4.attributedText = NSMutableAttributedString(string: kLocalized("discountRules3"), attributes: attDict)
//        bottomView.addSubview(title4)
        
        
    }
    @objc func sureBtnClick(_ button:UIButton) {
        guard let currentButton = currentButton else { return }
        if itmeModes.count > 0 {
            subScribeCount!(itmeModes[currentButton.tag - 100].count.integerValue())
            return
        }
        switch currentButton.tag - 100 {
        case 0:
            subScribeCount!(10)
            break
        case 1:
            subScribeCount!(50)
            
            break
        case 2:
            subScribeCount!(100)
            break
        default:
            break
        }
    }
    
    @objc func btnClick(_ button:UIButton) {
        
        setBorder(currentButton, isSelected: false)
        setBorder(button, isSelected: true)
        
        currentButton = button
        if itmeModes.count > 0 {
            getBatchInfo(itmeModes[currentButton!.tag - 100].count.integerValue(), block: nil)
            return
        }
        
        
    }
    func setBorder(_ view:UIView?, isSelected:Bool = false)  {
        if isSelected {
            view?.layer.borderColor = selOrangeColor.cgColor
            view?.layer.borderWidth = 1.0
           
            if let btn = view as? UIButton, let item = itmeModes.xm_index(of: btn.tag - 100) {
                reloadBtn(btn: btn, item: item, textColor: selOrangeColor)
            }
        }else{
            view?.layer.borderColor = defaultGrayColor.cgColor
            view?.layer.borderWidth =  0.5
            if let btn = view as? UIButton, let item = itmeModes.xm_index(of: btn.tag - 100) {
                reloadBtn(btn: btn, item: item, textColor: defaultGrayColor)
            }
        }
        
    }
    
    @objc func TapAction() {
        //        tapDismissAction?()
    }
    
    override func addsubScribe_SuccessView(_ end_Chaper_Name:String ,coin:String) {
        if finishView == nil{
            finishView = UIView(frame: bounds)
            finishView?.backgroundColor = bgColor
            bgView?.addSubview(finishView!)
            
            finishView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            finishView?.alpha = 0;
            UIView.animate(withDuration: 0.3, animations: {
                self.finishView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.finishView?.alpha = 1
            })
        }
        
        let space: CGFloat = 25
        
        let actionBtn = createButton(CGRect(x: (width-210)/2, y: height-40-30, width: 210, height: 40),
                                     normalTitle: kLocalized("confirm"),
                                     normalTilteColor: UIColor.white,
                                     bacColor: selOrangeColor,
                                     font: systemFont(15),
                                     target: self,
                                     action:  #selector(GDUserSubscribeChpaterView.sureDismiss))
        actionBtn.layer.cornerRadius = 20
        actionBtn.layer.masksToBounds = true
        finishView?.addSubview(actionBtn)

        let sucIcon = UIImageView(frame: CGRect(x: (width-60)/2, y: (actionBtn.y-60)/2, width: 60, height: 60))
        sucIcon.image = UIImage.init(named: "reader_successicon")
        finishView?.addSubview(sucIcon)
        //已订阅至
        let endChaperLabel = createLabel(CGRect (x: space, y: sucIcon.maxY+10, width: self.width-2*space, height: 20),
                                         font: UIFont.systemFont(ofSize: 13),
                                         bacColor: nil,
                                         textColor: defaultGrayColor,
                                         adjustsFontSizeToFitWidth: nil,
                                         textAlignment: .center,
                                         numberOfLines: 1)
        endChaperLabel.text =  kLocalized("SubscribedTo")
        endChaperLabel.textColor = UIColor.black
        finishView?.addSubview(endChaperLabel)
        
        
    }
    
    @objc func sureDismiss() {
        subScribeCount!(10000)//10000的时候就是消失的指令
    }
    
    override func dismissFinishView() {
        if self.finishView != nil {
            self.finishView?.removeFromSuperview()
            self.finishView = nil
        }
    }
    
    
    override class func getHeight() -> CGFloat {
        return 490
    }
    
    
    
    
    func getBatch_list() {
        MQILoadManager.shared.addProgressHUD("")
        MQIGetBatchListRequest()
            .request({[weak self] (re, rep, model:MQIMembershipCardDataModel) in
                MQILoadManager.shared.dismissProgressHUD()
                self?.itmeModes = model.data
                self?.reloadBtn(model: model)
                if (self?.currentButton?.tag ?? 100) - 100 < model.data.count {
                    self?.getBatchInfo(model.data[(self?.currentButton?.tag ?? 100) - 100].count.integerValue(), block: {
                        self?.setTextWithModels(itmes: model.data)
                    })
                }else{
                    self?.setTextWithModels(itmes: model.data)
                }
            }) {[weak self] (code, msg) in
                MQILoadManager.shared.dismissProgressHUD()
                self?.setTextWithModels(itmes: nil)
        }
        
    }
    
    func reloadBtn(model: MQIMembershipCardDataModel, textColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)) {
        for (index, item) in model.data.enumerated() {
            guard let btn = buttons.xm_index(of: index) else { continue }
            reloadBtn(btn: btn, item: item, textColor: btn == currentButton ? selOrangeColor: defaultGrayColor)
        }
    }
    func reloadBtn(btn: UIButton, item: MQIMembershipCardItemModel, textColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)) {
        let isDiscount = !item.discount_desc.isEmpty
        let chapter = NSMutableAttributedString(string: kLongLocalized("Chapter_After", replace: item.count), attributes:
            [.font : UIFont.systemFont(ofSize: 12),
             .foregroundColor : textColor,
             .backgroundColor : UIColor.clear])
        let discount = NSMutableAttributedString(string: "\n\(item.discount_desc)", attributes:
            [.font : UIFont.systemFont(ofSize: 10),
             .foregroundColor : #colorLiteral(red: 0.9215686275, green: 0.3333333333, blue: 0.4039215686, alpha: 1),
             .backgroundColor : UIColor.clear])
        if isDiscount {
            chapter.append(discount)
        }
        btn.setAttributedTitle(chapter, for: .normal)
    }
    
    
    
    
    func getBatchInfo(_ count: Int ,block:(()->())?) {
        if !MQIUserManager.shared.checkIsLogin() {
            MQILoadManager.shared.dismissProgressHUD()
            return
        }
        guard let chapter = chapter else {
            MQILoadManager.shared.dismissProgressHUD()
            return
        }
        MQILoadManager.shared.addProgressHUD("")
        guard let resultIds =   readMenu?.vc.readOperation.getFixedChapterIds(count, book: book, start_chapter_id: chapter.chapter_id) else {
//            self.title1.isHidden = true
            MQILoadManager.shared.dismissProgressHUD()
            return
        }
        
        if resultIds.0 != nil {
            MQISubscribeBatchInfoRequest(book_id: book.book_id, chapter_ids: resultIds.0!)
                .request({[weak self] (re, rep, model:MQIMembershipCardItemModel) in
                    MQILoadManager.shared.dismissProgressHUD()
                    block?()
                    self?.reloadViewData(model: model)
                }) {[weak self] (msg, code) in
                    block?()
                    MQILoadManager.shared.dismissProgressHUD()
            }
        }else{
            MQILoadManager.shared.dismissProgressHUD()
        }
    }
    
    
    func reloadViewData(model: MQIMembershipCardItemModel) {
        guard MQIUserManager.shared.checkIsLogin() else {
            detailedView.balanceLabel.text = "\(kLocalized("balance", describeStr: "余额"))： - "
            return
        }
        let coin = MQIUserManager.shared.user?.user_coin
        let premiumLabel = MQIUserManager.shared.user?.user_premium
        let balanceString = NSMutableAttributedString(string: "\(kLocalized("balance", describeStr: "余额"))：", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor : blackColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        balanceString.append(NSMutableAttributedString(string: "\(coin ?? "0")\(kLocalized("MoB", describeStr: "书币"))（\(premiumLabel ?? "0")\(kLocalized("MoD", describeStr: "书券"))）", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9137254902, green: 0.6745098039, blue: 0.2823529412, alpha: 1),
             NSAttributedString.Key.backgroundColor : UIColor.clear]))
        detailedView.balanceLabel.attributedText = balanceString
        
        
        guard let currentButton = currentButton else {
            detailedView.chapterLabel.text = " - "
            detailedView.price.text = "\(kLocalized("price", describeStr: "价格"))： - "
            return
        }
//        let item = itmeModes[currentButton.tag - 100]
        ///原价不等于真实价格就是有折扣
        let isDiscount = model.real_price != model.origin_price
        var first = chapter?.chapter_code.integerValue() ?? 0
        if first == 0 { first += 1 }
        let end = first + model.count.integerValue() - 1
        //        detailedView.alertLabel.text = isDiscount ? "您实际购买\(model.count)章，打\(item.discount)折" :
        //                                                    "您实际购买\(model.count)章"
        detailedView.chapterLabel.text = "\(model.start_chapter_title)- \(model.end_chapter_title)"
        
        ///价格
        let priceString = NSMutableAttributedString(string: "\(kLocalized("price", describeStr: "价格"))：", attributes:
            [.font : UIFont.systemFont(ofSize: 14),
             .foregroundColor : blackColor,
             .backgroundColor : UIColor.clear])
        let discountPrice = NSMutableAttributedString(string: "\(model.origin_price)\(kLocalized("MoD", describeStr: "书券"))", attributes:
            [.font : UIFont.systemFont(ofSize: 15),
             .foregroundColor : blackColor,
             .backgroundColor : UIColor.clear,
             .strikethroughStyle : 1])
        let nodiscountPrice = NSMutableAttributedString(string: "\(model.origin_price)\(kLocalized("MoD", describeStr: "书券"))", attributes:
            [.font : UIFont.systemFont(ofSize: 15),
             .foregroundColor : blackColor,
             .backgroundColor : UIColor.clear])
        let real_price = NSMutableAttributedString(string: "\n           \(model.real_price)\(kLocalized("MoD", describeStr: "书券"))", attributes:
            [.font : UIFont.systemFont(ofSize: 15),
             .foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
             .backgroundColor : UIColor.clear])
        
        let discount_card = NSMutableAttributedString(string: "（\(kLocalized("usedDiscountCard", describeStr: "已使用打折卡"))）", attributes:
            [.font : UIFont.systemFont(ofSize: 15),
             .foregroundColor : #colorLiteral(red: 0.9137254902, green: 0.3411764706, blue: 0.4039215686, alpha: 1),
             .backgroundColor : UIColor.clear])
        if isDiscount {
            priceString.append(discountPrice)
            priceString.append(real_price)
            let is_vip = MQIUserDiscountCardInfo.default?.isVip ?? false
            if is_vip {
                if MQIPayTypeManager.shared.isAvailable() {
                     priceString.append(discount_card)
                }
            }
        } else {
            priceString.append(nodiscountPrice)
        }
        detailedView.price.attributedText = priceString
    }
    
    
    
    func setTextWithModels(itmes:[MQIMembershipCardItemModel]?)  {
        guard let models = itmes  else {
            var currentIndex = 0
            if let row = readMenu?.vc.readModel?.readRecordModel?.chapterIndex {
                if let chapterListOld   = GYBookManager.shared.getChapterListFromLocation(book){
                    currentIndex = chapterListOld.count-row.intValue+1
                }
            }
            
            let btnCounts = [10,500,100,10]
            
            for btn in buttons {
                let tag = btn.tag - 100
                let showCount = btnCounts[tag]
                
                let  isClick = (showCount <=  currentIndex) ? true:false
                if isClick  {
                    btn.isUserInteractionEnabled = true
                    btn.setTitleColor(UIColor.colorWithHexString("000000"), for: .normal)
                }else{
                    if tag == 0 {currentButton = nil }
                    btn.isUserInteractionEnabled = false
                    btn.isSelected = false
                    setBorder(btn, isSelected: false)
                    btn.setTitleColor(UIColor.colorWithHexString("999999"), for: .normal)
                }
                
                if titles[tag] != " " {
                    btn.isHidden = false
                    btn.setAttributedTitle(nil, for: .normal)
                    btn.setTitle(titles[tag], for: .normal)
                }else {
                    btn.isHidden = true
                }
            }
            maskDetailedViewView.isHidden = buttons.filter { return $0.isUserInteractionEnabled }.count > 1
            
            return
        }
        
        
        var currentIndex = 0
        if let row = readMenu?.vc.readModel?.readRecordModel?.chapterIndex {
            if let chapterListOld   = GYBookManager.shared.getChapterListFromLocation(book){
                currentIndex = chapterListOld.count-row.intValue+1
            }
        }
        for btn in buttons {
            let tag = btn.tag - 100
            if tag < models.count {
                btn.isHidden = false
                let showCount =  models[tag].count.integerValue()
                
                let  isClick = (showCount <  currentIndex) ? true:false
                if isClick  {
                    btn.isUserInteractionEnabled = true
                }else{
                    if tag == 0 {currentButton = nil }
                    btn.isUserInteractionEnabled = false
                    btn.isSelected = false
                    setBorder(btn, isSelected: false)
                }
                
            }else {
                btn.isHidden = true
            }
        }
        let isHidden = buttons.filter { return $0.isUserInteractionEnabled }.count > 1
        maskDetailedViewView.isHidden = isHidden
        
        
    }
    
    
    func getButtonAtts(_ text1:String , text2:String ) ->NSAttributedString  {
        let font = systemFont(14)
        let att1 = NSMutableAttributedString.init(string: text1+"", attributes: [.font : font,.foregroundColor:UIColor.colorWithHexString("000000")])
        let att2 = NSAttributedString.init(string: text2+"  ", attributes: [.font : font,.foregroundColor:UIColor.colorWithHexString("E45101")])
        att1.append(att2)
        return att1
    }
    
    func getPriceAtts(_ text1:String , text2:String ,text3:String ) ->NSAttributedString {
        
        let font = UIFont.systemFont(ofSize: 12)
        let att1 = NSMutableAttributedString.init(string: text1, attributes: [.font : font,.foregroundColor:UIColor.colorWithHexString("323333")])
        let att2 = NSAttributedString.init(string: text2+"  ", attributes: [.font : font,.foregroundColor:UIColor.colorWithHexString("E45101")])
        let att3 = NSAttributedString.init(string: text3, attributes: [.font : font,.foregroundColor:UIColor.colorWithHexString("BDBDBD"),.strikethroughStyle:1])
        att1.append(att2)
        att1.append(att3)
        return att1
    }
    
    
}
extension GDUserSubscribeChpaterView {
    
    fileprivate class ContentView: UIView {
        open var book: MQIEachBook!
        
        
        
        var price: UILabel!
        var chapterLabel: UILabel!
        var balanceLabel: UILabel!
//        var totalLabel: UILabel!
//        var alertLabel: UILabel!
        init(frame: CGRect, book: MQIEachBook) {
            super.init(frame: frame)
            self.book = book
            configUI()
        }
        
        required init?(coder aDecoder:  NSCoder) {
            super.init(coder: aDecoder)
            configUI()
        }
        
        func configUI() {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "bulkSubscriptionBG"))
            imageView.frame = bounds
            addSubview(imageView)
//            alertLabel = createLabel(CGRect (x: 20, y: 21, width: screenWidth - 30, height: 20),
//                                         font: UIFont.systemFont(ofSize: 14),
//                                         bacColor: nil,
//                                         textColor: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
//                                         adjustsFontSizeToFitWidth: nil,
//                                         textAlignment: .left,
//                                         numberOfLines: 1)
//            addSubview(alertLabel)
            
            let chapterTitle = createLabel(CGRect (x: 20, y: 15, width: 43, height: 33.5),
                                font: UIFont.systemFont(ofSize: 14),
                                bacColor: nil,
                                textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
                                adjustsFontSizeToFitWidth: nil,
                                textAlignment: .left,
                                numberOfLines: 0)
            addSubview(chapterTitle)
            chapterTitle.text = "\(kLocalized("chapter", describeStr: "章节"))："
            let chapter = createLabel(CGRect (x: chapterTitle.maxX, y: 15, width: screenWidth - 128, height: 33.5),
                                      font: UIFont.systemFont(ofSize: 14),
                                      bacColor: nil,
                                      textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
                                      adjustsFontSizeToFitWidth: nil,
                                      textAlignment: .left,
                                      numberOfLines: 0)
            addSubview(chapter)
            chapterLabel = chapter
            chapter.text = " - "
//
//            let discountALert = createLabel(CGRect (x: 20, y: chapter.maxY + 5, width: screenWidth - 30, height: 21),
//                                            font: UIFont.systemFont(ofSize: 15),
//                                            bacColor: nil,
//                                            textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
//                                            adjustsFontSizeToFitWidth: nil,
//                                            textAlignment: .left,
//                                            numberOfLines: 1)
//            let discountString = NSMutableAttributedString(string: "已使用打折卡", attributes:
//                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                 NSAttributedString.Key.foregroundColor : blackColor,
//                 NSAttributedString.Key.backgroundColor : UIColor.clear])
//            discountString.append(NSMutableAttributedString(string: "（权限时间不足三天）", attributes:
//                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                 NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9490196078, green: 0.7490196078, blue: 0.3725490196, alpha: 1),
//                 NSAttributedString.Key.backgroundColor : UIColor.clear]))
//            discountALert.attributedText = discountString
//            addSubview(discountALert)
            
            price = createLabel(CGRect (x: 20, y: chapter.maxY + 10, width: screenWidth - 30, height: 44),
                                    font: UIFont.systemFont(ofSize: 15),
                                    bacColor: nil,
                                    textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
                                    adjustsFontSizeToFitWidth: nil,
                                    textAlignment: .left,
                                    numberOfLines: 2)
            addSubview(price)
            price.text = "\(kLocalized("price", describeStr: "价格"))： - "
            
            let balance = createLabel(CGRect (x: 20, y: price.maxY + 10, width: screenWidth - 30, height: 21),
                                      font: UIFont.systemFont(ofSize: 15),
                                      bacColor: nil,
                                      textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
                                      adjustsFontSizeToFitWidth: nil,
                                      textAlignment: .left,
                                      numberOfLines: 1)
            addSubview(balance)
            balanceLabel = balance
            balance.text = "\(kLocalized("balance", describeStr: "余额"))： - "
            
//            let total = createLabel(CGRect (x: 20, y: balance.maxY + 7, width: screenWidth - 30, height: 21),
//                                    font: UIFont.systemFont(ofSize: 15),
//                                    bacColor: nil,
//                                    textColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
//                                    adjustsFontSizeToFitWidth: nil,
//                                    textAlignment: .left,
//                                    numberOfLines: 1)
//            total.text = "需要支付： - "
//            addSubview(total)
//            totalLabel = total
        }
    }
    
}


class GDUserSubscribeBookView: MQIUserSubscribeView {
    
    fileprivate var titleLabel: UILabel!
    fileprivate var summaryLabel: UILabel!
    
    override func configUI() {
        self.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GDUserSubscribeBookView.TapAction), view: self)
        bgView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: self.height))
        bgView?.backgroundColor = bgColor
        self.addSubview(bgView!)
        
        let space: CGFloat = 25
        var originY: CGFloat = 25
        
        titleLabel = createLabel(CGRect (x: space, y: originY, width: width-2*space, height: 25),
                                 font: UIFont.systemFont(ofSize: 14),
                                 bacColor: nil,
                                 textColor: blackColor,
                                 adjustsFontSizeToFitWidth: nil,
                                 textAlignment: .left,
                                 numberOfLines: 1)
        bgView?.addSubview(titleLabel)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: kLocalized("CompleteTheSubscription"), attributes:
            [NSAttributedString.Key.font : titleLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : blackColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: "《\(book.book_name)》", attributes:
            [NSAttributedString.Key.font : titleLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : selOrangeColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        attStr.append(attStr2)
        titleLabel.attributedText = attStr
        
        originY = height-40-25
        let actionBtn = createButton(CGRect(x: (width-210)/2, y: height-40-25, width: 210, height: 40),
                                     normalTitle: kLocalized("CompleteTheSubscription"),
                                     normalTilteColor: UIColor.white,
                                     bacColor: selOrangeColor,
                                     font: systemFont(15),
                                     target: self,
                                     action:  #selector(GDUserSubscribeBookView.sureBtnClick(_:)))
        actionBtn.layer.cornerRadius = 20
        actionBtn.layer.masksToBounds = true
        bgView?.addSubview(actionBtn)
        
        originY = titleLabel.maxY+20
        summaryLabel = createLabel(CGRect (x: space, y: originY, width: width-2*space, height: actionBtn.y-originY-20),
                                   font: UIFont.systemFont(ofSize: 13),
                                   bacColor: nil,
                                   textColor: blackColor,
                                   adjustsFontSizeToFitWidth: nil,
                                   textAlignment: .left,
                                   numberOfLines: 0)
        summaryLabel.text = book.book_intro
        bgView?.addSubview(summaryLabel)
    }
    
    @objc func sureBtnClick(_ button:UIButton){
        subScribeCount?(-1)
    }
    
    @objc func TapAction() {
        
    }
    
    override func addsubScribe_SuccessView(_ end_Chaper_Name:String ,coin:String) {
        if finishView == nil{
            finishView = UIView(frame: bounds)
            finishView?.backgroundColor = bgColor
            bgView?.addSubview(finishView!)
            
            finishView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            finishView?.alpha = 0;
            UIView.animate(withDuration: 0.3, animations: {
                self.finishView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.finishView?.alpha = 1
            })
        }
        
        let space: CGFloat = 25
        
        let actionBtn = createButton(CGRect(x: (width-210)/2, y: height-40-20, width: 210, height: 40),
                                     normalTitle: kLocalized("confirm"),
                                     normalTilteColor: UIColor.white,
                                     bacColor: selOrangeColor,
                                     font: systemFont(15),
                                     target: self,
                                     action:  #selector(GDUserSubscribeBookView.sureDismiss))
        actionBtn.layer.cornerRadius = 20
        actionBtn.layer.masksToBounds = true
        finishView?.addSubview(actionBtn)
        
        let endChaperLabel = createLabel(CGRect (x: space, y: actionBtn.y-15-20, width: self.width-2*space, height: 20),
                                         font: UIFont.systemFont(ofSize: 13),
                                         bacColor: nil,
                                         textColor: defaultGrayColor,
                                         adjustsFontSizeToFitWidth: nil,
                                         textAlignment: .left,
                                         numberOfLines: 1)
        finishView?.addSubview(endChaperLabel)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: kLocalized("SubscribedBooks"), attributes:
            [NSAttributedString.Key.font : endChaperLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : defaultGrayColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        let attStr2 = NSMutableAttributedString(string: "《\(book.book_name)》", attributes:
            [NSAttributedString.Key.font : endChaperLabel.font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : selOrangeColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        attStr.append(attStr2)
        endChaperLabel.attributedText = attStr
        
        let sucIcon = UIImageView(frame: CGRect(x: 0, y: (endChaperLabel.y-60)/2, width: 60, height: 60))
        sucIcon.image = UIImage.init(named: "reader_successicon")
        finishView?.addSubview(sucIcon)
        sucIcon.center = CGPoint(x: self.width/2, y: 60)
    }
    
    @objc func sureDismiss() {
        subScribeCount!(10000)//10000的时候就是消失的指令
    }
    
    override func dismissFinishView() {
        if self.finishView != nil {
            self.finishView?.removeFromSuperview()
            self.finishView = nil
        }
    }
    
    override class func getHeight() -> CGFloat {
        return 200
    }
}
extension Array {
    
    func xm_index(of index: Int?) -> Element? {
        guard let index = index  else { return nil }
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    
}
