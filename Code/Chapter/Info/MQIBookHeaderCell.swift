//
//  MQIBookHeaderCell.swift
//  Reader
//
//  Created by CQSC  on 2017/11/2.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

enum BookHeaderCellBtnType {
    case likeBtn
    case rewardBtn
    case sharedBtn
    case listBtn
    case commentBtn
}
class MQIBookHeaderCell: MQITableViewCell {

    var book: MQIEachBook? {
        didSet{
            if let book = book {
                titleLabel.text = book.book_name
                classLabel.text = book.subclass_name
                
                wordsNumberLabel.text = qiuZhengshu(book.book_words) + kLocalized("Word")
                
//                starView.currentScore = CGFloat(4+(book.vote_number.floatValue()-2000)/2000)
            
//                likesLabel.text = " |  " + qiuZhengshu(book.vote_number) + kLocalized("GiveLikePopel")//book.vote_number
                likesLabel.text  =  (book.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
               
                if !book.book_update.contains("-"){
                     updateLabel.text =
                        " | " + getNowtimeDate(book.book_update)+"更新"
                }
               
                bookImageView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
                infoView.text = book.book_intro
                
            }
        }
    }
    
    fileprivate var titleLabel:UILabel!
    fileprivate var classLabel:UILabel!
    fileprivate var wordsNumberLabel:UILabel!
    fileprivate var starView: GYStar!

    fileprivate var likesLabel:UILabel!
    fileprivate var bookImageView:UIImageView!
    var infoView: GYBookOriginalHeaderInfo!
    
    fileprivate var likesButton:UIButton!
    fileprivate var rewardButton:UIButton!
    fileprivate var sharedButton:UIButton!
    var headerBtnClick:((_ type:BookHeaderCellBtnType) -> ())?

//    var newLabel:TimeLabel!//时间label
    var timeLabel:UILabel!
    private var finishFreeLabel:UILabel!
    private var secondsCountDown:Int = -1//倒计时
    fileprivate var updateLabel:UILabel!
    
    
    var limit_freeTime = "0" {
        didSet{
            let date = NSDate()
            let nowTime = date.timeIntervalSince1970
            let nowTimeInterval = Int(nowTime)
            let secondsCount = Int(limit_freeTime)! - nowTimeInterval//剩余秒
            
            if secondsCount > 0 {
                secondsCountDown = secondsCount
                timeLabel.text = kLocalized("TimeFree") + getTime_Day(secondsCountDown) + kLocalized("Day") + getTime_hour(secondsCountDown) + ":" + getTime_minute(secondsCountDown) + ":" + getTime_second(secondsCountDown)
                 
                
                timeLabel.isHidden = false
                finishFreeLabel?.isHidden = true
            }else {
                timeLabel.isHidden = true
                finishFreeLabel?.isHidden = true
                removeNSNotificationCenter()
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func configUI() {
        
        
        titleLabel = UILabel (frame: CGRect.zero)
        titleLabel.textColor = UIColor.colorWithHexString("#23252C")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        
        classLabel = UILabel (frame: CGRect.zero)
        classLabel.textColor = UIColor.colorWithHexString("#7187FF")
        classLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(classLabel)
        
        wordsNumberLabel = UILabel(frame: CGRect.zero)
        wordsNumberLabel.textColor = UIColor.colorWithHexString("#9DA0A9")
        wordsNumberLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(wordsNumberLabel)
        
        starView = GYStar(frame: CGRect (x: 0, y: 0, width: 80, height: 10))
        starView.isAnimation = true
        starView.rateStyle = .HalfStar
        starView.tag = 1
        starView.isUserInteractionEnabled = false
        contentView.addSubview(starView)
        
        likesLabel = UILabel(frame: CGRect.zero)
        likesLabel.textColor = UIColor.colorWithHexString("#9DA0A9")
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(likesLabel)
        
        updateLabel = UILabel(frame: CGRect.zero)
        updateLabel.textColor = UIColor.colorWithHexString("#9DA0A9")
        updateLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(updateLabel)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.textColor = UIColor.colorWithHexString("#FFB452")
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(timeLabel)
        timeLabel.isHidden = true
        finishFreeLabel = UILabel(frame: CGRect.zero)
        finishFreeLabel.textColor = UIColor.colorWithHexString("FFB452")
        finishFreeLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(finishFreeLabel)
        finishFreeLabel.isHidden = true
        bookImageView = UIImageView(frame: CGRect.zero)
        bookImageView.image = bookPlaceHolderImage
//        bookImageView?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        bookImageView?.layer.shadowRadius = 2
//        bookImageView?.layer.shadowOpacity = 0.5
//        bookImageView.layer.cornerRadius = 2
//        bookImageView.clipsToBounds = true
        contentView.addSubview(bookImageView)
        
        likesButton = headerCustomButton(kLocalized("GiveLike"), image: "info_likes")
        
        rewardButton = headerCustomButton(kLocalized("Exception"), image: "info_reward")
        
        sharedButton = headerCustomButton(kLocalized("Share"), image: "info_shared")
        
        infoView = GYBookOriginalHeaderInfo(frame: CGRect.zero)
        contentView.addSubview(infoView)
     
//        if MQIPayTypeManager.shared.type == .inPurchase {
//            rewardButton.isHidden = true
//        }else {
//            rewardButton.isHidden = false
//        }
         rewardButton.isHidden = true
         sharedButton.isHidden = true
         likesButton.isHidden = true
         starView.isHidden = true
         timeLabel.isHidden = true
        
       
         setSubLayout()
    }
    
    
   func setSubLayout() {
    
        bookImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(21)
            make.left.equalTo(contentView).offset(21)
            make.width.equalTo(93*gdscale > 93 ? 93 : 93*gdscale)
            make.height.equalTo(123*gdscale > 123 ? 123 : 123*gdscale)
        }
    
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(bookImageView.snp.bottom).offset(20)
            make.bottom.equalTo(contentView).offset(-10)
        }
    
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookImageView.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-10)
            make.top.equalTo(bookImageView)
            make.height.equalTo(16)
        }

        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(bookImageView.snp.centerY).offset(-6)
        }
    

        wordsNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(bookImageView)
        }
    
        likesLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(bookImageView.snp.centerY).offset(6)
        }
    
        updateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likesLabel.snp.right)
            make.centerY.equalTo(likesLabel)
            make.right.lessThanOrEqualToSuperview().offset(-10)
        }
    
    
   
    
    
        
    }

    func headerCustomButton(_ title:String, image:String) -> UIButton{
        let button  = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
        button.setTitleColor(UIColor.colorWithHexString("#000000"), for: .highlighted)
        button.setImage(UIImage.init(named: image), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(MQIBookHeaderCell.headerButtonClick(_:)), for: .touchUpInside)
        button.layoutUpImage_BottomTitleButton(5)
        contentView.addSubview(button)
        return button
    }
    @objc func headerButtonClick(_ sender:UIButton) {
        if sender == likesButton {
            headerBtnClick?(.likeBtn)
        }else if sender == rewardButton{
            headerBtnClick?(.rewardBtn)
        }else if sender == sharedButton {
            headerBtnClick?(.sharedBtn)
        }
    }
    
    func registerNSNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(MQIBookHeaderCell.countDownTimer), name: NSNotification.Name(rawValue: BookOriginalInfo_Timer), object: nil)
    }
    func removeNSNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(BookOriginalInfo_Timer), object: nil)
        
    }
    @objc fileprivate func countDownTimer() {
        secondsCountDown -= 1
        if secondsCountDown >= 0 {
            
            DispatchQueue.main.async {
                self.timeLabel.text = kLocalized("TimeFree") + self.getTime_Day(self.secondsCountDown) + kLocalized("Day") + self.getTime_hour(self.secondsCountDown) + ":" + self.getTime_minute(self.secondsCountDown) + ":" + self.getTime_second(self.secondsCountDown)
            }
            
            timeLabel.isHidden = false
            finishFreeLabel?.isHidden = true
        }else {
            timeLabel.isHidden = true
            finishFreeLabel?.isHidden = false
        }
    }
    func getTime_Day(_ secondCount:Int) -> String{
        let days = NSString.gd_timeInterval_Days(withSeconds: secondCount)
        return days!
    }
    func getTime_hour(_ secondCount:Int) -> String{
        let hour = NSString.gd_timeInterval_Hours(withSeconds: secondCount)
        return hour!
    }
    func getTime_minute(_ secondCount:Int) -> String{
        let minute = NSString.gd_timeInterval_Minutes(withSeconds: secondCount)
        return minute!
    }
    func getTime_second(_ secondCount:Int) -> String{
        let seconds = NSString.gd_timeInterval_seconds(withSeconds: secondCount)
        return seconds!
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(BookOriginalInfo_Timer), object: nil)
    }
}
//MARK:标签按钮cell
class MQIBookTipsCell:MQITableViewCell{
    var book_Tips:String = "" {
        didSet{
            configUI()
        }
    }
    var tip_SelectedIndex:((_ text:String) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    func configUI() {
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        let tips_Array = book_Tips.components(separatedBy: ",")
        var btn_X = 16
        var btn_Y = 0
        for i in 0..<tips_Array.count {
            
            let tipBtn = UIButton (type: .custom)
            let tipTitle = tips_Array[i].replacingOccurrences(of: " ", with: "")
            
            let nickWidth = getAutoRect(tipTitle, font: UIFont.systemFont(ofSize: 12), maxWidth:CGFloat(MAXFLOAT), maxHeight: 13).size.width + 20
            
//            tipBtn.frame = CGRect (x: 16 + i*(btnWidth + 10), y: 0, width: Int(nickWidth), height: 23)
            tipBtn.frame = CGRect (x: btn_X, y: btn_Y, width: Int(nickWidth), height: 23)

            tipBtn.setTitle(tipTitle, for: .normal)
            tipBtn.setTitleColor(UIColor.colorWithHexString("#999999"), for: .normal)
            tipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            tipBtn.addTarget(self, action: #selector(MQIBookTipsCell.tipBtnClick(_:)), for: .touchUpInside)
            tipBtn.layer.cornerRadius = 3
            tipBtn.clipsToBounds = true
            tipBtn.layer.borderColor = UIColor.colorWithHexString("#CECECE").cgColor
            tipBtn.layer.borderWidth = 0.5
            contentView.addSubview(tipBtn)
            if screenWidth - tipBtn.maxX <= CGFloat(nickWidth + 10 + 16) {
                btn_X = 16
                btn_Y += 28
            }else {
                btn_X += Int(10 + nickWidth)
            }
        }
    }
    @objc func tipBtnClick(_ sender:UIButton) {
        let text = sender.titleLabel?.text
        tip_SelectedIndex?("\(String(describing: text))")
    }
//    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
//        return 33
//    }
    
    class func getTipsHeight(_ string:String) -> CGFloat{
        let tips_Array = string.components(separatedBy: ",")
        var btn_X = 16
        var btn_Y = 33
        for i in 0..<tips_Array.count {
            let tipTitle = tips_Array[i].replacingOccurrences(of: " ", with: "")
            
            let nickWidth = getAutoRect(tipTitle, font: UIFont.systemFont(ofSize: 12), maxWidth:CGFloat(MAXFLOAT), maxHeight: 13).size.width + 20
            if screenWidth - CGFloat(btn_X) - nickWidth <= CGFloat(nickWidth + 10 + 16) {
                btn_X = 16
                btn_Y += 28
            }else {
                btn_X += Int(10 + nickWidth)
            }
        }
        
        return CGFloat(btn_Y)
//        return 33
    }
    
}
class MQIBookListCell :MQITableViewCell {
    
    var book :MQIEachBook? {
        didSet{
            if let book = book {
            
            listTotalLabel.text = kLocalized("CheckDirectory") + book.book_chapters + kLocalized("Chapter")
            lastedLabel.text = book.last_chapter_title
            
            }
            
        }
    
    }
    fileprivate var listImg:UIImageView!
    fileprivate var listTotalLabel:UILabel!
    fileprivate var lastedLabel:UILabel!
    fileprivate var nextImg:UIImageView!
    fileprivate var lineView:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
        configUI()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configUI() {
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
//        contentView.addLine(16, lineColor: UIColor.colorWithHexString("#EDEDED"), directions: .top)
        lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("#EDEDED")
        contentView.addSubview(lineView)
        
        
        listImg = UIImageView(frame: CGRect.zero)
        listImg.image = UIImage.init(named: "info_list")
        contentView.addSubview(listImg)
        
        listTotalLabel = UILabel(frame: CGRect.zero)
        listTotalLabel.textColor = UIColor.colorWithHexString("#23252C")
        listTotalLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(listTotalLabel)
        
        lastedLabel = UILabel(frame: CGRect.zero)
        lastedLabel.textColor = UIColor.colorWithHexString("#23252C")
        lastedLabel.font = UIFont.systemFont(ofSize: 14)
        lastedLabel.textAlignment = .right
        contentView.addSubview(lastedLabel)
    
        nextImg = UIImageView(frame: CGRect.zero)
        nextImg.image = UIImage.init(named: "arrow_right")
        contentView.addSubview(nextImg)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 5)
        
        listImg.frame = CGRect (x: 16, y: 5+14.5, width: 18, height: 15.5)
        
        listTotalLabel.frame = CGRect (x: listImg.maxX + 14.5, y: 0, width: 130, height: contentView.height)
        listTotalLabel.centerY = listImg.centerY
        
        lastedLabel.frame = CGRect (x: contentView.width - (width - listTotalLabel.maxX - 30) - 35, y: 0, width: width - listTotalLabel.maxX - 30, height: height)
         lastedLabel.centerY = listImg.centerY
        
        nextImg.frame = CGRect (x: contentView.width - 30, y: 15, width: 12, height: 15)
        nextImg.centerY = listImg.centerY
    }

    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 50
    }
}

