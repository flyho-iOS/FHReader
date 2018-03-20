//
//  FHPaginateContent.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/20.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHPaginateContent : NSObject <NSCoding>

@property (nonatomic,copy)   NSString *content;
@property (nonatomic,assign) NSInteger chapterNo;
@property (nonatomic,assign) NSInteger pageNo;

+ (instancetype)createPaginateContentWithContent:(NSString *)content
                                       chapterNo:(NSInteger)chapterNo
                                          pageNo:(NSInteger)pageNo;

@end
