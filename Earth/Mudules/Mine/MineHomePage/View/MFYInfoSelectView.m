//
//  MFYInfoSelectView.m
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYInfoSelectView.h"
#import "MFYMineService.h"

@interface MFYInfoSelectView()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) MFYInfoSelectType type;

@property (nonatomic, strong) UIView * backView; //背后黑色遮照

@property (nonatomic, strong) UIView * nameView;  //选择昵称弹窗
@property (nonatomic, strong) UILabel * nameTitle;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UITextField * nameField;
@property (nonatomic, strong) UIButton * nameConfirmBtn;

@property (nonatomic, strong) UIView *  genderView; //选择性别弹窗
@property (nonatomic, strong) UILabel * genderTitle;
@property (nonatomic, strong) UIButton * manBtn;
@property (nonatomic, strong) UIButton * womanBtn;

@property (nonatomic, strong) UIView * ageView;  //选择年龄弹窗
@property (nonatomic, strong) UILabel * ageTitle;
@property (nonatomic, strong) UIButton * ageCancelBtn;
@property (nonatomic, strong) UIPickerView * agePickerView;
@property (nonatomic, strong) UIButton * ageConfirmBtn;
@property (nonatomic, strong) NSArray * ageArr;

@property (nonatomic, strong) confirmBlock confirmB;
@property (nonatomic, strong) NSString * selectAge;

@end

@implementation MFYInfoSelectView

- (instancetype)initWithType:(MFYInfoSelectType)type completion:(nonnull confirmBlock)comletion {
    self = [super initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    if (self) {
        _type = type;
        _confirmB = comletion;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    switch (self.type) {
        case MFYInfoNameType:
            [self setupNameView];
            break;
        case MFYInfoGenderType:
            [self setupGenderView];
            break;
        case MFYInfoAgeType:
            [self setupAgeView];
            break;
        default:
            break;
    }
}


+ (void)showWithType:(MFYInfoSelectType)type completion:(nonnull confirmBlock)completion{
    MFYInfoSelectView * selectView = [[MFYInfoSelectView alloc]initWithType:type completion:completion];
    [[UIApplication sharedApplication].keyWindow addSubview:selectView];
     [UIView animateWithDuration:0.2 animations:^{
         selectView.alpha = 1;
     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.nameConfirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self modifyTheNickName];
    }];
    
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [self dismiss];
    }];
    
    [[self.ageCancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [self dismiss];
    }];
    
    [[self.manBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * btn) {
        @strongify(self)
        btn.layer.borderWidth = 0;
        btn.backgroundColor = wh_colorWithHexString(@"#FF3F70");
        btn.WH_setTitleColor_forState([UIColor whiteColor], UIControlStateNormal);
//        1=female，2=male，0=未填写
        [self modifyTheGenderToMan:YES];
        
    }];
    
    [[self.womanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * btn) {
        @strongify(self)
        btn.layer.borderWidth = 0;
        btn.backgroundColor = wh_colorWithHexString(@"#FF3F70");
        btn.WH_setTitleColor_forState([UIColor whiteColor], UIControlStateNormal);
//        1=female，2=male，0=未填写
        [self modifyTheGenderToMan:NO];
    }];
    
    [[self.ageConfirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self modifyTheAge];
    }];

}

