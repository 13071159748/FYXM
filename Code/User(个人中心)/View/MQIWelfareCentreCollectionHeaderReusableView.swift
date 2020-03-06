//
//  MQIWelfareCentreCollectionHeaderReusableView.swift
//  CHKReader
//
//  Created by moqing on 2019/1/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIWelfareCentreCollectionHeaderReusableView: MQICollectionReusableView {

    var titleLable: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(hex: "#F8F8F8")

        let bacView = UIView(frame: CGRect(x: 0, y: 15, width: screenWidth, height: self.height))

        bacView.backgroundColor = .white
        self.addSubview(bacView)
        titleLable = UILabel(frame: CGRect(x: 15, y: 0, width: bacView.width - 30, height: bacView.height))
        titleLable.font = UIFont.boldSystemFont(ofSize: 16)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .center
        bacView.addSubview(titleLable)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 40 + 15)
    }
}

class MQIWelfareCentreCollectionFooterReusableView: MQICollectionReusableView {

    var titleLable: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLable = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: self.height))
        titleLable.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .left
        self.addSubview(titleLable)
        titleLable.backgroundColor = UIColor.white
        titleLable.dsySetCorner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 30)
    }
}

