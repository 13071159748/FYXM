//
//  Pulsator.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 4/9/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  Objective-C version: https://github.com/shu223/PulsingHalo


import UIKit

import QuartzCore

internal let kPulsatorAnimationKey = "pulsator"

class Pulsator: CAReplicatorLayer, CAAnimationDelegate {

    let pulse = CALayer()
    var animationGroup: CAAnimationGroup!
    var alpha: CGFloat = 0.45

    override var backgroundColor: CGColor? {
        didSet {
            pulse.backgroundColor = backgroundColor
            guard let backgroundColor = backgroundColor else {return}
            let oldAlpha = alpha
            alpha = backgroundColor.alpha
            if alpha != oldAlpha {
                recreate()
            }
        }
    }
    
    override var repeatCount: Float {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.repeatCount = repeatCount
            }
        }
    }
    
    // MARK: - Public Properties

    /// The number of pulse.
    var numPulse: Int = 1 {
        didSet {
            if numPulse < 1 {
                numPulse = 1
            }
            instanceCount = numPulse
            updateInstanceDelay()
        }
    }
    
    ///	The radius of pulse.
    var radius: CGFloat = 60 {
        didSet {
            updatePulse()
        }
    }
    
    /// The animation duration in seconds.
    var animationDuration: TimeInterval = 3 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    /// If this property is `true`, the instanse will be automatically removed
    /// from the superview, when it finishes the animation.
    var autoRemove = false
    
    /// fromValue for radius
    /// It must be smaller than 1.0
    var fromValueForRadius: Float = 0.0 {
        didSet {
            if fromValueForRadius >= 1.0 {
                fromValueForRadius = 0.0
            }
            recreate()
        }
    }
    
    /// The value of this property should be ranging from @c 0 to @c 1 (exclusive).
    var keyTimeForHalfOpacity: Float = 0.2 {
        didSet {
            recreate()
        }
    }
    
    /// The animation interval in seconds.
    var pulseInterval: TimeInterval = 0
    
    /// A function describing a timing curve of the animation.
    var timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default) {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.timingFunction = timingFunction
            }
        }
    }
    
    /// The value of this property showed a pulse is started
    var isPulsating: Bool {
        guard let keys = pulse.animationKeys() else {return false}
        return keys.count > 0
    }
    
    /// private properties for resuming
    weak var prevSuperlayer: CALayer?
    var prevLayerIndex: Int?
    
    // MARK: - Initializer

    override init() {
        super.init()
        
        setupPulse()
        
        instanceDelay = 1
        repeatCount = MAXFLOAT
        backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 0.45).cgColor
            
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(Pulsator.save),
                                                         name: UIApplication.didEnterBackgroundNotification,
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(Pulsator.resume),
                                                         name:UIApplication.willEnterForegroundNotification,
                                                         object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    func setupPulse() {
        pulse.contentsScale = UIScreen.main.scale
        pulse.opacity = 0
        addSublayer(pulse)
        updatePulse()
    }
    
    func setupAnimationGroup() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = fromValueForRadius
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [alpha, alpha * 0.5, 0.0]
        opacityAnimation.keyTimes = [0.0, NSNumber(value: keyTimeForHalfOpacity as Float), 1.0]
        
        animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = animationDuration + pulseInterval
        animationGroup.repeatCount = repeatCount
        if let timingFunction = timingFunction {
            animationGroup.timingFunction = timingFunction
        }
        animationGroup.delegate = self
    }
    
    func updatePulse() {
        let diameter: CGFloat = radius * 2
        pulse.bounds = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: diameter, height: diameter))
        pulse.cornerRadius = radius
        pulse.backgroundColor = backgroundColor
    }
    
    func updateInstanceDelay() {
        guard numPulse >= 1 else { fatalError() }
        instanceDelay = (animationDuration + pulseInterval) / Double(numPulse)
    }
    
    func recreate() {
        guard animationGroup != nil else { return }        // Not need to be recreated.
        stop()
        let when = (Double(DispatchTime.now().rawValue) + Double(0.2 * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        after(when) {
            self.start()
        }
    }
    
    // MARK: - Internal Methods
    
    @objc internal func save() {
        prevSuperlayer = superlayer
//        prevLayerIndex = prevSuperlayer?.sublayers?.index(where: {$0 === self})
        prevLayerIndex = 0
    }
    
    @objc internal func resume() {
        if let prevSuperlayer = prevSuperlayer, let prevLayerIndex = prevLayerIndex {
            prevSuperlayer.insertSublayer(self, at: UInt32(prevLayerIndex))
        }
        if pulse.superlayer == nil {
            addSublayer(pulse)
        }
        if pulse.animation(forKey: kPulsatorAnimationKey) != nil {
            // if the animationGroup is not nil, it means the animation was not stopped
            if let animationGroup = animationGroup {
                pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// Start the animation.
    func start() {
        setupPulse()
        setupAnimationGroup()
        pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
    }
    
    /// Stop the animation.
    func stop() {
        pulse.removeAllAnimations()
        animationGroup = nil
    }
    
    
    // MARK: - Delegate methods for CAAnimation
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let keys = pulse.animationKeys(), keys.count > 0 {
            pulse.removeAllAnimations()
        }
        pulse.removeFromSuperlayer()
        
        if autoRemove {
            removeFromSuperlayer()
        }
    }
}

