//
//  FHPaginateContent.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/20.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHPaginateContent.h"

@implementation FHPaginateContent

+ (instancetype)createPaginateContentWithTitle:(NSString *)title
                                       Content:(NSString *)content
                                     totalPage:(NSInteger)totalPage
                                     chapterNo:(NSInteger)chapterNo
                                        pageNo:(NSInteger)pageNo {
    return [[self alloc] initWithTitle:title
                               Content:content
                             totalPage:(NSInteger)totalPage
                             chapterNo:chapterNo
                                pageNo:pageNo];
}

- (instancetype)initWithTitle:(NSString *)title
                      Content:(NSString *)content
                    totalPage:(NSInteger)totalPage
                    chapterNo:(NSInteger)chapterNo
                       pageNo:(NSInteger)pageNo {
    if (self = [super init]) {
        _title = title;
        _content = content;
        _totalPage = totalPage;
        _chapterNo = chapterNo;
        _pageNo = pageNo;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.totalPage = [[aDecoder decodeObjectForKey:@"totalPage"] integerValue];
        self.chapterNo = [[aDecoder decodeObjectForKey:@"chapterNo"] integerValue];
        self.pageNo = [[aDecoder decodeObjectForKey:@"pageNo"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:@(self.totalPage) forKey:@"totalPage"];
    [aCoder encodeObject:@(self.chapterNo) forKey:@"chapterNo"];
    [aCoder encodeObject:@(self.pageNo) forKey:@"pageNo"];
}

@end