#pragma mark- 网络交互
- (void)modifyTheNickName {
    NSString * nickName = self.nameField.text;
    if (nickName.length < 1) {
        [WHHud showString:@"昵称不可为空"];
    }
    [MFYMineService postModifyNickname:nickName Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            self.confirmB(YES);
            [self modifyIMInfo:nickName userFieldType:kJMSGUserFieldsNickname];
            [self dismiss];
        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

- (void)modifyTheGenderToMan:(BOOL)toman{
    NSInteger genderType = toman ? 2 : 1;
    JMSGUserGender IMGenderType = toman ? 1 : 2;
    [MFYMineService postModifyGender:genderType Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            self.confirmB(YES);
            [self modifyIMInfo:@(IMGenderType) userFieldType:kJMSGUserFieldsGender];
            [self dismiss];
        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

- (void)modifyTheAge {
    NSString * ageStr = [self.selectAge substringToIndex:self.selectAge.length - 1];
    NSInteger age = [ageStr integerValue];
    [MFYMineService postModifyAge:age Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            self.confirmB(YES);
            [self dismiss];
        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

#pragma mark- IM修改个人信息
- (void)modifyIMInfo:(id)info userFieldType:(JMSGUserField)fieldType {
    [JMSGUser updateMyInfoWithParameter:info userFieldType:fieldType completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            WHLog(@"修改成功%@",resultObject);
        }else {
            WHLog(@"%@",error);
        }
    }];
}

- (void)setupNameView {
    [self.backView addSubview:self.nameView];
    [self.nameView addSubview:self.nameTitle];
    [self.nameView addSubview:self.nameField];
    [self.nameView addSubview:self.nameConfirmBtn];
    [self.nameView addSubview:self.closeBtn];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView).offset(-50);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(164);
    }];
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(19);
    }];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameTitle.mas_bottom).offset(14);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(40);
    }];
    [self.nameConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-18);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(40);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

- (void)setupGenderView {
    [self.backView addSubview:self.genderView];
    [self.genderView addSubview:self.genderTitle];
    [self.genderView addSubview:self.manBtn];
    [self.genderView addSubview:self.womanBtn];
    
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(190, 160));
    }];
    [self.genderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.mas_equalTo(self.genderView);
        make.height.mas_equalTo(19);
    }];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.genderTitle.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.genderView);
        make.size.mas_equalTo(CGSizeMake(110, 40));
    }];
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.manBtn.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.genderView);
        make.size.mas_equalTo(CGSizeMake(110, 40));
    }];
}

- (void)setupAgeView {
    [self.backView addSubview:self.ageView];
    [self.ageView addSubview:self.ageTitle];
    [self.ageView addSubview:self.agePickerView];
    [self.ageView addSubview:self.ageCancelBtn];
    [self.ageView addSubview:self.ageConfirmBtn];
    [self configTheAgeArr];
    
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(275 + HOME_INDICATOR_HEIGHT);
    }];
    
    [self.ageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.ageCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(36, 22));
    }];
    
    [self.ageConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.agePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(self.ageTitle.mas_bottom).offset(18);
        make.bottom.mas_equalTo(self.ageConfirmBtn.mas_top).offset(-20);
    }];
}

- (void)configTheAgeArr {
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < 101; i ++) {
        [arr addObject:FORMAT(@"%d岁",i)];
    }
    self.ageArr = [arr copy];
    self.selectAge = @"20岁";
    [self.agePickerView selectRow:20 inComponent:0 animated:YES];
}

#pragma mark- pickViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.ageArr.count;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
       
       if (!label) {
           label = [[UILabel alloc] init];
           
           label.textAlignment = NSTextAlignmentCenter;
       }
       
       label.textColor = wh_colorWithHexString(@"#333333");
       label.transform = CGAffineTransformIdentity;
       label.text = self.ageArr[row];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 22;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.ageArr.count > 0) {
        self.selectAge = self.ageArr[row];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 9 || returnKey;
    }
    return NO;
}

#pragma mark- getting

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.5);
    }
    return _backView;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [[UIView alloc]init];
        _nameView.backgroundColor = [UIColor whiteColor];
        _nameView.layer.cornerRadius = 10;
        _nameView.clipsToBounds = YES;
    }
    return _nameView;
}

- (UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = UILabel.label;
        _nameTitle.WH_font(WHFont(18)).WH_textColor(wh_colorWithHexString(@"333333")).WH_text(@"昵称");
    }
    return _nameTitle;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入你想要的昵称" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
        NSFontAttributeName:WHFont(16)
        }];
        _nameField.attributedPlaceholder = attrString;
        _nameField.font = WHFont(16);
        _nameField.textColor = wh_colorWithHexString(@"#313133");
        _nameField.tintColor = wh_colorWithHexString(@"#313133");
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.leftView = [self createLeftView];
        _nameField.delegate = self;
        _nameField.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _nameField.layer.borderWidth = 1;
        _nameField.layer.cornerRadius = 6;
        
    }
    return _nameField;
}

- (UIView *)createLeftView {
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    leftView.backgroundColor = [UIColor whiteColor];
    return leftView;
}

