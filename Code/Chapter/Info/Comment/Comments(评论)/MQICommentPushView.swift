//
//  MQICommentPushView.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/6.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit

//评论view
class MQICommentPushView: UIView,UITextViewDelegate {
    
    var comment_type:Comment_Type = .comment_book
    var bookid:String! = ""
    var chapterid:String! = ""
    fileprivate let placeHolderTxt = "  \(kLocalized("WriteDownYourThoughts"))"
    fileprivate let allNum: Int = 500
    fileprivate var numberLabel:UILabel!
    var commentPushFinishBlock:(()->())?
    var commentClose:(()->())?
    
    fileprivate var backView:UIView!
    fileprivate var textView:UITextView!
    private var isTvEdit:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNotifi()
        addTGR(self, action: #selector(MQICommentPushView.commentendEdit), view: self)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addNotifi() {
        NotificationCenter.default.addObserver(self, selector: #selector(MQICommentPushView.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MQICommentPushView.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    deinit {
        if textView != nil {
            textView.delegate = nil
            textView.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
extension MQICommentPushView {
    
    @objc func backViewTouche() {
        
    }
    func createUI() {
        
        backView = UIView(frame: CGRect (x: 0, y: self.height, width: screenWidth, height: 260))
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        addTGR(self, action: #selector(MQICommentPushView.backViewTouche), view: backView)
        
        let backTextView = UIView(frame: CGRect (x: 15.5, y: 45, width: screenWidth - 31, height: 200))
        backTextView.layer.borderWidth = 1
        backTextView.layer.borderColor = UIColor.colorWithHexString("#CACACA").cgColor
        backTextView.layer.cornerRadius = 5
        backTextView.clipsToBounds = true
        backView.addSubview(backTextView)
        
        textView = UITextView(frame: CGRect (x: 0, y: 0, width: backTextView.width, height: 185))
        textView.text = placeHolderTxt
        textView.textColor = UIColor.colorWithHexString("#cacaca")
        textView.delegate = self
        backTextView.addSubview(textView)
        
        
        numberLabel = UILabel(frame: CGRect (x: 0, y: textView.maxY, width: backTextView.width - 10, height: 15))
        numberLabel.textAlignment = .right
        numberLabel.font = UIFont.systemFont(ofSize: 10)
        numberLabel.textColor = UIColor.colorWithHexString("#CACACA")
        numberLabel.text = "\(0)/\(allNum)"
        backTextView.addSubview(numberLabel)
        
        let close = UIButton (frame: CGRect (x: 0, y: 0, width: 44, height: 44))
        //        close.setImage(UIImage.init(named: "reader_commentEdit_close"), for: .normal)
        close.addTarget(self, action: #selector(MQICommentPushView.closeBtnClick(_:)), for: .touchUpInside)
        let closeimage = UIImage(named: "reader_commentEdit_close")?.withRenderingMode(.alwaysTemplate)
        close.setImage(closeimage, for: .normal)
        close.tintColor = UIColor.black
        
        close.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        backView.addSubview(close)
        
        let push = UIButton(frame: CGRect (x: screenWidth - 60, y: 0, width: 60, height: 44))
        push.setTitle("发布", for: .normal)
        push.setTitleColor(mainColor, for: .normal)
        backView.addSubview(push)
        push.addTarget(self, action: #selector(MQICommentPushView.pushBtnClick(_:)), for: .touchUpInside)
        push.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        UIView.animate(withDuration: 0.2) {[weak self]()->Void in
            if let weakSelf = self{
                weakSelf.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0.5)
                
                weakSelf.backView.frame = CGRect (x: 0, y:weakSelf.height - weakSelf.backView.height - x_TabbatSafeBottomMargin, width: screenWidth, height: weakSelf.backView.height)
            }
        }
        
    }
    @objc func commentendEdit() {
        if isTvEdit {
            textView.endEditing(true)
        }else {
            dismissCommentView {[weak self]()->Void in
                if let weakSelf = self{
                    weakSelf.commentClose?()
                }
            }
        }
        
    }
    @objc func closeBtnClick(_ sender:UIButton) {
        
        dismissCommentView {[weak self]()->Void in
            if let weakSelf = self{
                weakSelf.commentClose?()
            }
        }
        
    }
    func dismissCommentView(_ completion:@escaping (()->())) {
        UIView.animate(withDuration: 0.2, animations: { [weak self]()->Void in
            if let weakSelf = self{
                weakSelf.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0)
                weakSelf.backView.frame = CGRect (x: 0, y:weakSelf.height, width: screenWidth, height: weakSelf.backView.height)
            }
        }) { (finish) in
            completion()
        }
    }
    
    @objc func pushBtnClick(_ sender:UIButton) {
        publish()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        isTvEdit = false
        if textView.text.length < 1 {
            textView.text = placeHolderTxt
            textView.textColor = UIColor.colorWithHexString("#cacaca")
            numberLabel.text = "\(0)/\(allNum)"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isTvEdit = true
        if textView.text == placeHolderTxt {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        var num: Int = 0
        if let str = textView.text {
            num = str.count
        }else {
            num = 0
        }
        numberLabel.text = "\(num)/\(allNum)"
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let str = textView.text {
            if str.count+text.count > allNum {
                MQILoadManager.shared.makeToast("\(kLocalized("SorryTheNumberOfCommentsInTheContentCannotExceed"))\(allNum)\(kLocalized("Word"))")
                return false
            }else {
                if text == "\n" {
                    publish()
                    return true
                }
                return true
            }
        }else {
            return true
        }
    }
    
    func publish() {
        if textView.text == placeHolderTxt {
            MQILoadManager.shared.makeToast("请输入评论内容")
            return
        }
        if textView.text.length < 6 {
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
            MQIloginManager.shared.toLogin(nil, finish: {[weak self]()->Void in
                if let weakSelf = self {
                    weakSelf.pushComments()
                }
                
            })
        }else {
            pushComments()
        }
        //发布
    }
    
    func pushComments() {
        
        MQILoadManager.shared.addProgressHUD("评论中")
        
        GYCommentRequest(book_id: bookid, comment_type: "\(comment_type.rawValue)", chapter_id: chapterid, comment_content: textView.text).request({ [weak self](request, response, result:MQIBaseModel) in
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(kLocalized("pleaseWaitForAuthorReview"))
            
            if let weakSelf = self{
                weakSelf.numberLabel.text = "\(0)/\(weakSelf.allNum)"
                //                weakSelf.commentPushFinishBlock?()
                weakSelf.dismissCommentView {[weak self]()->Void in
                    if let weakSelf = self{
                        weakSelf.commentPushFinishBlock?()
                    }
                }
            }
            
        }) { (errmsg, errcode) in
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(errmsg)
        }
        
    }
}
extension MQICommentPushView {
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let _ = textView {
            let userInfo = noti.userInfo
            let frameNew = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = frameNew.size.height
            UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.backView.frame.origin.y = strongSelf.height-strongSelf.backView.height-keyboardHeight
                }
                }, completion: { (suc) in
                    
            })
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        if let _ = textView {
            UIView.animate(withDuration: 0.25, animations: {[weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.backView.frame.origin.y = strongSelf.height-strongSelf.backView.height-x_TabbatSafeBottomMargin
                }
                }, completion: { (suc) in
                    
            })
        }
    }
}
