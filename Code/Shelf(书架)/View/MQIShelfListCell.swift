//
//  GYShelfListCell.swift
//  Reader
//
//  Created by CQSC  on 16/7/15.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


protocol MQIShelfCellDelegate:NSObjectProtocol {
    func longPress(_ book: MQIEachBook)
    func cellEditSel(_ book: MQIEachBook)
//    func lastReader(_ book:MQIEachBook)
}

class MQIShelfListCell: MQICollectionViewCell {
    
    var icon: MQIBookImageView!
    var textLabel: UILabel!
//    @IBOutlet weak var authorLabel: UILabel!
    var progressLabel: UILabel!
//    @IBOutlet weak var isReaderLabel: UILabel!
    
    var updateImageView: UIImageView!
    var updateLabel: UILabel!
    
    var editBtn: UIButton!
    
    
    var indexPath: IndexPath!
    
    let textFont = UIFont.boldSystemFont(ofSize: 15)
    let textColor = RGBColor(51, g: 51, b: 51)
    let detextFont = UIFont.systemFont(ofSize: 13)
    let detextColor = RGBColor(93, g: 93, b: 93)
    
    var coverImage: MQIShadowImageView!
    var recordLabel: UILabel!
    var statusLabel: UILabel!
    
    var  maskImageView:UIView!
    var  editMaskBtn:UIButton!
    var isBtnSelected: Bool  = false {
        didSet(oldValue) {
            if isBtnSelected {
                editMaskBtn.isSelected = true
                editMaskBtn.tintColor = mainColor
            }else{
                editMaskBtn.isSelected = false
                editMaskBtn.tintColor = UIColor.white
            }
            
        }
    }
    var book: MQIEachBook! {
        didSet {
            textLabel.text = book.book_name

            if book.last_chapter_title.count > 0 {
                progressLabel.text = "\(kLocalized("UpdateTo"))\(book.last_chapter_title)"
            }else {
                progressLabel.text = ""
            }

           
            if let record = MQILastReaderManager.shared.getLastReader(book.book_id) {
                if let chapter = record.readChapterModel {
                    if chapter.chapter_title == "" {
                        recordLabel.text = "\(kLocalized("AlreadyRead"))：\(kLocalized("TheTirstChapt"))"
                    }else {
                        recordLabel.text = "\(kLocalized("AlreadyRead"))：\(chapter.chapter_title)"
                    }
                    
                }else {
                    recordLabel.text = kLocalized("UnRead")
                }
            }else {
                recordLabel.text = kLocalized("UnRead")
            }
            
            statusLabel.text = (book.book_status == "1") ? kLocalized("serial"):kLocalized("TheEnd")
        
        
            updateLabel.isHidden = (book.updateBook == 1) ? false:true
            updateImageView.isHidden = updateLabel.isHidden
            coverImage.imageView.sd_setImage(with: URL(string:book.book_cover), placeholderImage: bookPlaceHolderImage)
        
            
        }
    }
    
    weak var delegate: MQIShelfCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
        isEdit(false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        isEdit(false)
    }
    
    func configUI() {
        addLongPress(self, action: #selector(MQIShelfListCell.longPressAction(_:)), view: self)
        coverImage = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImage)
        addUpdateLable()
        maskImageView = UIView()
        maskImageView.layer.cornerRadius = 8
        maskImageView.clipsToBounds = true
        maskImageView.backgroundColor = kUIStyle.colorWithHexString("020B1C", alpha: 0.2)
        contentView.addSubview(maskImageView)
      
        editMaskBtn = UIButton()
        let image  = UIImage(named: "CHK_shelf_edit_sel_image")?.withRenderingMode(.alwaysTemplate)
        editMaskBtn.setImage(image, for: .normal)
        editMaskBtn.tintColor = UIColor.white
        contentView.addSubview(editMaskBtn)
        editMaskBtn.isUserInteractionEnabled = false
        
        textLabel = UILabel(frame: CGRect.zero)
        textLabel.textColor = UIColor.colorWithHexString("#425154")
        textLabel.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(textLabel!)
        
        
        progressLabel = UILabel(frame: CGRect.zero)
        progressLabel.textColor = UIColor.colorWithHexString("#868989")
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(progressLabel)
        
        
        recordLabel = UILabel(frame: CGRect.zero)
        recordLabel.textColor = UIColor.colorWithHexString("7187FF")
        recordLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(recordLabel)
        
        statusLabel = UILabel(frame: CGRect.zero)
        statusLabel.textColor = UIColor.colorWithHexString("#868989")
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(statusLabel)
        
//        if let updateImageView = updateImageView, let updateLabel = updateLabel {
////            updateImageView.frame = CGRect(x: 0.5, y: 0.5, width: 15, height: 15*124/58)
////            updateLabel.frame = updateImageView.bounds
//
//        }
        
    }
    
