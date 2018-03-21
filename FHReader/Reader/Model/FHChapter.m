//
//  FHChapter.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHChapter.h"
#import "FHFrameConstructor.h"
#import "FHPaginateContent.h"
#import "FHReadConfig.h"

@interface FHChapter ()
{
    NSArray *_tempPaginateContents;
}
@end

@implementation FHChapter

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.chapterNo = [[aDecoder decodeObjectForKey:@"chapterNo"] integerValue];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.paginateContents = [aDecoder decodeObjectForKey:@"paginateContents"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.chapterNo) forKey:@"chapterNo"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.paginateContents forKey:@"paginateContents"];
}

#pragma mark - setter
- (void)setContent:(NSString *)content {
//    _content = content;
    FHReadConfig *config = [FHReadConfig getConfig];
    NSArray *pageContent = [FHFrameConstructor paginateContent:content WithConfig:config];
    NSMutableArray<FHPaginateContent *> *paginateContents = [NSMutableArray array];
    if (self.paginateContents.count == 0) {
        for (int i = 0; i < pageContent.count; i ++) {
            FHPaginateContent *pc =
            [FHPaginateContent createPaginateContentWithTitle:self.title
                                                      Content:pageContent[i]
                                                    totalPage:pageContent.count
                                                    chapterNo:self.chapterNo-1
                                                       pageNo:i];
            [paginateContents addObject:pc];
        }
        self.paginateContents = [paginateContents copy];
    }
}
#pragma mark - getter
- (NSInteger)pageCount {
    return self.paginateContents.count;
}

@end
