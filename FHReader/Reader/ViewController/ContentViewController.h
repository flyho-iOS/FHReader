//
//  ContentViewController.h
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FHChapter;

@interface ContentViewController : UIViewController

+ (instancetype)createPageWithChapter:(FHChapter *)chapter;

@end
