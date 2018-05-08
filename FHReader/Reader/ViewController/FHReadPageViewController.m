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

@interface FHReadPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource,FHReaderBarDelegate>
{
    NSInteger _currentPaginateNo;
    ContentViewController *_frontVC;
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

+ (instancetype)createReaderWithContentPath:(NSString *)contentPath {
    return [[self alloc] initWithContentPath:contentPath];
}

- (instancetype)initWithContentPath:(NSString *)contentPath {
    if (self = [super init]) {
        _content = [FHReadContent createContentWithFile:contentPath];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookId = 1;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.readerToolBar];
    [self requestData];
}

- (void)requestData {
    
    FHRecord *record = [FHRecord getRecordWithBookId:self.bookId];
    if (record) {
        _currentPaginateNo = record.recordPage_to;
    }else {
        _currentPaginateNo = 0;
    }
    FHPaginateContent *pc = _content.paginateContents[_currentPaginateNo];
    ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
    _frontVC = contentVC;
    [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
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
    if (point.x > 50 && point.x < FHScreenWidth-50) {
        self.readerToolBar.hidden = !self.readerToolBar.hidden;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    BOOL isSwipeForward = NO;
    ContentViewController *preVC = (ContentViewController *)[previousViewControllers lastObject];
    if ((preVC.paginateContent.chapterNo < _frontVC.paginateContent.chapterNo) || (preVC.paginateContent.chapterNo == _frontVC.paginateContent.chapterNo && preVC.paginateContent.pageNo < _frontVC.paginateContent.pageNo)) {
        isSwipeForward = YES;
    }
    if (finished && completed) { //翻页动画结束且已翻页
        if (isSwipeForward) {
            _currentPaginateNo ++;
        }else{
            _currentPaginateNo --;
        }
        if (_currentPaginateNo < 0) _currentPaginateNo = 0;
        if (_currentPaginateNo > _content.paginateContents.count-1) _currentPaginateNo = _content.paginateContents.count-1;
        
        NSLog(@"第%ld章,第%ld页,共%ld页,第%ld页",[_content.paginateContents[_currentPaginateNo] chapterNo]+1,[_content.paginateContents[_currentPaginateNo] pageNo]+1,_content.paginateContents.count,_currentPaginateNo+1);
        FHRecord *record = [FHRecord new];
        record.bookId = self.bookId;
        record.chapterNo = [_content.paginateContents[_currentPaginateNo] chapterNo];
        record.recordPage_ch = [_content.paginateContents[_currentPaginateNo] pageNo];
        record.recordPage_to = _currentPaginateNo;
        [record updateRecord];
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
    
    if (_currentPaginateNo == 0) return nil;
    
    NSInteger cpn = _currentPaginateNo-1;
    FHPaginateContent *pc = _content.paginateContents[cpn];
    
    ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
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
    NSInteger cpn = _currentPaginateNo + 1;
    
    if (cpn > _content.paginateContents.count-1) return nil;
    
    FHPaginateContent *pc = _content.paginateContents[cpn];
    ContentViewController *contentVC = [ContentViewController createPageWithContent:pc];
    return contentVC;
}

#pragma mark - FHReaderBarDelegate

- (void)readerBarDidClickExit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerBarDidChangeFontSize {
    [self.content collectPaginateChapters];
    [self.content updateContent];
    [[FHDrawerCache shareInstance] clearDrawerCache];
    
    if (_currentPaginateNo >= self.content.paginateContents.count-1) {
        _currentPaginateNo = self.content.paginateContents.count-1;
    }
    
    _frontVC.paginateContent = self.content.paginateContents[_currentPaginateNo];
    [_frontVC redrawReadPage];
}

- (void)readerBarDidClickThemeColor:(UIColor *)color {
    self.pageViewController.view.backgroundColor = color;
    [_frontVC changeThemeWithColor:color];
}

- (void)readerBarDidClickLastChapter {
    
    if (_currentPaginateNo == 0) return;
    
    FHPaginateContent *currentPage = self.content.paginateContents[_currentPaginateNo];
    NSInteger currentChapterNo = currentPage.chapterNo;
    
    if (currentChapterNo <= 0) return;
    
    FHChapter *lastChapter = self.content.chapters[currentChapterNo-1];
    FHPaginateContent *lastChapterPage = self.content.paginateContents[lastChapter.startPageNo];
    _frontVC.paginateContent = lastChapterPage;
    _currentPaginateNo = lastChapter.startPageNo;
    [_frontVC redrawReadPage];
}

- (void)readerBarDidClickNextChapter {
    if (_currentPaginateNo == self.content.paginateContents.count -1) return;
    
    FHPaginateContent *currentPage = self.content.paginateContents[_currentPaginateNo];
    NSInteger currentChapterNo = currentPage.chapterNo;
    
    if (currentChapterNo >= self.content.chapters.count-1) return;
    
    FHChapter *nextChapter = self.content.chapters[currentChapterNo+1];
    FHPaginateContent *nextChapterPage = self.content.paginateContents[nextChapter.startPageNo];
    _frontVC.paginateContent = nextChapterPage;
    _currentPaginateNo = nextChapter.startPageNo;
    [_frontVC redrawReadPage];
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
