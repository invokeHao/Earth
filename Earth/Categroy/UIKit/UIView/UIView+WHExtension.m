//
//  UIView+WHExtension.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "UIView+WHExtension.h"


@implementation UIView (WHExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


// edges related

- (CGFloat)wh_top {
    return self.y;
}

- (void)setWh_top:(CGFloat)wh_top {
    self.y = wh_top;
}

- (CGFloat)wh_bottom {
    return self.y + self.height;
}

- (void)setWh_bottom:(CGFloat)wh_bottom {
    self.y = wh_bottom - self.height;
}

- (CGFloat)wh_left {
    return self.x;
}

- (void)setWh_left:(CGFloat)wh_left {
    self.x = wh_left;
}

- (CGFloat)wh_right {
    return self.x + self.width;
}

- (void)setWh_right:(CGFloat)wh_right {
    self.x = wh_right - self.width;
}


@end
