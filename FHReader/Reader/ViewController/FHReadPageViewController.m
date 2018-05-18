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
#import "FHReadConfig.h"

static NSString *const FHReadPageCellID = @"FHReadPageCellID";

@interface FHReadPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource,FHReaderBarDelegate>
{
    ContentViewController *_frontVC; //当前页面
    BOOL _isTurning; // 翻页中
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
    self.view.backgroundColor = [FHReadConfig shareConfiguration].themeColor;
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
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([FHReadConfig shareConfiguration].style != FHReadPageTransitionStylePageCurl && self.readerToolBar.hidden) return;
    
    if (_isTurning) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"点击位置 --> x=%f,y=%f",point.x,point.y);
    if (point.x > 50 && point.x < FHScreenWidth-50) {
        self.readerToolBar.hidden = !self.readerToolBar.hidden;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)tapGesAction:(UITapGestureRecognizer *)tapGes {
    
    if (_isTurning) return;
    
    CGPoint point = [tapGes locationInView:self.view];
    NSLog(@"点击位置 --> x=%f,y=%f",point.x,point.y);
    if (point.x > 60 && point.x < FHScreenWidth-60) {
        self.readerToolBar.hidden = !self.readerToolBar.hidden;
    }
    [self setNeedsStatusBarAppearanceUpdate];

    if ([FHReadConfig shareConfiguration].style != FHReadPageTransitionStyleNone) return;
    
    FHPaginateContent *page = nil;
    if (point.x < 60)
    {
        page = [self.manager lastPageContent];
    }
    else if (point.x > FHScreenWidth-60)
    {
        page = [self.manager nextPageContent];
    }
    if (page) {
        [self.manager saveReadRecord:page];
        _frontVC.paginateContent = page;
        [_frontVC redrawReadPage];
    }
}


#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    _isTurning = NO;
    if (finished && completed) { //翻页动画结束且已翻页
        [self.manager didFinishTurnPage]; //记录当前页面
        [self.manager saveReadRecord:_frontVC.paginateContent]; //保存阅读记录
    }
    ContentViewController *cvc = (ContentViewController *)[previousViewControllers lastObject];
    NSLog(@"did transition-->%ld章，%ld页",cvc.paginateContent.chapterNo+1,cvc.paginateContent.pageNo+1);
    NSLog(@"--------------------------------------------");
    // 翻页完成后开启交互，防止翻页过快导致页码定位错误
    if ([FHReadConfig shareConfiguration].style == FHReadPageTransitionStylePageCurl) {
        self.pageViewController.view.userInteractionEnabled = YES;
    }
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _isTurning = YES;
    if ([FHReadConfig shareConfiguration].style == FHReadPageTransitionStylePageCurl) {
        _pageViewController.view.userInteractionEnabled = NO; //关掉用户交互
    }

    _frontVC = (ContentViewController *)[pendingViewControllers lastObject];
    NSLog(@"will transition-->%ld章，%ld页",_frontVC.paginateContent.chapterNo+1,_frontVC.paginateContent.pageNo+1);
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([FHReadConfig shareConfiguration].style == FHReadPageTransitionStyleNone) {
        return nil;
    }
    
    FHPaginateContent *page = [self.manager lastPageContent];
    if (!page) return nil;
    NSLog(@"before-->%ld章，%ld页",page.chapterNo+1,page.pageNo+1);
    ContentViewController *contentVC = [ContentViewController createPageWithContent:page];
    // 页面镜像反转，作为页面背面
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:contentVC];
    }
    return contentVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([FHReadConfig shareConfiguration].style == FHReadPageTransitionStyleNone) {
        return nil;
    }
    
    // 页面镜像反转，作为页面背面
    if ([viewController isKindOfClass:[ContentViewController class]] && pageViewController.doubleSided) {
        return [FHBackViewController createBackPageWithFontPage:viewController];
    }
    
    FHPaginateContent *page = [self.manager nextPageContent];
    if (!page) return nil;
    NSLog(@"next-->%ld章，%ld页",page.chapterNo+1,page.pageNo+1);
    ContentViewController *contentVC = [ContentViewController createPageWithContent:page];
    return contentVC;
}

#pragma mark - FHReaderBarDelegate

- (void)readerBarDidClickExit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readBarDidClickChangeLineSpace {
    [self changeTextAttribute];
}

- (void)readerBarDidChangeFontSize {
    [self changeTextAttribute];
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
    [self.manager saveReadRecord:page];
}

- (void)readerBarDidClickNextChapter {
    FHPaginateContent *page = [self.manager nextChapterContent];
    if (!page) {
        NSLog(@"已经是最后一章了");
        return;
    }
    _frontVC.paginateContent = page;
    [_frontVC redrawReadPage];
    [self.manager saveReadRecord:page];
}

- (void)changeTextAttribute {
    [self.manager.contents collectPaginateChapters];
    _frontVC.paginateContent = [self.manager refetchPaginateContent];
    [_frontVC redrawReadPage];
    [self.manager saveReadRecord:_frontVC.paginateContent];
}

#pragma mark - lazy load
- (FHPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [FHPageViewController configPageViewController];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;//
        _pageViewController.doubleSided = [FHReadConfig shareConfiguration].style == FHReadPageTransitionStylePageCurl;
        if ([FHReadConfig shareConfiguration].style != FHReadPageTransitionStylePageCurl) {
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];
            [_pageViewController.view addGestureRecognizer:tapGes];
        }
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
