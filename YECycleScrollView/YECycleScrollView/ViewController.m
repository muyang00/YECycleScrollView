//
//  ViewController.m
//  YECycleScrollView
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "ViewController.h"
#import "YECycleScrollView.h"

#define  RGBColor(x,y,z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define KRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i ++) {
        [images addObject:RGBColor(arc4random()%255, arc4random()%255, arc4random()%255)];
        //[images addObject:KRandomColor];
    }
    YECycleScrollView *scroll = [[YECycleScrollView alloc] initWithFrame:rect withImages:images withIsRunloop:YES withBlock:^(NSInteger index) {
        NSLog(@"点击了index%zd",index);
    }];
    [self.view addSubview:scroll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
