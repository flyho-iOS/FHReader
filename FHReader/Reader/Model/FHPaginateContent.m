//
//  FHPaginateContent.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/20.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHPaginateContent.h"

@implementation FHPaginateContent

+ (instancetype)createPaginateContentWithContent:(NSString *)content
                                       chapterNo:(NSInteger)chapterNo
                                          pageNo:(NSInteger)pageNo {
    return [[self alloc] initWithContent:content
                               chapterNo:chapterNo
                                  pageNo:pageNo];
}

- (instancetype)initWithContent:(NSString *)content
                      chapterNo:(NSInteger)chapterNo
                         pageNo:(NSInteger)pageNo {
    if (self = [super init]) {
        _content = content;
        _chapterNo = chapterNo;
        _pageNo = pageNo;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.chapterNo = [[aDecoder decodeObjectForKey:@"chapterNo"] integerValue];
        self.pageNo = [[aDecoder decodeObjectForKey:@"pageNo"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:@(self.chapterNo) forKey:@"chapterNo"];
    [aCoder encodeObject:@(self.pageNo) forKey:@"pageNo"];
}

@end
