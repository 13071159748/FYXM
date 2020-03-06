//
//  MQISelectMultipleCollectionViewCell.swift
//  XSDQReader
//
//  Created by moqing on 2018/10/16.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

protocol MQISelectMultipleCollectionViewCellDelegate:class {
      func backScrollViewOffset(offSet:CGPoint)
}


class MQISelectMultipleCollectionViewCell: MQICollectionViewCell {
    
    weak var delegate:MQISelectMultipleCollectionViewCellDelegate?
    /// 点击回调
    var clickSelectMultipleItem:((_ item:MQISelectMultipleItemView)->())?
    
    /// 主视图
    fileprivate  var  contentBacView:UIScrollView!
    fileprivate  var  titleLable:UILabel!
    
    fileprivate let itemW = kUIStyle.scaleW(300)
    fileprivate let itemH = kUIStyle.scaleW(300)*1.27
    fileprivate let leftMargin = kUIStyle.scaleW(26)
    fileprivate let itemTopMargin = kUIStyle.scaleH(90)
    fileprivate let itemBottomMargin = kUIStyle.scaleH(40)
    fileprivate let itemLeftMargin = kUIStyle.scaleW(26)
    
    var type_text:String = "" {
        didSet(oldValue) {
             titleLable.text = type_text
        }
    }
    var eachbookModel:MQIMainRecommendModel?{
        didSet(oldValue) {
            if let model = eachbookModel {
                type_text = model.name
                addSelectMultipleItem(model.books)
                
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.clear
        contentBacView = UIScrollView()
        contentBacView.bounces = false
        contentBacView.showsHorizontalScrollIndicator = false
        contentBacView.showsVerticalScrollIndicator = false
        contentBacView.delegate = self
        contentView.addSubview(contentBacView)
        contentBacView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        self.backgroundColor = contentBacView.backgroundColor
        
        titleLable = UILabel()
        titleLable.font = kUIStyle.boldSystemFontDesignSize(size: 36)
        titleLable.textColor = kUIStyle.colorWithHexString("425154")
        titleLable.textAlignment  = .left
        contentView.addSubview(titleLable)
        titleLable.frame = CGRect(x: leftMargin, y: 20, width: self.width-leftMargin, height: 25)
        
    }
    
    
    func addSelectMultipleItem(_ models:[MQIMainEachRecommendModel]) -> Void {
        contentBacView.frame = self.bounds
        
        for i in 0..<models.count {
            let view = self.viewWithTag(110+i)
            var item:MQISelectMultipleItemView!
            if view == nil {
                item  = MQISelectMultipleItemView()
                item.tag =  110+i
                contentBacView.addSubview(item)
                item.frame = CGRect(x: leftMargin + (itemLeftMargin + itemW)*CGFloat(i), y: contentBacView.height - itemH - itemBottomMargin , width: itemW, height:itemH)
                item.dsyAddTap(self, action: #selector(clickItem(tap:)))
            }else{
                item = view as? MQISelectMultipleItemView
            }
            
            let model = models[i]
            item.bacImageView.sd_setImage(with: URL(string:model.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
            item.titleLabel.text = model.book_name
            item.book_id = model.book_id
            
            
        }
     contentBacView.contentSize = CGSize(width:leftMargin+(itemLeftMargin + itemW)*CGFloat(models.count), height: 0)
    }
    
    @objc  func clickItem(tap:UITapGestureRecognizer)  {
        
        let  item = tap.view as! MQISelectMultipleItemView
        item.clickState()
        clickSelectMultipleItem?(item)
    }
    
    class func getSize() -> CGSize {
        
        return CGSize(width: screenWidth, height: 280*gdscale)
    }
    
    
}

extension MQISelectMultipleCollectionViewCell :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.backScrollViewOffset(offSet: scrollView.contentOffset)
    }
}


/// 内容视图
class MQISelectMultipleItemView: UIView {
    
    /// 背景
    var bacView:UIView!
    /// 背景图片
    var bacImageView:UIImageView!
    /// 标题
    var titleLabel:UILabel!
    /// 遮罩
    var itemMaskView : UIView!
    
    var book_id = ""
    var changeColor:UIColor = kUIStyle.colorWithHexString("000000", alpha: 0.2)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
    }
    
    func setupUI() -> Void {
        
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = changeColor.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 5
        self.clipsToBounds = false
    
        bacView = UIView()
        bacView.backgroundColor = UIColor.white
        addSubview(bacView)
        bacView.layer.masksToBounds = true
        bacView.layer.cornerRadius = 8
        bacView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        bacImageView = UIImageView()
        bacImageView.dsySetCorner(radius: 4)
        addSubview(bacImageView)
        bacImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 33, bottom: 58, right: 33))
        }
        
        titleLabel = UILabel()
        titleLabel.font = kUIStyle.boldSystemFontDesignSize(size: 32)
        titleLabel.textColor = kUIStyle.colorWithHexString("#425154")
        titleLabel.textAlignment  = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(bacView).offset(-kUIStyle.scaleH(50))
            make.centerX.width.equalTo(bacView)
        }
 
        itemMaskView = UIView()
        itemMaskView.backgroundColor = kUIStyle.colorWithHexString("#000000",alpha:0.2)
        itemMaskView.isHidden = true
        itemMaskView.layer.masksToBounds = true
        itemMaskView.layer.cornerRadius = 8
        addSubview(itemMaskView)
        itemMaskView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    /// 点击动画
    func clickState() -> Void {
        itemMaskView.isHidden = false
        itemMaskView.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.itemMaskView.alpha = 0
        }) { (finished) in
            if finished {
                self.itemMaskView.isHidden = true
            }
        }
    }
    
    
}
