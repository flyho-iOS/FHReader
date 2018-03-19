//
//  FHChapter.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHChapter : NSObject <NSCoding>

@property (nonatomic,assign) NSInteger chapterNo;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;

- (NSArray *)getPaginateContents;

- (NSInteger)getPageCount;

@end
