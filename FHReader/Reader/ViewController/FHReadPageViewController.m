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
    NSInteger _currentPaginateNo;
    ContentViewController *_fontVC;
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
        _currentPaginateNo = 0;
        FHPaginateContent *pc = _content.paginateContents[_currentPaginateNo];
        ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    BOOL isSwipeForward = NO;
    ContentViewController *preVC = (ContentViewController *)[previousViewControllers lastObject];
    if ((preVC.paginateContent.chapterNo < _fontVC.paginateContent.chapterNo) || (preVC.paginateContent.chapterNo == _fontVC.paginateContent.chapterNo && preVC.paginateContent.pageNo < _fontVC.paginateContent.pageNo)) {
        isSwipeForward = YES;
    }
    if (finished && completed) {
        if (isSwipeForward) {
            _currentPaginateNo ++;
        }else{
            _currentPaginateNo --;
        }
        NSLog(@"第%ld章,第%ld页,共%ld页,第%ld页",[_content.paginateContents[_currentPaginateNo] chapterNo]+1,[_content.paginateContents[_currentPaginateNo] pageNo]+1,_content.paginateContents.count,_currentPaginateNo+1);
    }
    // 翻页完成后开启交互，防止翻页过快导致页码定位错误
    if (finished) {
        self.pageViewController.view.userInteractionEnabled = YES;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _pageViewController.view.userInteractionEnabled = NO; //关掉用户交互
    _fontVC = (ContentViewController *)[pendingViewControllers lastObject];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
//    if (_currentChapterNo == 0 && _currentPage == 0) return nil; //第一张第一页不能再向前翻
//
//    FHChapter *chapter;
//    if (_currentPage == 0) {
//        _currentChapterNo --;
//        chapter = _content.chapters[_currentChapterNo];
//        _currentPage = chapter.pageCount-1;
//    }else{
//        _currentPage --;
//        chapter = _content.chapters[_currentChapterNo];
//    }
    
    if (_currentPaginateNo == 0) return nil;
    
    NSInteger cpn = _currentPaginateNo-1;
    FHPaginateContent *pc = _content.paginateContents[cpn];
    
    ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:contentVC];
    }
    return contentVC;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    
//    NSInteger currentPageNo = 0;
//    NSInteger currentChapNo = 0;
//    if (_currentPage == currentChapter.pageCount-1) {
//        currentPageNo = _currentChapterNo+1 ;
//        currentChapNo = 0;
//    }else{
//        currentPageNo = _currentPage + 1;
//    }
    
    NSInteger cpn = _currentPaginateNo + 1;
    
    if (cpn > _content.paginateContents.count-1) return nil;
    
    FHPaginateContent *pc = _content.paginateContents[cpn];
    ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
    return contentVC;
}

#pragma mark - lazy load
- (FHPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [FHPageViewController configPageViewController];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.doubleSided = _pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl;
    }
    return _pageViewController;
}

@end
