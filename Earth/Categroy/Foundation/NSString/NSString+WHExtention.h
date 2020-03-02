//
//  NSString+WHExtention.h
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WHExtention)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithWordWrapFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)sha1:(NSString *)input;


+ (id)toArrayOrNSDictionary:(NSString*)NOjsonString;

// 饭票逗号分开
+ (NSMutableString*)getTheMutableStringWithInteger:(NSInteger)num;

// 饭票显示单位
+ (NSString *)getTheUnitStringWithInteger:(NSInteger)num;

// 删除link中部分参数
+ (NSString *)deleteSpecificUrlQuery:(NSArray *)array andUrl:(NSString *)url;


- (NSString *)stringByTrimingWhitespace;

//一串字符串有几行
- (NSUInteger)numberOfLines;

@end

NS_ASSUME_NONNULL_END
