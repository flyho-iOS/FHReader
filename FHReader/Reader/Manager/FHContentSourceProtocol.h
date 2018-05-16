//
//  FHContentSourceProtocol.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/8.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHReadContent.h"
#import "FHManagerHeader.h"

@protocol FHContentSourceProtocol <NSObject>

@optional

- (void)fetchContentWithBookId:(NSInteger)bookId success:(FetchContentSuccess)fetchSuccess andFailure:(FetchContentFailure)fetchFail;

- (void)saveReadRecord;

- (void)didFinishTurnPage;

- (FHPaginateContent *)currentPageContent;

- (FHPaginateContent *)nextPageContent;

- (FHPaginateContent *)lastPageContent;

@end
