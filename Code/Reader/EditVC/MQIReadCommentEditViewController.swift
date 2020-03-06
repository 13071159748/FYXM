//
//  GYReadCommentEditVC.swift
//  Reader
//
//  Created by CQSC  on 2017/11/2.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadCommentEditViewController: MQIBaseViewController {

    fileprivate var editView: MQIReadCommentEditView!
    public var book: MQIEachBook!
    public var chapter: MQIEachChapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editView = UIView.loadNib(MQIReadCommentEditView.self)
        editView.frame = view.bounds
        editView.book = book
        editView.chapter = chapter
        editView.vc = self
        view.addSubview(editView)
        
    }
    
    public func publish(_ text: String) {
        MQILoadManager.shared.addProgressHUD(kLocalized("HoldOnPlease"))
        GYCommentRequest(book_id: book.book_id,
                         comment_type: "2",
                         chapter_id: chapter.chapter_id,
                         comment_content: text)
            .request({[weak self] (request, response, result: MQIBaseModel) in
                MQILoadManager.shared.dismissProgressHUD()
                if let strongSelf = self {
                    strongSelf.editView.endEditing(true)
                    strongSelf.makeToast(kLocalized("pleaseWaitForAuthorReview"))
                    after(1.0, block: {
                        strongSelf.dismiss()
                    })
                }
            }) {[weak self] (msg, code) in
                MQILoadManager.shared.dismissProgressHUD()
                if let strongSelf = self {
                    strongSelf.makeToast(msg)
                }
        }
    }
    
    public func makeToast(_ message: String) {
       view.makeToast(message, duration: 1.5, position: .center)
    }
    
    public func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
