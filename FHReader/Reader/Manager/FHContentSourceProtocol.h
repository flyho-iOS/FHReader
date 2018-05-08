//
//  FHContentSourceProtocol.h
//  FHReader
//
//  Created by hefeiyang on 2018/5/8.
//  Copyright © 2018年 hefeiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FetchContentHandler)(NSArray *chapters, NSError *error);

@protocol FHContentSourceProtocol <NSObject>

- (void)fetchContentWithBookId:(NSInteger)bookId complete:(FetchContentHandler)fetchHandler;

@end
