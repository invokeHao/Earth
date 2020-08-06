//
//  WHTopImageBtn.m
//  Earth
//
//  Created by colr on 2020/3/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "WHTopImageBtn.h"

@interface WHTopImageBtn()

@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, assign) CGFloat titleScale;

@end

@implementation WHTopImageBtn

- (instancetype)initWithImageScale:(CGFloat)imageScale
                     andTitleScale:(CGFloat)titleScale
{
    if (self=[super initWithFrame:CGRectZero]) {
        self.imageScale = imageScale;
        self.titleScale = titleScale;
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.imageScale = 0.7;
        self.titleScale = 0.2;
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.imageScale = 0.6;
        self.titleScale = 0.3;
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *(1-self.titleScale);
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * self.imageScale;
    return CGRectMake(0, 0, imageW, imageH);
}



@end
