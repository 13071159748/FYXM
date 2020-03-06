//
//  MQIRankViewController.swift
//  CQSC
//
//  Created by moqing on 2019/3/6.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
enum RankState {
    case isLoad
    case isNew
}
class MQIRankViewController: MQIBaseViewController{

    fileprivate var topNavScrollView:MQIRankScrollView!
    fileprivate var topTypes = [MQIRankTypesModel]()
    fileprivate let buttonMinWidth:CGFloat = 80
    fileprivate let topMinHeight:CGFloat = 40
    fileprivate var contentScrollView:MQIRankScrollView!
    fileprivate var record_State = [RankState]()
    @IBOutlet weak var bacLabel: UILabel!
    fileprivate var allVC = [MQIRankDetailViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = kUIStyle.colorWithHexString("F2F2F2")
        addPreloadView()
        topXMNavRequest()
        view.sendSubviewToBack(bacLabel)
    }
    
    //MARK:加载
    func loadContentDatas(_ index:NSInteger) {
        guard record_State.count >= index else {
            return
        }
        if record_State[index] == .isNew {
            //还没加载过的
            record_State[index] = .isLoad
            let model = topTypes[index]
            allVC[index].rank_id = model.type
        }
        
    }
    //MARK:导航栏
    func xm_AddTopNavScrView(_ types:[MQIRankTypesModel],_ isEnd:Bool = false) {
        
        topNavScrollView = MQIRankScrollView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: topMinHeight))
        topNavScrollView.backgroundColor = UIColor.white
        topNavScrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(topNavScrollView)
        topNavScrollView.contentSize = CGSize(width: Int(buttonMinWidth) * types.count, height: 0)
        
        contentScrollView = MQIRankScrollView(frame: CGRect (x: 0, y: topNavScrollView.maxY+1, width: screenWidth, height: contentView.height-topNavScrollView.maxY-1))
        contentScrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(contentScrollView)
        contentScrollView.contentSize = CGSize(width: screenWidth * CGFloat(types.count), height: 0)
        contentScrollView.isPagingEnabled = true
        if let navpopRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            contentScrollView.panGestureRecognizer.require(toFail:navpopRecognizer)
        }
        
        
        contentScrollView.delegate = self
        
        
        for i in 0..<types.count {
            let eachType = types[i]
            let navButton = nav_Btn(type: .custom)
            navButton.frame = CGRect (x: CGFloat(i)*buttonMinWidth, y: 0, width: buttonMinWidth, height: topMinHeight)
            navButton.backgroundColor = UIColor.white
            navButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            navButton.setTitle(eachType.name, for: .normal)
            //            navButton.setTitleColor(mainColor, for: .selected)
            navButton.setTitleColor(UIColor.colorWithHexString("#1C1C1E"), for: .normal)
            navButton.tag = 100+i
            navButton.addTarget(self, action: #selector(MQIRankViewController.rankType_ButtonClick(_:)), for: .touchUpInside)
            topNavScrollView.addSubview(navButton)
            
            
            let height = contentScrollView.height
            let detailVC = MQIRankDetailViewController.create() as! MQIRankDetailViewController
            detailVC.view.frame = CGRect (x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: height)
            contentScrollView.addSubview(detailVC.view)
            self.addChild(detailVC)
            
            allVC.append(detailVC)
            record_State.append(.isNew)
            if i == 0 {
                navButton.isSelected = true
                detailVC.rank_id = types[i].type
            }
        }
        
    }
  
    @objc func rankType_ButtonClick(_ button:UIButton) {
        let btnTag = getSubViewTag(button) - 100
        contentScrollView.setContentOffset(CGPoint(x:CGFloat(btnTag)*screenWidth,  y: 0), animated: true)
        for view in topNavScrollView.subviews {
            if view.isKind(of: UIButton.self){
                let sender = view as! UIButton
                if sender.tag == button.tag{
                    sender.isSelected = true
                    loadContentDatas(btnTag)
                }else {
                    sender.isSelected = false
                }
            }
        }
    }
    
    func getSubViewTag(_ view:UIView) -> Int {
        return view.tag
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private class nav_Btn:UIButton {
        override var isSelected: Bool{
            didSet(oldValue) {
                lineView.isHidden = !isSelected
            }
        }
        private  var lineView:UIView!
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func setupUI() {
            lineView  = UIView()
            lineView.isHidden = true
            lineView.dsySetCorner(radius: 1)
            lineView.backgroundColor = UIColor.colorWithHexString("7187FF")
            addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(12)
                make.height.equalTo(2)
                if let titleLabel = titleLabel {
                    make.bottom.equalTo(titleLabel.snp.bottom).offset(5)
                }else{
                    make.bottom.equalToSuperview().offset(-10)
                }
                
            }
        }
        
        
    }
    
}

extension MQIRankViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            let offset = contentScrollView.contentOffset.x
            for view in topNavScrollView.subviews {
                if view.isKind(of: UIButton.self) {
                    let button = view as! UIButton
                    if getSubViewTag(button) == Int(100 + offset/screenWidth){
                        topNavScrollView.scrollRectToVisible(CGRect (x: CGFloat(offset/screenWidth)*buttonMinWidth, y: 0, width: buttonMinWidth, height:topMinHeight), animated: true)
                        loadContentDatas(getSubViewTag(button) - 100)
                        button.isSelected = true
                    }else {
                        button.isSelected = false
                    }
                }
            }
        }
    }
    
}
extension MQIRankViewController {
    //MARK:请求
    func topXMNavRequest() {
        GDRankTypesRequest().requestCollection({ [weak self](request, response, result:[MQIRankTypesModel]) in

            if  let weakSelf = self {
                weakSelf.dismissPreloadView()
                weakSelf.dismissWrongView()
                weakSelf.topTypes = result
                weakSelf.xm_AddTopNavScrView(result,false)
            }
        }) { [weak self](errMsg, errcode) in
            if let weakSelf = self {
                weakSelf.dismissPreloadView()
                weakSelf.loadfailed()
            }
        }
    }
    func loadfailed() {
        addWrongView(kLocalized("NewError"),refresh:{[weak self]()-> Void in
            if let weakSelf = self {
                weakSelf.topXMNavRequest()
                weakSelf.wrongView?.setLoading()
            }
        })
    }
}
