//
//  FHReadConfig.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadConfig.h"

static NSString *const ConfigCacheKey = @"ConfigCacheKey";
static NSString * const FHReadPageTransitionStyleKey = @"FHReadPageTransitionStyleKey";
static FHReadConfig *config = nil;

@interface FHReadConfig ()

@end

@implementation FHReadConfig 

#pragma mark - initialize
+ (instancetype)shareConfiguration {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [super allocWithZone:NULL];
    });
    return config;
}

- (void)defaultConfiguration {
    _themeColor = [UIColor colorWithRed:226.0/255.0 green:204.0/255.0 blue:169.0/225.0 alpha:1.0];
    _fontSize = 18;
    _fontColor = [UIColor blackColor];
    _lineSpace = 0.5f;
    _style = FHReadPageTransitionStyleScrollVertical;
    _fontName = @"ArialMT";
}

- (instancetype)init {
    FHReadConfig *configuration = [FHReadConfig getCacheConfig];
    if (configuration) {
        return configuration;
    }
    if (self = [super init]) {
        [self defaultConfiguration];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.fontColor = [aDecoder decodeObjectForKey:@"fontColor"];
        self.themeColor = [aDecoder decodeObjectForKey:@"themeColor"];
        self.fontName = [aDecoder decodeObjectForKey:@"fontName"];
        self.fontSize = [[aDecoder decodeObjectForKey:@"fontSize"] integerValue];
        self.lineSpace = [[aDecoder decodeObjectForKey:@"lineSpace"] floatValue];
        self.style = [[aDecoder decodeObjectForKey:@"style"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.themeColor forKey:@"themeColor"];
    [aCoder encodeObject:self.fontColor forKey:@"fontColor"];
    [aCoder encodeObject:self.fontName forKey:@"fontName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fontSize] forKey:@"fontSize"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.lineSpace] forKey:@"lineSpace"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
}

#pragma mark - cache
- (void)updateCacheConfig {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:ConfigCacheKey];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:ConfigCacheKey];
    [FHUserDefault synchronize];
}

+ (FHReadConfig *)getCacheConfig {
    NSData *data = [FHUserDefault objectForKey:ConfigCacheKey];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchive decodeObjectForKey:ConfigCacheKey];
}

#pragma mark - setter
- (void)setLineSpace:(CGFloat)lineSpace {
    _lineSpace = lineSpace;
    [self updateCacheConfig];
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    [self updateCacheConfig];
}

- (void)setStyle:(FHReadPageTransitionStyle)style {
    _style = style;
    [self updateCacheConfig];
}

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    [self updateCacheConfig];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updateCacheConfig];
}

@end
