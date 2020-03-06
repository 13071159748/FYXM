//
//  AABookInfoLikesCell.swift
//  Reader
//
//  Created by CQSC  on 2017/11/4.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class AABookInfoLikesCell: MQITableViewCell {

    var books = [MQIEachBook]() {
        didSet{
            configUI(books)
        }
    }
    var likesClick:((_ bookid:String)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    func configUI(_ books:[MQIEachBook]){
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        let bookSize = GDBookInfoLikesEachBookView.infoBookSize()
        var rect_x:CGFloat = 21*gdscale
        var rect_y:CGFloat = 0
        for i in 0..<books.count {
            let eachBook = books[i]
            
            let likesBook = GDBookInfoLikesEachBookView(frame: CGRect (x: rect_x, y: rect_y, width: bookSize.width, height: bookSize.height))
            likesBook.tag = i
            addTGR(self, action: #selector(AABookInfoLikesCell.likesBtnClick(_:)), view: likesBook)
            likesBook.book_ImageView.sd_setImage(with: URL(string:eachBook.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            likesBook.booktitle = eachBook.book_name
            likesBook.book_readNum.text = eachBook.read_num + kLocalized("reading")
            contentView.addSubview(likesBook)
            
            if i%3 == 2,i>1{
                rect_x = 21*gdscale
                rect_y += bookSize.height
            }else {
                rect_x += bookSize.width + 23*gdscale
            }

        }
        
    }
    @objc func likesBtnClick(_ sender:AnyObject) {
        let tap = sender as! UITapGestureRecognizer
        if let tag = tap.view?.tag {
            if tag < books.count {
                likesClick?(books[tag].book_id)
            }
        }
    }
    class func infoLikesHeight(_ count:NSInteger)->CGFloat {
        let bookSize = GDBookInfoLikesEachBookView.infoBookSize()
        var rect_y:CGFloat = bookSize.height
        for i in 0..<count {
            if i%4 == 3,i>1{
                rect_y += bookSize.height
            }
        }
        return rect_y
    }
    
}
class GDBookInfoLikesEachBookView:UIView {
    
    var book_ImageView:UIImageView!
    fileprivate var book_Name:UILabel!
    var book_readNum:UILabel!
    
    var booktitle:String = ""{
        didSet{
            book_Name.text = booktitle
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createUI() {
        book_ImageView = UIImageView(frame: CGRect.zero)
        book_ImageView.image = UIImage.init(named: book_PlaceholderImg)
        book_ImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        book_ImageView.layer.shadowRadius = 2
        book_ImageView.layer.shadowOpacity = 0.5
        self.addSubview(book_ImageView)
        
        book_Name = UILabel(frame: CGRect.zero)
        book_Name.textColor = UIColor.colorWithHexString("#23252C")
        book_Name.font = UIFont.systemFont(ofSize: 12)
        book_Name.numberOfLines = 0
        self.addSubview(book_Name)
        
        book_readNum = UILabel(frame: CGRect.zero)
        book_readNum.font = UIFont.systemFont(ofSize: 10)
        book_readNum.textColor = UIColor.colorWithHexString("#999999")
        self.addSubview(book_readNum)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        book_ImageView.frame = CGRect(x: 0, y: 0, width: 96*gdscale, height: 129*gdscale)
        book_ImageView.layer.shadowPath = UIBezierPath(rect: book_ImageView.bounds).cgPath

        let newheight = getAutoRect(booktitle, font: book_Name.font, maxWidth: 96*gdscale, maxHeight: 100).size.height

        book_Name.frame = CGRect (x: 0, y: book_ImageView.maxY + 10, width: book_ImageView.width, height: newheight)
        
        book_readNum.frame = CGRect (x: 0, y: self.height - 17, width: book_ImageView.width, height: 10)
        
    }
    
//129 + 58
    class func infoBookSize() -> CGSize {
        return CGSize(width: 96*gdscale, height: 129*gdscale + 58)
    }
    
    
}
