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

@property (nonatomic, strong)UILabel * regretLabel;

@property (nonatomic, strong)UIButton * closeBtn;

@property (nonatomic, strong)MFYPayItemView * firstPayView;

@property (nonatomic, strong)MFYPayItemView * secondPayView;

@property (nonatomic, strong)MFYPayItemView * thirdPayView;

@property (nonatomic, strong)UIButton * aliPayBtn;

@property (nonatomic, strong)UIButton * wxPayBtn;

@property (nonatomic, strong)MFYPayItemView * selectedItem;

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
    [self.backView addSubview:self.payView];
    [self.payView addSubview:self.headerView];
    [self.headerView addSubview:self.userIcon];
    [self.headerView addSubview:self.missLabel];
    [self.headerView addSubview:self.regretLabel];
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
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(280, 300));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(102);
    }];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.missLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIcon.mas_right).offset(12);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(19);
    }];
    
    [self.regretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.missLabel);
        make.top.mas_equalTo(self.missLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(19);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.firstPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(74, 90));
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
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(110, 44));
    }];
    [self.wxPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.aliPayBtn);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(110, 44));
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self dismiss];
    }];
    MFYGlobalModel * model = [MFYGlobalManager shareGlobalModel];
    [model.imageRereadRechargeProducts enumerateObjectsUsingBlock:^(MFYAudioRereadRechargeProduct* product, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [self.firstPayView setProduct:product];
        }
        if (idx == 1) {
            [self.secondPayView setProduct:product];
        }
        if (idx == 2) {
            [self.thirdPayView setProduct:product];
        }
    }];
    
    self.selectedItem = self.secondPayView;
    
    [self.firstPayView setTapBlock:^(BOOL isTap) {
        @strongify(self)
        if (isTap) {
            [self setSelectedItem:self.firstPayView];
        }
    }];
    
    [self.secondPayView setTapBlock:^(BOOL isTap) {
        @strongify(self)
        if (isTap) {
            [self setSelectedItem:self.secondPayView];
        }
        
    }];
    
    [self.thirdPayView setTapBlock:^(BOOL isTap) {
        @strongify(self)
        if (isTap) {
            [self setSelectedItem:self.thirdPayView];
        }
    }];
    
    //微信支付
    [[self.wxPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        MFYAudioRereadRechargeProduct * product = self.selectedItem.product;
        [MFYRechargeManager rereadWithWXPay:product.productId completion:^(BOOL issuccess) {
            [self dismiss];
            if (issuccess) {
                [WHHud showString:@"支付成功"];
            }else {
                [WHHud showString:@"支付失败"];
            }
        }];
    }];
}

- (void)setSelectedItem:(MFYPayItemView *)selectedItem {
    if (selectedItem) {
        _selectedItem = selectedItem;
        [_firstPayView setIsSelected:NO];
        [_secondPayView setIsSelected:NO];
        [_thirdPayView setIsSelected:NO];
        [_selectedItem setIsSelected:YES];
    }
}

- (void)setArticle:(MFYArticle *)article {
    if (article) {
        _article = article;
        MFYProfile * profile = article.profile;
        [self.userIcon yy_setImageWithURL:[NSURL URLWithString:profile.headIconUrl] placeholder:WHImageNamed(@"default_user")];
    }
}


+ (void)showTheBeforeCard:(MFYArticle *)article Completion:(void (^)(BOOL))completion {
    MFYPayCardView * cardView = [[MFYPayCardView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    [cardView setArticle:article];
    [[UIApplication sharedApplication].keyWindow addSubview:cardView];
     [UIView animateWithDuration:0.2 animations:^{
         cardView.alpha = 1;
     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
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
        _payView.layer.cornerRadius = 10;
        _payView.clipsToBounds = YES;
    }
    return _payView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = UIImageView.imageView.WH_image(WHImageNamed(@"flow_pay_header"));
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

-(YYAnimatedImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[YYAnimatedImageView alloc]init];
        _userIcon.layer.cornerRadius = 30;
        _userIcon.clipsToBounds = YES;
    }
    return _userIcon;
}

- (UILabel *)missLabel {
    if (!_missLabel) {
        _missLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(UIColor.whiteColor);
        _missLabel.WH_text(@"你刚刚错过了我");
    }
    return _missLabel;
}

- (UILabel *)regretLabel {
    if (!_regretLabel) {
        _regretLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(UIColor.whiteColor);
        _regretLabel.WH_text(@"后悔吗？");
    }
    return _regretLabel;
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
        _aliPayBtn.WH_setTitle_forState(@" 支付宝",UIControlStateNormal);
        _aliPayBtn.backgroundColor = wh_colorWithHexString(@"#2B8DE4");
        _aliPayBtn.layer.cornerRadius = 6;
        _aliPayBtn.clipsToBounds = YES;
    }
    return _aliPayBtn;
}

- (UIButton *)wxPayBtn {
    if (!_wxPayBtn) {
        _wxPayBtn = UIButton.button;
        _wxPayBtn.WH_setImage_forState(WHImageNamed(@"pay_wxpayBtn"),UIControlStateNormal);
        _wxPayBtn.WH_setTitle_forState(@" 微信",UIControlStateNormal);
        _wxPayBtn.backgroundColor = wh_colorWithHexString(@"#2BC57D");
        _wxPayBtn.layer.cornerRadius = 6;
        _wxPayBtn.clipsToBounds = YES;
    }
    return _wxPayBtn;
}

- (MFYPayItemView *)firstPayView {
    if (!_firstPayView) {
        _firstPayView = [[MFYPayItemView alloc]init];
    }
    return _firstPayView;
}

- (MFYPayItemView *)secondPayView {
    if (!_secondPayView) {
        _secondPayView = [[MFYPayItemView alloc]init];
    }
    return _secondPayView;
}

- (MFYPayItemView *)thirdPayView {
    if (!_thirdPayView) {
        _thirdPayView = [[MFYPayItemView alloc]init];
    }
    return _thirdPayView;
}

@end

@implementation MFYPayItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self bindEvents];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = wh_colorWithHexString(@"#EBEBF5");
    [self addSubview:self.timesLabel];
    [self addSubview:self.priceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (void)setProduct:(MFYAudioRereadRechargeProduct *)product {
    if (product) {
        _product = product;
        [self.timesLabel setText:FORMAT(@"%ld次",product.productAmount)];
        [self.priceLabel setText:FORMAT(@"¥%ld",product.priceAmount)];
    }
}

- (void)bindEvents {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    @weakify(self)
    [[tap rac_gestureSignal]subscribeNext:^(id x) {
     @strongify(self)
        if (self.tapBlock) {
            self.tapBlock(YES);
        }
    }];
    [self addGestureRecognizer:tap];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.backgroundColor = wh_colorWithHexString(@"#FF3F70");
        self.timesLabel.WH_textColor(UIColor.whiteColor);
        self.priceLabel.WH_textColor(UIColor.whiteColor);
    }else {
        self.backgroundColor = wh_colorWithHexString(@"#EBEBF5");
        self.timesLabel.WH_textColor(wh_colorWithHexString(@"#626266"));
        self.priceLabel.WH_textColor(wh_colorWithHexString(@"#626266"));
    }
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
