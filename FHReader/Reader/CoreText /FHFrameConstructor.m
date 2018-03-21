//
//  FHFrameConstructor.m
//  FHReader
//
//  Created by hefeiyang on 2018/3/14.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHFrameConstructor.h"
#import <CoreText/CoreText.h>
#import "FHReadConfig.h"
#import "FHReadPageDrawer.h"
#import "AppDefine.h"

#define ReadPageTopLayout 30
#define ReadPageBottomLayout 30
#define ReadPageLeftLayout 30
#define ReadPageRightayout 30
#define ReadPageBounds CGRectMake(ReadPageLeftLayout, ReadPageTopLayout, FHScreenWidth-ReadPageLeftLayout-ReadPageRightayout, FHScreenHeight-ReadPageTopLayout-ReadPageBottomLayout);

@implementation FHFrameConstructor

+ (FHReadPageDrawer *)parseContent:(NSString *)content config:(FHReadConfig *)config bounds:(CGRect)bounds {
    NSDictionary *attributes = [self getParserAttributeWithConfig:config];
    NSAttributedString *contentString =
    [[NSAttributedString alloc] initWithString:content
                                    attributes:attributes];
    // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)contentString);
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(FHScreenWidth-60, FHScreenHeight-60);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;

    CGPathRef path = CGPathCreateWithRect(bounds, NULL);;
//    CGPathAddRect(path, NULL, CGRectMake(0, 0, FHScreenWidth-40, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    FHReadPageDrawer *drawer = [FHReadPageDrawer new];
    drawer.ctframe = frame;
    drawer.height = textHeight;
    // 释放内存
    CFRelease(path);
    CFRelease(frame);
    CFRelease(framesetter);
    return drawer;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(FHReadConfig *)config
                                  height:(CGFloat)height
                                 content:(NSString *)content {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, FHScreenWidth-40, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (NSArray *)paginateChapterContent:(NSString *)content WithConfig:(FHReadConfig *)config{
    
    CGRect bounds = ReadPageBounds;
    NSMutableArray *pageArr = [NSMutableArray array];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary *attribute = [self getParserAttributeWithConfig:config];
    [attrStr setAttributes:attribute range:NSMakeRange(0, attrStr.length)];
    attrString = [attrStr copy];
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (pageArr.count == 0) {
                [pageArr addObject:@(currentOffset)];
            }
            else {
                NSUInteger lastOffset = [[pageArr lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [pageArr addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [pageArr addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    CGPathRelease(path);
    CFRelease(frameSetter);
    return pageArr;
}

+ (NSArray *)paginateContent:(NSString *)content WithConfig:(FHReadConfig *)config {
    NSMutableArray *paginateContent = [NSMutableArray array];
    NSArray *paginateIndexs = [self paginateChapterContent:content WithConfig:config];
    for (int i = 0 ; i < paginateIndexs.count ; i ++) {
        NSInteger local = [paginateIndexs[i] integerValue];
        NSInteger length;
        NSString *subStr;
        if (i != paginateIndexs.count-1) {
            length = [paginateIndexs[i+1] integerValue] - local;
        }else{
            length = content.length - local;
        }
        subStr = [content substringWithRange:NSMakeRange(local, length)];
        [paginateContent addObject:subStr];
    }
    return paginateContent;
}


+ (NSDictionary *)getParserAttributeWithConfig:(FHReadConfig *)config {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = config.fontColor;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", config.fontSize, NULL);
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[(id)kCTParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}

@end
