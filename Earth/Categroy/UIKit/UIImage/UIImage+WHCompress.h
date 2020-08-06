//
//  UIImage+WHCompress.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WHCompress)

// 压缩分辨率
- (UIImage *)scaledToMaxSide:(CGFloat)maxSide;

// 压缩质量
- (NSData *)compressToByte:(NSUInteger)maxLength;

// mobu上传图片压缩
- (NSData *)uploadImageCompress;

@end

NS_ASSUME_NONNULL_END
