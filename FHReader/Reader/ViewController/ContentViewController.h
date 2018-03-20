//
//  ContentViewController.h
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FHPaginateContent;

@interface ContentViewController : UIViewController

@property (nonatomic,strong) FHPaginateContent *paginateContent; //分页内容

+ (instancetype)createPageWithContent:(FHPaginateContent *)paginateContent;

@end
