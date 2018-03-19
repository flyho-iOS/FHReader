//
//  FHRecord.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHChapter.h"

@interface FHRecord : NSObject

@property (nonatomic,strong) FHChapter *chapter;

@property (nonatomic,assign) NSInteger recordPage;

@end
