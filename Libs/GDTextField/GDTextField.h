//
//  GDTextField.h
//  XUIPhone
//
//  Created by xiaoyu on 16/2/26.
//  Copyright © 2016年 guoda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GDTFBlock)(NSString *text);

@interface GDTextField : UITextField

@property (nonatomic, copy) GDTFBlock textBlock;

@property (nonatomic, copy) NSString* nihao;

@end
