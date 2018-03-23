//
//  AppDefine.h
//  FHReader
//
//  Created by fly on 2018/3/4.
//  Copyright © 2018年 flyho. All rights reserved.
//

#ifndef AppDefine_h
#define AppDefine_h

#define FHUserDefault [NSUserDefaults standardUserDefaults]

#define FHScreenWidth [UIScreen mainScreen].bounds.size.width
#define FHScreenHeight [UIScreen mainScreen].bounds.size.height

#define NSDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define ReadPageRect CGRectMake(30, 30, FHScreenWidth-70, FHScreenHeight-80)

#define FHDeallocLog() NSLog(@"dealloc --> %@ <%p>",[self class],self);

#endif /* AppDefine_h */
