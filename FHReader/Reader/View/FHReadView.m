//
//  FHReadView.m
//  FHReader
//
//  Created by fly on 2018/3/6.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadView.h"
#import "FHReadPageDrawer.h"
#import "FHFrameConstructor.h"
#import "FHReadConfig.h"
#import "AppDefine.h"

@interface FHReadView ()

@property (nonatomic,strong) FHReadPageDrawer *drawer;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *progressLb;

@end

@implementation FHReadView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (self.drawer) {
        CTFrameDraw(self.drawer.ctframe, context);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLb];
        [self addSubview:self.progressLb];
    }
    return self;
}

- (void)redraw {
    self.drawer = [FHFrameConstructor parseContent:[_dataSource chapterContent]
                                            config:[FHReadConfig shareConfiguration]
                                            bounds:ReadPageRect];
    [self setNeedsDisplay];
    //刷新页面顶部标题和阅读进度
    if (_dataSource && [_dataSource respondsToSelector:@selector(chapterTitle)]) {
        self.titleLb.text = [_dataSource chapterTitle];
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(chapterReadProgress)]) {
        self.progressLb.text = [_dataSource chapterReadProgress];
    }
}

#pragma mark - setter
- (void)setDataSource:(id<FHReadViewDataSource>)dataSource {
    _dataSource = dataSource;
    if (_dataSource && [_dataSource respondsToSelector:@selector(chapterTitle)]) {
        self.titleLb.text = [_dataSource chapterTitle];
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(chapterReadProgress)]) {
        self.progressLb.text = [_dataSource chapterReadProgress];
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(chapterContent)]) {
        self.drawer = [FHFrameConstructor parseContent:[_dataSource chapterContent] config:[FHReadConfig shareConfiguration] bounds:ReadPageRect];
    }
}

#pragma mark - getter
- (UILabel *)titleLb {
    if (!_titleLb) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        _titleLb = label;
    }
    return _titleLb;
}

- (UILabel *)progressLb {
    if (!_progressLb) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-30, FHScreenWidth-20, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        _progressLb = label;
    }
    return _progressLb;
}

@end
