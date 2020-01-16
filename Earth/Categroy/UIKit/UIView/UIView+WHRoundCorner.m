//
//  UIView+WHRoundCorner.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "UIView+WHRoundCorner.h"


@implementation UIView (WHRoundCorner)

- (void)roundCorner:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

@end
