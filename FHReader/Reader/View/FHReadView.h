//
//  FHReadView.h
//  FHReader
//
//  Created by fly on 2018/3/6.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FHReadViewDataSource <NSObject>

- (NSString *) chapterTitle;
- (NSString *) chapterReadProgress;
- (NSString *) chapterContent;

@end

@interface FHReadView : UIView

@property (nonatomic,weak) id<FHReadViewDataSource> dataSource;

- (void)drawReadView;

@end
