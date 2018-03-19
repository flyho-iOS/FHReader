//
//  ContentViewController.m
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "ContentViewController.h"
#import "FHReadConfig.h"
#import "FHReadContent.h"
#import "FHReadView.h"

@interface ContentViewController ()

@property (nonatomic,strong) FHChapter *chapter; //分页内容
@property (nonatomic,strong) FHReadView *readView;
@property (nonatomic,strong) UILabel *label;

@end

@implementation ContentViewController

+ (instancetype)createPageWithChapter:(FHChapter *)chapter {
    return [[self alloc] initWithChapter:chapter];
}

- (instancetype)initWithChapter:(FHChapter *)chapter {
    if (self = [super init]) {
        _chapter = chapter;
        [self.view addSubview:self.readView];
        self.label.text = _chapter.content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - getter
- (FHReadView *)readView {
    if (!_readView) {
        _readView = [[FHReadView alloc] initWithFrame:self.view.bounds];
        _readView.backgroundColor = [UIColor lightGrayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:_readView.bounds];
        label.numberOfLines = 0;
        [_readView addSubview:label];
        _label = label;
    }
    return _readView;
}

@end
