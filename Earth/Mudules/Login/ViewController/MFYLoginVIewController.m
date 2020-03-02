//
//  MFYLoginVIewController.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYLoginVIewController.h"
#import "MFYTimerButton.h"
#import "MFYLoginService.h"
#import "MFYMineService.h"

typedef enum : NSUInteger {
    PhoneNumType,
    verifyCodeType,
} TextFieldType;


@interface MFYLoginVIewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * dismissBtn;

@property (nonatomic, strong) UIScrollView * mainScroll;

@property (nonatomic, strong) UILabel * slognLabel;

@property (nonatomic, strong) UILabel * tipsLabel;

@property (nonatomic, strong) UILabel * phoneLabel;

@property (nonatomic, strong) UITextField * PhoneField;

@property (nonatomic, strong) UILabel * codeLabel;

@property (nonatomic, strong) UITextField * codeField;

@property (nonatomic, strong) MFYTimerButton * sendCodeBtn;

@property (nonatomic, strong) UILabel * agreeLabel;

@property (nonatomic, strong) UIButton * userAgreeBtn;

@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation MFYLoginVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
}

- (void)setupViews {
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + 32, VERTICAL_SCREEN_WIDTH, 150)];
    [self.view addSubview:topView];
    [self.view addSubview:self.dismissBtn];
    [self.view addSubview:self.mainScroll];
    [self.view addSubview:self.confirmBtn];
    
    [topView addSubview:self.slognLabel];
    [topView addSubview:self.tipsLabel];
    
    UIView * phoneView = [[UIView alloc]init];
    UIView * codeView = [[UIView alloc]init];
    
    [self.mainScroll addSubview:phoneView];
    [self.mainScroll addSubview:codeView];
    
    [self.mainScroll addSubview:self.phoneLabel];
    [phoneView addSubview:self.PhoneField];
    [self.mainScroll addSubview:self.codeLabel];
    [codeView addSubview:self.codeField];
    
    
    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + 10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [self.slognLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(topView);
        make.height.mas_equalTo(40);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.slognLabel.mas_bottom).offset(14);
        make.centerX.mas_equalTo(topView);
        make.height.mas_equalTo(15);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.mainScroll);
        make.height.mas_equalTo(25);
    }];
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(H_SCALE(30));
        make.left.mas_equalTo(W_SCALE(45));
        make.size.mas_equalTo(CGSizeMake(VERTICAL_SCREEN_WIDTH - W_SCALE(90), 56));
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(phoneView.mas_right).offset(W_SCALE(90));
        make.width.mas_equalTo(VERTICAL_SCREEN_WIDTH - W_SCALE(90));
        make.height.mas_equalTo(25);
    }];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(H_SCALE(30));
        make.left.equalTo(self.codeLabel);
        make.size.mas_equalTo(phoneView);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScroll.mas_bottom).offset(10);
        make.left.mas_equalTo(W_SCALE(45));
        make.right.mas_equalTo(W_SCALE(-45));
        make.height.mas_equalTo(56);
    }];
    
    //因为ios13的左右视图的bug，导致要这么写，蛋疼
    
    UIView * PhoneLeftView = [self setupLeftViewWithType:PhoneNumType];
    UIView * codeLeftView = [self setupLeftViewWithType:verifyCodeType];
    UIView * codeRightView = [self setupCodeFieldRightView];
    [self layoutTheView:phoneView];
    [self layoutTheView:codeView];
    [phoneView addSubview:PhoneLeftView];
    [codeView addSubview:codeLeftView];
    [codeView addSubview:codeRightView];

    
    [PhoneLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.centerY.mas_equalTo(phoneView);
        make.size.mas_equalTo(CGSizeMake(70, 56));
    }];
    [self.PhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PhoneLeftView);
        make.left.equalTo(PhoneLeftView.mas_right).offset(2);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
    }];
    
    [codeLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.centerY.mas_equalTo(codeView);
        make.size.mas_equalTo(CGSizeMake(25, 56));
    }];
    
    [codeRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeView);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 26));
    }];

    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLeftView);
        make.left.mas_equalTo(codeLeftView.mas_right).offset(1);
        make.right.mas_equalTo(codeRightView.mas_left).offset(-1);
        make.height.equalTo(codeView);
    }];
}


