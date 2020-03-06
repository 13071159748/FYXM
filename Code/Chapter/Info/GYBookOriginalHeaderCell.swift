//
//  GYBookOriginalHeaderCell
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

let BookOriginalInfo_Timer = "BookOriginalInfo_Timer"

let GYBookOriginalHeaderCell_minHeight: CGFloat = 160
class GYBookOriginalHeaderCell: MQITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bytesLabel: UILabel!
    @IBOutlet weak var gradeView: UIView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookCover: GYBookOriginalHeaderBookView!
    @IBOutlet weak var chapterLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var bottomViewLine: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var bookTypeLabel: UILabel!
    var starView: GYStar!
    var infoView: GYBookOriginalHeaderInfo!
    
    var toList: (() -> ())?
    
    var gaussianBacBool: Bool = false {
        didSet {
            var color: UIColor!
            if gaussianBacBool == true {
                color = UIColor.white
            }else {
                color = UIColor.black
            }
            authorLabel.textColor = color
            typeLabel.textColor = color
            bytesLabel.textColor = color
            likesLabel.textColor = color
        }
    }
    
    var book: MQIEachBook? {
        didSet {
            if let book = book {
                authorLabel.text = book.author_name
                typeLabel.text = book.class_name+"丨"+book.subclass_name
                let bytes = String(format: "%.1f", NSString(string: book.book_words).floatValue/10000)
                bytesLabel.text = "\(bytes)\(kLocalized("TenRhousand"))"
                chapterLabel.text = kLocalized("UpdateTo")+" \(book.last_chapter_title)"
                infoView.text = book.book_intro
                if book.book_cover != "" {
                    bookCover.bookView.sd_setImage(with: URL(string: book.book_cover),
                                                   placeholderImage: bookPlaceHolderImage,
                                                   options: .allowInvalidSSLCertificates) { (image, error, type, url) in
                                                    if let _ = image {
                                                        self.bookCover.showShoadowView()
                                                    }
                    }
                }
                bookTypeLabel.text = book.book_status == "1" ? kLocalized("MQIloading") : kLocalized("finished")
                starView.currentScore = CGFloat(4+(book.vote_number.floatValue()-2000)/2000)
                likesLabel.text = "（\(book.vote_number)\(kLocalized("LikeIt"))）"
                
                layoutIfNeeded()
            }
        }
    }
    var newLabel:MQITimeLabel!//时间label
    private var finishFreeLabel:UILabel?
    private var secondsCountDown:Int = -1//倒计时
    var limit_freeTime = "0" {
        didSet{
            let date = NSDate()
            let nowTime = date.timeIntervalSince1970
            let nowTimeInterval = Int(nowTime)
            let secondsCount = Int(limit_freeTime)! - nowTimeInterval//剩余秒
            if secondsCount > 0 {
                secondsCountDown = secondsCount
                newLabel.addTimeText(getTime_Day(secondsCountDown), hours: getTime_hour(secondsCountDown), minutes: getTime_minute(secondsCountDown), seconds: getTime_second(secondsCountDown))
                newLabel.isHidden = false
                finishFreeLabel?.isHidden = true
            }else {
                newLabel.isHidden = true
                finishFreeLabel?.isHidden = true
                removeNSNotificationCenter()
            }
            
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        infoView = GYBookOriginalHeaderInfo(frame: CGRect.zero)
        contentView.addSubview(infoView)
        
        starView = GYStar(frame: CGRect(x: 0, y: 0, width: 90, height: 15))
        starView.isAnimation = true
        starView.rateStyle = .HalfStar
        starView.tag = 1
        starView.isUserInteractionEnabled = false
        starView.isUserInteractionEnabled = false
        
        bookTypeLabel = createLabel(CGRect.zero,
                                    font: UIFont.systemFont(ofSize: 12),
                                    bacColor: RGBColor(21, g: 160, b: 191),
                                    textColor: UIColor.white,
                                    adjustsFontSizeToFitWidth: false,
                                    textAlignment: .center,
                                    numberOfLines: 1)
        bookTypeLabel.layer.cornerRadius = 3
        bookTypeLabel.layer.masksToBounds = true
        contentView.addSubview(bookTypeLabel)
        //时间
        //        newLabel = TimeLabel.init(frame: CGRect (x: header_title!.maxX, y: 0, width: self.width-header_title!.maxX - 20, height: 16))
        newLabel = MQITimeLabel.init(frame: CGRect.zero)
        newLabel.backgroundColor = UIColor.clear
        contentView.addSubview(newLabel)
        newLabel.isHidden = true
        finishFreeLabel = UILabel(frame: CGRect.zero)
        finishFreeLabel?.text = kLocalized("FreeForALimitedTime")
        finishFreeLabel?.textColor = UIColor.colorWithHexString("#DD5048")
        finishFreeLabel?.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(finishFreeLabel!)
        finishFreeLabel?.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(bookCover.snp.bottom).offset(25)
            make.bottom.equalTo(bottomViewLine.snp.top).offset(-5)
        }
        
        starView.frame = gradeView.bounds
        let bookTypeLabelHeight: CGFloat =  18
        let width = getAutoRect(bytesLabel.text, font: bytesLabel.font, maxWidth: CGFloat(MAXFLOAT), maxHeight: 21).size.width
        let originX = bytesLabel.frame.minX+width+10
        let originY = bytesLabel.frame.minY+(bytesLabel.bounds.height-bookTypeLabelHeight)/2
        bookTypeLabel.frame = CGRect(x: originX, y: originY, width: 50, height: bookTypeLabelHeight)
        //时间
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(starView.snp.left)
            make.width.equalTo(self.width - 100)
            make.height.equalTo(16)
        }
        finishFreeLabel?.translatesAutoresizingMaskIntoConstraints = false
        finishFreeLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(starView.snp.left)
            make.width.equalTo(self.width - 100)
            make.height.equalTo(16)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomViewLine.backgroundColor = GYBookOriginalInfoVC_lineColor
        bottomView.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GYBookOriginalHeaderCell.bottomViewAction), view: bottomView)
        
        //        authorLabel.textColor = blackColor
        //        authorLabel.font = UIFont.systemFont(ofSize: 15)
        //        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.isHidden = true
        
        typeLabel.textColor = blackColor
        typeLabel.font = UIFont.systemFont(ofSize: 15)
        typeLabel.adjustsFontSizeToFitWidth = true
        
        bytesLabel.textColor = blackColor
        bytesLabel.font = UIFont.systemFont(ofSize: 15)
        bytesLabel.adjustsFontSizeToFitWidth = true
        
        chapterLabel.textColor = blackColor
        chapterLabel.font = UIFont.systemFont(ofSize: 13)
        chapterLabel.adjustsFontSizeToFitWidth = true
        
        likesLabel.textColor = blackColor
        likesLabel.font = UIFont.systemFont(ofSize: 15)
        
        listLabel.textColor = UIColor.black
        listLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        gradeView.addSubview(starView)
        
    }
    func registerNSNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(GYBookOriginalHeaderCell.countDownTimer), name: NSNotification.Name(rawValue: BookOriginalInfo_Timer), object: nil)
    }
    func removeNSNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(BookOriginalInfo_Timer), object: nil)
        
    }
    @objc fileprivate func countDownTimer() {
        secondsCountDown -= 1
        if secondsCountDown >= 0 {
            
            DispatchQueue.main.async {
                self.newLabel.addTimeText(self.getTime_Day(self.secondsCountDown), hours: self.getTime_hour(self.secondsCountDown), minutes: self.getTime_minute(self.secondsCountDown), seconds: self.getTime_second(self.secondsCountDown))
                
            }
            
            newLabel.isHidden = false
            finishFreeLabel?.isHidden = true
        }else {
            newLabel.isHidden = true
            finishFreeLabel?.isHidden = false
        }
    }
    @objc func bottomViewAction() {
        toList?()
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

let GYBookOriginalHeaderInfo_font = UIFont.systemFont(ofSize: 13.5)
let GYBookOriginalHeaderInfo_lineSpace: CGFloat = 5
let GYBookOriginalHeaderInfo_btnWidth: CGFloat = 100
class GYBookOriginalHeaderInfo: UIView {
    
    var fontHeight: CGFloat! {
        return GYBookOriginalHeaderInfo_font.lineHeight+2
    }
    
    var textColor: UIColor = UIColor.colorWithHexString("#23252C")
    
    var sparedBtn: UIButton!
    let btnHeight: CGFloat = 25
    
    let downImage = UIImage(named: "arrow_down")!
    let upImage = UIImage(named: "arrow_up")!
    var text: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var shortText: String! {
        return MQIEachBook.shortInfo(text)
    }
    
    var toSpared: ((_ spared: Bool) -> ())?
    var isSpared: Bool = false {
        didSet {
            if isSpared == true {
                sparedBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 63, bottom: 0, right: 2)
            }else {
                sparedBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 2)
            }
            sparedBtn.setTitle(isSpared == true ? kLocalized("Collapse") : kLocalized("ExpandAll"), for: .normal)
            sparedBtn.setImage(isSpared == true ? upImage : downImage, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.clear
        
        sparedBtn = UIButton(type: .custom)
        sparedBtn.setTitle("\(kLocalized("ExpandAll")) ", for: .normal)
        sparedBtn.contentHorizontalAlignment = .right
        sparedBtn.setTitleColor(RGBColor(155, g: 155, b: 155), for: .normal)
        sparedBtn.setImage(downImage, for: .normal)
        sparedBtn.addTarget(self, action: #selector(GYBookOriginalHeaderInfo.sparedBtnAction(_:)), for: .touchUpInside)
        sparedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sparedBtn.contentHorizontalAlignment = .center
        self.addSubview(sparedBtn)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let lineSpace = GYBookOriginalHeaderInfo_lineSpace
        let str = isSpared == true ? text : shortText
        let allLineCount = isSpared == true ? 1000 : 3
        if (str?.count)! <= 0 {
            return
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: str!, attributes:
            [NSAttributedString.Key.font : GYBookOriginalHeaderInfo_font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : textColor,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        let typeSetter = CTTypesetterCreateWithAttributedString(attStr)
        
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            UIGraphicsPushContext(context)
            
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -fontHeight)
            
            var originY = lineSpace
            var start: Int = 0
            var lineCount: Int = 0//几行
            while (start < str!.length && lineCount < allLineCount) {
                let width = Double(lineCount >= allLineCount-1 ? self.bounds.width-GYBookOriginalHeaderInfo_btnWidth-50 : self.bounds.width)
                let count = CTTypesetterSuggestLineBreak(typeSetter, start, width)
                let line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count))
                context.textPosition = CGPoint(x: 0, y: -originY)
                
                CTLineDraw(line, context)
                
                start += count
                originY += fontHeight+lineSpace
                lineCount += 1
            }
            
            UIGraphicsPopContext()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sparedBtn.frame = CGRect(x: self.bounds.width-GYBookOriginalHeaderInfo_btnWidth-10,
                                 y: self.bounds.height-btnHeight,
                                 width: GYBookOriginalHeaderInfo_btnWidth,
                                 height: btnHeight)
        sparedBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        sparedBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 2)
    }
    
    //MARK: --
    @objc func sparedBtnAction(_ btn: UIButton) {
        isSpared = !isSpared
        toSpared?(isSpared)
    }
    
    //MARK: --
    class func getHeight(_ text: String, isSpared: Bool) -> CGFloat {
        
        var str = ""
        if isSpared == true {
            str = text
        }else {
            str = text
            str = str.replacingOccurrences(of: "\n", with: "")
            str = str.replacingOccurrences(of: "　", with: "")
            str = str.replacingOccurrences(of: " ", with: "")
            str = str.replacingOccurrences(of: "\r", with: "")
        }
        
        if str.count <= 0 {
            return 0
        }
        
        let fontHeight = GYBookOriginalHeaderInfo_font.lineHeight+2
        let lineSpace = GYBookOriginalHeaderInfo_lineSpace
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: str, attributes:
            [NSAttributedString.Key.font : GYBookOriginalHeaderInfo_font,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : UIColor.black,
             NSAttributedString.Key.backgroundColor : UIColor.clear])
        let typeSetter = CTTypesetterCreateWithAttributedString(attStr)
        
        var originY = lineSpace
        var start: Int = 0
        var lineCount: Int = 0//几行
        let allLineCount = isSpared == true ? 1000 : 3
        while (start < str.length && lineCount < allLineCount) {
            let allWidth = screenWidth-20
            let width = Double(lineCount >= allLineCount-1 ? allWidth-GYBookOriginalHeaderInfo_btnWidth-50 : allWidth)
            let count = CTTypesetterSuggestLineBreak(typeSetter, start, width)
            
            start += count
            originY += fontHeight+lineSpace
            lineCount += 1
        }
        
        UIGraphicsPopContext()
        return isSpared == true ? originY+60 : originY+25
    }
}

class GYBookOriginalHeaderBookView: UIView {
    
    var bookView: UIImageView!
    var bookShadowView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.clear
        
        bookView = UIImageView(image: UIImage(named: "a.jpg"))
        self.addSubview(bookView)
        
        bookView.layer.shadowOpacity = 0.5
        bookView.layer.shadowColor = UIColor.black.cgColor
        bookView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bookView.layer.shadowRadius = 1
        
        let rotate = CATransform3DMakeRotation(CGFloat(Double.pi/7), 0, 1, 0)
        bookView.layer.transform = CATransform3DPerspect(rotate, center: CGPoint(x: 0, y: 0), disZ: -280)
        
        bookShadowView = UIImageView(image: UIImage(named: "bookInfoShadow"))
        bookShadowView.isHidden = true
        self.addSubview(bookShadowView)
    }
    
    func showShoadowView() {
        bookShadowView.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bookWidth = self.bounds.height*69/87
        bookView.frame = CGRect(x: 0, y: 0, width: bookWidth, height: self.bounds.height)
        bookShadowView.frame = CGRect(x: bookView.frame.maxX, y: -2, width: self.bounds.width-bookWidth, height: self.bounds.height+5)
    }
}
