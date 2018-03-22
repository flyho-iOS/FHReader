//
//  FHReadConfig.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadConfig.h"

static NSString *const ConfigCacheKey = @"ConfigCacheKey";

@implementation FHReadConfig 

#pragma mark - initialize

+ (FHReadConfig *)getConfig {
    return [[self alloc] init];
}

- (instancetype)init {
    FHReadConfig *config = [FHReadConfig getCacheConfig];
    if (config) {
        return config;
    }
    if (self = [super init]) {
        _themeColor = [UIColor colorWithRed:226.0/255.0 green:204.0/255.0 blue:169.0/225.0 alpha:1.0];
        _fontSize = 18;
        _lineSpace = 0.5f;
        _style = FHREeadPageTransitionStylePageCurl;
        [self updateCacheConfig];
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
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:ConfigCacheKey];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:ConfigCacheKey];
    [FHUserDefault synchronize];
}

+ (FHReadConfig *)getCacheConfig {
    NSData *data = [FHUserDefault objectForKey:ConfigCacheKey];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchive decodeObjectForKey:ConfigCacheKey];
}

@end
