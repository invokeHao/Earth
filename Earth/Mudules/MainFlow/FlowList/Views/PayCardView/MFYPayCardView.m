//
//  MFYPayCardView.m
//  Earth
//
//  Created by colr on 2020/3/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPayCardView.h"

@interface MFYPayCardView()

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UIView * payView;

@property (nonatomic, strong)UIImageView * headerView;

@property (nonatomic, strong)YYAnimatedImageView * userIcon;

@property (nonatomic, strong)UILabel * missLabel;

@property (nonatomic, strong)UIButton * closeBtn;

@property (nonatomic, strong)MFYPayItemView * firstPayView;

@property (nonatomic, strong)MFYPayItemView * secondPayView;

@property (nonatomic, strong)MFYPayItemView * thirdPayView;

@property (nonatomic, strong)UIButton * aliPayBtn;

@property (nonatomic, strong)UIButton * wxPayBtn;

@end

@implementation MFYPayCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.backView];
    [self addSubview:self.payView];
    [self.payView addSubview:self.headerView];
    [self.headerView addSubview:self.userIcon];
    [self.headerView addSubview:self.missLabel];
    [self.headerView addSubview:self.closeBtn];
    
    [self.payView addSubview:self.firstPayView];
    [self.payView addSubview:self.secondPayView];
    [self.payView addSubview:self.thirdPayView];
    
    [self.payView addSubview:self.aliPayBtn];
    [self.payView addSubview:self.wxPayBtn];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, 345));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(102);
    }];
    
    
    
    [self.firstPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(74, 88));
    }];
    
    [self.thirdPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstPayView);
        make.size.mas_equalTo(self.firstPayView);
        make.right.mas_equalTo(-20);
    }];

    
    [self.secondPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstPayView);
        make.size.mas_equalTo(self.firstPayView);
        make.centerX.mas_equalTo(self);
    }];
    
    
    [self.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    [self.wxPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.aliPayBtn);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(self.aliPayBtn);
    }];
}

- (void)bindEvents {
    
}

+ (void)showInView:(UIView *)view completion:(void (^)(BOOL))completion {
    MFYPayCardView * cardView = [[MFYPayCardView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    [view addSubview:cardView];
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.5);
    }
    return _backView;
}

- (UIView *)payView {
    if (!_payView) {
        _payView = [[UIView alloc]init];
        _payView.backgroundColor = UIColor.whiteColor;
    }
    return _payView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = UIImageView.imageView.WH_image(WHImageNamed(@"flow_pay_header"));
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

-(YYAnimatedImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[YYAnimatedImageView alloc]init];
    }
    return _userIcon;
}

- (UILabel *)missLabel {
    if (!_missLabel) {
        _missLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(UIColor.whiteColor);
        _missLabel.WH_text(@"你刚刚错过了我 后悔吗？");
        _missLabel.numberOfLines = 2;
    }
    return _missLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = UIButton.button;
        _closeBtn.WH_setImage_forState(WHImageNamed(@"flow_pay_close"),UIControlStateNormal);
    }
    return _closeBtn;
}

-(UIButton *)aliPayBtn {
    if (!_aliPayBtn) {
        _aliPayBtn = UIButton.button;
        _aliPayBtn.WH_setImage_forState(WHImageNamed(@"pay_alipayBtn"),UIControlStateNormal);
        _aliPayBtn.WH_setTitle_forState(@"支付宝",UIControlStateNormal);
        _aliPayBtn.backgroundColor = wh_colorWithHexString(@"#2B8DE4");
    }
    return _closeBtn;
}

- (UIButton *)wxPayBtn {
    if (!_wxPayBtn) {
        _wxPayBtn = UIButton.button;
        _wxPayBtn.WH_setImage_forState(WHImageNamed(@"pay_wxpayBtn"),UIControlStateNormal);
        _wxPayBtn.WH_setTitle_forState(@"微信",UIControlStateNormal);
        _wxPayBtn.backgroundColor = wh_colorWithHexString(@"#2BC57D");
    }
    return _wxPayBtn;
}

@end

@implementation MFYPayItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor =  wh_colorWithHexString(@"#EBEBF5");
    [self addSubview:self.timesLabel];
    [self addSubview:self.priceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (UILabel *)timesLabel {
    if (!_timesLabel) {
        _timesLabel = UILabel.label.WH_font(WHFont(20)).WH_textColor(wh_colorWithHexString(@"#626266"));
        _timesLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _timesLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#626266"));
        _priceLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _priceLabel;
}




@end
