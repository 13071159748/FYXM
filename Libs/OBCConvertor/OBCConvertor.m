//
//  OBCConvertor.m
//
//  Created by Bill Cheng on 11/1/13.
//  Copyright 2013 R3 Studio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "OBCConvertor.h"

static OBCConvertor * instance=nil;

@implementation OBCConvertor
@synthesize string_GB = _string_GB;
@synthesize string_BIG5 = _string_BIG5;

+ (OBCConvertor*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[OBCConvertor alloc] init];
        }
    }
    return instance;
}


-(id)init
{
    if(self = [super init])
    {
        NSError *error;
        NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
        self.string_GB = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"gb.txt"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
        self.string_BIG5 = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"big5.txt"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    }
    
    return self;
}


//简体转繁体
-(NSString*)s2t:(NSString*)srcString
{
    NSInteger length = [srcString length];
    for (NSInteger i = 0; i< length; i++)
    {
        NSString *string = [srcString substringWithRange:NSMakeRange(i, 1)];
        NSRange gbRange = [_string_GB rangeOfString:string];
        if(gbRange.location != NSNotFound)
        {
            NSString *big5String = [_string_BIG5 substringWithRange:gbRange];
            srcString = [srcString stringByReplacingCharactersInRange:NSMakeRange(i, 1)
                                                           withString:big5String];
        }
    }
    
    return srcString;
}

//繁体转简体
-(NSString*)t2s:(NSString*)srcString
{
    NSInteger length = [srcString length];
    for (NSInteger i = 0; i< length; i++)
    {
        NSString *string = [srcString substringWithRange:NSMakeRange(i, 1)];
        NSRange big5Range = [_string_BIG5 rangeOfString:string];
        if(big5Range.location != NSNotFound)
        {
            NSString *gbString = [_string_GB substringWithRange:big5Range];
            srcString = [srcString stringByReplacingCharactersInRange:NSMakeRange(i, 1)
                                                           withString:gbString];
        }
    }
    
    return srcString;
}

@end
