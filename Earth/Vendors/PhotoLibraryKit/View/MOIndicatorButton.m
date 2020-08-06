//
//  MOIndicatorButton.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOIndicatorButton.h"
#import "UIView+MOExtension.h"

@implementation MOIndicatorButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    [self setTintColor:[UIColor whiteColor]];
    [self setImage:[UIImage imageNamed:@"ico_arrows_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"ico_arrows_up"] forState:UIControlStateSelected];
    [self sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.titleLabel.x = 0;
    self.imageView.x = self.titleLabel.width + 2;
    [CATransaction commit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self layoutIfNeeded];
}


@end


