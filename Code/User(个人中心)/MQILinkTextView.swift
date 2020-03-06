//
//  MQILinkTextView.swift
//  moqing
//
//  Created by moqing on 2019/5/22.
//  Copyright © 2019 dsy. All rights reserved.
//

import UIKit

class MQILinkTextView: UITextView {
    
    override var text: String!{
        didSet(oldValue) {
            text_new = text
        }
    }
    var lineSpacing:CGFloat = 5
    var defaultTextColor:UIColor = UIColor.black
    /// 点击url回调
    var call_URL_Block:((_ rurlStr:URL)->())?
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
    }
    func setupTextView() {
        self.delegate = self
        self.isEditable = false
        self.isScrollEnabled = false;
//                self.isSelectable = false
        self.isUserInteractionEnabled = true
    }
    

    
    fileprivate func parsingText() {
        attributedText = MQIOpenlikeManger.getParsingAtts(text_new, font: self.font, defaultTextColor: self.defaultTextColor, lineSpacing: self.lineSpacing, textAlignment:self.textAlignment)
    }
//    deinit {
//        UIMenuController.shared.isMenuVisible = true
//    }
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        UIMenuController.shared.isMenuVisible = false
//        self.resignFirstResponder()
//        return  false
//    }
    fileprivate  var mark_text:String = "<dsy"
    fileprivate  var text_new:String?{
        didSet(oldValue) {
            parsingText()
        }
    }
}

extension MQILinkTextView:UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        call_URL_Block?(URL)
        return false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return false
    }
}


