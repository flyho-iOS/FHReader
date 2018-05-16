//
//  FHParserUtil.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHParserUtil.h"
#import "FHChapter.h"
#import "YYModel.h"

@implementation FHParserUtil

+ (NSArray<FHChapter *> *)parserFileToChapter:(NSInteger)bookId {
    NSArray *chapters = nil;
    NSString *fileName = [NSString stringWithFormat:@"%ld.json",bookId];
    if ([fileName.pathExtension isEqualToString:@"json"]) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingLastPathComponent] ofType:[fileName pathExtension]];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        chapters = [NSArray yy_modelArrayWithClass:[FHChapter class] json:dataStr];
    }
    return chapters;
}

@end
