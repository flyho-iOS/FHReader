//
//  FHManagerHeader.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/15.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#ifndef FHManagerHeader_h
#define FHManagerHeader_h

@class FHReadContent;
@protocol FHContentSourceProtocol;

typedef void(^FetchContentSuccess)(id<FHContentSourceProtocol> manager);

typedef void(^FetchContentFailure)(NSString *errorMsg);

#endif /* FHManagerHeader_h */
