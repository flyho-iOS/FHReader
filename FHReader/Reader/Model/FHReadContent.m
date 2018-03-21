//
//  FHReadContent.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadContent.h"
#import "FHParserUtil.h"

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
        NSMutableArray<FHPaginateContent *> *pcs = [NSMutableArray array];
        for (FHChapter *chapter in _chapters) {
            [pcs addObjectsFromArray:chapter.paginateContents];
        }
        _paginateContents = [pcs copy];
        [self updateContent];
    }
    return self;
}

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
