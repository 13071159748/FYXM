//
//  GYBookOriginalActionCell.swift
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalActionCell: MQITableViewCell {

//    fileprivate
    var rewardBtn: GYBookOriginalActionCellLikeBtn!
//    fileprivate
    var likeBtn: GYBookOriginalActionCellLikeBtn!
    
    fileprivate var btnFont = UIFont.systemFont(ofSize: 14)
    
    var toReward: (() -> ())?
//    var toLike: ((vote_num: Int) -> ())?
    var toLike: (() -> ())?
    
//    var timer: NSTimer!
    var timeCount: Int = 0
    var like_num: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        self.selectionStyle = .none
        
        rewardBtn = GYBookOriginalActionCellLikeBtn(frame: CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height))
        rewardBtn.backgroundColor = UIColor.clear
        rewardBtn.addTarget(self, action: #selector(GYBookOriginalActionCell.rewardBtnAction), for: .touchUpInside)
        rewardBtn.setTitle(kLocalized("Exception"), for: .normal)
        rewardBtn.setTitleColor(RGBColor(64, g: 174, b: 160), for: .normal)
        rewardBtn.image = UIImage(named: "info_reward")
        rewardBtn.titleLabel?.font = btnFont
        rewardBtn.contentHorizontalAlignment = .center
        rewardBtn.addLine(3, lineColor: GYBookOriginalInfoVC_lineColor, directions: .right)
        contentView.addSubview(rewardBtn)
        
        likeBtn = GYBookOriginalActionCellLikeBtn(frame: CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height))
        likeBtn.backgroundColor = UIColor.clear
        likeBtn.addTarget(self, action: #selector(GYBookOriginalActionCell.likeBtnAction), for: .touchUpInside)
        likeBtn.setTitle(kLocalized("GiveLike"), for: .normal)
        likeBtn.setTitleColor(RGBColor(227, g: 118, b: 84), for: .normal)
        likeBtn.image = UIImage(named: "info_like")
        likeBtn.titleLabel?.font = btnFont
        likeBtn.contentHorizontalAlignment = .center
        
        contentView.addSubview(likeBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rewardBtn.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        likeBtn.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height)
    }
    
    //MARK: --
    @objc func rewardBtnAction() {
        rewardBtn.reload()
        rewardBtn.icon.animate()
        toReward?()
    }
    
    @objc func likeBtnAction() {
        let pulsator = Pulsator()
        pulsator.numPulse = 1
        pulsator.radius = 200
        pulsator.animationDuration = 1
        pulsator.repeatCount = 1
        pulsator.backgroundColor = RGBColor(18, g: 181, b: 234).cgColor
        pulsator.position = CGPoint(x: likeBtn.frame.size.width/2, y: likeBtn.frame.size.height/2)
        
        likeBtn.layer.addSublayer(pulsator)
        likeBtn.layer.masksToBounds = true
        pulsator.start()
        
        likeBtn.reload()
        likeBtn.icon.animate()
        toLike?()
        
    }

}

class GYBookOriginalActionLikeBtn: UIButton, CAAnimationDelegate {
    
    var images = [UIImage]()
    
    var maxLeft: CGFloat = 0
    var maxRight: CGFloat = 0
    var maxHeight: CGFloat = 0
    var duration: CFTimeInterval = 0.25
    var array: NSMutableArray = NSMutableArray(capacity: 1)
    var recyclePool: NSMutableSet = NSMutableSet(capacity: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        
    }
    
    func generateBubbleInRandom() {
        var layer: CALayer?
        if recyclePool.count > 0 {
            layer = recyclePool.anyObject() as? CALayer
            if let l = layer {
                recyclePool.remove(l)
            }
        }else {
            let image = self.images[Int(arc4random_uniform(UInt32(self.images.count)))]
            layer = self.createLayer(image)
        }
        if let layer = layer {
            self.layer.addSublayer(layer)
            self.generateBubbleWithLayer(layer)
        }
    }
    
    func generateBubbleWithImage(_ image: UIImage) {
        let layer = self.createLayer(image)
        self.layer.addSublayer(layer)
        self.generateBubbleWithLayer(layer)
    }
    
    func generateBubbleWithLayer(_ layer: CALayer) {
        let maxWidth = maxLeft+maxRight
        let startPoint = CGPoint(x: self.bounds.width/2, y: 0)
        let endPoint = CGPoint(x: maxWidth*self.randomFloat()-maxLeft, y: -maxHeight)
        let controlPoint1 = CGPoint(x: maxWidth*self.randomFloat()-maxLeft, y: -maxHeight*0.2)
        let controlPoint2 = CGPoint(x: maxWidth*self.randomFloat()-maxLeft, y: -maxHeight*0.6)
        let curvedPath = CGMutablePath()
        
        curvedPath.move(to: startPoint)
        curvedPath.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
        
        let keyFrame = CAKeyframeAnimation()
        keyFrame.keyPath = "position"
        keyFrame.path = curvedPath
        keyFrame.duration = duration
        keyFrame.calculationMode = CAAnimationCalculationMode.paced
        
        layer.add(keyFrame, forKey: "keyframe")
        
        let scale = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 1
        scale.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 0.1))
        scale.duration = 0.5
        
        let alpha = CABasicAnimation()
        alpha.keyPath = "opacity"
        alpha.fromValue = 1
        alpha.toValue = 0.1
        alpha.duration = duration*0.4
        alpha.beginTime = duration-alpha.duration
        
        let group = CAAnimationGroup()
        group.animations = [keyFrame, scale, alpha]
        group.duration = duration
        group.delegate = self
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        layer.add(group, forKey: "group")
        
        array.add(layer)
    }
    
    func createLayer(_ image: UIImage) -> CALayer {
        let scale = UIScreen.main.scale
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: image.size.width/scale, height: image.size.height/scale);
        layer.contents = image.cgImage
        return layer
    }
    
    func randomFloat() -> CGFloat {
        return CGFloat(arc4random_uniform(100))/100.0
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            if let layer = array.firstObject as? CALayer {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
                array.remove(layer)
                recyclePool.add(layer)
            }
        }
    }
    
}

import Spring
class GYBookOriginalActionCellLikeBtn: UIButton {
    
    var icon: SpringImageView!
    
    var image: UIImage? {
        didSet {
            icon.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        icon = SpringImageView(frame: CGRect.zero)
        reload()
        self.addSubview(icon)
    }
    
    func reload() {
        icon.animation = "pop"
        icon.curve = "easeOut"
        icon.force = 2.1
        icon.duration = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width
        let height = self.bounds.height
        let space: CGFloat = 3
        
        let imageSide = height/2
        
        icon.frame = CGRect(x: width/2-imageSide-space, y: (height-imageSide)/2, width: imageSide, height: imageSide)
        if let titleLabel = titleLabel {
            titleLabel.frame = CGRect(x: width/2+space, y: 0, width: width/2-space, height: height)
        }
    }
    
    
}
