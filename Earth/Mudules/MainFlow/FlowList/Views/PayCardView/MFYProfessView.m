//
//  MFYProfessView.m
//  Earth
//
//  Created by colr on 2020/4/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYProfessView.h"
#import "MFYSingleChatVC.h"
#import "JCHATSendMsgManager.h"
#import "MFYChatService.h"

@interface MFYProfessView()

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UIView * payView;

@property (strong, nonatomic) UIButton * closeBtn;

@property (strong, nonatomic) UIImageView * headerView;

@property (strong, nonatomic) YYAnimatedImageView * userIcon;

@property (strong, nonatomic) UILabel * missLabel;

@property (strong, nonatomic) UILabel * regretLabel;

@property (strong, nonatomic) UITextView * textView;

@property (strong, nonatomic) UIButton * aliPayBtn;

@property (strong, nonatomic) UIButton * wxPayBtn;

@property (strong, nonatomic) UIButton * professBtn;

@end

@implementation MFYProfessView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
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
    [self.payView  addSubview:self.headerView];
    [self.payView  addSubview:self.userIcon];
    [self.payView  addSubview:self.missLabel];
    [self.payView  addSubview:self.regretLabel];
    [self.payView  addSubview:self.closeBtn];
    [self.payView  addSubview:self.textView];
    [self.payView  addSubview:self.aliPayBtn];
    [self.payView  addSubview:self.wxPayBtn];
    [self.payView  addSubview:self.professBtn];
    
    [self layoutViews];
}

- (void)bindEvents {
    @weakify(self)
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self dismiss];
    }];
    [[self.professBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        if (self.textView.text.length > 0) {
            [WHHud showActivityView];
            [JMSGConversation createSingleConversationWithUsername:self.article.profile.imId completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    JMSGConversation * conversation = resultObject;
                    [JCHATSendMsgManager sendMessage:self.textView.text withConversation:conversation];
                    [MFYChatService postProfessSB:self.article.profile.userId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
                        [WHHud hideActivityView];
                        if (isSuccess) {
                            [WHHud showString:@"表白成功"];
                            [JMSGConversation deleteSingleConversationWithUsername:self.article.profile.imId];
                        }else{
                            [WHHud showString:error.descriptionFromServer];
                        }
                        [self dismiss];
                    }];
                    
                }
            }];
        }else {
            [WHHud showString:@"请输入表白内容"];
        }
    }];
    [[self.wxPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYRechargeManager professWXRechargeCompletion:^(BOOL issuccess) {
            if (issuccess) {
                [WHHud showString:@"支付成功"];
                self.price = 0;
            }
        }];
    }];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(280), H_SCALE(400)));
    }];

    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
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
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(H_SCALE(175));
    }];
    
    [self.wxPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];

    [self.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.wxPayBtn.mas_top).offset(-12);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(self.wxPayBtn);
    }];
    
    [self.professBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.payView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(20);
    }];
}

+ (void)showTheProfessView:(MFYArticle *)article Price:(CGFloat)price Completion:(void (^)(BOOL))completion {
    MFYProfessView * professView = [[MFYProfessView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    professView.article = article;
    professView.price = price;
    [[UIApplication sharedApplication].keyWindow addSubview:professView];
     [UIView animateWithDuration:0.2 animations:^{
         professView.alpha = 1;
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

- (void)setArticle:(MFYArticle *)article {
    if (article) {
        _article = article;
        MFYProfile * profile = article.profile;
        [self.userIcon yy_setImageWithURL:[NSURL URLWithString:profile.headIconUrl] options:YYWebImageOptionProgressive];
    }
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    self.professBtn.hidden = price > 0;
    self.aliPayBtn.hidden = self.wxPayBtn.hidden = !self.professBtn.hidden;
    CGFloat height = price > 0 ? H_SCALE(400) : H_SCALE(360);
    [self.payView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(280), height));
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
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
        _userIcon.layer.cornerRadius = 30;
        _userIcon.layer.borderColor = UIColor.whiteColor.CGColor;
        _userIcon.layer.borderWidth = 3;
        _userIcon.clipsToBounds = YES;
    }
    return _userIcon;
}

- (UILabel *)missLabel {
    if (!_missLabel) {
        _missLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(UIColor.whiteColor);
        _missLabel.WH_text(@"你想对我说什么");
    }
    return _missLabel;
}

- (UILabel *)regretLabel {
    if (!_regretLabel) {
        _regretLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(UIColor.whiteColor);
        _regretLabel.WH_text(@"爱情吗？");
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
        _aliPayBtn.WH_setTitle_forState(@" 支付宝获取（1元）",UIControlStateNormal);
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
        _wxPayBtn.WH_setTitle_forState(@" 微信获取（1元）",UIControlStateNormal);
        _wxPayBtn.backgroundColor = wh_colorWithHexString(@"#2BC57D");
        _wxPayBtn.layer.cornerRadius = 6;
        _wxPayBtn.clipsToBounds = YES;
    }
    return _wxPayBtn;
}

- (UIButton *)professBtn {
    if (!_professBtn) {
        _professBtn = UIButton.button;
        _professBtn.WH_setImage_forState(WHImageNamed(@"core_message"),UIControlStateNormal);
    }
    return _professBtn;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.textView;
        _textView.textColor = wh_colorWithHexString(@"#343434");
        _textView.placeholder = @"对方会收到你的消息，如果有好感会主动回复你～";
        _textView.font = WHFont(14);
        _textView.backgroundColor = wh_colorWithHexString(@"#F5F5F5");
    }
    return _textView;;
}


@end
