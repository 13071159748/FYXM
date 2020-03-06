//
//  ZBCycleVerticalView.m
//  DeRong
//
//  Created by 周博 on 2019/1/7.
//  Copyright © 2019 周博. All rights reserved.
//

#import "ZBCycleVerticalView.h"

@interface ZBCycleVerticalView ()
{
    CGRect          _topRect;   //上View
    CGRect          _middleRect;//中View
    CGRect          _btmRect;   //下View
    double          _animationTime;//动画时长
    
    UIButton        *_button;   //按钮
    NSTimer         *_timer;    //计时器
    NSInteger       _indexNow;  //计数器
}

@property (strong, nonatomic) ZBCycleView *view1;
@property (strong, nonatomic) ZBCycleView *view2;

@property (strong, nonatomic) ZBCycleView *tmpTopView;
@property (strong, nonatomic) ZBCycleView *tmpMiddleView;
@property (strong, nonatomic) ZBCycleView *tmpBtmView;

@end

@implementation ZBCycleVerticalView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showTime = 3;
        _animationTime = 0.3;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.showTime = 3;
        _animationTime = 0.3;
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _middleRect = self.bounds;
    _topRect = CGRectMake(0, -CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _btmRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    self.view1.frame = _middleRect;
    self.view2.frame = self.direction == ZBCycleVerticalViewScrollDirectionDown ? self->_topRect : self->_btmRect;
    _button.frame = _middleRect;
}

- (void)initUI{
    self.view1 = [[ZBCycleView alloc]init];
//    self.view1.backgroundColor = [UIColor clearColor];

    self.view2 = [[ZBCycleView alloc]init];
//    self.view2.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.view1];
    [self addSubview:self.view2];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor clearColor];
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    self.clipsToBounds = YES;
}

// 执行动画
- (void)executeAnimation{
    [self setViewInfo];
    [UIView animateWithDuration:_animationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tmpMiddleView.frame = self.direction == ZBCycleVerticalViewScrollDirectionDown ? self->_btmRect : self->_topRect;
        if (self->_direction == ZBCycleVerticalViewScrollDirectionDown) {
            self.tmpTopView.frame = self->_middleRect;
        } else {
            self.tmpBtmView.frame = self->_middleRect;
        }
    }completion:^(BOOL finished) {
        self.tmpMiddleView.frame = self->_direction == ZBCycleVerticalViewScrollDirectionDown ? self->_topRect : self->_btmRect;
        if (self->_indexNow < self.dataArray.count - 1) {
            self->_indexNow ++;
        }else{
            self->_indexNow = 0;
        }
    }];
}

#pragma mark - set
- (void)setDirection:(ZBCycleVerticalViewScrollDirection)direction{
    _direction = direction;
    self.view2.frame = _direction == ZBCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (![_timer isValid]) {
        _indexNow = 0;
        [self startAnimation];
    }
}

- (void)setViewInfo{
    if (_direction == ZBCycleVerticalViewScrollDirectionDown) {
        if (self.view1.frame.origin.y == 0) {
            _tmpMiddleView = self.view1;
            _tmpTopView = self.view2;
        } else {
            _tmpMiddleView = self.view2;
            _tmpTopView = self.view1;
        }
    } else {
        if (self.view1.frame.origin.y == 0) {
            _tmpMiddleView = self.view1;
            _tmpBtmView = self.view2;
        } else {
            _tmpMiddleView = self.view2;
            _tmpBtmView = self.view1;
        }
    }
    _tmpMiddleView.dicData = _dataArray[_indexNow%(_dataArray.count)];
    if(_dataArray.count > 1){
        if (_direction == ZBCycleVerticalViewScrollDirectionDown) {
            _tmpTopView.dicData = _dataArray[(_indexNow+1)%(_dataArray.count)];
        } else {
            _tmpBtmView.dicData = _dataArray[(_indexNow+1)%(_dataArray.count)];
        }
    }
}

- (void)startAnimation{
    [self setViewInfo];
    if (_dataArray.count > 1) {
        [self stopTimer];
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.showTime target:weakSelf selector:@selector(executeAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

- (void)stopAnimation{
    [self stopTimer];
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc
{
    [ self stopAnimation];
    [_timer invalidate];
    _dataArray  = nil;
    _timer = nil;
}
#pragma mark -
- (void)stopTimer{
    if(_timer){
        if([_timer isValid]){
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)btnClick{
    if (self.block) {
        self.block(_indexNow);
    }
}

@end


@implementation ZBCycleView
    
{
      UILabel        *_titleLabel;
      UILabel        *_subLabel;
}
    
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithRed:44/255.0 green:43/255.0 blue:64/255.0 alpha:1.0];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_titleLabel];
        
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = [UIFont systemFontOfSize:13];
        _subLabel.textColor = [UIColor colorWithRed:235/255.0 green:85/255.0 blue:103/255.0 alpha:1.0];
        [self addSubview:_subLabel];
        
        [self setlayout];
    }
   
    return self;
}
-(void)setlayout {
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layou1 =  [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0.f];
    NSLayoutConstraint *layou2 =  [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f];
    NSLayoutConstraint *layou3 =  [NSLayoutConstraint constraintWithItem:_subLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:-1.f];
    NSLayoutConstraint *layou4 =  [NSLayoutConstraint constraintWithItem:_subLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f];
    NSLayoutConstraint *layou5 =  [NSLayoutConstraint constraintWithItem: _subLabel attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:  _titleLabel attribute:NSLayoutAttributeRight  multiplier:1.f constant:0.f];
    [layou5 setPriority:    UILayoutPriorityDefaultLow];
    NSLayoutConstraint *layou6 =  [NSLayoutConstraint constraintWithItem: _subLabel attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:  _titleLabel attribute:NSLayoutAttributeRight  multiplier:1.f constant:0.f];
    [layou6 setPriority:UILayoutPriorityDefaultHigh];

    
    [self addConstraints:@[layou1,layou2,layou3,layou4,layou5,layou6]];
}
    
    
- (void)setDicData:(NSDictionary *)dicData{
    _dicData = dicData;
    _titleLabel.text = dicData[@"title"];
    _subLabel.text = dicData[@"sub_title"];
}
@end
