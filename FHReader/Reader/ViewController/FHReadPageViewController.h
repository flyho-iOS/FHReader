//
//  FHReadPageViewController.h
//  FHReader
//
//  Created by fly on 2018/3/3.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FHContentSource) {
    FHContentSourceLocal,
    FHContentSourceOnline
};

@interface FHReadPageViewController : UIViewController

@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,assign) BOOL isContinue;

+ (instancetype)createReaderWithContentPath:(NSString *)contentPath;


@end
