//
//  MFYAddTagView.m
//  Earth
//
//  Created by colr on 2020/2/27.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAddTagView.h"
#import "MFYMineService.h"

@interface MFYAddTagView ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UIView * alterView;

@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)UIButton * dismissBtn;

@property (nonatomic, strong)UITextField * tagNameField;

@property (nonatomic, strong)UIButton * confirmBtn;

@property (nonatomic, strong) confirmBlock confirmB;

@end

@implementation MFYAddTagView

- (instancetype)initWithCompletion:(confirmBlock)completion {
    self = [super initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    if (self) {
        _confirmB = completion;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.alterView];
    [self.alterView addSubview:self.titleLabel];
    [self.alterView addSubview:self.dismissBtn];
    [self.alterView addSubview:self.tagNameField];
    [self.alterView addSubview:self.confirmBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView).offset(-50);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(164);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(19);
    }];
    [self.tagNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(40);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-18);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(40);
    }];
    
    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.tagNameField.text.length < 1) {
            [WHHud showString:@"不可以输入空标签"];
            return ;
        }
        if (self.tagNameField.text.length > 4) {
            [WHHud showString:@"最多输入4个文字"];
            return;
        }
        [MFYMineService postModifyTag:self.tagNameField.text isremove:NO Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                @strongify(self)
                if (self.confirmB) {
                    self.confirmB(YES);
                    [self dismiss];
                }
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
    
    [[self.dismissBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
      @strongify(self)
        [self dismiss];
    }];
}

+ (void)showWithCompletion:(confirmBlock)completion {
    MFYAddTagView * addTagView = [[MFYAddTagView alloc]initWithCompletion:completion];
    [[UIApplication sharedApplication].keyWindow addSubview:addTagView];
     [UIView animateWithDuration:0.2 animations:^{
         addTagView.alpha = 1;
     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.tagNameField) {
//        NSUInteger oldLength = [textField.text length];
//        NSUInteger replacementLength = [string length];
//        NSUInteger rangeLength = range.length;
//        NSUInteger newLength = oldLength - rangeLength + replacementLength;
//        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
//        return oldLength <= 4 || returnKey;
//    }
//    return NO;
//}



- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.4);
    }
    return _backView;
}

- (UIView *)alterView {
    if (!_alterView) {
        _alterView = [[UIView alloc]init];
        _alterView.backgroundColor = [UIColor whiteColor];
        _alterView.layer.cornerRadius = 10;
        _alterView.clipsToBounds = YES;
    }
    return _alterView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_font(WHFont(18));
        _titleLabel.WH_textColor(wh_colorWithHexString(@"#333333")).WH_text(@"贴标签");
    }
    return _titleLabel;
}

- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = UIButton.button;
        _dismissBtn.WH_setImage_forState(WHImageNamed(@"mine_close"),UIControlStateNormal);
    }
    return _dismissBtn;
}

- (UITextField *)tagNameField {
    if (!_tagNameField) {
        _tagNameField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"最多可填写四个文字" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(16)
        }];
        _tagNameField.attributedPlaceholder = attrString;
        _tagNameField.font = WHFont(16);
        _tagNameField.textColor = wh_colorWithHexString(@"#313133");
        _tagNameField.tintColor = wh_colorWithHexString(@"#313133");
        _tagNameField.backgroundColor = [UIColor whiteColor];
        _tagNameField.leftViewMode = UITextFieldViewModeAlways;
        _tagNameField.leftView = [self createLeftView];
        _tagNameField.delegate = self;
        _tagNameField.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _tagNameField.layer.borderWidth = 1;
        _tagNameField.layer.cornerRadius = 6;
    }
    return _tagNameField;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = UIButton.button;
        _confirmBtn.backgroundColor = wh_colorWithHexString(@"#FF6CA0");
        _confirmBtn.WH_titleLabel_font(WHFont(19)).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
        _confirmBtn.WH_setTitle_forState(@"确定",UIControlStateNormal);
        _confirmBtn.layer.cornerRadius = 6;
        _confirmBtn.clipsToBounds = YES;
    }
    return _confirmBtn;
}


- (UIView *)createLeftView {
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    leftView.backgroundColor = [UIColor whiteColor];
    return leftView;
}


@end
