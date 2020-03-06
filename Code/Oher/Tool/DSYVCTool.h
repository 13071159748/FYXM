//
//  DSYVCTool.h

//
//  Created by DSY on 2016/12/19.
//  Copyright © 2016年 DSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DSYVCToolModel;
@interface DSYVCTool : NSObject

/**
 mj默认下拉刷新控件

 @param scrollView 当前添加视图
 @param target 绑定对象
 @param HAction 上拉方法
 */
+(void)dsyAddMJNormalHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL) HAction;

/**
 mjGif下拉刷新控件

 @param scrollView 当前添加视图
 @param target 绑定对象
 @param HAction 上拉方法
 @param images GIF 图片数组
 */
+(void)dsyAddMJgifHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL)  HAction  gifImages:(NSArray*) images;


/**
  mj默认上拉刷新控件

 @param scrollView 当前添加视图
 @param target 绑定对象
 @param FAction 上拉方法
 */
+(void)dsyAddMJNormalFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction;


/**
 mjGIF上拉刷新控件

 @param scrollView 当前添加视图
 @param target 绑定对象
 @param FAction 上拉方法
 @param images GIF 图片数组
 */
+(void)dsyAddMJGifFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction  gifImages:(NSArray*) images;


/*  更改固定数据时调用方法  */
/**
 mj默认下拉刷新控件
 
 @param scrollView 当前添加视图
 @param target 绑定对象
 @param HAction 上拉方法
 @param model 改变固定数据模型
 */
+(void)dsyAddMJNormalHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL) HAction model:(DSYVCToolModel*) model;


/**
 mjGif下拉刷新控件
 
 @param scrollView 当前添加视图
 @param target 绑定对象
 @param HAction 上拉方法
 @param model 改变固定数据模型
 */
+(void)dsyAddMJgifHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL)  HAction  model:(DSYVCToolModel*) model;


/**
 mj默认上拉刷新控件
 
 @param scrollView 当前添加视图
 @param target 绑定对象
 @param FAction 上拉方法
 @param model 改变固定数据模型
 */
+(void)dsyAddMJNormalFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction model:(DSYVCToolModel*) model;


/**
 mjGIF上拉刷新控件
 
 @param scrollView 当前添加视图
 @param target 绑定对象
 @param FAction 上拉方法
 @param model 改变固定数据模型
 */
+(void)dsyAddMJGifFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction  model:(DSYVCToolModel*) model;


/**
 开始刷新
 
 @param scr  开始对象
 */
+(void)dsyBeginRefresh:(UIScrollView*) scr;


/**
  结束刷新

 @param scr  结束对象
 */
+(void)dsyEndRefresh:(UIScrollView*) scr;

@end

@class DSYVCToolModel;
@interface DSYVCToolModel : NSObject

/// 模型初始化方法
+(void)dsyCreatedM:(void (^) (DSYVCToolModel* make))mBlock;

/// 下拉文字
@property(nonatomic,copy)NSString* pullingStr;
/// 开始刷新文字  
@property(nonatomic,copy)NSString* refreshingStr;
/// 闲置文字
@property(nonatomic,copy)NSString* idleStr;
/// 文字大小
@property(nonatomic,assign)CGFloat stateFont;
/// 文字颜色
@property(nonatomic,strong)UIColor* stateColor;
/// 下拉调整透明度
@property(nonatomic,assign)BOOL changeAlpha;
/// 下拉忽略高度
@property(nonatomic,assign)CGFloat ignoredScrollViewContentInsetTop;
/// 上提忽略高度
@property(nonatomic,assign)CGFloat ignoredScrollViewContentInsetBottom;

/* 下拉数据用到 */
/// 是否显示更新时间文字
@property(nonatomic,assign) BOOL updatedHidden;
/// 是否显示文字
@property(nonatomic,assign) BOOL stateHidden;
/// 更新文字大小
@property(nonatomic,assign)CGFloat updatedFont;
/// 更新文字颜色
@property(nonatomic,strong)UIColor*  updatedColor;

/* 下拉数据用到 */
/// gif周期时间
@property(nonatomic,assign)CGFloat  cycleTime;
/// 图片数组
@property(nonatomic,strong)NSArray<UIImage*> * gifImgArr;

@end





