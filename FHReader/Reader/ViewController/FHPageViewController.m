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
//    UIPageViewControllerTransitionStyle style = UIPageViewControllerTransitionStylePageCurl;
//    UIPageViewControllerNavigationOrientation orientation = UIPageViewControllerNavigationOrientationHorizontal;
//    NSString *key = style == UIPageViewControllerTransitionStylePageCurl ? UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerOptionInterPageSpacingKey;
//    NSDictionary *options = @{key : @(UIPageViewControllerSpineLocationNone)};
    
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

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options {
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        self.view.backgroundColor = [FHReadConfig shareConfiguration].themeColor;
        [self fixGestureConflict];
    }
    return self;
}

- (void)fixGestureConflict {
//    UIScrollView *scrollView;
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            scrollView = (UIScrollView *)view;
//            break;
//        }
//    }
//    for (UIGestureRecognizer *ges in scrollView.gestureRecognizers) {
//        if ([ges isKindOfClass:[UIGestureRecognizer class]]) {
//            ges.delegate = self;
//        }
//        
//    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return YES;
}

@end
