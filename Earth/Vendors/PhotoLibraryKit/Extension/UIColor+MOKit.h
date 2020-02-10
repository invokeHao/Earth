//
//  UIColor+MOKit.h
//  Cosmos
//
//  Created by Lane on 2018/3/8.
//  Copyright © 2018年 Shell&Colr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (MOKit)

+ (UIColor *)cms_colorWithHexString:(NSString *)color;
+ (UIColor *)cms_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
