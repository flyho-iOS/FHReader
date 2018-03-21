//
//  FHReadPageDrawer.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/21.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface FHReadPageDrawer : NSObject

@property (nonatomic,assign) CTFrameRef ctframe;
@property (nonatomic,assign) CGFloat height;

@end
