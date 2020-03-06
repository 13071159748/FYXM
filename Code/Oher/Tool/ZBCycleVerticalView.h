//
//  ZBCycleVerticalView.h
//  DeRong
//
//  Created by 周博 on 2019/1/7.
//  Copyright © 2019 周博. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ZBCycleVerticalViewScrollDirection) {
    ZBCycleVerticalViewScrollDirectionUp = 0,
    ZBCycleVerticalViewScrollDirectionDown
};

typedef void(^ClickBlock)(NSInteger index);

@interface ZBCycleVerticalView : UIView

@property (assign, nonatomic) ZBCycleVerticalViewScrollDirection direction;
@property (strong, nonatomic) NSArray *dataArray;  // 数据源
@property (copy, nonatomic) ClickBlock block;
@property (assign, nonatomic) double showTime;///timer循环时长
// 开启动画（默认是开启的）
- (void)startAnimation;

// 关闭动画
- (void)stopAnimation;

@end


@interface ZBCycleView : UIView
    
@property (strong, nonatomic) NSDictionary *dicData;

@end

NS_ASSUME_NONNULL_END

