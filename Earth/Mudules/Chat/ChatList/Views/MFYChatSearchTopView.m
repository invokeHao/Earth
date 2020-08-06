//
//  MFYChatSearchTopView.m
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatSearchTopView.h"

@interface MFYChatSearchTopView()

@property (nonatomic, strong)UIButton * cancelBtn;

@property (nonatomic, strong)UILabel * tipsLabel;

@property (nonatomic, strong)UILabel * descLabel;

@property (nonatomic, copy) void (^action)(NSString *keyword);

@property (nonatomic, copy) dispatch_block_t cancelAction;


@end

@implementation MFYChatSearchTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.searchView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.descLabel];
//    [self.searchView.textField becomeFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchView);
        make.size.mas_equalTo(CGSizeMake(35, 22));
        make.right.mas_equalTo(-7);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(self.cancelBtn.mas_left).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(18);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
}

- (void)bindEvents {
    @weakify(self)
    [self.searchView setPlaceholder:@"搜索" searchAction:^(NSString * _Nonnull keywork) {
        @strongify(self)
        if (self.action) {
            self.action(keywork);
        }
    }];
    
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.cancelAction) {
            self.cancelAction();
        }
    }];
}

#pragma mark- public method

- (void)searchAction:(void (^)(NSString * _Nonnull))action cancelAction:(dispatch_block_t)cancelAction {
    if (action) {
        self.action = action;
    }
    if (cancelAction) {
        self.cancelAction = cancelAction;
    }
}


- (MFYChatSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[MFYChatSearchView alloc]init];
    }
    return _searchView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.button.WH_setTitle_forState(@"取消",UIControlStateNormal).WH_setTitleColor_forState(wh_colorWithHexString(@"#626366"),UIControlStateNormal);
        _cancelBtn.WH_titleLabel_font(WHFont(16));
    }
    return _cancelBtn;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.label.WH_textColor(wh_colorWithHexString(@"#939499")).WH_textAlignment(NSTextAlignmentCenter);
        _tipsLabel.WH_font(WHFont(15));
        _tipsLabel.text = @"输入朋友帐号/昵称，即可与对方聊天";
    }
    return _tipsLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = UILabel.label.WH_font(WHFont(13)).WH_textColor(wh_colorWithHexString(@"#C4C5CC"));
        _descLabel.WH_textAlignment(NSTextAlignmentCenter);
        _descLabel.numberOfLines = 2;
        _descLabel.text = @"交友指南：建议让喜欢的人输入帐号，如果没有注册，可在3天内指定帐号注册";
    }
    return _descLabel;
}

@end
