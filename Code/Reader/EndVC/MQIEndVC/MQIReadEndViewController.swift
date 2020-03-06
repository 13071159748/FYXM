//
//  MQIReadEndViewController.swift
//  MoQingInternational
//
//  Created by moqing on 2019/6/19.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIReadEndViewController: MQIBaseViewController {
    
    var book:MQIEachBook!{
        didSet(oldValue) {
            if book != nil {
                b_id = book!.book_id
            }
        }
    }
    
    fileprivate var b_id:String = ""
    
    fileprivate var fixedData = [[String:String]]()
    fileprivate var tableView:UITableView!
    fileprivate var bottomView:UIView!
    fileprivate var refreshText = "1"
    fileprivate var pushView:MQICommentPushView!
    fileprivate var buyBtn:UIButton!
    fileprivate var offset :Int = -1{
        didSet(oldValue) {
            if let dataModel = dataModel {
                if dataModel.total_rows.integerValue() == 1 {
                    refreshText = "3"
                }
                else if  dataModel.total_rows.integerValue() <= offset {
                    refreshText = "2"
                }
                    
                else{
                    refreshText = "1"
                }
            }
        }
    }

    
    fileprivate var dataModel:MQIEachBook?{
        didSet(oldValue) {
           
            if dataModel == nil {
                setProvisionsData(type: "end_center_cell", row: "0")
                setProvisionsData(type: "end_content_cell", row: "0")
                buyBtn.isHidden = true
            }else{
                setProvisionsData(type: "end_center_cell", row: "1")
                setProvisionsData(type: "end_content_cell", row: "\(dataModel?.chapters.count ?? 0)")
                buyBtn.isHidden = false
            }
         
            tableView.reloadData()
        }
    }
    
    fileprivate var total_rows = [MQIEachBook]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomview()
        addTableView()
        configFixedData()
        title = book?.book_name
        
        getData()
    }
    

}

extension MQIReadEndViewController{
    
    func getData() {
       
        if b_id == "" { return }
        offset += 1
        if refreshText != "1" {
            self.dataModel = total_rows[offset%total_rows.count]
            self.tableView.reloadData()
            return
        }
        if dataModel != nil {
//            MQILoadManager.shared.addProgressHUD("")
        }else{
            self.addPreloadView()
        }
       
        MQIEndContentRequest(book_id:b_id, offset: "\(offset)")
            .request({ [weak self] (request, response, result: MQIEachBook) in
//                MQILoadManager.shared.dismissProgressHUD()
                
                if result.book_id.count <= 1 {
                    self?.dataModel = nil
                    self?.dismissWrongView()
                    self?.dismissPreloadView()
                    return
                }
                for chapter in result.chapters {
                    chapter.content =  unlockCntent.getOriginContent(bookId: result.book_id.integerValue(), chapterId:   chapter.chapter_id.integerValue(), cryptString: chapter.content)
                }
                if result.total_rows == "1"{
                     self?.refreshText = "3"
                }
                self?.dataModel = result
                self?.dismissWrongView()
                self?.dismissPreloadView()
                self?.total_rows.append(result)
            }) { [weak self] (err_msg, err_code) in
//                MQILoadManager.shared.dismissProgressHUD()
                self?.dismissPreloadView()
                self?.offset -= 1
                self?.addWrongView(err_msg, refresh: {
                    self?.getData()
                })
        }
    }
    
    
    @objc func clickBottomBtnAction(btn:UIButton)  {
        guard let dataModel  = dataModel  else {
            return
        }
        if  !MQIShelfManager.shared.checkIsExist(dataModel.book_id){
            MQIUserOperateManager.shared.addShelf(dataModel, completion: nil)
        }
        MQIUserOperateManager.shared.toReader(dataModel.book_id,toIndex:nil,chapter_id: dataModel.continue_chapter_id)
    }
    
    func requestToLike() {
          MQILoadManager.shared.addProgressHUD("")
        GYBookInfoToVoteRequest(user_id: MQIUserManager.shared.user!.user_id, book_id: b_id, toVote: false, vote_num: "10")
            .request({ (request, response, result: MQIBaseModel) in
                 MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("TenPress"))
                
            }) { (err_msg, err_code) in
                 MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("TomorrowCome"))
        }
    }
    
    func toCommentView () {
        self.pushView = MQICommentPushView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: view.height))
        self.pushView.bookid = b_id
        self.pushView.comment_type = .comment_chapter
        self.pushView.chapterid = ""
        self.view.addSubview(pushView)
        self.pushView.commentClose = {[weak self] in
            self?.pushView.removeFromSuperview()
        }
        self.pushView.commentPushFinishBlock = {[weak self] in
            self?.pushView.removeFromSuperview()
        }
        
    }
}

extension MQIReadEndViewController{
   
   
    
