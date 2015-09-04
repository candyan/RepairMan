//
//  NSString+ARLength.h
//  Arrietty
//
//  Created by liuyan on 14-12-11.
//  Copyright (c) 2014年 JoyShare Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ARLength)

- (NSUInteger)lengthForChineseChar;
- (NSUInteger)lengthForChar;
- (NSString *)substringCharToIndex:(NSUInteger)to;

@end
