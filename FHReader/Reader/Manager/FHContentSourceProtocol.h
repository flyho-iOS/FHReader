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

@required
/** 书id */
@property (nonatomic,assign) NSInteger bookId;
/** 当前页码 */
@property (nonatomic,strong) FHPaginateContent *currentPaginate;
/** 书籍所有信息 */
@property (nonatomic,strong) FHReadContent *contents;

@optional

- (void)fetchContentWithBookId:(NSInteger)bookId success:(FetchContentSuccess)fetchSuccess andFailure:(FetchContentFailure)fetchFail;

- (void)saveReadRecord;

- (void)didFinishTurnPage;

- (FHPaginateContent *)currentPageContent;

- (FHPaginateContent *)nextPageContent;

- (FHPaginateContent *)lastPageContent;

- (FHPaginateContent *)refetchPaginateContent;

- (FHPaginateContent *)lastChapterContent;

- (FHPaginateContent *)nextChapterContent;

@end
