//
//  UIImage+WHMosaic.h
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WHMosaic)

#pragma mark- 将图片整个打码

+(UIImage *)mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
