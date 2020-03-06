//
//  MQIShelfHeaderView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIShelfHeaderView: UIView {
    fileprivate var shelfBtn :UIButton!
    fileprivate var iconImage:UIImageView!
    fileprivate var decorationImage:UIImageView!
    fileprivate var book_title:UILabel!
    fileprivate var recordLabel:UILabel!
    fileprivate var readerTimeLable:UILabel!
    
    fileprivate let noIcon = UIImage(named: "shelf_book_no_cover")
    var lastBook: MQIEachBook?{
        didSet(oldValue) {
            if lastBook == nil {
               normalDatas()
            }else{
                if let record = MQILastReaderManager.shared.getLastReader(lastBook!.book_id) {
                    shelfBtn.isHidden = true
                    decorationImage.isHidden = false
                    readerTimeLable.isHidden = !shelfBtn.isHidden
                    iconImage.sd_setImage(with: URL(string: lastBook!.book_cover), placeholderImage: bookPlaceHolderImage)
                    book_title.text  = lastBook!.book_name
                    
                    if let chapter = record.readChapterModel {
                        if chapter.chapter_title == "" {
                            recordLabel.text = "\(kLocalized("AlreadyRead"))：\(kLocalized("TheTirstChapt"))"
                     
                        }else {
                            recordLabel.text = "\(kLocalized("AlreadyRead"))：\(chapter.chapter_title)"
                        }
                        
                    }else {
                        recordLabel.text = kLocalized("UnRead")
                    }
                    readerTimeLable.text = MQILastReaderManager.shared.nowtimeDate(record.lastReadTime)
                }else {
                    normalDatas()
                }
               
            }
            
            
        }
    }
    var shelfBtnClick: ((_ btn:UIButton) -> ())?
    var to_bookBlick: ((_ book_id:String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupUI()
    }
    
    func normalDatas()  {
        shelfBtn.isHidden = false
        decorationImage.isHidden = true
        readerTimeLable.isHidden = !shelfBtn.isHidden
        iconImage.image = noIcon
        book_title.text = kLocalized("NoReadingHistory")
        recordLabel.text = kLocalized("BookCityIsAGoodBook")
        readerTimeLable.text = ""

    }
   
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//        if self.point(inside: point, with: event) {
//            if editorBtn.frame.origin.x - point.x < 30 ||  point.x > (editorBtn.frame.origin.x+editorBtn.bounds.width){
//
//                return editorBtn
//            }
//        }
//
//        return super.hitTest(point, with: event)
//    }
    
    func setupUI() {
        
        let  bacView = UIView(frame: CGRect(x: 0, y: kUIStyle.kNavBarHeight, width: screenWidth, height: self.height-kUIStyle.kNavBarHeight))
        addSubview(bacView)
        bacView.dsyAddTap(self, action: #selector(MQIShelfHeaderView.to_book))
        
        
        let w = kUIStyle.scale1PXW(87)
        iconImage = UIImageView(frame: CGRect(x: 20, y: 0, width: w, height: w*1.334))
        iconImage.contentMode = .scaleAspectFit
        bacView.addSubview(iconImage)
        iconImage.maxY = bacView.height - 16
        
        decorationImage = UIImageView(frame: CGRect(x: iconImage.maxX, y: iconImage.y, width: 15, height: iconImage.height ))
        decorationImage.image = UIImage(named: "shelf_book_no_cover_decoration")
        bacView.addSubview(decorationImage)
        
        
        let t_b_manger:CGFloat = 15
         book_title = UILabel(frame: CGRect(x: decorationImage.maxX+t_b_manger, y: iconImage.y+15, width: self.width-iconImage.maxX-t_b_manger-20, height: 10))
        book_title.font = kUIStyle.boldSystemFont1PXDesignSize(size: 16)
        book_title.textColor = kUIStyle.colorWithHexString("ffffff")
        book_title.textAlignment =  .left
        book_title.adjustsFontSizeToFitWidth = true
        bacView.addSubview(book_title)
        book_title.height = book_title.font.pointSize+5
        book_title.text = kLocalized("NoReadingHistory")
        
        recordLabel = UILabel(frame: CGRect(x: book_title.x, y:0, width:  book_title.width, height: 10))
        recordLabel.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        recordLabel.textColor = kUIStyle.colorWithHexString("ffffff")
        recordLabel.textAlignment =  .left
        recordLabel.adjustsFontSizeToFitWidth = true
        bacView.addSubview(recordLabel)
        recordLabel.height = recordLabel.font.pointSize+5
        recordLabel.centerY = iconImage.centerY
        recordLabel.text = kLocalized("BookCityIsAGoodBook")
        
    
         readerTimeLable = UILabel(frame: CGRect(x: book_title.x, y:0, width:  book_title.width, height: 10))
        readerTimeLable.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        readerTimeLable.textColor = kUIStyle.colorWithHexString("ffffff")
        readerTimeLable.textAlignment =  .left
        readerTimeLable.adjustsFontSizeToFitWidth = true
        bacView.addSubview(readerTimeLable)
        readerTimeLable.height = recordLabel.font.pointSize+5
        readerTimeLable.maxY = iconImage.maxY - t_b_manger
        readerTimeLable.text = ""
        
        
        shelfBtn = UIButton(frame:CGRect(x: readerTimeLable.x, y: readerTimeLable.y, width: 10, height: kUIStyle.scale1PXH(22)) )
        bacView.addSubview(shelfBtn)
        shelfBtn.addTarget(self, action: #selector(MQIShelfHeaderView.shelfBtnAction), for: .touchUpInside)
        shelfBtn.setTitle(kLocalized("GoToTheBookCity")+"->", for: .normal)
        shelfBtn.setTitleColor(kUIStyle.colorWithHexString("ffffff"), for: .normal)
        shelfBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        let  btn_lable = shelfBtn.titleLabel!
        shelfBtn.width =  btn_lable.font.pointSize*CGFloat(btn_lable.text!.count)
        shelfBtn.tag = 102
        shelfBtn.dsySetCorner(radius: 5)
        shelfBtn.dsySetBorderr(color: UIColor.white, width: 1)
        shelfBtn.isHidden = true
    }
    
    

    @objc func to_book(){
        if let book = lastBook{
          to_bookBlick?(book.book_id)
        }
    }
    
    @objc func shelfBtnAction(){
        shelfBtnClick?(shelfBtn)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


