//
//  MOSelectedButton.m
//  cosmos
//
//  Created by colr on 2018/6/14.
//  Copyright © 2018年 Shell&Colr. All rights reserved.
//

#import "MOSelectedButton.h"

@implementation MOSelectedButton


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(self.width-25, 0, 25, 25);
    self.titleLabel.frame = CGRectMake(self.width-25, 0, 25, 25);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
