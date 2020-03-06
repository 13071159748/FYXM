//
//  GYReadCommentEditView.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/3.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIReadCommentEditView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var placeHolder: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textBacView: UIView!
    weak var vc: MQIReadCommentEditViewController!
    
    let allNum: Int = 500
    
    public var book: MQIEachBook! {
        didSet {
            titleLabel.text = book.book_name
        }
    }
    
    public var chapter: MQIEachChapter! {
        didSet {
            chapterLabel.text = chapter.chapter_title
        }
    }
    
    var publishBlock: ((_ text: String) -> ())?
    var closeBlock: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addTGR(self, action: Selector("dimiss"), view: self)
        addTGR(self, action: #selector(MQIReadCommentEditView.dimiss), view: self)
        topView.backgroundColor = UIColor.init(white: 0, alpha: 0.65)
        
        textView.delegate = self
        textView.returnKeyType = .done
        
        placeHolder.text = kLocalized("WriteYouFeel")
        numLabel.text = "0/\(allNum)"
        
        titleLabel.textColor = blackColor
        chapterLabel.textColor = blackColor
        
        textBacView.layer.borderColor = RGBColor(202,g: 202,b: 202).cgColor
        textBacView.layer.borderWidth = 1.0
        
        placeHolder.textColor = RGBColor(153,g: 153,b: 153)
        numLabel.textColor = RGBColor(153,g: 153,b: 153)
        
        textView.textColor = RGBColor(131, g: 131, b: 131)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        vc.dismiss()
    }

    @IBAction func publishAction(_ sender: Any) {
        publish()
    }
    
    fileprivate func publish() {
        if textView.text.length < 6 {
            vc.makeToast(kLocalized("NoShotSix"))
            return
        }
        let donotWant = CharacterSet.init(charactersIn:" ")
        let keyword = textView.text.trimmingCharacters(in: donotWant)
        if keyword == "" {
            vc.makeToast(kLocalized("NoShotSix"))
            return
        }
        
        vc.publish(textView.text)
    }
    
    @objc fileprivate func dimiss() {
        endEditing(true)
    }
}

extension MQIReadCommentEditView: UITextViewDelegate {
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
}
