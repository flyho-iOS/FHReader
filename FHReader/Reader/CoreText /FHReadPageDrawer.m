


//
//  FHReadPageDrawer.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/21.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHReadPageDrawer.h"

@implementation FHReadPageDrawer

- (void)dealloc {
    if (_ctframe) {
        CFRelease(_ctframe);
        _ctframe = nil;
    }
}
// CTFrameRef由C语言实现，生命周期需要自己管理
- (void)setCtframe:(CTFrameRef)ctframe {
    if (_ctframe != ctframe) {
        if (_ctframe) {
            CFRelease(_ctframe);
        }
        CFRetain(ctframe);
        _ctframe = ctframe;
    }
}

@end
