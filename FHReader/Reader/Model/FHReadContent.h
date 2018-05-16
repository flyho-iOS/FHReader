//
//  FHReadContent.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHChapter.h"
#import "FHNote.h"
#import "FHRecord.h"
#import "FHBookMark.h"
#import "FHPaginateContent.h"

/** 该类管理书籍内容 */
@interface FHReadContent : NSObject <NSCoding>

/** 书籍标识，这里用文件名，严格设计应该赋予唯一标识 */
@property (nonatomic,assign) NSInteger identifier;
/** 笔记 */
@property (nonatomic,copy) NSArray<FHNote *> *notes;
/** 书签 */
@property (nonatomic,copy) NSArray<FHBookMark *> *marks;
/** 章节 */
@property (nonatomic,copy) NSDictionary <NSString *,FHChapter *> *chapters;
/** 所有章节所有分页 */
@property (nonatomic,copy) NSArray<FHPaginateContent *> *paginateContents;
/** 阅读记录 */
@property (nonatomic,strong) FHRecord *record;
/** 章节总数 */
@property (nonatomic,assign,readonly) NSInteger totalChapter;

/**
 *  创建内容模型
 *  @param  bookId  书籍id
 *  @return FHReadContent  内容模型
 */
+ (instancetype)localContentWithIdentifer:(NSInteger)bookId;

- (void)updateContent;

- (void)collectPaginateChapters;

@end
