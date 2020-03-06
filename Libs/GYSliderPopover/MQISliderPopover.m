//
//  MQISliderPopover.m
//  Reader
//
//  Created by CQSC  on 16/10/9.
//  Copyright © 2016年  CQSC. All rights reserved.
//

#import "MQISliderPopover.h"

@implementation MQISliderPopover

#pragma mark -
#pragma mark UISlider methods

- (GYPopover *)popover
{
    if (_popover == nil) {
        //Default size, can be changed after
        [self addTarget:self action:@selector(updatePopoverFrame) forControlEvents:UIControlEventValueChanged];
        
        _popover = [[GYPopover alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2, self.frame.origin.y - 50, 40, 50)];
        [self updatePopoverFrame];
        _popover.alpha = 0;
        [self.superview addSubview:_popover];
    }
    
    return _popover;
}

- (void)setValue:(float)value
{
    [super setValue:value];
    [self updatePopoverFrame];
}

- (void)setPopoverTitle:(NSString *)popoverTitle {
    _popover.alpha = 1;
    _popoverTitle = popoverTitle;
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 32);
    
    CGFloat width = [popoverTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _popover.textLabel.font} context:nil].size.width;
    _popover.textLabel.text = popoverTitle;
    
    CGRect rect = _popover.frame;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width-width-20)/2;
    rect.size.width = width+20;
    _popover.frame = rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self updatePopoverFrame];
//    [self showPopoverAnimated:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(sliderSelectedValue:)] == YES) {
        [self.sDelegate sliderSelectedValue:self.value];
    }
//    [self hidePopoverAnimated:YES];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self hidePopoverAnimated:YES];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark -
#pragma mark - Popover methods

- (void)updatePopoverFrame
{
//    CGFloat minimum =  self.minimumValue;
//    CGFloat maximum = self.maximumValue;
//    CGFloat value = self.value;
//    
//    if (minimum < 0.0) {
//        
//        value = self.value - minimum;
//        maximum = maximum - minimum;
//        minimum = 0.0;
//    }
//    
//    CGFloat x = self.frame.origin.x;
//    CGFloat maxMin = (maximum + minimum) / 2.0;
//    
//    if (maximum-minimum > 0) {
//        x += (((value - minimum) / (maximum - minimum)) * self.frame.size.width) - (self.popover.frame.size.width / 2.0);
//    }
//    if (value > maxMin) {
//        
//        value = (value - maxMin) + (minimum * 1.0);
//        value = value / maxMin;
//        value = value * 11.0;
//        
//        x = x - value;
//        
//    } else {
//        
//        value = (maxMin - value) + (minimum * 1.0);
//        value = value / maxMin;
//        value = value * 11.0;
//        
//        x = x + value;
//    }
    
    CGRect popoverRect = self.popover.frame;
//    CGFloat differ = self.popover.frame.size.width+x - [UIScreen mainScreen].bounds.size.width;
//    if (differ > 0) {
//        popoverRect.origin.x = x-differ-5;
//    }else  if (x <= 0) {
//        popoverRect.origin.x = 5;
//    }else {
//        popoverRect.origin.x = x;
//    }
    popoverRect.origin.x = ([UIScreen mainScreen].bounds.size.width-popoverRect.size.width)/2;
    popoverRect.origin.y = self.frame.origin.y - popoverRect.size.height - 1;
    
    self.popover.frame = popoverRect;
}

- (void)showPopover
{
    [self showPopoverAnimated:NO];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 1.0;
        }];
    } else {
        self.popover.alpha = 1.0;
    }
}

- (void)hidePopover
{
    [self hidePopoverAnimated:NO];
}

- (void)hidePopoverAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 0;
        }];
    } else {
        self.popover.alpha = 0;
    }
}

@end

