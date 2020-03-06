//
//  GYStar.h
//  Reader
//
//  Created by CQSC  on 2017/3/31.
//  Copyright © 2017年  CQSC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYStar;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};

@protocol GYStarDelegate <NSObject>

-(void)starRateView:(GYStar *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface GYStar : UILabel

@property (nonatomic,assign)BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic,assign)RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic, weak) id<GYStarDelegate>delegate;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic,assign)CGFloat currentScore;   // 当前评分：0-5  默认0

-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;


-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end
