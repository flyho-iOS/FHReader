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

@interface FHPageViewController () <UIGestureRecognizerDelegate>

@end

@implementation FHPageViewController

+ (FHPageViewController *)configPageViewController {
    
    UIPageViewControllerTransitionStyle style;
    UIPageViewControllerNavigationOrientation orientation;
    NSString *key ;
    
    switch ([FHReadConfig shareConfiguration].style) {
        case FHReadPageTransitionStylePageCurl:
            style = UIPageViewControllerTransitionStylePageCurl;
            orientation = UIPageViewControllerNavigationOrientationHorizontal;
            key = UIPageViewControllerOptionSpineLocationKey;
            break;
        case FHReadPageTransitionStyleScrollVertical:
            style = UIPageViewControllerTransitionStyleScroll;
            orientation = UIPageViewControllerNavigationOrientationVertical;
            key = UIPageViewControllerOptionInterPageSpacingKey;
            break;
        case FHReadPageTransitionStyleScrollHorizontal:
            style = UIPageViewControllerTransitionStyleScroll;
            orientation = UIPageViewControllerNavigationOrientationHorizontal;
            key = UIPageViewControllerOptionInterPageSpacingKey;
            break;
        case FHReadPageTransitionStyleNone:
            style = UIPageViewControllerTransitionStylePageCurl;
            orientation = UIPageViewControllerNavigationOrientationHorizontal;
            key = UIPageViewControllerOptionSpineLocationKey;
            break;
        default:
            break;
    }
    NSDictionary *options = @{key : @(UIPageViewControllerSpineLocationNone)};
    return [[self alloc] initWithTransitionStyle:style
                           navigationOrientation:orientation
                                         options:options];
}

@end
