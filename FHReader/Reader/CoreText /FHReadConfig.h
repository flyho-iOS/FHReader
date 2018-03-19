//
//  FHReadConfig.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , FHReadPageTransitionStyle) {
    FHREeadPageTransitionStylePageCurl = 0, //翻页
    FHREeadPageTransitionStyleScrollHorizontal, //水平滚动
    FHREeadPageTransitionStyleScrollVertical //垂直滚动
};

@interface FHReadConfig : NSObject <NSCoding>
/** 主题背景色 */
@property (nonatomic,strong) UIColor *themeColor;
/** 行距 */
@property (nonatomic,assign) CGFloat lineSpace;
/** 字体大小 */
@property (nonatomic,assign) CGFloat fontSize;
/** 字体 */
@property (nonatomic,copy) NSString *fontName;
/** 翻页动画 */
@property (nonatomic,assign) FHReadPageTransitionStyle style;

/**
 *  更新缓存配置参数
 *  @param config  配置参数
 */
+ (void)updateCacheConfig:(FHReadConfig *)config;
/**
 *  获取配置参数
 *  @return FHReadConfig  配置参数
 */
+ (FHReadConfig *)getConfig;

@end
