//
//  DSYDottedLineView.m
//  hangban
//
//  Created by 盛美 on 2017/3/8.
//  Copyright © 2017年 shengmei. All rights reserved.
//

#import "DSYDottedLineView.h"

@implementation DSYDottedLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.dashColor = [UIColor blackColor];
        self.dashW = 3;
        self.dashSpacing = 2;
    }
    return self;
}

-(void)setDashColor:(UIColor *)dashColor{
    _dashColor = dashColor;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGFloat lengths[] = {_dashW,_dashSpacing};
    CGContextSetStrokeColorWithColor(cont,_dashColor.CGColor);
    CGContextSetLineWidth(cont, 1);
    CGContextSetLineDash(cont, 0, lengths, 2);  //画虚线
    CGContextBeginPath(cont);
    CGContextMoveToPoint(cont, 0.0, rect.size.height - 1);    //开始画线
    CGContextAddLineToPoint(cont, rect.size.width, rect.size.height - 1);
    CGContextStrokePath(cont);
    
    //CGFontRelease(cont);
}

@end
