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

@end

@implementation FHChapter

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.chapterNo = [[aDecoder decodeObjectForKey:@"chapterNo"] integerValue];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.startPageNo = [[aDecoder decodeObjectForKey:@"startPageNo"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.chapterNo) forKey:@"chapterNo"];
    [aCoder encodeObject:@(self.startPageNo) forKey:@"startPageNo"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
}

#pragma mark - setter
#pragma mark - getter

@end
