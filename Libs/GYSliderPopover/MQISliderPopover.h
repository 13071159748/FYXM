//
//  MQISliderPopover.h
//  Reader
//
//  Created by CQSC  on 16/10/9.
//  Copyright © 2016年  CQSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPopover.h"

@protocol MQISliderPopoverDelegate <NSObject>

- (void)sliderSelectedValue:(CGFloat)value;

@end

@interface MQISliderPopover : UISlider

@property (nonatomic, strong) GYPopover *popover;
@property (nonatomic, assign) id<MQISliderPopoverDelegate>sDelegate;
@property (nonatomic, copy) NSString *popoverTitle;

- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;
- (void)hidePopoverAnimated:(BOOL)animated;

@end
