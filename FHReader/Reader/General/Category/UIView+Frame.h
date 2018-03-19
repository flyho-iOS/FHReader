//
//  UIView+Frame.h
//  Intelligent Guide
//
//  Created by hefeiyang on 2017/8/28.
//  Copyright © 2017年 hefeiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic,assign) CGFloat  x;
@property (nonatomic,assign) CGFloat  y;
@property (nonatomic,assign) CGFloat  width;
@property (nonatomic,assign) CGFloat  height;

@property (nonatomic,assign) CGFloat  centerX;
@property (nonatomic,assign) CGFloat  centerY;
/** view右边的坐标 */
@property (nonatomic,assign,readonly) CGFloat right;
/** view底部的坐标 */
@property (nonatomic,assign,readonly) CGFloat bottom;

@end
