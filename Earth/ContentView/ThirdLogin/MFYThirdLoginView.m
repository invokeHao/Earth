//
//  MFYThirdLoginView.m
//  Earth
//
//  Created by colr on 2020/4/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYThirdLoginView.h"
#import "MFYBindZFBView.h"
#import "MFYMineService.h"

@interface MFYThirdLoginView()

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UIView * loginView;

@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)UIButton * aliPayBtn;

@property (nonatomic, strong)UIButton * wxPayBtn;

@property (nonatomic, strong)MFYBindZFBView * bindZFBView;

@end

@implementation MFYThirdLoginView

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
    [self.backView addSubview:self.bindZFBView];
    [self.backView addSubview:self.loginView];
    [self.loginView addSubview:self.titleLabel];
    [self.loginView addSubview:self.aliPayBtn];
    [self.loginView addSubview:self.wxPayBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(280, 166));
    }];
    
    [self.bindZFBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(280, 280));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginView);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(19);
    }];
    
    [self.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.wxPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.height.mas_equalTo(self.aliPayBtn);
        make.top.mas_equalTo(self.aliPayBtn.mas_bottom).offset(10);
    }];
}


- (void)bindEvents {
    @weakify(self)
    [[self.aliPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.bindZFBView.hidden = NO;
        self.loginView.hidden = YES;
    }];
    
    [[self.wxPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYThirdLoginManager sendWXAuthReqCoompletion:^(BOOL isSuccess) {
            @strongify(self)
            [self dismiss];
        }];
    }];
    
    [self.bindZFBView setSubmitBlock:^(NSDictionary * _Nonnull infoDic) {
        if (infoDic.allKeys.count == 3) {
            [MFYThirdLoginManager sendALiInfo:infoDic Coompletion:^(BOOL isSuccess) {
                @strongify(self)
                [self dismiss];
            }];
        }else {
            [WHHud showString:@"请完善信息"];
        }
    }];
}

+ (void)showInView{
    MFYThirdLoginView * loginView = [[MFYThirdLoginView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:loginView];
         [UIView animateWithDuration:0.2 animations:^{
             loginView.alpha = 1;
         }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)checkToShowTheThirdLoginView {
    if ([MFYLoginManager token].length > 0) {
        [MFYMineService getSelfDetailInfoCompletion:^(MFYProfile * profile, NSError * error) {
            if (profile) {
                if (profile.balance > 0) {
                    if (profile.withdrawWeixinEnable || profile.withdrawAlipayEnable) {
                    }else {
                        [MFYThirdLoginView showInView];
                    }
                }
            }
        }];
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.5);
    }
    return _backView;
}

- (UIView *)loginView {
    if (!_loginView) {
        _loginView = [[UIView alloc]init];
        _loginView.backgroundColor = UIColor.whiteColor;
        _loginView.layer.cornerRadius = 10;
    }
    return _loginView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label;
        _titleLabel.WH_font(WHFont(18)).WH_textColor(wh_colorWithHexString(@"#333333"));
        _titleLabel.WH_text(@"提现绑定");
    }
    return _titleLabel;
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

- (MFYBindZFBView *)bindZFBView {
    if (!_bindZFBView) {
        _bindZFBView = [[MFYBindZFBView alloc]init];
        _bindZFBView.hidden = YES;
    }
    return _bindZFBView;
}



@end
