//
//  FHReaderBar.h
//  FHReader
//
//  Created by hefeiyang on 2018/3/22.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHReaderBarDelegate.h"

@interface FHReaderBar : UIView

@property (nonatomic,weak) id<FHReaderBarDelegate> delegate;

@end
