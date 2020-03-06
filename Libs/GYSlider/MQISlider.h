//
//  MQISlider.h
//  UXinyong
//
//  Created by CQSC  on 15/4/17.
//  Copyright (c) 2015年 _CHK_ . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchStateEnd) (CGFloat);
typedef void(^TouchStateChanged) (CGFloat);

typedef NS_ENUM(NSInteger, GYSliderDirection) {
    horizonal = 0,
    vertical
};

@interface MQISlider : UIControl

@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat ratioNum;//滑动的比值
@property (nonatomic, assign) GYSliderDirection direction;//方向
@property (nonatomic, copy) TouchStateChanged StateChanged;
@property (nonatomic, copy) TouchStateEnd StateEnd;

- (id)initWithFrame:(CGRect)frame direction:(GYSliderDirection)direction;

- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock;

- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock;


@end
