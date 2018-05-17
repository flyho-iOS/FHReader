//
//  FHReaderBar.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/22.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FHReaderBar;

@protocol FHReaderBarDelegate <NSObject>

@optional

- (void)readerBarDidClickExit;
- (void)readerBarDidChangeFontSize;
- (void)readerBarDidClickLastChapter;
- (void)readerBarDidClickNextChapter;
- (void)readBarDidClickChangeLineSpace;
- (void)readerBarDidClickThemeColor:(UIColor *)color;

@end

@interface FHReaderBar : UIView

@property (nonatomic,weak) id<FHReaderBarDelegate> delegate;

@end
