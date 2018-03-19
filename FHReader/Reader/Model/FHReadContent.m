//
//  FHReadContent.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHReadContent.h"
#import "FHParserUtil.h"

@implementation FHReadContent

+ (instancetype)createContentWithFile:(NSString *)fileName {
    return [[self alloc] initWithFileName:fileName];
}

- (instancetype)initWithFileName:(NSString *)fileName {
    if (self = [super init]) {
        _identifier = fileName;
        NSArray *chapters = [FHParserUtil parserFileToChapter:fileName];
        [self.chapters addObjectsFromArray:chapters];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
    }
    return self;
}

#pragma mark - getter
- (NSMutableArray<FHChapter *> *)chapters {
    if (!_chapters) {
        _chapters = [NSMutableArray new];
    }
    return _chapters;
}

- (NSMutableArray<FHNote *> *)notes {
    if (!_notes) {
        _notes = [NSMutableArray new];
    }
    return _notes;
}

- (NSMutableArray<FHBookMark *> *)marks {
    if (!_marks) {
        _marks = [NSMutableArray new];
    }
    return _marks;
}

@end
