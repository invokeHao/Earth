//
//  MFYPurchasedCell.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPurchasedCell.h"

@implementation MFYPurchasedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = UIColor.grayColor;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.clipsToBounds = YES;
}

@end
