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
        self.currentPaginate = [aDecoder decodeObjectForKey:@"currentPaginate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.bookId) forKey:@"bookId"];
    [aCoder encodeObject:self.currentPaginate forKey:@"currentPaginate"];
}

+ (FHRecord *)emptyRecord:(NSInteger)bookId {
    FHRecord *record = [FHRecord new];
    record.bookId = bookId;
    [record updateRecord];
    return record;
}

- (void)updateRecord {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:FHRecordKey(self.bookId)];
    [archiver finishEncoding];
    [FHUserDefault setObject:data forKey:FHRecordKey(self.bookId)];
    [FHUserDefault synchronize];
}

+ (FHRecord *)getRecordWithBookId:(NSInteger)bookId {
    NSData *data = [FHUserDefault objectForKey:FHRecordKey(bookId)];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    FHRecord *record = [unarchive decodeObjectForKey:FHRecordKey(bookId)];
    return record;
}

@end
