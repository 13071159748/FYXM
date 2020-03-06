//
//  DSYDottedLineView.h
//  hangban
//
//  Created by 盛美 on 2017/3/8.
//  Copyright © 2017年 shengmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSYDottedLineView : UIView
///虚线宽度
@property(nonatomic,assign) CGFloat dashW;
///虚线间距
@property(nonatomic,assign) CGFloat dashSpacing;
///虚线颜色
@property (nonatomic,strong) UIColor *dashColor;

@end
