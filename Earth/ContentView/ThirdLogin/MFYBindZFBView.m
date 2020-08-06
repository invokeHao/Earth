//
//  MFYBindZFBView.m
//  Earth
//
//  Created by colr on 2020/5/7.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBindZFBView.h"

@interface MFYBindZFBView()

@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)UITextField * nameField;

@property (nonatomic, strong)UITextField * IDField;

@property (nonatomic, strong)UITextField * ZFBIDField;

@end

@implementation MFYBindZFBView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 10;
    [self addSubview:self.titleLabel];
    [self addSubview:self.ZFBIDField];
    [self addSubview:self.nameField];
    [self addSubview:self.IDField];
    [self addSubview:self.submitBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(19);
    }];
    [self.ZFBIDField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.height.mas_equalTo(self.ZFBIDField);
        make.top.mas_equalTo(self.ZFBIDField.mas_bottom).offset(10);
    }];
    
    [self.IDField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.height.mas_equalTo(self.ZFBIDField);
        make.top.mas_equalTo(self.nameField.mas_bottom).offset(10);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
//        make.top.mas_equalTo(self.IDField.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        if (self.ZFBIDField.text.length < 1) {
            [WHHud showString:@"请填写您的支付宝账号"];
            return;
        }
        if (self.nameField.text.length < 1) {
            [WHHud showString:@"请填写您的真实姓名"];
            return;
        }
        if (self.IDField.text.length < 1) {
            [WHHud showString:@"请填写您的身份证号"];
            return;
        }
        NSDictionary * infoDic = [[NSDictionary alloc]init];
        [infoDic setValue:self.ZFBIDField.text forKey:@"id"];
        [infoDic setValue:self.nameField.text forKey:@"realname"];
        [infoDic setValue:self.IDField.text forKey:@"cardid"];
        if (self.submitBlock) {
            self.submitBlock(infoDic);
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label;
        _titleLabel.WH_font(WHFont(18)).WH_textColor(wh_colorWithHexString(@"#333333"));
        _titleLabel.WH_text(@"支付宝提现绑定");
    }
    return _titleLabel;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入您的真实姓名" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(15)
        }];
        _nameField.attributedPlaceholder = attrString;
        _nameField.textColor = wh_colorWithHexString(@"333333");
        _nameField.tintColor = wh_colorWithHexString(@"333333");
        _nameField.font = WHFont(15);
        _nameField.leftView = [self createLeftView];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _nameField.layer.borderWidth = 1;
        _nameField.layer.cornerRadius = 6;
    }
    return _nameField;
}

- (UITextField *)IDField {
    if (!_IDField) {
        _IDField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入您的身份证号" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(15)
        }];
        _IDField.attributedPlaceholder = attrString;
        _IDField.textColor = wh_colorWithHexString(@"333333");
        _IDField.tintColor = wh_colorWithHexString(@"333333");
        _IDField.font = WHFont(15);
        _IDField.leftView = [self createLeftView];
        _IDField.leftViewMode = UITextFieldViewModeAlways;
        _IDField.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _IDField.layer.borderWidth = 1;
        _IDField.layer.cornerRadius = 6;

    }
    return _IDField;
}

- (UITextField *)ZFBIDField {
    if (!_ZFBIDField) {
        _ZFBIDField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入您的支付宝账号" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(15)
        }];
        _ZFBIDField.attributedPlaceholder = attrString;
        _ZFBIDField.textAlignment = NSTextAlignmentLeft;
        _ZFBIDField.textColor = wh_colorWithHexString(@"333333");
        _ZFBIDField.tintColor = wh_colorWithHexString(@"333333");
        _ZFBIDField.font = WHFont(15);
        _ZFBIDField.leftView = [self createLeftView];
        _ZFBIDField.leftViewMode = UITextFieldViewModeAlways;
        _ZFBIDField.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _ZFBIDField.layer.borderWidth = 1;
        _ZFBIDField.layer.cornerRadius = 6;
    }
    return _ZFBIDField;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = UIButton.button.WH_setTitle_forState(@"绑定支付宝",UIControlStateNormal);
        _submitBtn.backgroundColor = wh_colorWithHexString(@"#FF6CA0");
        _submitBtn.WH_setTitleColor_forState(UIColor.whiteColor, UIControlStateNormal);
        _submitBtn.WH_titleLabel_font(WHFont(18));
        _submitBtn.layer.cornerRadius = 8;
        _submitBtn.clipsToBounds = YES;
    }
    return _submitBtn;;
}


- (UIView *)createLeftView {
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 44)];
    leftView.backgroundColor = [UIColor whiteColor];
    return leftView;
}


@end
