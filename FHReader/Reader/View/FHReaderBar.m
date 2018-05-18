//
//  FHReaderBar.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/22.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHReaderBar.h"
#import "FHReadConfig.h"

#define FONT_MAX 22
#define FONT_MIN 15

@interface FHReaderBar ()

@property (weak, nonatomic) IBOutlet UILabel *fontSizeLb;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation FHReaderBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *backView =  [[NSBundle mainBundle] loadNibNamed:@"FHReaderBar"owner:self options:nil].firstObject;
        backView.frame = frame;
        [self addSubview:backView];
        self.fontSizeLb.text = [NSString stringWithFormat:@"%d",(int)[FHReadConfig shareConfiguration].fontSize];
    }
    return self;
}

#pragma mark - event response

- (IBAction)backClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(readerBarDidClickExit)]) {
        [_delegate readerBarDidClickExit];
    }
}

- (IBAction)lastChapterClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(readerBarDidClickLastChapter)]) {
        [_delegate readerBarDidClickLastChapter];
    }
}

- (IBAction)nextChapterClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(readerBarDidClickNextChapter)]) {
        [_delegate readerBarDidClickNextChapter];
    }
}

- (IBAction)fontReduce:(id)sender {
    FHReadConfig *config = [FHReadConfig shareConfiguration];
    config.fontSize --;
    
    if (config.fontSize < FONT_MIN) {
        config.fontSize = FONT_MIN;
        return;
    }
    
    self.fontSizeLb.text = [NSString stringWithFormat:@"%d",(int)config.fontSize];
    [self chageFontSize];
}

- (IBAction)fontIncrease:(id)sender {
    FHReadConfig *config = [FHReadConfig shareConfiguration];
    config.fontSize ++;
    
    if (config.fontSize > FONT_MAX) {
        config.fontSize = FONT_MAX;
        return;
    }
    
    self.fontSizeLb.text = [NSString stringWithFormat:@"%d",(int)config.fontSize];
    [self chageFontSize];
}



- (IBAction)changeThemeColor:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(readerBarDidClickThemeColor:)]) {
        [_delegate readerBarDidClickThemeColor:button.backgroundColor];
    }    
    FHReadConfig *config = [FHReadConfig shareConfiguration];
    config.themeColor = button.backgroundColor;
}

#pragma mark -
- (void)chageFontSize {
    if (_delegate && [_delegate respondsToSelector:@selector(readerBarDidChangeFontSize)]) {
        [_delegate readerBarDidChangeFontSize];
    }
}

@end