- (void)bindEvents {
    @weakify(self)
    [[self.dismissBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [[self.PhoneField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField * x) {
        @strongify(self)
        if (x.text.length == 11) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.mainScroll setContentOffset:CGPointMake(VERTICAL_SCREEN_WIDTH, 0)];
            } completion:^(BOOL finished) {
                [self.codeField becomeFirstResponder];
            }];
        }
    }];
    
    [[self.codeField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField * x) {
        if (x.text.length == 6) {
            self.confirmBtn.enabled = YES;
            self.confirmBtn.backgroundColor = wh_colorWithHexString(@"#FF6CA0");
        }else{
            self.confirmBtn.enabled = NO;
            self.confirmBtn.backgroundColor = wh_colorWithHexString(@"#d4d4d4");
        }
    }];
    
    [[self.sendCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.sendCodeBtn startTimer];
        
    }];
    
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.PhoneField.text.length == 11 && self.codeField.text.length == 6 ) {
            [self loginWithPhoneNum:self.PhoneField.text code:self.codeField.text];
        }else{
            WHLog(@"%@",self.codeField.text);
            [self.view showString:@"请检查验证码格式"];
        }
    }];

}


#pragma mark- 验证码登录
- (void)loginWithPhoneNum:(NSString*)num code:(NSString*)code {
    [self.view showActivityView];
    [MFYLoginService loginWithPhoneNum:num verifyCode:code completion:^(MFYLoginModel * _Nonnull loginModel, NSError * _Nonnull error) {
        if (!error) {
            //登录IM
            [self loginJChatIM:loginModel];
        }else {
            [WHHud showString:error.descriptionFromServer];
            [self.view hideActivityView];
        }
    }];
}

#pragma mark- 登录IM
- (void)loginJChatIM:(MFYLoginModel *)loginModel {
    //先获取用户IM信息
    [MFYMineService getSelfDetailInfoCompletion:^(MFYProfile * _Nonnull profile, NSError * _Nonnull error) {
        [self.view hideActivityView];
        if (!error) {
            //IM登录
            [JMSGUser loginWithUsername:profile.imId
                               password:profile.imPwd
                      completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    loginModel.imId = profile.imId;
                    loginModel.imPwd = profile.imPwd;
                    [MFYLoginManager saveTheLoginModel:loginModel];
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];

                    [self dismissViewControllerAnimated:YES completion:^{
                        [WHHud showString:@"登录成功"];
                    }];
                }else {
                    [WHHud showString:@"登录聊天系统失败"];
                    WHLogError(@"%@",error);
                }
            }];

        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.PhoneField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 11 || returnKey;
    }
    if (textField == self.codeField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 6 || returnKey;
    }
    return NO;
}

- (void)layoutTheView:(UIView*)view {
    view.layer.borderColor = wh_colorWithHexString(@"333333").CGColor;
    view.layer.borderWidth = 2;
    view.layer.cornerRadius = 28;
    view.layer.masksToBounds = YES;
}


- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.WH_setImage_forState(WHImageNamed(@"login_close"),UIControlStateNormal);
    }
    return _dismissBtn;
}

-(UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + 150, VERTICAL_SCREEN_WIDTH, 180)];
        _mainScroll.backgroundColor = [UIColor clearColor];
        _mainScroll.contentSize = CGSizeMake(VERTICAL_SCREEN_WIDTH * 2, 180);
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.pagingEnabled = YES;
        _mainScroll.bounces = NO;
        _mainScroll.scrollEnabled = NO;
    }
    return _mainScroll;
}

- (UILabel *)slognLabel {
    if (!_slognLabel) {
        _slognLabel = UILabel.label.WH_text(@"全球风靡的生活圈社交软件").WH_textColor(wh_colorWithHexString(@"383838")).WH_font(WHFont(25)).WH_textAlignment(NSTextAlignmentCenter);
    }
    return _slognLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.label.WH_text(@"中国注册人数：258801").WH_textColor(wh_colorWithHexString(@"4D4D4D")).WH_font(WHFont(14)).WH_textAlignment(NSTextAlignmentCenter);
    }
    return _tipsLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = UILabel.label.WH_text(@"输入手机号码").WH_textColor(wh_colorWithHexString(@"#FC5B64")).WH_font(WHFont(24)).WH_textAlignment(NSTextAlignmentCenter);
    }
    return _phoneLabel;
}

