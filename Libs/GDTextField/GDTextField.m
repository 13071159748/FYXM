//
//  GDTextField.m
//  XUIPhone
//
//  Created by xiaoyu on 16/2/26.
//  Copyright © 2016年 guoda. All rights reserved.
//

#import "GDTextField.h"

@interface GDTextField ()<UITextFieldDelegate>
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}

@end
@implementation GDTextField

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self addTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)reformatAsCardNumber:(UITextField*)textField {
    if ([textField.text length] > 11) {
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        return;
    }
}

- (BOOL)textField                       :(UITextField *)textField
        shouldChangeCharactersInRange   :(NSRange)range
        replacementString               :(NSString *)string
{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    if (self.textBlock) {
        self.textBlock(previousTextFieldContent);
    }
    
    return YES;
}
@end
