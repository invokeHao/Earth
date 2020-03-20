//
//  MFYTakePhotoCell.m
//  Earth
//
//  Created by colr on 2020/3/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYTakePhotoCell.h"

@interface MFYTakePhotoCell()

@property (nonatomic, strong)YYAnimatedImageView * iconView;

@end

@implementation MFYTakePhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = UIColor.grayColor;
    [self.contentView addSubview:self.iconView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(29, 25));
    }];
}

- (YYAnimatedImageView *)iconView {
    if (!_iconView) {
        _iconView = [[YYAnimatedImageView alloc]init];
        _iconView.image = WHImageNamed(@"album_takePhoto");
    }
    return _iconView;
}

@end
