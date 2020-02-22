//
//  MFYCFToolView.m
//  Earth
//
//  Created by colr on 2019/12/24.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCFToolView.h"
#import "MFYBaseNavigationController.h"
#import "MFYPublicImageCardVC.h"

@implementation MFYCFToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.beforeBtn];
    [self addSubview:self.dislikeBtn];
    [self addSubview:self.likeBtn];
    [self addSubview:self.messageBtn];
    [self addSubview:self.publicBtn];
}

- (void)bindEvents {
    
    [[self.beforeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYLoginManager jumpToLoginWithCompletion:^{
            WHLog(@"success");
        }];
    }];
    
    [[self.publicBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIViewController * vc = [WHAlertTool WHTopViewController];
        MFYBaseNavigationController * Nav = [[MFYBaseNavigationController alloc]initWithRootViewController:[MFYPublicImageCardVC new]];
        [vc presentViewController:Nav animated:YES completion:NULL];
    }];
    @weakify(self)
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.tapLikeBlock) {
            self.tapLikeBlock(YES);
        }
    }];
    
    [[self.dislikeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        if (self.tapLikeBlock) {
            self.tapLikeBlock(NO);
        }
    }];
}

- (void)likeBtnAction {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = ((VERTICAL_SCREEN_WIDTH - 36) - W_SCALE(80) - W_SCALE(100) - W_SCALE(60)) / 4;
    @weakify(self)
    [self.beforeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(40), W_SCALE(40)));
    }];
    
    [self.dislikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.mas_equalTo(self.beforeBtn.mas_right).mas_offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(50), W_SCALE(50)));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.mas_equalTo(self.dislikeBtn.mas_right).mas_offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(60), W_SCALE(60)));
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.mas_equalTo(self.likeBtn.mas_right).mas_offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(50), W_SCALE(50)));
    }];
    
    [self.publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.mas_equalTo(self.messageBtn.mas_right).mas_offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(40), W_SCALE(40)));
    }];
    [self layoutIfNeeded];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            @strongify(self)
            [self setupTheShadowWithView:obj];
        }
    }];
}

- (void)setupTheShadowWithView:(UIButton*)button {
    button.layer.shadowColor = [UIColor colorWithRed:251/255.0 green:126/255.0 blue:92/255.0 alpha:0.8].CGColor;
    button.layer.shadowOffset = CGSizeMake(0,0);
    button.layer.shadowOpacity = 1;
    button.layer.shadowRadius = 22;
    [button roundCorner:UIRectCornerAllCorners radius:button.width/2];
}



- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:WHImageNamed(@"core_like") forState:UIControlStateNormal];
    }
    return _likeBtn;
}

- (UIButton *)dislikeBtn {
    if (!_dislikeBtn) {
        _dislikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dislikeBtn setImage:WHImageNamed(@"core_dislike") forState:UIControlStateNormal];
    }
    return _dislikeBtn;
}

- (UIButton *)beforeBtn {
    if (!_beforeBtn) {
        _beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beforeBtn setImage:WHImageNamed(@"core_before") forState:UIControlStateNormal];
    }
    return _beforeBtn;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:WHImageNamed(@"core_message") forState:UIControlStateNormal];
    }
    return _messageBtn;
}

- (UIButton *)publicBtn {
    if (!_publicBtn) {
        _publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publicBtn setImage:WHImageNamed(@"core_public") forState:UIControlStateNormal];
    }
    return _publicBtn;
}

@end
