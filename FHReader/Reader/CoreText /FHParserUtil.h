//
//  FHParserUtil.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHChapter;

@interface FHParserUtil : NSObject

+ (NSArray<FHChapter *> *)parserFileToChapter:(NSString *)fileName;

@end
