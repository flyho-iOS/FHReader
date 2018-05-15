//
//  FHSourceLocalManager.m
//  FHReader
//
//  Created by hefeiyang on 2018/5/8.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHSourceLocalManager.h"
#import "FHReadContent.h"
#import "FHRecord.h"

@interface FHSourceLocalManager ()
{
    NSMutableArray *_pageginates;
    NSInteger _currentPage;
}
@end

@implementation FHSourceLocalManager

- (instancetype)initWithBookId:(NSInteger)bookId {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)fetchContentWithBookId:(NSInteger)bookId success:(FetchContentSuccess)fetchSuccess andFailure:(FetchContentFailure)fetchFail {
    FHReadContent *content = [FHReadContent createContentWithFile:@"Content.json"];
    if (content) {
        fetchSuccess(content);
    }else{
        fetchFail(@"解析文档失败");
    }
}

- (void)saveReadRecord {
    FHRecord *record = [FHRecord new];
    record.bookId = self.bookId;
    record.chapterNo = [self.contents.paginateContents[_currentPage] chapterNo];
    record.recordPage_ch = [self.contents.paginateContents[_currentPage] pageNo];
    record.recordPage_to = _currentPage;
    [record updateRecord];
}

- (NSInteger)currentPageNo {
    return _currentPage;
}

@end
