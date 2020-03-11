//
//  MFYChatSearchView.m
//  Earth
//
//  Created by colr on 2020/3/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatSearchView.h"

@interface MFYChatSearchView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) void (^action)(NSString *keyword);

@end

@implementation MFYChatSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    

    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    self.textField.font = WHFont(16);
    self.textField.textColor = wh_colorWithHexString(@"#939499");
    self.textField.layer.cornerRadius = 17.0;
    self.textField.clipsToBounds = YES;
    self.textField.returnKeyType = UIReturnKeySearch;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" 搜索" attributes:
                                      @{
                                        NSForegroundColorAttributeName: wh_colorWithHexString(@"#C4C6CC"),
                                        NSFontAttributeName: WHFont(16)
                                        }];
    self.textField.attributedPlaceholder = attrString;
    self.textField.leftView = [self setLeftView];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.tintColor = wh_colorWithHexString(@"#939499");
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    @weakify(self);
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.height.equalTo(@36);
        make.centerY.mas_equalTo(self);
    }];
}

- (UIView *)setLeftView {
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    UIImageView * leftImageV = UIImageView.imageView.WH_image(WHImageNamed(@"chat_search"));
    [leftImageV setFrame:CGRectMake(0, 0, 36, 36)];
    leftImageV.contentMode = UIViewContentModeCenter;
    [leftView addSubview:leftImageV];
    return leftView;
}

#pragma mark - Action

- (void)setPlaceholder:(NSString *)placeholder searchAction:(void (^)(NSString *))action {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{
                                          NSForegroundColorAttributeName: wh_colorWithHexString(@"#C4C6CC"),
                                          NSFontAttributeName: WHFont(16)
                                        }];
    self.textField.attributedPlaceholder = attrString;
    if (action) {
        self.action = [action copy];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        if (self.action) {
            self.action(textField.text);
        }
        [self.textField resignFirstResponder];
    }
    return YES;
}


@end
