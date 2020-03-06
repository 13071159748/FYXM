//
//  GYCommentView.swift
//  Reader
//
//  Created by _CHK_  on 2017/6/9.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class GYCommentView: UIView, UITextViewDelegate {

    var textView: UITextView!
    var placeHolder: UILabel!
    var numLabel: UILabel!
    var doneBtn: UIButton!
    
    var titleFont = systemFont(14)
    var titleColor = RGBColor(153, g: 153, b: 153)

    let allNum: Int = 200
    
    var bookId: String = ""
    
    var completion: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.white
        
        let bacView = UIView(frame: CGRect.zero)
        bacView.backgroundColor = UIColor.clear
        bacView.layer.borderColor = mainColor.cgColor
        bacView.layer.borderWidth = 1.0
        bacView.layer.cornerRadius = 3
        self.addSubview(bacView)
        
        textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        textView.font = titleFont
        textView.text = ""
        bacView.addSubview(textView)
        
        placeHolder = createLabel(CGRect.zero,
                                  font: titleFont,
                                  bacColor: UIColor.clear,
                                  textColor: RGBColor(201, g: 201, b: 201),
                                  adjustsFontSizeToFitWidth: false,
                                  textAlignment: .left,
                                  numberOfLines: 0)
        placeHolder.text = "请输入评论内容"
        bacView.addSubview(placeHolder)
        
        numLabel = createLabel(CGRect.zero,
                                  font: systemFont(13),
                                  bacColor: UIColor.clear,
                                  textColor: RGBColor(201, g: 201, b: 201),
                                  adjustsFontSizeToFitWidth: false,
                                  textAlignment: .right,
                                  numberOfLines: 0)
        numLabel.text = "0/\(allNum)"
        bacView.addSubview(numLabel)
        
        let btnColor = RGBColor(51, g: 51, b: 51)
        doneBtn = createButton(CGRect.zero,
                               normalTitle: "发表",
                               normalImage: nil,
                               selectedTitle: nil,
                               selectedImage: nil,
                               normalTilteColor: btnColor,
                               selectedTitleColor: nil,
                               bacColor: UIColor.clear,
                               font: titleFont,
                               target: self,
                               action: #selector(GYCommentView.toComment))
        doneBtn.layer.borderColor = btnColor.cgColor
        doneBtn.layer.borderWidth = 1.0
        doneBtn.layer.cornerRadius = 3
        self.addSubview(doneBtn)
        
        let space: CGFloat = 10
        
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-space)
            make.bottom.equalTo(self.snp.bottom).offset(-space)
            make.height.equalTo(27)
            make.width.equalTo(50)
        }

        bacView.translatesAutoresizingMaskIntoConstraints = false
        bacView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(space)
            make.top.equalTo(self.snp.top).offset(space)
            make.right.equalTo(self.doneBtn.snp.right)
            make.bottom.equalTo(self.doneBtn.snp.top).offset(-space)
        }
        
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bacView.snp.left).offset(space)
            make.right.equalTo(bacView.snp.right).offset(-space)
            make.bottom.equalTo(bacView.snp.bottom)
            make.height.equalTo(20)
        }
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(bacView.snp.left)
            make.top.equalTo(bacView.snp.top)
            make.right.equalTo(bacView.snp.right)
            make.bottom.equalTo(numLabel.snp.top)
        }
        

        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.snp.makeConstraints { (make) in
            make.left.equalTo(self.textView.snp.left).offset(6)
            make.top.equalTo(self.textView.snp.top).offset(5)
            make.right.equalTo(self.textView.snp.right).offset(5)
            make.height.equalTo(21)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    //MARK:评论按钮
    @objc func toComment() {
        if textView.text.count < 6 {
            MQILoadManager.shared.makeToast("评论内容不得少于6个字")
            return
        }
        let donotWant = CharacterSet.init(charactersIn:" ")
        let keyword = textView.text.trimmingCharacters(in: donotWant)
        if keyword == "" {
            MQILoadManager.shared.makeToast("评论内容不得少于6个字")
            return
        }

        if MQIUserManager.shared.checkIsLogin() == false {
            textView.endEditing(true)
            MQIloginManager.shared.toLogin(nil, finish: {

                self.requestComment()
            })
        }else {
            requestComment()
        }
    }
    
    func requestComment() {
        MQILoadManager.shared.addProgressHUD("评论中")
        GYCommentRequest(book_id: bookId, comment_type: "1", chapter_id: "", comment_content: textView.text).request({[weak self] (request, resposne, result: MQIBaseModel) in
            MQILoadManager.shared.dismissProgressHUD()
            self?.numLabel.text = "\(0)/\(String(describing: self?.allNum))"
            MQILoadManager.shared.makeToast(kLocalized("pleaseWaitForAuthorReview"))
            self?.completion?()
        }) { (msg, code) in
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(msg)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let str = textView.text {
            if str.count+text.count > allNum {
//                MQILoadManager.shared.makeToast("抱歉，您已超出最大字数限制")
                MQILoadManager.shared.makeToast("\(kLocalized("SorryTheNumberOfCommentsInTheContentCannotExceed"))\(allNum)\(kLocalized("Word"))")

                return false
            }else {
                return true
            }
        }else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var show: Bool = false
        var num: Int = 0
        if let str = textView.text {
            show = str.count <= 0 ? false : true
            num = str.count
        }else {
            show = false
            num = 0
        }
        placeHolder.isHidden = show
        numLabel.text = "\(num)/\(allNum)"
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    class func getHeight() -> CGFloat {
//        return 235
        return 130
    }

}
