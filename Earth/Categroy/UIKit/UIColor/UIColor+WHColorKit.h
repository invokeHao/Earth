//
//  UIColor+WHColorKit.h
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//


#import <UIKit/UIKit.h>

extern UIColor *wh_colorWithHexString(NSString *str);

extern UIColor *wh_colorWithHexAndAlpha(NSString *str, CGFloat alpha);

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WHColorKit)

+ (UIColor *)wh_colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)wh_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

- (UIImage *)wh_translateToImage;

+ (UIColor*)randomColor;


@end

NS_ASSUME_NONNULL_END
