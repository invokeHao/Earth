//
//  MFYEmptyView.m
//  Earth
//
//  Created by colr on 2020/4/14.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYEmptyView.h"

@interface MFYEmptyView()

@property (nonatomic, strong)UIImageView * iconView;

@property (nonatomic, strong)UILabel * topLabel;

@property (nonatomic, strong)UILabel * bottomLabel;



@end

@implementation MFYEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void) setupViews {
    [self addSubview:self.iconView];
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomLabel];
    [self addSubview:self.refreshBtn];
}

- (void)bindEvents {
    @weakify(self)
    [[self.refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(9);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(17);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).offset(7);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(17);
    }];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
}

+ (void)showInView:(UIView *)view refreshBlock:(void (^)(void))refresh {
    MFYEmptyView * emptyView = [[MFYEmptyView alloc]init];
    [view addSubview:emptyView];
    emptyView.refreshBlock = refresh;
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.centerY.mas_equalTo(view).offset(-80);
        make.size.mas_equalTo(CGSizeMake(160, 140));
    }];
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = UIImageView.imageView;
        _iconView.image = WHImageNamed(@"empty_icon");
    }
    return _iconView;;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = UILabel.label;
        _topLabel.WH_textColor(wh_colorWithHexString(@"#333333")).WH_font([UIFont boldSystemFontOfSize:16]).WH_text(@"103个国家");
        _topLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = UILabel.label;
        _bottomLabel.WH_textColor(wh_colorWithHexString(@"#333333")).WH_font([UIFont boldSystemFontOfSize:16]).WH_text(@"超过300万人在使用");
        _bottomLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _bottomLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = UIButton.button;
        _refreshBtn.WH_setTitle_forState(@"点击刷新",UIControlStateNormal);
        _refreshBtn.WH_setTitleColor_forState(wh_colorWithHexString(@"#B3B3B3"),UIControlStateNormal);
        _refreshBtn.titleLabel.WH_font(WHFont(14));
    }
    return _refreshBtn;
}

@end
