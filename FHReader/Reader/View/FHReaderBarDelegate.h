//
//  FHReaderBarDelegate.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/17.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FHReaderBarDelegate <NSObject>

@optional

- (void)readerBarDidClickExit;
- (void)readerBarDidChangeFontSize;
- (void)readerBarDidClickLastChapter;
- (void)readerBarDidClickNextChapter;
- (void)readBarDidClickChangeLineSpace;
- (void)readerBarDidClickThemeColor:(UIColor *)color;

@end
