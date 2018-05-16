//
//  FHReadContent.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadContent.h"
#import "FHParserUtil.h"
#import "FHPaginateContent.h"
#import "FHReadConfig.h"
#import "FHFrameConstructor.h"
#import "AppDefine.h"

static NSString *const FHContentCache = @"FHContentCache";

@implementation FHReadContent

+ (instancetype)localContentWithIdentifer:(NSInteger)bookId {
    return [[self alloc] initLocalWithIdentifer:bookId];
}

- (instancetype)initLocalWithIdentifer:(NSInteger)bookId {
    if (self = [super init]) {
        _identifier = bookId;
        [self collectPaginateChapters];
    }
    return self;
}

- (void)collectPaginateChapters {
    NSMutableDictionary *pcs = [NSMutableDictionary dictionary];
    NSArray<FHChapter *> *chapters = [FHParserUtil parserFileToChapter:_identifier];
    for (FHChapter *chapter in chapters) {
        // 每一章节全部分页内容
        [pcs setObject:[self paginateContentsForChapter:chapter] forKey:FHChapterKey(chapter.chapterNo)];
    }
    _chapters = [pcs copy];
}
// 把一个章节内容分页
- (NSDictionary *)paginateContentsForChapter:(FHChapter *)chapter {
    FHReadConfig *config = [FHReadConfig shareConfiguration];
    NSArray *pageContent = [FHFrameConstructor paginateContent:chapter.content WithConfig:config withBounds:ReadPageRect];
    NSMutableDictionary<NSString *,FHPaginateContent *> *paginateContents = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < pageContent.count; i ++) {
        FHPaginateContent *pc = [FHPaginateContent new];
        pc.title = chapter.title;
        pc.content = pageContent[i];
        pc.totalPage = pageContent.count;
        pc.chapterNo = chapter.chapterNo;
        pc.pageNo = i;
        [paginateContents setObject:pc forKey:FHPaginateKey(i)];
    }
    return paginateContents.copy;
}

+ (FHReadContent *)getCacheContentWithIdentifier:(NSInteger)identifier {
    NSData *data = [FHUserDefault objectForKey:FHReadContentKey(identifier)];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchive decodeObjectForKey:FHReadContentKey(identifier)];
}

- (void)updateContent {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:FHReadContentKey(self.identifier)];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:FHReadContentKey(self.identifier)];
    [FHUserDefault synchronize];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.identifier) forKey:@"identifier"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.paginateContents forKey:@"paginateContents"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.paginateContents = [aDecoder decodeObjectForKey:@"paginateContents"];
    }
    return self;
}

#pragma mark - getter
- (FHRecord *)record {
    FHRecord *record = [FHRecord getRecordWithBookId:self.identifier];
    if (record) {
        return record;
    }
    record = [FHRecord new];
    record.bookId = self.identifier;
    NSDictionary *dict = self.chapters[FHChapterKey((NSInteger)0)];
    record.currentPaginate = dict[FHPaginateKey((NSInteger)0)];
    return record;
}

- (NSInteger)totalChapter {
    return _chapters.count;
}

@end