- (UIButton *)nameConfirmBtn {
    if (!_nameConfirmBtn) {
        _nameConfirmBtn = UIButton.button;
        _nameConfirmBtn.backgroundColor = wh_colorWithHexString(@"#FF6CA0");
        _nameConfirmBtn.WH_titleLabel_font(WHFont(19)).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
        _nameConfirmBtn.WH_setTitle_forState(@"确定",UIControlStateNormal);
        _nameConfirmBtn.layer.cornerRadius = 6;
        _nameConfirmBtn.clipsToBounds = YES;
    }
    return _nameConfirmBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = UIButton.button;
        _closeBtn.WH_setImage_forState(WHImageNamed(@"mine_close"),UIControlStateNormal);
    }
    return _closeBtn;
}

- (UIView *)genderView {
    if (!_genderView) {
        _genderView = [[UIView alloc]init];
        _genderView.backgroundColor = [UIColor whiteColor];
        _genderView.layer.cornerRadius = 10;
        _genderView.clipsToBounds = YES;
    }
    return _genderView;
}

- (UILabel *)genderTitle {
    if (!_genderTitle) {
        _genderTitle = UILabel.label;
        _genderTitle.WH_font(WHFont(18)).WH_textColor(wh_colorWithHexString(@"#333333"));
        _genderTitle.WH_text(@"性别");
    }
    return _genderTitle;
}

- (UIButton *)manBtn {
    if (!_manBtn) {
        _manBtn = UIButton.button.WH_titleLabel_font(WHFont(17)).WH_setTitleColor_forState(wh_colorWithHexString(@"#939499"),UIControlStateNormal);
        _manBtn.WH_setTitle_forState(@"男",UIControlStateNormal);
        _manBtn.backgroundColor = wh_colorWithHexString(@"FFFFFF");
        _manBtn.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _manBtn.layer.borderWidth = 1;
        _manBtn.layer.cornerRadius = 6;
    }
    return _manBtn;
}

- (UIButton *)womanBtn {
    if (!_womanBtn) {
        _womanBtn = UIButton.button.WH_titleLabel_font(WHFont(17)).WH_setTitleColor_forState(wh_colorWithHexString(@"#939499"),UIControlStateNormal);
        _womanBtn.WH_setTitle_forState(@"女",UIControlStateNormal);
        _womanBtn.backgroundColor = wh_colorWithHexString(@"FFFFFF");
        _womanBtn.layer.borderColor = wh_colorWithHexString(@"#D7D9E0").CGColor;
        _womanBtn.layer.borderWidth = 1;
        _womanBtn.layer.cornerRadius = 6;
    }
    return _womanBtn;
}


- (UIView *)ageView {
    if (!_ageView) {
        _ageView = [[UIView alloc]init];
        _ageView.backgroundColor = [UIColor whiteColor];
    }
    return _ageView;
}

- (UILabel *)ageTitle {
    if (!_ageTitle) {
        _ageTitle = UILabel.label.WH_text(@"年龄");
        _ageTitle.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#333333"));
    }
    return _ageTitle;
}

- (UIButton *)ageCancelBtn {
    if (!_ageCancelBtn) {
        _ageCancelBtn = UIButton.button.WH_setTitle_forState(@"取消",UIControlStateNormal);
        _ageCancelBtn.WH_titleLabel_font(WHFont(17)).WH_setTitleColor_forState(wh_colorWithHexString(@"#939499"),UIControlStateNormal);
    }
    return _ageCancelBtn;
}

- (UIPickerView *)agePickerView {
    if (!_agePickerView) {
        _agePickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _agePickerView.backgroundColor = [UIColor whiteColor];
        _agePickerView.delegate = self;
        _agePickerView.dataSource = self;
    }
    return _agePickerView;
}

-  (UIButton *)ageConfirmBtn {
    if (!_ageConfirmBtn) {
        _ageConfirmBtn = UIButton.button.WH_setTitle_forState(@"确认",UIControlStateNormal);
        _ageConfirmBtn.WH_titleLabel_font(WHFont(18)).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
        _ageConfirmBtn.backgroundColor = wh_colorWithHexString(@"FF3F70");
    }
    return _ageConfirmBtn;
}
@end
