//
//  FHPaginateContent.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/20.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHPaginateContent : NSObject <NSCoding>

/** 标题 */
@property (nonatomic,copy)   NSString *title;
/** 分页内容 */
@property (nonatomic,copy)   NSString *content;
/** 总页数 */
@property (nonatomic,assign) NSInteger totalPage;
/** 章节序号 */
@property (nonatomic,assign) NSInteger chapterNo;
/** 页码 */
@property (nonatomic,assign) NSInteger pageNo;

+ (instancetype)createPaginateContentWithTitle:(NSString *)title
                                       Content:(NSString *)content
                                     totalPage:(NSInteger)totalPage
                                     chapterNo:(NSInteger)chapterNo
                                        pageNo:(NSInteger)pageNo;

@end
