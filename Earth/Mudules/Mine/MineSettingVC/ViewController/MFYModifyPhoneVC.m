//
//  MFYModifyPhoneVC.m
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYModifyPhoneVC.h"
#import "MFYTimerButton.h"
#import "MFYSettingService.h"

@interface MFYModifyPhoneVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *currentPhoneView;
@property (nonatomic, strong) UIView *currentCodeView;
@property (nonatomic, strong) UIView *modifyPhoneView;
@property (nonatomic, strong) UIView *modifyCodeView;

@property (nonatomic,strong) UITextField * currentPhoneField;
@property (nonatomic,strong) UITextField * currentCodeField;
@property (nonatomic,strong) UITextField * modifyPhoneField;
@property (nonatomic,strong) UITextField * modifycodeField;

@property (nonatomic,strong) MFYTimerButton * currentTimerBtn;
@property (nonatomic,strong) MFYTimerButton * modifyTimerbtn;

@property (nonatomic,strong) UIButton * confirmBtn;


@end

@implementation MFYModifyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"更换手机号";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.currentPhoneView];
    [self.contentView addSubview:self.currentCodeView];
    [self.contentView addSubview:self.modifyPhoneView];
    [self.contentView addSubview:self.modifyCodeView];
    [self.contentView addSubview:self.confirmBtn];
    
    [self.currentPhoneView addSubview:self.currentPhoneField];
    [self.currentCodeView addSubview:self.currentCodeField];
    [self.modifyPhoneView addSubview:self.modifyPhoneField];
    [self.modifyCodeView addSubview:self.modifycodeField];
    
    [self layoutViews];
    
    [self.currentCodeField setRightView:[self setupCurrentCodeFieldRightView]];
    [self.modifycodeField setRightView:[self setupModifyCodeFieldRightView]];
}

- (void)layoutViews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
            make.left.right.bottom.equalTo(self.view);
            make.width.height.equalTo(self.view);
    }];
        
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.confirmBtn.mas_bottom).offset(20);
        make.top.equalTo(self.currentPhoneView.mas_top).offset(-12);
    }];
    
    [self.currentPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(55);
    }];

    [self.currentPhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.currentPhoneView);
        make.height.mas_equalTo(44);
    }];

    [self.currentCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.currentPhoneView.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.currentPhoneView);
    }];

    [self.currentCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.currentCodeView);
        make.height.mas_equalTo(44);
    }];

    [self.modifyPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.currentCodeView.mas_bottom).offset(25);
       make.left.right.height.mas_equalTo(self.currentPhoneView);
    }];

    [self.modifyPhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.modifyPhoneView);
        make.height.mas_equalTo(44);
    }];

    [self.modifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.modifyPhoneView.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.currentPhoneView);
    }];

    [self.modifycodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.modifyCodeView);
        make.height.mas_equalTo(44);
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.modifyCodeView.mas_bottom).offset(90);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(200, 48));
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self modifyThePhone];
    }];
}

- (void)modifyThePhone{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if (self.currentPhoneField.text.length == 11) {
        dic[@"mobile"] = self.currentPhoneField.text;
    }
    if (self.currentCodeField.text.length > 3) {
        dic[@"verifycode"] = self.currentCodeField.text;
    }
    if (self.modifyPhoneField.text.length == 11) {
        dic[@"newmobile"] = self.modifyPhoneField.text;
    }
    if (self.modifycodeField.text.length > 3) {
        dic[@"newverifycode"] = self.modifycodeField.text;
    }
    [MFYSettingService postModifyBindPhone:[dic copy] Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            [WHHud showString:@"修改成功"];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.currentPhoneField || textField == self.modifyPhoneField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 11 || returnKey;
    }
    if (textField == self.currentCodeField && textField == self.modifycodeField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 6 || returnKey;
    }
    return NO;
}

#pragma mark- setting&getting

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIView *)currentPhoneView {
    if (!_currentPhoneView) {
        _currentPhoneView = [[UIView alloc]init];
        _currentPhoneView.backgroundColor = [UIColor whiteColor];
        _currentPhoneView.layer.cornerRadius = 8;
        _currentPhoneView.clipsToBounds = YES;
    }
    return _currentPhoneView;
}

- (UITextField *)currentPhoneField {
    if (!_currentPhoneField) {
        _currentPhoneField = [[UITextField alloc]init];
        _currentPhoneField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入原手机号" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(17)
        }];
        _currentPhoneField.attributedPlaceholder = attrString;
        _currentPhoneField.keyboardType = UIKeyboardTypePhonePad;
        _currentPhoneField.font = WHFont(17);
        _currentPhoneField.textColor = wh_colorWithHexString(@"333333");
        _currentPhoneField.tintColor = wh_colorWithHexString(@"333333");
        _currentPhoneField.leftViewMode = UITextFieldViewModeAlways;
        _currentPhoneField.delegate = self;
    }
    return _currentPhoneField;
}

- (UIView *)currentCodeView {
    if (!_currentCodeView) {
        _currentCodeView = [[UIView alloc]init];
        _currentCodeView.backgroundColor = [UIColor whiteColor];
        _currentCodeView.layer.cornerRadius = 8;
        _currentCodeView.clipsToBounds = YES;
    }
    return _currentCodeView;
}

