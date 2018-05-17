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

- (instancetype)initWithBookId:(NSInteger)bookId;

@end
