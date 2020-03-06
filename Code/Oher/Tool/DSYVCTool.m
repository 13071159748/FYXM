//
//  DSYVCTool.m
//
//  Created by DSY on 2016/12/19.
//  Copyright © 2016年 DSY. All rights reserved.
//

#import "DSYVCTool.h"
#import <MJRefresh/MJRefresh.h>

@interface DSYVCTool ()

@end


@implementation DSYVCTool

static DSYVCTool * _tool;


+(void)dsyAddMJNormalHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL) HAction
{
    scrollView.mj_header = nil;
    MJRefreshNormalHeader *  header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:HAction];
    // 设置文字
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    // 透明度自动调整
    header.automaticallyChangeAlpha = YES;
 
    // 设置刷新控件
    scrollView.mj_header = header;
}

+(void)dsyAddMJgifHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL)  HAction  gifImages:(NSArray*) images
{
    
    scrollView.mj_header = nil;
    MJRefreshGifHeader * gifHeader = [MJRefreshGifHeader  headerWithRefreshingTarget:self refreshingAction:HAction];
    
    gifHeader.stateLabel.hidden = NO;
    gifHeader.lastUpdatedTimeLabel.hidden = NO;
    [gifHeader setImages:images forState:MJRefreshStateIdle];
    [gifHeader setImages:images duration:1.5 forState:MJRefreshStateRefreshing];
 
    // 设置文字
    [gifHeader setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [gifHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [gifHeader setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
  
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    // 设置字体
    gifHeader.stateLabel.font = [UIFont systemFontOfSize:15];
    gifHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    gifHeader.stateLabel.textColor = [UIColor blackColor];
    gifHeader.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    // 透明度自动调整
    gifHeader.automaticallyChangeAlpha = YES;
    scrollView.mj_header = gifHeader;
}


+(void)dsyAddMJNormalFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction
{
    scrollView.mj_footer = nil;
    //上拉
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:FAction];
    // 设置文字
    [footer setTitle:@"加载更多数据" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载数据"  forState:MJRefreshStateIdle];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor blackColor];
    // 透明度自动调整
    footer.automaticallyChangeAlpha = YES;
    // 设置footer
    scrollView.mj_footer = footer;

}

+(void)dsyAddMJGifFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction  gifImages:(NSArray*) images
{
    scrollView.mj_footer = nil;
    MJRefreshBackGifFooter * gifFooter  = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:FAction];
    gifFooter.stateLabel.hidden = NO;
    [gifFooter setImages:images forState:MJRefreshStateIdle];
    [gifFooter setImages:images duration:1.5 forState:MJRefreshStateRefreshing];
    [gifFooter setTitle:@"加载更多数据" forState:MJRefreshStatePulling];
    [gifFooter setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
    [gifFooter setTitle:@"加载数据"  forState:MJRefreshStateIdle];
    
    // 设置字体
    gifFooter.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    gifFooter.stateLabel.textColor = [UIColor blackColor];
    // 透明度自动调整
    gifFooter.automaticallyChangeAlpha = YES;
    // 设置footer
    scrollView.mj_footer = gifFooter;

}


/*  更改固定数据时调用方法  */

+(void)dsyAddMJNormalHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL) HAction  model:(DSYVCToolModel*) model
{
    scrollView.mj_header = nil;
    MJRefreshNormalHeader *  header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:HAction];
    
    if (!model) {
        scrollView.mj_header = header;
        return ;
        
    }
    // 设置文字
    [header setTitle: model.pullingStr forState:MJRefreshStatePulling];
    [header setTitle: model.refreshingStr forState:MJRefreshStateRefreshing];
    [header setTitle: model.idleStr  forState:MJRefreshStateIdle];
    
    header.stateLabel.hidden = model.stateHidden;
    header.lastUpdatedTimeLabel.hidden = model.updatedHidden;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:model.stateFont];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:model.updatedFont];
    /// 忽略高度
    header.ignoredScrollViewContentInsetTop = model.ignoredScrollViewContentInsetTop;
    // 设置颜色
    header.stateLabel.textColor = model.stateColor;
    header.lastUpdatedTimeLabel.textColor = model.updatedColor;
    // 透明度自动调整
    header.automaticallyChangeAlpha = model.changeAlpha;
    // 设置刷新控件
    scrollView.mj_header = header;
    model = nil;
}

