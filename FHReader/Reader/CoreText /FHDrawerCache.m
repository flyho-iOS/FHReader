//
//  FHDrawerCache.m
//  FHReader
//
//  Created by hefeiyang on 2018/5/7.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHDrawerCache.h"
#import "FHReadPageDrawer.h"

#define FHTotalCostLimit 1024*1024

static FHDrawerCache *drawCache = nil;

@interface FHDrawerCache () <NSCacheDelegate>

@property (nonatomic,strong) NSCache *cache;

@end

@implementation FHDrawerCache

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        drawCache = [[self alloc] init];
    });
    return drawCache;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        drawCache = [super allocWithZone:zone];
    });
    return drawCache;
}

- (instancetype)init {
    if (self = [super init]) {
        _cache = [NSCache new];
        _cache.totalCostLimit = FHTotalCostLimit;
        _cache.delegate = self;
    }
    return self;
}

#pragma mark - public
- (void)cacheDrawer:(FHReadPageDrawer *)drawer WithIdentifier:(NSString *)identifier {
    [self.cache setObject:drawer forKey:identifier];
}

- (FHReadPageDrawer *)getDrawerWithIdentifier:(NSString *)identifier {
    FHReadPageDrawer *drawer = [self.cache objectForKey:identifier];
    return drawer;
}

- (void)clearDrawerCache {
    [self.cache removeAllObjects];
}

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"Evict-->%@",obj);
}
@end
