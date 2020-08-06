//
//  MFYHomeItemView.m
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYHomeItemView.h"

@interface MFYHomeItemView ()

@property (nonatomic, strong) UIImageView * moreView;

@property (nonatomic, assign) MFYHomeItemType type;

@end

@implementation MFYHomeItemView

- (instancetype)initWithType:(MFYHomeItemType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.userIconView];
    [self addSubview:self.moreView];
}

- (void)layoutSubviews {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(18);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(-12);
       make.centerY.mas_equalTo(self);
       make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreView.mas_left).offset(-12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(18);
    }];
    
    [self configTheType];
}

- (void)configTheType {
    self.userIconView.hidden = self.type != MFYHomeItemIconType;
    self.iconView.hidden = self.type != MFYHomeItemLikeType;
    self.moreView.hidden = self.type == MFYHomeItemIconType;
    if (self.type != MFYHomeItemLikeType) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
        }];
    }
}

- (void)bindEvents {
    @weakify(self)
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] init];
    [[singleTap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        @strongify(self)
        self.selectB(YES);
    }];
    [self addGestureRecognizer:singleTap];
    
}

- (YYAnimatedImageView *)iconView {
    if (!_iconView) {
        _iconView = [[YYAnimatedImageView alloc]init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#313133"));
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = UILabel.label.WH_font(WHFont(16)).WH_textColor(wh_colorWithHexString(@"#626366"));
    }
    return _subtitleLabel;
}

- (YYAnimatedImageView *)userIconView {
    if (!_userIconView) {
        _userIconView = [[YYAnimatedImageView alloc]init];
        _userIconView.backgroundColor = wh_colorWithHexString(@"E5E5E5");
        _userIconView.layer.cornerRadius = 6;
        _userIconView.layer.masksToBounds = YES;
    }
    return _userIconView;
}

- (UIImageView *)moreView {
    if (!_moreView) {
        _moreView = UIImageView.imageView;
        _moreView.image = WHImageNamed(@"mine_more");
    }
    return _moreView;
}

@end