+(void)dsyAddMJgifHeade:(UIScrollView *)scrollView  refreshHFTarget:(id)target MJHeaderAction:(SEL)  HAction  model:(DSYVCToolModel*) model
{
    scrollView.mj_header = nil;
    MJRefreshGifHeader * gifHeader = [MJRefreshGifHeader  headerWithRefreshingTarget:self refreshingAction:HAction];
    
    gifHeader.stateLabel.hidden = model.stateHidden;
    gifHeader.lastUpdatedTimeLabel.hidden = model.updatedHidden;
    [gifHeader setImages:model.gifImgArr forState:MJRefreshStateIdle];
    [gifHeader setImages:model.gifImgArr duration:model.cycleTime  forState:MJRefreshStateRefreshing];
    
    // 设置文字
    [gifHeader setTitle:model.pullingStr forState:MJRefreshStatePulling];
    [gifHeader setTitle:model.refreshingStr forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:model.idleStr forState:MJRefreshStateIdle];
    
    gifHeader.lastUpdatedTimeLabel.hidden = model.updatedHidden;
    // 设置字体
    gifHeader.stateLabel.font = [UIFont systemFontOfSize:model.stateFont];
    gifHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:model.updatedFont];
    gifHeader.ignoredScrollViewContentInsetTop = model.ignoredScrollViewContentInsetTop;
    // 设置颜色
    gifHeader.stateLabel.textColor = model.stateColor;
    gifHeader.lastUpdatedTimeLabel.textColor = model.updatedColor;
    // 透明度自动调整
    gifHeader.automaticallyChangeAlpha = model.changeAlpha;
    scrollView.mj_header = gifHeader;
     model = nil;
}


+(void)dsyAddMJNormalFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction  model:(DSYVCToolModel*) model
{
    scrollView.mj_footer = nil;
    //上拉
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:FAction];
    if (!model) {
        scrollView.mj_footer = footer;
        return ;
    }
    // 设置文字
    [footer setTitle:model.pullingStr forState:MJRefreshStatePulling];
    [footer setTitle:model.refreshingStr forState:MJRefreshStateRefreshing];
    [footer setTitle:model.idleStr  forState:MJRefreshStateIdle];
   
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:model.stateFont];
    // 设置颜色
    footer.stateLabel.textColor = model.stateColor;
    // 透明度自动调整
    footer.automaticallyChangeAlpha = model.changeAlpha;
    footer.ignoredScrollViewContentInsetBottom = model.ignoredScrollViewContentInsetBottom;
    // 设置footer
    scrollView.mj_footer = footer;
     model = nil;
    
}

+(void)dsyAddMJGifFooter:(UIScrollView *)scrollView  refreshHFTarget:(id)target  MJFooterAction:(SEL) FAction  model:(DSYVCToolModel*) model
{
    scrollView.mj_footer = nil;
    MJRefreshBackGifFooter * gifFooter  = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:FAction];
    gifFooter.stateLabel.hidden = model.updatedHidden;
    [gifFooter setImages:model.gifImgArr forState:MJRefreshStateIdle];
    [gifFooter setImages:model.gifImgArr  duration:model.cycleTime forState:MJRefreshStateRefreshing];
    [gifFooter setTitle:model.pullingStr forState:MJRefreshStatePulling];
    [gifFooter setTitle:model.refreshingStr forState:MJRefreshStateRefreshing];
    [gifFooter setTitle:model.idleStr  forState:MJRefreshStateIdle];
    
    // 设置字体
    gifFooter.stateLabel.font = [UIFont systemFontOfSize:model.stateFont];
    // 设置颜色
    gifFooter.stateLabel.textColor = model.stateColor;
    // 透明度自动调整
    gifFooter.automaticallyChangeAlpha = YES;
    gifFooter.ignoredScrollViewContentInsetBottom = model.ignoredScrollViewContentInsetBottom;
    // 设置footer
    scrollView.mj_footer = gifFooter;
     model = nil;
    
}


+(void)dsyBeginRefresh:(UIScrollView*) scr{
    
    [scr.mj_header beginRefreshing];
}

+(void)dsyEndRefresh:(UIScrollView*) scr{
  [scr.mj_footer endRefreshing];
  [scr.mj_header endRefreshing];
}


@end


@implementation DSYVCToolModel

/// 模型初始化方法
+(void)dsyCreatedM:(void (^) (DSYVCToolModel* make))mBlock{
    if (mBlock) {
        mBlock([DSYVCToolModel new]);
    }
}


@end


