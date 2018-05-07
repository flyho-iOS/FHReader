//
//  ViewController.m
//  FHReader
//  
//  Created by fly on 2018/3/3.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "ViewController.h"
#import "FHReadPageViewController.h"
#import "FHConstant.h"
#import "AppDefine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    FHReadPageViewController *readPageVC = [FHReadPageViewController createReaderWithContentPath:@"Content.json"];
    [self presentViewController:readPageVC animated:YES completion:nil];
}


@end