- (UITextField *)PhoneField {
    if (!_PhoneField) {
        _PhoneField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(20)
        }];
        _PhoneField.attributedPlaceholder = attrString;
        _PhoneField.keyboardType = UIKeyboardTypePhonePad;
        _PhoneField.font = WHFont(20);
        _PhoneField.textColor = wh_colorWithHexString(@"333333");
        _PhoneField.tintColor = wh_colorWithHexString(@"333333");
        _PhoneField.leftViewMode = UITextFieldViewModeAlways;
        _PhoneField.delegate = self;
    }
    return _PhoneField;
}

- (UIView *)setupLeftViewWithType:(TextFieldType)type {
    UIView * leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    if (type == PhoneNumType) {
        [leftView setFrame:CGRectMake(0, 0, 70,  56)];
        UILabel * areaLabel = UILabel.label.WH_text(@"+86").WH_textColor(wh_colorWithHexString(@"333333")).WH_font(WHFont(20));
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = wh_colorWithHexString(@"999999");
        [leftView addSubview:areaLabel];
        [leftView addSubview:lineView];
        [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(leftView);
            make.height.mas_equalTo(21);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.size.mas_equalTo(CGSizeMake(1, 36));
            make.left.mas_equalTo(areaLabel.mas_right).offset(8);
        }];
    }
    if (type == verifyCodeType) {
        [leftView setFrame:CGRectMake(0, 0, 25, 56)];
    }
    return leftView;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = UILabel.label.WH_text(@"输入验证码").WH_textColor(wh_colorWithHexString(@"#FC5B64")).WH_font(WHFont(24)).WH_textAlignment(NSTextAlignmentCenter);
    }
    return _codeLabel;
}

- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
               NSFontAttributeName:WHFont(20)
               }];
        _codeField.attributedPlaceholder = attrString;
        _codeField.rightViewMode = UITextFieldViewModeAlways;
        _codeField.leftViewMode = UITextFieldViewModeAlways;
        _codeField.keyboardType = UIKeyboardTypePhonePad;
        _codeField.font = WHFont(20);
        _codeField.textColor = wh_colorWithHexString(@"333333");
        _codeField.tintColor = wh_colorWithHexString(@"333333");
        _codeField.delegate = self;
    }
    return _codeField;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = UIButton.button.WH_setTitle_forState(@"确认",UIControlStateNormal).WH_titleLabel_font(WHFont(22)).WH_setTitleColor_forState(wh_colorWithHexString(@"ffffff"),UIControlStateNormal);
        _confirmBtn.WH_setTitleColor_forState(wh_colorWithHexString(@"ffffff"),UIControlStateDisabled);
        _confirmBtn.backgroundColor = wh_colorWithHexString(@"d4d4d4");
        _confirmBtn.enabled = NO;
        _confirmBtn.layer.cornerRadius = 28;
        _confirmBtn.clipsToBounds = YES;
    }
    return _confirmBtn;
}

- (MFYTimerButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [[MFYTimerButton alloc]initWithCountDownTime:60];
        _sendCodeBtn.WH_titleLabel_font(WHFont(14));
        _sendCodeBtn.disableColor = wh_colorWithHexString(@"#666666");
        _sendCodeBtn.normalColor = wh_colorWithHexString(@"#FF3F70");
        _sendCodeBtn.title = @"获取验证码";
        [_sendCodeBtn setFrame:CGRectMake(0, 0, 100, 26)];
        _sendCodeBtn.layer.cornerRadius = 13;
        _sendCodeBtn.clipsToBounds = YES;
    }
    return _sendCodeBtn;
}

- (UIView *)setupCodeFieldRightView {
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 26)];
    [rightView addSubview:self.sendCodeBtn];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(rightView);
        make.size.mas_equalTo(CGSizeMake(100, 26));
    }];
    return rightView;
}

@end
