//
//  ContentViewController.m
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "ContentViewController.h"
#import "FHReadConfig.h"
#import "FHReadView.h"
#import "FHPaginateContent.h"

@interface ContentViewController () <FHReadViewDataSource>

@property (nonatomic,strong) FHReadView *readView;

@end

@implementation ContentViewController

+ (instancetype)createPageWithContent:(FHPaginateContent *)paginateContent {
    return [[self alloc] initWithContent:paginateContent];
}

- (instancetype)initWithContent:(FHPaginateContent *)paginateContent {
    if (self = [super init]) {
        _paginateContent = paginateContent;
        [self.view addSubview:self.readView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
- (void)redrawReadPage {
    [self.readView redraw];
}

- (void)changeThemeWithColor:(UIColor *)color {
    self.readView.backgroundColor = color;
}

#pragma mark - FHReadViewDataSource
- (NSString *)chapterTitle {
    return self.paginateContent.title;
}

- (NSString *)chapterReadProgress {
    return [NSString stringWithFormat:@"%ld / %ld",self.paginateContent.pageNo+1,self.paginateContent.totalPage];
}

- (NSString *)chapterContent {
    return self.paginateContent.content;
}

#pragma mark - getter
- (FHReadView *)readView {
    if (!_readView) {
        _readView = [[FHReadView alloc] initWithFrame:self.view.bounds];
        _readView.backgroundColor = [FHReadConfig shareConfiguration].themeColor;
        _readView.dataSource = self;
    }
    return _readView;
}

@end
