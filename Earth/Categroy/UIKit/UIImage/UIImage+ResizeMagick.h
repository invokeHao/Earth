//
//  UIImage+ResizeMagick.h
//  Earth
//
//  Created by colr on 2020/3/2.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ResizeMagick)

- (NSString *) resizedAndReturnPath;
- (NSData *) resizedAndReturnData;

- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;
+(UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;

+(UIImage *) imageWithImageSimple:(UIImage*)image scaled:(float) scaled;

@end

NS_ASSUME_NONNULL_END
