//
//  FHBackViewController.m
//  FHReader
//
//  Created by fly on 2018/3/13.
//  Copyright © 2018年 flyho. All rights reserved.
//

#import "FHBackViewController.h"

@interface FHBackViewController ()

@property (nonatomic,strong) UIImageView *backImage;

@end

@implementation FHBackViewController

- (void)dealloc {
    NSLog(@"dealloc %@-->%p",[self class],self);
}

+ (instancetype)createBackPageWithFontPage:(UIViewController *)fontVC {
    return [[self alloc] initWithFontPage:fontVC];
}

- (instancetype)initWithFontPage:(UIViewController *)fontVC {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.backImage];
        self.backImage.image = [self captureView:fontVC.view];
    }
    return self;
}
/**
 *  页面截图并y轴翻转
 *  @param  view  被翻转的页面
 *  @return UIImage
 */
- (UIImage *)captureView:(UIView *)view {
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0.0);
    CGContextConcatCTM(context,transform);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - getter
- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _backImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
