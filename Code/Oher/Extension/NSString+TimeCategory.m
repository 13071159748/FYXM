//
//  NSString+TimeCategory.m
//  Reader
//
//  Created by CQSC  on 2017/7/13.
//  Copyright © 2017年  CQSC. All rights reserved.
//

#import "NSString+TimeCategory.h"

@implementation NSString (TimeCategory)

+ (NSString *) gd_timeInterval_DaysWithSeconds:(long)seconds {
    NSString *time_day = [NSString stringWithFormat:@"%02ld",seconds/86400];
    return time_day;
}
+ (NSString *) gd_timeInterval_HoursWithSeconds:(long)seconds {
    NSString *time_hour = [NSString stringWithFormat:@"%02ld",(seconds%86400)/3600];
    return time_hour;
}
+ (NSString *) gd_timeInterval_MinutesWithSeconds:(long)seconds {
    NSString *time_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    return time_minute;
}
+ (NSString *) gd_timeInterval_secondsWithSeconds:(long)seconds {
    NSString *time_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    return time_second;
}
+ (void)RuoKanGuoShen {
    
}
@end
