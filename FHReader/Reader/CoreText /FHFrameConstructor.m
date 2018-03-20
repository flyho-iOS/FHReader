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
#import "AppDefine.h"

#define ReadPageTopLayout 30
#define ReadPageBottomLayout 30
#define ReadPageLeftLayout 30
#define ReadPageRightayout 30

@implementation FHFrameConstructor

+ (NSArray *)paginateChapterIndex:(NSString *)content
{
    CGRect bounds = CGRectMake(ReadPageLeftLayout, ReadPageTopLayout, FHScreenWidth-ReadPageLeftLayout-ReadPageRightayout, FHScreenHeight-ReadPageTopLayout-ReadPageBottomLayout);
    NSMutableArray *pageArr = [NSMutableArray array];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:content];
    NSDictionary *attribute = [self getParserAttribute];
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

+ (NSArray *)paginateContent:(NSString *)content {
    NSMutableArray *paginateContent = [NSMutableArray array];
    NSArray *paginateIndexs = [self paginateChapterIndex:content];
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


+(NSDictionary *)getParserAttribute
{
    FHReadConfig *config = [FHReadConfig getConfig];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}

@end