    func isEdit(_ edit:Bool)  {
        maskImageView.isHidden = !edit
        editMaskBtn.isHidden = !edit
    }
    
    
    
    func addUpdateLable() {
        if updateImageView == nil {
//            updateImageView = UIImageView(image: UIImage(named: "shelf_update1"))
            updateImageView = UIImageView()
            coverImage.addSubview(updateImageView!)
        }
        
        if updateLabel == nil {
            updateLabel = createLabel(CGRect.zero,
                                      font: systemFont(9),
                                      bacColor: UIColor.clear,
                                      textColor: UIColor.white,
                                      adjustsFontSizeToFitWidth: true,
                                      textAlignment: .center,
                                      numberOfLines: 2)
            updateLabel!.text = kLocalized("update")
            updateLabel.backgroundColor = mainColor
            updateImageView!.addSubview(updateLabel!)
        }
        updateImageView.snp.makeConstraints { (make) in
            make.right.equalTo(coverImage)
            make.top.equalTo(coverImage)
            make.width.equalTo(kUIStyle.scale1PXW(25))
            make.height.equalTo(15)
        }
        updateLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = 120*gdscale
        coverImage.frame = CGRect(x: 15, y: 0, width: h*0.75 ,height:h )
        maskImageView.frame =  coverImage.frame
        editMaskBtn.frame = CGRect(x: maskImageView.maxX-10-18, y: maskImageView.y+10, width: 18, height: 18)
        
        textLabel.frame = CGRect(x: coverImage.maxX+10, y: coverImage.y+10, width: self.width-coverImage.maxX-20, height: 22)
        
        progressLabel.frame = CGRect(x: textLabel.x, y: textLabel.maxY+8, width: textLabel.width, height: 20)
        
        recordLabel.frame = CGRect(x: textLabel.x, y: progressLabel.maxY+3, width: textLabel.width, height: 20)
        
        statusLabel.frame = CGRect(x: textLabel.x, y: recordLabel.maxY+6, width: textLabel.width, height: 20)
        
        
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 140*gdscale)
    }
    
    @IBAction func editBtnAction(_ sender: AnyObject) {
        editBtn.isSelected = !editBtn.isSelected
        delegate?.cellEditSel(book)
    }
    
    
    @objc func longPressAction(_ t: UILongPressGestureRecognizer) {
        if t.state == .began {
            delegate?.longPress(book)
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editBtn.setImage(shelfEditSelImage, for: .selected)
        
        //        textLabel.textColor = textColor
        //        textLabel.font = textFont
        
        
        //        authorLabel?.layer.cornerRadius = 2
        //        authorLabel?.clipsToBounds = true
        //        authorLabel?.layer.borderWidth = 1
        //        authorLabel?.textColor = UIColor.colorWithHexString("#4dafd6")
        //        authorLabel?.layer.borderColor = UIColor.colorWithHexString("#4dafd6").cgColor
        //        authorLabel?.font = UIFont.systemFont(ofSize: 12)
        //        authorLabel?.text = "连载"
        //        authorLabel?.textAlignment = .center
        
        //        progressLabel.textColor = detextColor
        //        progressLabel.font = detextFont
        
        //        isReaderLabel.textColor = detextColor
        //        isReaderLabel.font = detextFont
        
        updateLabel.font = UIFont.systemFont(ofSize: 12)
        updateLabel.adjustsFontSizeToFitWidth = true
    }
}
