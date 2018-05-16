//
//  FHBaseSourceManager.m
//  FHReader
//
//  Created by hefeiyang on 2018/5/8.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import "FHBaseSourceManager.h"

@interface FHBaseSourceManager ()
{
    FHPaginateContent *_tempPage;
}
@end

@implementation FHBaseSourceManager

#pragma mark - FHContentSourceProtocol

- (void)hasTurnLastPage {
    if ([self isFirstChapter] && [self isFirstPage])
    {
        self.currentPaginate.chapterNo = 0;
        self.currentPaginate.pageNo = 0;
    }
    else if (![self isFirstChapter] && [self isFirstPage])
    {
        self.currentPaginate.chapterNo --;
        self.currentPaginate.pageNo = self.currentPaginate.totalPage - 1;
    }
    else
    {
        self.currentPaginate.pageNo --;
    }
    self.currentPaginate = _tempPage;
}

- (void)hasTurnNextPage {
    if ([self isLastChapter] && [self isLastPage])
    {
        self.currentPaginate.chapterNo = self.contents.chapters.count - 1;
        self.currentPaginate.pageNo = self.currentPaginate.totalPage - 1;
    }
    else if (![self isLastChapter] && [self isLastPage])
    {
        self.currentPaginate.chapterNo ++;
        self.currentPaginate.pageNo = 0;
    }
    else
    {
        self.currentPaginate.pageNo ++;
    }
    self.currentPaginate = _tempPage;
}

- (FHPaginateContent *)nextPageContent {
    if ([self isLastChapter] && [self isLastPage])
    {
        return nil;
    }
    else if (![self isLastChapter] && [self isLastPage])
    {
        NSInteger chapterNo = self.currentPaginate.chapterNo + 1;
        NSInteger pageNo = 0;
        NSDictionary *chapterDict = self.contents.chapters[FHChapterKey(chapterNo)];
        FHPaginateContent *page = chapterDict[FHPaginateKey(pageNo)];
        _tempPage = page;
        return page;
    }
    else
    {
        NSInteger pageNo = self.currentPaginate.pageNo + 1;
        NSDictionary *chapterDict = self.contents.chapters[FHChapterKey(self.currentPaginate.chapterNo)];
        FHPaginateContent *page = chapterDict[FHPaginateKey(pageNo)];
        _tempPage = page;
        return page;
    }
}

- (FHPaginateContent *)lastPageContent {
    if ([self isFirstChapter] && [self isFirstPage])
    {
        return nil;
    }
    else if (![self isFirstChapter] && [self isFirstPage])
    {
        NSInteger chapterNo = self.currentPaginate.chapterNo - 1;
        NSInteger pageNo = self.currentPaginate.totalPage - 1;
        NSDictionary *chapterDict = self.contents.chapters[FHChapterKey(chapterNo)];
        FHPaginateContent *page = chapterDict[FHPaginateKey(pageNo)];
//        self.currentPaginate = page;
        _tempPage = page;
        return page;
    }
    else
    {
        NSInteger pageNo = self.currentPaginate.pageNo - 1;
        NSDictionary *chapterDict = self.contents.chapters[FHChapterKey(self.currentPaginate.chapterNo)];
        FHPaginateContent *page = chapterDict[FHPaginateKey(pageNo)];
//        self.currentPaginate = page;
        _tempPage = page;
        return page;
    }
}

- (FHPaginateContent *)currentPageContent {
    if (self.contents.record) {
        return self.contents.record.currentPaginate;
    }
    NSDictionary *chapterDict = self.contents.chapters[FHChapterKey((NSInteger)0)];
    FHPaginateContent *page = chapterDict[FHPaginateKey((NSInteger)0)];
    self.currentPaginate = page;
    return page;
}

- (void)saveReadRecord {
    FHRecord *record = self.contents.record;
    record.currentPaginate = self.currentPaginate;
    [record updateRecord];
}

#pragma mark - private
- (BOOL)isFirstChapter {
    return self.currentPaginate.chapterNo == 0;
}

- (BOOL)isFirstPage {
    return self.currentPaginate.pageNo == 0;
}

- (BOOL)isLastChapter {
    return self.currentPaginate.chapterNo == self.contents.chapters.count-1;
}

- (BOOL)isLastPage {
    return self.currentPaginate.pageNo == self.currentPaginate.totalPage - 1;
}



@end
