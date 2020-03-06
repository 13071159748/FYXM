//
//  GYGifView.m
//  Nymph
//
//  Created by _CHK_  on 16/1/7.
//  Copyright © 2016年 _xinmo_. All rights reserved.
//

#import "GYGifView.h"
#import "GYGIfImage.h"
#import <QuartzCore/QuartzCore.h>

@interface GYGifView ()

@property (nonatomic, strong) GYGIfImage *animatedImage;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval accumulator;
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic, strong) UIImage* currentFrame;
@property (nonatomic) NSUInteger loopCountdown;

@end

@implementation GYGifView

const NSTimeInterval kMaxTimeStep = 1; // note: To avoid spiral-o-death

@synthesize runLoopMode = _runLoopMode;
@synthesize displayLink = _displayLink;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
    }
    return self;
}

- (CADisplayLink *)displayLink
{
    if (self.superview) {
        if (!_displayLink && self.animatedImage) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    return _displayLink;
}

- (NSString *)runLoopMode
{
    return _runLoopMode ?: NSRunLoopCommonModes;
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (runLoopMode != _runLoopMode) {
        [self stopAnimating];
        
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [self.displayLink removeFromRunLoop:runloop forMode:_runLoopMode];
        [self.displayLink addToRunLoop:runloop forMode:runLoopMode];
        
        _runLoopMode = runLoopMode;
        
        [self startAnimating];
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.image = [GYGIfImage imageNamed:_imageName];
}

- (void)setImage:(UIImage *)image
{
    if (image == self.image) {
        return;
    }
    
    [self stopAnimating];
    
    self.currentFrameIndex = 0;
    self.loopCountdown = 0;
    self.accumulator = 0;
    
    if ([image isKindOfClass:[GYGIfImage class]] && image.images) {
        if(image.images[0])
            [super setImage:image.images[0]];
        else
            [super setImage:nil];
        self.currentFrame = nil;
        self.animatedImage = (GYGIfImage *)image;
        self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
        [self startAnimating];
    } else {
        self.animatedImage = nil;
        [super setImage:image];
    }
    [self.layer setNeedsDisplay];
}

- (void)setAnimatedImage:(GYGIfImage *)animatedImage
{
    _animatedImage = animatedImage;
    if (animatedImage == nil) {
        self.layer.contents = nil;
    }
}

- (BOOL)isAnimating
{
    return [super isAnimating] || (self.displayLink && !self.displayLink.isPaused);
}

- (void)stopAnimating
{
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    
    self.loopCountdown = 0;
    
    self.displayLink.paused = YES;
}

- (void)startAnimating
{
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    
    if (self.isAnimating) {
        return;
    }
    
    self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
    
    self.displayLink.paused = NO;
}

- (void)changeKeyframe:(CADisplayLink *)displayLink
{
    if (self.currentFrameIndex >= [self.animatedImage.images count]) {
        return;
    }
    self.accumulator += fmin(displayLink.duration, kMaxTimeStep);
    
    while (self.accumulator >= self.animatedImage.frameDurations[self.currentFrameIndex]) {
        self.accumulator -= self.animatedImage.frameDurations[self.currentFrameIndex];
        if (++self.currentFrameIndex >= [self.animatedImage.images count]) {
            if (--self.loopCountdown == 0) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
        }
        self.currentFrameIndex = MIN(self.currentFrameIndex, [self.animatedImage.images count] - 1);
        self.currentFrame = [self.animatedImage getFrameWithIndex:self.currentFrameIndex];
        [self.layer setNeedsDisplay];
    }
}

- (void)displayLayer:(CALayer *)layer
{
    if (!self.animatedImage || [self.animatedImage.images count] == 0) {
        return;
    }
    //NSLog(@"display index: %luu", (unsigned long)self.currentFrameIndex);
    if(self.currentFrame && ![self.currentFrame isKindOfClass:[NSNull class]])
        layer.contents = (__bridge id)([self.currentFrame CGImage]);
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimating];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.window) {
                [self stopAnimating];
            }
        });
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        //Has a superview, make sure it has a displayLink
        [self displayLink];
    } else {
        //Doesn't have superview, let's check later if we need to remove the displayLink
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayLink];
        });
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (!self.animatedImage) {
        [super setHighlighted:highlighted];
    }
}

- (UIImage *)image
{
    return self.animatedImage ?: [super image];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.image.size;
}

@end

