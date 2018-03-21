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
#import "FHReadConfig.h"

@interface FHPageViewController ()

@end

@implementation FHPageViewController

+ (FHPageViewController *)configPageViewController {
    UIPageViewControllerTransitionStyle style = UIPageViewControllerTransitionStylePageCurl;
    UIPageViewControllerNavigationOrientation orientation = UIPageViewControllerNavigationOrientationHorizontal;
    NSString *key = style == UIPageViewControllerTransitionStylePageCurl ? UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerOptionInterPageSpacingKey;
    NSDictionary *options = @{key : @(UIPageViewControllerSpineLocationNone)};
    return [[self alloc] initWithTransitionStyle:style
                           navigationOrientation:orientation
                                         options:options];
}

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options {
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        self.view.backgroundColor = [FHReadConfig getConfig].themeColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
