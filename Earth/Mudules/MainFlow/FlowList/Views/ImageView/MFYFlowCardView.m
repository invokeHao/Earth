//
//  MFYFlowCardView.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYFlowCardView.h"

@implementation MFYFlowCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = wh_colorWithHexString(@"#E6E6E6").CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    [self addSubview:self.suduView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.likeIcon];
    [self addSubview:self.dislikeIcon];
}

- (void)layoutSubviews {
    @weakify(self)
    [self.suduView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(H_SCALE(325));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-30);
        make.right.mas_equalTo(-20);
    }];
    [self.likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.dislikeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

- (void)setModel:(MFYArticle *)model {
    if (model) {
        _model = model;
        [self.suduView setArticle:model];
        [self.titleLabel setText:model.title];
    }
}

-(void)mfy_stopPlay {
    [self.suduView stopPlay];
}

- (void)mfy_startPlay {
    [self.suduView startPlay];
}

- (MFYCardSuduPicView *)suduView {
    if (!_suduView) {
        _suduView = [[MFYCardSuduPicView alloc]init];
    }
    return _suduView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.WH_font(WHFont(17)).WH_textColor(MFYDoc333Title);
    }
    return _titleLabel;
}

- (UIImageView *)likeIcon {
    if (!_likeIcon) {
        _likeIcon = UIImageView.imageView;
        _likeIcon.image = WHImageNamed(@"core_card_like");
        _likeIcon.alpha = 0;
    }
    return _likeIcon;
}

- (UIImageView *)dislikeIcon {
    if (!_dislikeIcon) {
        _dislikeIcon = UIImageView.imageView;
        _dislikeIcon.image = WHImageNamed(@"core_card_dislike");
        _dislikeIcon.alpha = 0;
    }
    return _dislikeIcon;
}

@end
