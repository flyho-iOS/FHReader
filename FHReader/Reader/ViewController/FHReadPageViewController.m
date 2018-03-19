//
//  FHReadPageViewController.m
//  FHReader
//
//  Created by fly on 2018/3/3.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadPageViewController.h"
#import "FHPageViewController.h"
#import "ContentViewController.h"
#import "FHBackViewController.h"
#import "FHReadContent.h"

@interface FHReadPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSInteger _currentPage;
    FHChapter *_curretChapter;
}
@property (nonatomic,strong) FHPageViewController *pageViewController;
@property (nonatomic,strong) FHReadContent *content;

@end

@implementation FHReadPageViewController

+ (instancetype)createReaderWithContentPath:(NSString *)contentPath {
    return [[self alloc] initWithContentPath:contentPath];
}

- (instancetype)initWithContentPath:(NSString *)contentPath {
    if (self = [super init]) {
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        _content = [FHReadContent createContentWithFile:contentPath];
        _curretChapter = _content.chapters[0];
        _currentPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark UIPageViewControllerDelegate
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    if (_curretChapter.chapterNo == 0 && _currentPage == 0) return nil;
    
    ContentViewController *contentVC = [ContentViewController createPageWithChapter:_content.chapters[0]];
    return contentVC;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    return contentVC;
}

#pragma mark - lazy load
- (FHPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [FHPageViewController configPageViewController];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        ContentViewController *contentVC = [[ContentViewController alloc] init];
        _pageViewController.doubleSided = _pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl;
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    return _pageViewController;
}

@end
