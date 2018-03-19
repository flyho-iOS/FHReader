//
//  FHPageViewController.m
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHPageViewController.h"
#import "AppDefine.h"
#import "FHConstant.h"

@interface FHPageViewController ()

@end

@implementation FHPageViewController

+ (FHPageViewController *)configPageViewController {
    UIPageViewControllerTransitionStyle style = [[FHUserDefault objectForKey:FHReadPageTransitionStyleKey] integerValue];
    UIPageViewControllerNavigationOrientation orientation = UIPageViewControllerNavigationOrientationHorizontal;
    NSString *key = style == UIPageViewControllerTransitionStylePageCurl ? UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerOptionInterPageSpacingKey;
    NSDictionary *options = @{key : @(UIPageViewControllerSpineLocationNone)};
    return [[self alloc] initWithTransitionStyle:style
                           navigationOrientation:orientation
                                         options:options];
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
