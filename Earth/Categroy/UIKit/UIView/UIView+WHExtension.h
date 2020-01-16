//
//  UIView+WHExtension.h
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WHExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

// edges related
@property (nonatomic, assign) CGFloat wh_top;
@property (nonatomic, assign) CGFloat wh_bottom;
@property (nonatomic, assign) CGFloat wh_left;
@property (nonatomic, assign) CGFloat wh_right;

@end

NS_ASSUME_NONNULL_END
