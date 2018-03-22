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

static NSString *const FHContentCache = @"FHContentCache";

@implementation FHReadContent

+ (instancetype)createContentWithFile:(NSString *)fileName {
    return [[self alloc] initWithFileName:fileName];
}

- (instancetype)initWithFileName:(NSString *)fileName {
    FHReadContent *content = [FHReadContent getCacheContentWithIdentifier:fileName];
    if (content) {
        return content;
    }
    if (self = [super init]) {
        _identifier = fileName;
        _chapters = [FHParserUtil parserFileToChapter:fileName];
        [self collectPaginateChapters];
        [self updateContent];
    }
    return self;
}

- (void)collectPaginateChapters {
    int count = 0;
    NSMutableArray<FHPaginateContent *> *pcs = [NSMutableArray array];
    for (FHChapter *chapter in _chapters) {
        NSArray *paginateContents = [self paginateContentsForChapter:chapter];
        [pcs addObjectsFromArray:paginateContents];
        chapter.startPageNo = count;
        count += paginateContents.count;
    }
    _paginateContents = [pcs copy];
}

- (NSArray *)paginateContentsForChapter:(FHChapter *)chapter {
    FHReadConfig *config = [FHReadConfig getConfig];
    NSArray *pageContent = [FHFrameConstructor paginateContent:chapter.content WithConfig:config withBounds:ReadPageRect];
    NSMutableArray<FHPaginateContent *> *paginateContents = [NSMutableArray array];
    for (int i = 0; i < pageContent.count; i ++) {
        FHPaginateContent *pc =
        [FHPaginateContent createPaginateContentWithTitle:chapter.title
                                                  Content:pageContent[i]
                                                totalPage:pageContent.count
                                                chapterNo:chapter.chapterNo-1
                                                   pageNo:i];
        [paginateContents addObject:pc];
    }
    return paginateContents.copy;
}

//- (FHChapter *)locateChapterWithPageNo:(NSInteger)pageNo {
//    
//}

+ (FHReadContent *)getCacheContentWithIdentifier:(NSString *)identifier {
    NSData *data = [FHUserDefault objectForKey:identifier];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchive decodeObjectForKey:identifier];
}

- (void)updateContent {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:self.identifier];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:self.identifier];
    [FHUserDefault synchronize];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.paginateContents forKey:@"paginateContents"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.paginateContents = [aDecoder decodeObjectForKey:@"paginateContents"];
    }
    return self;
}

#pragma mark - getter
- (NSInteger)totalChapter {
    return _chapters.count;
}

@end
