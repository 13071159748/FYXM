//
//  GDCommentsVC.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/4.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */
enum Comment_Type :String{
    case comment_all = "0"
    case comment_book = "1"
    case comment_chapter = "2"
}
class GDCommentsVC: MQIBaseViewController {

    fileprivate var bookImageView:UIImageView!
    fileprivate var bookTitle:UILabel!
    fileprivate var bookCommendCount:UILabel!
    fileprivate var current_type:Comment_Type = .comment_all
    
    fileprivate var selectedView:UIView!
    fileprivate var bottomButton:UIButton!
    fileprivate var lineView:UIView!
    fileprivate var contentScrollView:MQIRankScrollView!
    fileprivate var allVC = [GDCommentsDetailVC]()
    fileprivate var record_State = [RankState]()
    fileprivate var comment_typeArray:[Comment_Type] = [.comment_all,.comment_book,.comment_chapter]
    fileprivate var pushView:GDCommentPushView!
    var book:MQIEachBook!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "全部评论"
        
        addTopView()
        addBottomView()
        addnavselectView()
    }
    func addnavselectView() {
        let backview = UIView(frame: CGRect (x: 0, y: bookImageView.maxY + 10, width: screenWidth, height: 7))
        backview.backgroundColor = UIColor.colorWithHexString("#f8f8f8")
        contentView.addSubview(backview)
        
        selectedView = UIView(frame: CGRect (x: 0, y: backview.maxY, width: screenWidth, height: 43))
        contentView.addSubview(selectedView)
        let line = UIView(frame: CGRect (x: 0, y: 42, width: screenWidth, height: 1))
        line.backgroundColor = UIColor.colorWithHexString("#F5F5F5")
        selectedView.addSubview(line)
        
        contentScrollView = MQIRankScrollView(frame:  CGRect (x: 0, y: selectedView.maxY, width: screenWidth, height: contentView.height - selectedView.maxY - 45))
        contentScrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(contentScrollView)
        contentScrollView.contentSize = CGSize(width: screenWidth * 3, height: contentView.height - selectedView.maxY - 45)
        contentScrollView.isPagingEnabled = true
        contentScrollView.panGestureRecognizer.require(toFail: (self.navigationController?.interactivePopGestureRecognizer)!)
//        contentScrollView.delegate = self
        contentScrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        let buttonWidth = screenWidth/3
        let titleArr = ["全部","书评","章节说"]
        for i in 0..<3 {
            let button = UIButton(frame: CGRect (x: CGFloat(i)*(buttonWidth), y: 0, width: buttonWidth, height: 40))
            button.setTitle(titleArr[i], for: UIControlState())
            button.setTitleColor(UIColor.colorWithHexString("#000000"), for: UIControlState())
            button.tag = i + 100
            button.addTarget(self, action: #selector(GDCommentsVC.commentTypeBtnClick(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            selectedView.addSubview(button)
            
            let height = contentScrollView.height
            let detailVC = GDCommentsDetailVC()
            detailVC.view.frame = CGRect (x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: height)
            detailVC.book_id = book.book_id
            contentScrollView.addSubview(detailVC.view)
            self.addChildViewController(detailVC)
            
            allVC.append(detailVC)
            record_State.append(.isNew)
            if i == 0 {
                detailVC.comments_type = .comment_all
            }
        }
        lineView = UIView(frame: CGRect (x: buttonWidth/3, y: 38, width: buttonWidth/3, height: 2))
        lineView.layer.addDefineLayer(lineView.bounds)
        selectedView.addSubview(lineView)
        
    }
    func loadCommentDetailView(_ index:NSInteger) {
        guard record_State.count >= index else {
            return
        }
        if record_State[index] == .isNew {
            //还没加载过的
            record_State[index] = .isLoad
            let type = comment_typeArray[index]
            allVC[index].comments_type = type
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offset = contentScrollView.contentOffset.x
        lineView.frame = CGRect (x: offset/3 + screenWidth/3/3, y: 38, width: lineView.width, height: 2)
        if offset/screenWidth == 0.0 {
            current_type = .comment_all
            loadCommentDetailView(0)
        }else if offset/screenWidth == 1.0 {
            current_type = .comment_book
            loadCommentDetailView(1)
        }else if offset/screenWidth == 2.0 {
            current_type = .comment_chapter
            loadCommentDetailView(2)
        }

    }
    @objc func commentTypeBtnClick(_ button:UIButton) {
        let btnNum = button.tag - 100
        contentScrollView.scrollRectToVisible(CGRect (x: CGFloat(btnNum)*screenWidth, y: 0, width: screenWidth, height: contentScrollView.height), animated: false)
    }
    
    func addTopView() {
        bookImageView = UIImageView(frame: CGRect (x: 15.5, y: 15, width: 40, height: 53))
        bookImageView.image = bookPlaceHolderImage
        contentView.addSubview(bookImageView)
        if book.book_cover != "" {
            bookImageView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
        }
        bookTitle = UILabel(frame: CGRect (x: bookImageView.maxX + 10, y: 22.5, width: screenWidth - bookImageView.maxX - 10, height: 16))
        bookTitle.text = book.book_name

        bookTitle.font = UIFont.systemFont(ofSize: 16)
        bookTitle.textColor = UIColor.colorWithHexString("#23252C")
        contentView.addSubview(bookTitle)
        
        bookCommendCount = UILabel (frame: CGRect (x: bookTitle.x, y: bookTitle.maxY + 14, width: bookTitle.width, height: 12))
        bookCommendCount.font = UIFont.systemFont(ofSize: 12)
        bookCommendCount.textColor = UIColor.colorWithHexString("#666666")
        bookCommendCount.text = "0条评论"
        contentView.addSubview(bookCommendCount)
        requestcommentCount(book.book_id)
    }
    func addBottomView() {
        bottomButton = UIButton(type: .custom)
        bottomButton.frame = CGRect (x: 0, y: contentView.height - 45, width: screenWidth, height: 45)
        bottomButton.setTitle("发布评论", for: UIControlState())
        bottomButton.backgroundColor = mainColor
        bottomButton.setTitleColor(UIColor.colorWithHexString("#ffffff"), for: UIControlState())
        contentView.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(GDCommentsVC.pushComnents), for: .touchUpInside)
    }
    @objc func pushComnents() {
        
        pushView = GDCommentPushView(frame:CGRect (x: 0, y: 0, width: screenWidth, height: view.height))
        pushView.bookid = book.book_id
        pushView.comment_type = .comment_book
        view.addSubview(pushView)

        pushView.commentClose = {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.pushView.removeFromSuperview()
                weakSelf.pushView = nil
            }
        }
        pushView.commentPushFinishBlock = {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.pushView.removeFromSuperview()
                weakSelf.pushView = nil
            }
        }
    }
    func requestcommentCount(_ bookid:String) {
        GDCommentCountRequest(book_id: "\(bookid)").request({[weak self](request, response, result:GDCommentCountModel) in
            if let weakSelf = self {
                weakSelf.bookCommendCount.text = result.comment_count + "条评论"
            }
            
        }) { (errmsg, errcode) in
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        if contentScrollView != nil {
            contentScrollView.removeObserver(self, forKeyPath: "contentOffset")
        }
        //
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
