//
//  FHChapter.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHPaginateContent;

@interface FHChapter : NSObject <NSCoding>
/** 章节序号 */
@property (nonatomic,assign) NSInteger chapterNo;
/** 章节开始页数（总页数） */
@property (nonatomic,assign) NSInteger startPageNo;
/** 章节页数 */
@property (nonatomic,assign) NSInteger chapterPageCount;
/** 章节标题 */
@property (nonatomic,copy) NSString *title;
/** 全章节内容 */
@property (nonatomic,copy) NSString *content;
/** 章节分页内容 */
@property (nonatomic,copy) NSDictionary<NSString *,FHPaginateContent *> *chapterPaginates;

@end
