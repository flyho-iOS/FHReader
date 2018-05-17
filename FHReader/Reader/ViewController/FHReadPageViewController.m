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
#import "FHReaderBar.h"
#import "FHDrawerCache.h"
#import "FHContentSourceProtocol.h"
#import "FHSourceLocalManager.h"

@interface FHReadPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource,FHReaderBarDelegate>
{
    NSInteger _currentPaginateNo;
    ContentViewController *_frontVC; //当前页面
}
@property (nonatomic,strong) FHPageViewController *pageViewController;
@property (nonatomic,strong) FHReaderBar *readerToolBar;
@property (nonatomic,strong) FHReadContent *content;
@property (nonatomic,strong) id<FHContentSourceProtocol> manager;

@end

@implementation FHReadPageViewController

- (void)dealloc {
    FHDeallocLog();
}

+ (instancetype)createReaderWithBookId:(NSInteger)bookId {
    return [[self alloc] initWithBookId:bookId];
}

- (instancetype)initWithBookId:(NSInteger)bookId {
    if (self = [super init]) {
        _bookId = bookId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestData];
}

- (void)initUI {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.readerToolBar];
}

- (void)requestData {
    
    self.manager = [FHSourceLocalManager new];
    
    [self.manager fetchContentWithBookId:self.bookId success:^(id<FHContentSourceProtocol> manager) {
        
        FHPaginateContent *pc = [self.manager currentPageContent];
        ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
        _frontVC = contentVC;
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    } andFailure:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - statusBar
- (BOOL)prefersStatusBarHidden {
    return self.readerToolBar.isHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"点击位置 --> x=%f,y=%f",point.x,point.y);
    if (point.x > 30 && point.x < FHScreenWidth-30) {
        self.readerToolBar.hidden = !self.readerToolBar.hidden;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished && completed) { //翻页动画结束且已翻页
        [self.manager didFinishTurnPage]; //记录当前页面
        [self.manager saveReadRecord]; //保存阅读记录
    }
    // 翻页完成后开启交互，防止翻页过快导致页码定位错误
    if (finished && self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        self.pageViewController.view.userInteractionEnabled = YES;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        _pageViewController.view.userInteractionEnabled = NO; //关掉用户交互
    }
    _frontVC = (ContentViewController *)[pendingViewControllers lastObject];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    FHPaginateContent *page = [self.manager lastPageContent];
    if (!page) return nil;
    
    ContentViewController *contentVC = [ContentViewController createPageWithContent:page];
    // 页面镜像反转，作为页面背面
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:contentVC];
    }
    return contentVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // 页面镜像反转，作为页面背面
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    
    FHPaginateContent *page = [self.manager nextPageContent];
    if (!page) return nil;
    
    ContentViewController *contentVC = [ContentViewController createPageWithContent:page];
    return contentVC;
}

#pragma mark - FHReaderBarDelegate

- (void)readerBarDidClickExit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerBarDidChangeFontSize {
    [self.manager.contents collectPaginateChapters];
    
    _frontVC.paginateContent = [self.manager refetchPaginateContent];
    [_frontVC redrawReadPage];
    [self.manager saveReadRecord];
}

- (void)readerBarDidClickThemeColor:(UIColor *)color {
    self.pageViewController.view.backgroundColor = color;
    [_frontVC changeThemeWithColor:color];
}

- (void)readerBarDidClickLastChapter {
    
    FHPaginateContent *page = [self.manager lastChapterContent];
    if (!page) {
        NSLog(@"已经是第一章了");
        return;
    }
    _frontVC.paginateContent = page;
    [_frontVC redrawReadPage];
    [self.manager saveReadRecord];
}

- (void)readerBarDidClickNextChapter {
    FHPaginateContent *page = [self.manager nextChapterContent];
    if (!page) {
        NSLog(@"已经是最后一章了");
        return;
    }
    _frontVC.paginateContent = page;
    [_frontVC redrawReadPage];
    [self.manager saveReadRecord];
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

- (FHReaderBar *)readerToolBar {
    if (!_readerToolBar) {
        FHReaderBar *bar = [[FHReaderBar alloc] initWithFrame:self.view.bounds];
        bar.delegate = self;
        _readerToolBar = bar;
        _readerToolBar.hidden = YES;
    }
    return _readerToolBar;
}

@end
