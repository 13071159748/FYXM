//
//  MQIWelfareHorizonListCollectionViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/12/18.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import Foundation

class MQIWelfareHorizonListCollectionViewCell: MQICollectionViewCell {

    var horizonCollecitonView: MQICollectionView!
    var booksArray: [MQIPopupAdsenseListModel] = [] {
        didSet {
            horizonCollecitonView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addCollectionView()
    }

    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal

        layout.itemSize = MQIHorizonCollectionViewCell.getSize()
        horizonCollecitonView = MQICollectionView(frame: CGRect(x: 0, y: 20, width: screenWidth, height: 105), collectionViewLayout: layout)
        horizonCollecitonView.gyDelegate = self
        horizonCollecitonView.alwaysBounceVertical = false
        horizonCollecitonView.showsHorizontalScrollIndicator = false
        horizonCollecitonView.registerCell(MQIHorizonCollectionViewCell.self, xib: false)
        contentView.addSubview(horizonCollecitonView)
        horizonCollecitonView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(105)
        }

        let titleLabel = UILabel()
        titleLabel.text = "精彩活动"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: 5, y: 0, width: 100, height: 22)
        contentView.addSubview(titleLabel)

        let moreBtn = UIButton()
        moreBtn.setTitle("查看全部", for: .normal)
        moreBtn.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
        moreBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        moreBtn.tintColor = UIColor(hex: "#7187FF")
        moreBtn.setTitleColor(UIColor(hex: "#7187FF"), for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreBtn.frame = CGRect(x: screenWidth - 110, y: 0, width: 80, height: 22)
        moreBtn.addTarget(self, action: #selector(onMoreBtnTapped), for: .touchUpInside)
        contentView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(80)
            make.height.equalTo(22)
            make.top.equalToSuperview()
        }


        if #available(iOS 11.0, *) {
            horizonCollecitonView.contentInsetAdjustmentBehavior = .never
        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    static func getSize() -> CGSize {
        return CGSize(width: screenWidth - 10, height: 136)
    }

    @objc func onMoreBtnTapped() {
                let vc = MQIEventCenterViewController()
                vc.hidesBottomBarWhenPushed = true
                gd_currentNavigationController().pushVC(vc)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        horizonCollecitonView.frame = self.bounds
    }
}

extension MQIWelfareHorizonListCollectionViewCell: MQICollectionViewDelegate {

    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MQIHorizonCollectionViewCell.self, forIndexPath: indexPath)
        let model = booksArray[indexPath.item]
        cell.indexModel = model
        return cell
    }

    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return booksArray.count
    }

    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        return MQIHorizonCollectionViewCell.getSize()
    }

    func minimumInteritemSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {

        return 0.01
    }
//
//    func minimumLineSpacingForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGFloat {
//        return 0
//    }

    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        if let url = URL(string: booksArray[indexPath.row].url) {
            MQIOpenlikeManger.toPath(url)
        }

    }

}

