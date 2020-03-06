//
//  NSString+TimeCategory.h
//  Reader
//
//  Created by CQSC  on 2017/7/13.
//  Copyright © 2017年  CQSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeCategory)

+ (NSString *) gd_timeInterval_DaysWithSeconds:(long)seconds;

+ (NSString *) gd_timeInterval_HoursWithSeconds:(long)seconds;

+ (NSString *) gd_timeInterval_MinutesWithSeconds:(long)seconds;

+ (NSString *) gd_timeInterval_secondsWithSeconds:(long)seconds;

@end
