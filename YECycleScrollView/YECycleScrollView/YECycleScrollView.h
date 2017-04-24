//
//  YECycleScrollView.h
//  YECycleScrollView
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImageViewClick)(NSInteger index);

@interface YECycleScrollView : UIView
//是否开启定时器 default NO
@property (nonatomic, assign) BOOL isRunloop;
//轮播时间间隔 default 3秒
@property (nonatomic, assign) NSTimeInterval dur;
@property (nonatomic, strong) UIColor *color_pageControl;
@property (nonatomic, strong) UIColor *color_currentPageControl;
@property (nonatomic, strong) ImageViewClick click;
- (instancetype)initWithFrame:(CGRect)frame
                   withImages:(NSArray *)images
                withIsRunloop:(BOOL)isRunloop
                    withBlock:(ImageViewClick)block;

@end
