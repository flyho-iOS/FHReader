//
//  FHReadConfig.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , FHReadPageTransitionStyle) {
    FHReadPageTransitionStylePageCurl = 0, //翻页
    FHReadPageTransitionStyleScrollHorizontal, //水平滚动
    FHReadPageTransitionStyleScrollVertical, //垂直滚动
    FHReadPageTransitionStyleNone //无动画
};

@interface FHReadConfig : NSObject <NSCoding>

/** 主题背景色 */
@property (nonatomic,strong) UIColor *themeColor;
/** 行距 */
@property (nonatomic,assign) CGFloat lineSpace;
/** 字体大小 */
@property (nonatomic,assign) CGFloat fontSize;
/** 字体颜色 */
@property (nonatomic,strong) UIColor *fontColor;
/** 字体 */
@property (nonatomic,copy) NSString *fontName;
/** 翻页动画 */
@property (nonatomic,assign) FHReadPageTransitionStyle style;

+ (instancetype)shareConfiguration;

@end
