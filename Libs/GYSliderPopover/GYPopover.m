//
//  GYPopover.m
//  Reader
//
//  Created by CQSC  on 16/10/9.
//  Copyright © 2016年  CQSC. All rights reserved.
//

#import "GYPopover.h"

@implementation GYPopover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.layer.cornerRadius = 5;
        self.textLabel.layer.masksToBounds = YES;
        self.opaque = NO;
        
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat y = (frame.size.height - 26) / 3;
    
    if (frame.size.height < 38)
        y = 0;
    
    self.textLabel.frame = CGRectMake(0, y, frame.size.width, 35);
}

- (void)drawRect:(CGRect)rect {
    
//    CGFloat width = 4; //三角形的宽度
//    
//    [[UIColor clearColor] set];
//    
//    UIRectFill([self bounds]);
//    
//    //拿到当前视图准备好的画板
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    
//    CGContextMoveToPoint(context, CGRectGetWidth(self.bounds)/2-width/2, 26);//设置起点
//    
//    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds)/2+width/2, 26);
//    
//    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor blackColor] setFill]; //设置填充色
//    
//    [[UIColor blackColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}


@end

