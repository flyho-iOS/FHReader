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
    self.contents = [FHReadContent localContentWithIdentifer:bookId];
    self.currentPaginate = self.contents.record.currentPaginate;
    if (self.contents) {
        fetchSuccess(self.contents);
    }else{
        fetchFail(@"解析文档失败");
    }
}

@end
