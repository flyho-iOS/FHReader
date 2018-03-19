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
    FHChapter *_currentChapter;
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
        _content = [FHReadContent createContentWithFile:contentPath];
        _currentChapter = _content.chapters[0];
        _currentPage = 1;
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark UIPageViewControllerDelegate
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (_currentChapter.chapterNo == 1 && _currentPage == 1) return nil;
    
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    _currentPage --;
    ContentViewController *contentVC = [ContentViewController createPageWithChapter:_content.chapters[_currentPage]];
    return contentVC;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (_currentChapter.chapterNo == _content.totalChapter  && _currentPage == [_currentChapter getPageCount]) return nil;
    
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    _currentPage ++;
    ContentViewController *contentVC = [ContentViewController createPageWithChapter:_content.chapters[_currentPage]];
    return contentVC;
}

#pragma mark - lazy load
- (FHPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [FHPageViewController configPageViewController];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        ContentViewController *contentVC = [ContentViewController createPageWithChapter:_currentChapter];
        _pageViewController.doubleSided = _pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl;
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    return _pageViewController;
}

@end
