//
//  GYLabel.h
//  Reader
//
//  Created by CQSC  on 2017/3/29.
//  Copyright © 2017年  CQSC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface GYLabel : UILabel {
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;  

@end
