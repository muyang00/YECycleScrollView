//
//  YECycleScrollView.m
//  YECycleScrollView
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YECycleScrollView.h"

typedef NS_ENUM(NSUInteger, ScrollViewDirection){//滚动方向
  ScrollViewDirectionLeft,
  ScrollViewDirectionRight
};
@interface YECycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) ScrollViewDirection scrollDirection;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YECycleScrollView
@synthesize color_pageControl = _color_pageControl, color_currentPageControl = _color_currentPageControl;

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images withIsRunloop:(BOOL)isRunloop withBlock:(ImageViewClick)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.dur = 3;
        self.imageCount = images.count ? images.count : 0;
        self.isRunloop = isRunloop;
        self.dataArray = images;
        self.click = block;
        [self loadBaseView];
    }
    return self;
}
//利用 3个 视图不断的切换，滑动结束的时候始终让1显示在屏幕中间。
- (void)loadBaseView{
    self.currentImageIndex = 0;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        if (i == 0 && self.dataArray != nil && self.dataArray.count > 1) {
            imageView.backgroundColor = self.dataArray[self.dataArray.count - 1];//left
        }
        if (i == 1 && self.dataArray != nil && self.dataArray.count > 0) {
            imageView.backgroundColor = self.dataArray[0];//中间
        }
        if (i == 2 && self.dataArray != nil && self.dataArray.count > 1){
            imageView.backgroundColor = self.dataArray[1];//right
        }
        [self.images addObject:imageView];
        [self.scrollView addSubview:imageView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

#pragma mark - set

- (void)setImageCount:(NSInteger)imageCount{
    _imageCount = imageCount;
    if (_imageCount < 1) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    self.scrollView.scrollEnabled = YES;
    self.pageControl.numberOfPages = imageCount;
    CGSize size = [self.pageControl sizeForNumberOfPages:imageCount];
    self.pageControl.center = CGPointMake(self.frame.size.width - size.width - 0., self.frame.size.height - 20.0);
    self.pageControl.currentPage = 0;
}

- (void)setIsRunloop:(BOOL)isRunloop{
    _isRunloop = isRunloop;
    if (isRunloop) {
        [self createTimer];
    }
}
- (void)setColor_pageControl:(UIColor *)color_pageControl{
    _color_pageControl = color_pageControl;
    self.pageControl.pageIndicatorTintColor = _color_pageControl;
}
//default whiteColor
- (UIColor *)color_pageControl{
    if (!_color_pageControl) {
        _color_pageControl = [UIColor whiteColor];
    }
    return _color_pageControl;
}
- (void)setColor_currentPageControl:(UIColor *)color_currentPageControl{
    _color_currentPageControl = color_currentPageControl;
    self.pageControl.currentPageIndicatorTintColor = _color_currentPageControl;
}
//default darkGrayColor
- (UIColor *)color_currentPageControl{
    if (!_color_currentPageControl) {
        _color_currentPageControl = [UIColor darkGrayColor];
    }
    return _color_currentPageControl;
}

- (void)createTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.dur target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - action

- (void)timerAction{
    if (_imageCount <= 1) return;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    [self performSelector:@selector(reloadImage) withObject:nil afterDelay:.35];
}

- (void)tapAction{
    if (self.click) {
        self.click(_currentImageIndex);
    }
}

#pragma mark - UIScrollViewDeleagte
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadImage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self createTimer];
}


#pragma mark - reloadImage
- (void)reloadImage{
    if (self.images.count == 0 || self.dataArray.count == 0){
        return;
    }
    NSInteger leftImageIndex, rightImageIndex;
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > self.frame.size.width) {//向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.dataArray.count;
    }else if (offset.x < self.frame.size.width){//向左滑动
        _currentImageIndex = (_currentImageIndex + self.dataArray.count - 1) % self.dataArray.count;
    }
    UIImageView *centerImageView = [self.images objectAtIndex:1];
    UIImageView *leftImageView = [self.images objectAtIndex:0];
    UIImageView *rightImageView = [self.images objectAtIndex:2];
    centerImageView.backgroundColor = self.dataArray[_currentImageIndex];
    
    //重新设置left ， right 图片
    leftImageIndex = (_currentImageIndex + self.dataArray.count - 1) % self.dataArray.count;
    rightImageIndex = (_currentImageIndex + 1) % self.dataArray.count;
    leftImageView.backgroundColor = self.dataArray[leftImageIndex];
    rightImageView.backgroundColor = self.dataArray[rightImageIndex];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = self.currentImageIndex;
}

#pragma mark - lazy

- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);//这里的3 是固定的，和轮播的数量没有关系
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = self.color_pageControl;
        _pageControl.currentPageIndicatorTintColor = self.color_currentPageControl;
    }
    return _pageControl;
}

- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