- (UITextField *)currentCodeField {
    if (!_currentCodeField) {
        _currentCodeField = [[UITextField alloc]init];
        _currentCodeField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(17)
        }];
        _currentCodeField.attributedPlaceholder = attrString;
        _currentCodeField.rightViewMode = UITextFieldViewModeAlways;
        _currentCodeField.keyboardType = UIKeyboardTypePhonePad;
        _currentCodeField.font = WHFont(17);
        _currentCodeField.textColor = wh_colorWithHexString(@"333333");
        _currentCodeField.tintColor = wh_colorWithHexString(@"333333");
        _currentCodeField.leftViewMode = UITextFieldViewModeAlways;
        _currentCodeField.delegate = self;
    }
    return _currentCodeField;
}

- (UIView *)modifyPhoneView {
    if (!_modifyPhoneView) {
        _modifyPhoneView = [[UIView alloc]init];
        _modifyPhoneView.backgroundColor = [UIColor whiteColor];
        _modifyPhoneView.layer.cornerRadius = 8;
        _modifyPhoneView.clipsToBounds = YES;
    }
    return _modifyPhoneView;
}

- (UITextField *)modifyPhoneField {
    if (!_modifyPhoneField) {
        _modifyPhoneField = [[UITextField alloc]init];
        _modifyPhoneField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入新手机号" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(17)
        }];
        _modifyPhoneField.attributedPlaceholder = attrString;
        _modifyPhoneField.keyboardType = UIKeyboardTypePhonePad;
        _modifyPhoneField.font = WHFont(17);
        _modifyPhoneField.textColor = wh_colorWithHexString(@"333333");
        _modifyPhoneField.tintColor = wh_colorWithHexString(@"333333");
        _modifyPhoneField.leftViewMode = UITextFieldViewModeAlways;
        _modifyPhoneField.delegate = self;
    }
    return _modifyPhoneField;
}

- (UIView *)modifyCodeView {
    if (!_modifyCodeView) {
        _modifyCodeView = [[UIView alloc]init];
        _modifyCodeView.backgroundColor = [UIColor whiteColor];
        _modifyCodeView.layer.cornerRadius = 8;
        _modifyCodeView.clipsToBounds = YES;
    }
    return _modifyCodeView;
}

- (UITextField *)modifycodeField {
    if (!_modifycodeField) {
        _modifycodeField = [[UITextField alloc]init];
        _modifycodeField = UITextField.textField;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(17)
        }];
        _modifycodeField.attributedPlaceholder = attrString;
        _modifycodeField.rightViewMode = UITextFieldViewModeAlways;
        _modifycodeField.keyboardType = UIKeyboardTypePhonePad;
        _modifycodeField.font = WHFont(17);
        _modifycodeField.textColor = wh_colorWithHexString(@"333333");
        _modifycodeField.tintColor = wh_colorWithHexString(@"333333");
        _modifycodeField.delegate = self;
    }
    return _modifycodeField;
}

- (MFYTimerButton *)currentTimerBtn {
    if (!_currentTimerBtn) {
        _currentTimerBtn = [[MFYTimerButton alloc]initWithCountDownTime:60];
        _currentTimerBtn.WH_titleLabel_font(WHFont(15));
        _currentTimerBtn.disableColor = wh_colorWithHexString(@"#939399");
        _currentTimerBtn.normalColor = wh_colorWithHexString(@"#FF3F70");
        _currentTimerBtn.title = @"获取验证码";
        [_currentTimerBtn setFrame:CGRectMake(0, 0, 100, 30)];
        _currentTimerBtn.layer.cornerRadius = 15;
        _currentTimerBtn.clipsToBounds = YES;
    }
    return _currentTimerBtn;
}

- (MFYTimerButton *)modifyTimerbtn {
    if (!_modifyTimerbtn) {
        _modifyTimerbtn = [[MFYTimerButton alloc]initWithCountDownTime:60];
        _modifyTimerbtn.WH_titleLabel_font(WHFont(15));
        _modifyTimerbtn.disableColor = wh_colorWithHexString(@"#939399");
        _modifyTimerbtn.normalColor = wh_colorWithHexString(@"#FF3F70");
        _modifyTimerbtn.title = @"获取验证码";
        [_modifyTimerbtn setFrame:CGRectMake(0, 0, 100, 30)];
        _modifyTimerbtn.layer.cornerRadius = 15;
        _modifyTimerbtn.clipsToBounds = YES;
    }
    return _modifyTimerbtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = UIButton.button.WH_setTitle_forState(@"完成",UIControlStateNormal).WH_titleLabel_font(WHFont(17)).WH_setTitleColor_forState(wh_colorWithHexString(@"ffffff"),UIControlStateNormal);
        _confirmBtn.WH_setTitleColor_forState(wh_colorWithHexString(@"ffffff"),UIControlStateDisabled);
        _confirmBtn.backgroundColor = wh_colorWithHexString(@"#FF3F70");
        _confirmBtn.layer.cornerRadius = 8;
        _confirmBtn.clipsToBounds = YES;
    }
    return _confirmBtn;
}

- (UIView *)setupCurrentCodeFieldRightView {
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [rightView addSubview:self.currentTimerBtn];
    [self.currentTimerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return rightView;
}

- (UIView *)setupModifyCodeFieldRightView {
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [rightView addSubview:self.modifyTimerbtn];
    [self.modifyTimerbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return rightView;
}


@end
