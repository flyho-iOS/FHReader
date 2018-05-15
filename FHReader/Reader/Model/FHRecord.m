//
//  FHRecord.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHRecord.h"
#import "AppDefine.h"

@implementation FHRecord

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.bookId = [[aDecoder decodeObjectForKey:@"bookId"] integerValue];
        self.chapterNo = [[aDecoder decodeObjectForKey:@"chapterNo"] integerValue];
        self.recordPage_ch = [[aDecoder decodeObjectForKey:@"recordPage_ch"] integerValue];
        self.recordPage_to = [[aDecoder decodeObjectForKey:@"recordPage_to"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.bookId) forKey:@"bookId"];
    [aCoder encodeObject:@(self.chapterNo) forKey:@"chapterNo"];
    [aCoder encodeObject:@(self.recordPage_ch) forKey:@"recordPage_ch"];
    [aCoder encodeObject:@(self.recordPage_to) forKey:@"recordPage_to"];
}

- (void)updateRecord {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:FHRecordKey(self.bookId)];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:[NSString stringWithFormat:@"%ld",self.bookId]];
    [FHUserDefault synchronize];
}

+ (FHRecord *)getRecordWithBookId:(NSInteger)bookId {
    NSData *data = [FHUserDefault objectForKey:FHRecordKey(bookId)];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchive decodeObjectForKey:FHRecordKey(bookId)];
}

@end
