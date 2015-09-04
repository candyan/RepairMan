//
//  NSString+ARLength.m
//  Arrietty
//
//  Created by liuyan on 14-12-11.
//  Copyright (c) 2014年 JoyShare Inc. All rights reserved.
//

#import "NSString+ARLength.h"

@implementation NSString (ARLength)

- (NSString *)substringCharToIndex:(NSUInteger)to
{
    NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *stringData = [self dataUsingEncoding:stringEncoding];
    NSData *finalStringData = [stringData subdataWithRange:NSMakeRange(0, to)];
    return [[NSString alloc] initWithData:finalStringData encoding:stringEncoding];
}

- (NSUInteger)lengthForChineseChar
{
    return floorf((self.lengthForChar / 2.0));
}

- (NSUInteger)lengthForChar
{
    NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *stringData = [self dataUsingEncoding:stringEncoding];
    return [stringData length];
}

@end