    func addTableView() {
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height-bottomView.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        contentView.addSubview(tableView)
      
        tableView.register(MQIEndHeadCollectionViewCell.self, forCellReuseIdentifier: MQIEndHeadCollectionViewCell.getIdentifier())
        tableView.register(MQIEndContentCollectionViewCell.self, forCellReuseIdentifier: MQIEndContentCollectionViewCell.getIdentifier())
        tableView.register(MQIEndCenterCollectionViewCell.self, forCellReuseIdentifier: MQIEndCenterCollectionViewCell.getIdentifier())
    }
    
    
    func addBottomview() {
        
        bottomView = UIView(frame: CGRect(x: 0, y: contentView.height-60, width: contentView.width, height: 60))
        bottomView.backgroundColor = UIColor.white
        contentView.addSubview(bottomView)
        //        let lineView = UIView()
        //        lineView.backgroundColor = UIColor.colorWithHexString("dbdbdb")
        //        bottomView.addSubview(lineView)
        //        lineView.snp.makeConstraints { (make) in
        //            make.left.right.top.equalToSuperview()
        //            make.height.equalTo(1)
        //        }
        
        buyBtn = UIButton()
        buyBtn.setTitle(kLocalized("Join_the_bookshelf_and_read_on"), for: .normal)
        buyBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        buyBtn.setTitleColor(UIColor.white, for: .normal)
        buyBtn.backgroundColor = UIColor.colorWithHexString("E65751")
        buyBtn.dsySetCorner(radius: 18)
        buyBtn.addTarget(self, action: #selector(clickBottomBtnAction), for: UIControl.Event.touchUpInside)
        bottomView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
    }
    
}



extension MQIReadEndViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
         return fixedData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return fixedData[section]["row"]!.integerValue()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let type = fixedData[indexPath.section]["type"]
        switch type {
        case "end_Head_cell":
            let cell = tableView.dequeueReusableCell(withIdentifier: MQIEndHeadCollectionViewCell.getIdentifier(), for: indexPath) as! MQIEndHeadCollectionViewCell
            cell.title.text =    (book.book_status == "2") ?  kLocalized("AuthFinsh",describeStr:"全书大结局】，阅读是最好的礼物。" ):  kLocalized("AuthHard",describeStr:"【未完待续】，精彩剧情敬请期待。" )
            cell.subTitle1.text =     kLocalized("Go_to_the_book_store_and_find_more_popular_books",describeStr: "去書城，發現更多熱門好書>")
        
            cell.selectionStyle = .none
            cell.clickBlock = { [weak self] (type) in
                
                if type == .likeBtn {
                    if MQIUserManager.shared.checkIsLogin() {
                        self?.requestToLike()
                    }else{
                        MQIUserOperateManager.shared.toLoginVC({
                            self?.requestToLike()
                        })
                    }
                    
                }else if type == .commentBtn {
                    if MQIUserManager.shared.checkIsLogin() {
                        self?.toCommentView()
                    }else{
                        MQIUserOperateManager.shared.toLoginVC({
                            self?.toCommentView()
                        })
                    }
                    
                }else{
                    MQIOpenlikeManger.todo(key: "open.page.HOME",tab:"store")
                    self?.navigationController?.popToRootViewController(animated: false)
                    
                }
                
            }
            
            return cell
            
        case "end_center_cell":
            let cell = tableView.dequeueReusableCell(withIdentifier: MQIEndCenterCollectionViewCell.getIdentifier(), for: indexPath) as! MQIEndCenterCollectionViewCell
               cell.selectionStyle = .none
            cell.coverImageView.isShowTitle = true
            cell.coverImageView.title =   dataModel?.badge_text
            cell.coverImageView.imageView.sd_setImage(with:   URL(string: dataModel?.book_cover ??  ""), placeholderImage: UIImage(named: book_PlaceholderImg))
            cell.title.text = dataModel?.book_name
            cell.title1.text  =  dataModel?.recommend_text
            cell.subTitle1.text = dataModel?.subclass_name
            cell.subTitle2.text =  (dataModel?.read_num ?? "13532") + "人" +  kLocalized("AlreadyRead", describeStr: "已读")
            
            if refreshText == "3"{
               cell.refreshBtn.isHidden = true
            }else{
               cell.refreshBtn.isHidden = false
            }
            
            cell.clickBlock = { [weak self] (type) in
                if type == .refreshBtn {
                    self?.getData()
                }
            }
            return cell
        case "end_content_cell":
            let cell = tableView.dequeueReusableCell(withIdentifier: MQIEndContentCollectionViewCell.getIdentifier(), for: indexPath) as! MQIEndContentCollectionViewCell
               cell.selectionStyle = .none
            let  chapter = dataModel!.chapters[indexPath.row]
            cell.title.text = chapter.chapter_title
            cell.contentText = chapter.content
            //             cell.subTitle1.text = chapter.content
            return cell
        default:
            
            return UITableViewCell()
        }
    }
    
    
}


extension MQIReadEndViewController {
    
    func configFixedData() {
      
        fixedData  = [
            [
                "type":"end_Head_cell",
                "row":"1",
                ],
            [
                "type":"end_center_cell",
                "row":"0",
            ],
            
            [
                "type":"end_content_cell",
                "row":"0",
                
                ],
            
        ]
        
    }
    
    func setProvisionsData(type:String,row:String) {
        var tag:Int = 0
        for dic in  fixedData {
            if dic["type"] == type {
                fixedData[tag]["row"] = row
                return
            }
            tag += 1
        }
        
    }
    
    
}
