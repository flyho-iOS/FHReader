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
    if (config)
        return config;
    
    if (self = [super init]) {
        _themeColor = [UIColor lightGrayColor];
        _fontSize = 20;
        _lineSpace = 0.5f;
        _style = FHREeadPageTransitionStylePageCurl;
    }
    return self;
}

+ (FHReadConfig *)getCacheConfig {
    return [FHUserDefault objectForKey:ConfigCacheKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.themeColor = [aDecoder decodeObjectForKey:@"themeColor"];
        self.fontSize = [[aDecoder decodeObjectForKey:@"fontSize"] integerValue];
        self.lineSpace = [[aDecoder decodeObjectForKey:@"lineSpace"] floatValue];
        self.style = [[aDecoder decodeObjectForKey:@"style"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.themeColor forKey:@"themeColor"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fontSize] forKey:@"fontSize"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.lineSpace] forKey:@"lineSpace"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
}

#pragma mark - cache
+ (void)updateCacheConfig:(FHReadConfig *)config {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:ConfigCacheKey];
    [archiver finishEncoding];
    [FHUserDefault setObject:config forKey:ConfigCacheKey];
}

@end
