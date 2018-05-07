//
//  FHDrawerCache.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/7.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHReadPageDrawer;

@interface FHDrawerCache : NSObject

+ (instancetype)shareInstance;

- (void)cacheDrawer:(FHReadPageDrawer *)drawer WithIdentifier:(NSString *)identifier;

- (FHReadPageDrawer *)getDrawerWithIdentifier:(NSString *)identifier;

- (void)clearDrawerCache;

@end
