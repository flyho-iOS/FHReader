//
//  FHChapter.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/16.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHChapter.h"

@interface FHChapter ()
{
    NSInteger _pageCount;
    NSArray *_paginateContents;
}
@end

@implementation FHChapter

- (NSArray *)getPaginateContents {
    return _paginateContents;
}

- (NSInteger)getPageCount {
    return _pageCount;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

@end
