//
//  CodeInputView.m
//  JDZBorrower
//
//  Created by WangXueqi on 2018/4/20.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "CodeInputView.h"


//#define K_W 20

@interface CodeInputView()<UITextViewDelegate>
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * lines;
@property(nonatomic,strong)NSMutableArray <CALayer *> * bottomLines;
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;
@property(nonatomic,strong)UIColor * markColor ;
@property(nonatomic,strong)UIFont  * textFont ;

@end

@implementation CodeInputView

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum markColor:(UIColor*)markColor  font:(UIFont*)font selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.CodeBlock = CodeBlock;
        self.inputNum = inputNum;
        self.markColor = markColor;
        self.textFont = font;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat K_W = W/(self.inputNum)-10;
    CGFloat Padd = (self.bounds.size.width-self.inputNum*K_W)/(self.inputNum+1);
    [self addSubview:self.textView];
    self.textView.frame = CGRectMake(Padd, 0, W-Padd*2, H);
    UIColor* fillColor  = (self.markColor == nil) ? [UIColor redColor]: self.markColor;
    //默认编辑第一个.
    [self beginEdit];
    for (int i = 0; i < _inputNum; i ++) {
        UIView *subView = [UIView new];
        subView.frame = CGRectMake(Padd+(K_W+Padd)*i, 0, K_W, H);
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        [self addSubLayerWithFrame:CGRectMake(0, H-2, K_W, 2) backgroundColor:[UIColor lightGrayColor] backView:subView];
        //Label
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, K_W, H);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.font = self.textFont;
        [subView addSubview:label];
        //光标
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(K_W / 2, H*0.25, 2,H*0.5)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  fillColor.CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
        //把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
    }
}
    
-(void)cleanText {
    self.textView.text = @"";
    [self.textView resignFirstResponder];
    [self textViewDidChange:self.textView];
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = [textView.text uppercaseString];
    if (verStr.length > _inputNum) {
        textView.text = [textView.text substringToIndex:_inputNum];
    }
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
        [self endEdit];
    }
    if (self.CodeBlock) {
        self.CodeBlock(verStr);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
             self.bottomLines[i].backgroundColor = [self.lineSelColor CGColor];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
               self.bottomLines[i].backgroundColor = [[UIColor grayColor] CGColor];
        }
     
    }
}
//设置光标显示隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.lines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}

//开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
}
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 1;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
//对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (NSMutableArray *)bottomLines {
    if (!_bottomLines) {
        _bottomLines = [NSMutableArray array];
    }
    return _bottomLines;
}



- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _textView;
}

-(CALayer *)addSubLayerWithFrame:(CGRect)frame
                   backgroundColor:(UIColor *)color
                          backView:(UIView *)baseView

{
    CALayer * layer = [[CALayer alloc]init];
    layer.frame = frame;
    layer.backgroundColor = [color CGColor];
    [baseView.layer addSublayer:layer];
    [self.bottomLines addObject:layer];
    return layer;
}
@end
