//
//  FHFrameConstructor.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHReadConfig;
@class FHReadPageDrawer;

@interface FHFrameConstructor : NSObject

+ (FHReadPageDrawer *)parseContent:(NSString *)content config:(FHReadConfig *)config bounds:(CGRect)bounds;

+ (NSArray *)paginateContent:(NSString *)content WithConfig:(FHReadConfig *)config withBounds:(CGRect)bounds;

@end
