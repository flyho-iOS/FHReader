//
//  FHBaseSourceManager.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/8.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHContentSourceProtocol.h"
#import "FHReadContent.h"

@interface FHBaseSourceManager : NSObject <FHContentSourceProtocol>

/** 书id */
@property (nonatomic,assign) NSInteger bookId;
/** 当前页码 */
@property (nonatomic,strong) FHPaginateContent *currentPaginate;
/** 书籍所有信息 */
@property (nonatomic,strong) FHReadContent *contents;

@end
