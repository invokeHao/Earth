//
//  MFYShareView.m
//  Earth
//
//  Created by colr on 2020/3/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYShareView.h"
#import "WHTopImageBtn.h"

#import <TencentOpenAPI/QQApiInterface.h>

@interface MFYShareView()

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, assign) CGRect shareViewFrame;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) WHTopImageBtn *wechatBtn;
@property (nonatomic, strong) WHTopImageBtn *weFriendBtn;
@property (nonatomic, strong) WHTopImageBtn *weiboBtn;
@property (nonatomic, strong) WHTopImageBtn *QQZoneBtn;
@property (nonatomic, strong) WHTopImageBtn *QQBtn;

@property (nonatomic, strong) MFYArticle * article;

@end

@implementation MFYShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    _shareViewFrame = CGRectMake(0,VERTICAL_SCREEN_HEIGHT,VERTICAL_SCREEN_WIDTH,214 + HOME_INDICATOR_HEIGHT);
    [self addSubview:self.shareView];
    [self.shareView addSubview:self.titleLabel];
    [self.shareView addSubview:self.lineView];
    [self.shareView addSubview:self.wechatBtn];
    [self.shareView addSubview:self.weFriendBtn];
    [self.shareView addSubview:self.QQBtn];
    [self.shareView addSubview:self.weiboBtn];
    [self.shareView addSubview:self.QQZoneBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(18);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.height.mas_equalTo(1.0);
    }];
    NSArray * viewArray = @[self.wechatBtn,self.weFriendBtn,self.QQBtn,self.weiboBtn,self.QQZoneBtn];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:12 tailSpacing:12];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50 + 20);
        make.bottom.mas_equalTo(-(44 + HOME_INDICATOR_HEIGHT));
    }];
}

- (void)bindEvents {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        @strongify(self)
        CGFloat tapY = [tap locationInView:self].y;
        if (tapY < self.shareView.origin.y ) {
            [self dismiss];
        }
    }];
    [self addGestureRecognizer:tap];
    
    [[self.wechatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYShareManager shareToWechatFriend:YES article:self.article completion:^(BOOL success) {
            }];
    }];
    
    [[self.weFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYShareManager shareToWechatFriend:NO article:self.article completion:^(BOOL success) {
            }];
    }];
    
    [[self.QQBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [MFYShareManager shareToQQ:YES andArticle:self.article completion:^(BOOL success) {
            if (success) {
                [self dismiss];
            }
        }];
    }];
    
    [[self.QQZoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [MFYShareManager shareToQQ:NO andArticle:self.article completion:^(BOOL success) {
            if (success) {
                [self dismiss];
            }
        }];
    }];
    
    [[self.weiboBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [MFYShareManager shareToWeiboWithArticle:self.article completion:^(BOOL success) {
            if (success) {
                [self dismiss];
            }
        }];
    }];
}

+ (void)showInViewWithArticle:(MFYArticle *)article{
    MFYShareView * shareView = [[MFYShareView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    shareView.article = article;
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
     [UIView animateWithDuration:0.2 animations:^{
         shareView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.5);
         shareView.shareView.frame = CGRectMake(0,
                                        shareView.shareViewFrame.origin.y - shareView.shareViewFrame.size.height,
                                        shareView.shareViewFrame.size.width,
                                        shareView.shareViewFrame.size.height);
     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.shareView.frame = self.shareViewFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:_shareViewFrame];
        _shareView.backgroundColor = UIColor.whiteColor;
       [_shareView roundCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
    }
    return _shareView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#313133")).WH_textAlignment(NSTextAlignmentCenter);
        _titleLabel.WH_text(@"分享至");
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = wh_colorWithHexString(@"#F5F5F5");
    }
    return _lineView;
}

- (WHTopImageBtn *)wechatBtn {
    if (!_wechatBtn) {
        _wechatBtn = [WHTopImageBtn buttonWithType:UIButtonTypeCustom];
        [_wechatBtn setImage:WHImageNamed(@"share_wx") forState:UIControlStateNormal];
        [_wechatBtn setTitleColor:wh_colorWithHexString(@"#939399") forState:UIControlStateNormal];
        [_wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
    }
    return _wechatBtn;
}

- (WHTopImageBtn *)weFriendBtn {
    if (!_weFriendBtn) {
        _weFriendBtn = [WHTopImageBtn buttonWithType:UIButtonTypeCustom];
        [_weFriendBtn setImage:WHImageNamed(@"share_pyq") forState:UIControlStateNormal];
        [_weFriendBtn setTitleColor:wh_colorWithHexString(@"#939399") forState:UIControlStateNormal];
        [_weFriendBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
    }
    return _weFriendBtn;
}

- (WHTopImageBtn *)QQBtn {
    if (!_QQBtn) {
        _QQBtn = [WHTopImageBtn buttonWithType:UIButtonTypeCustom];
        [_QQBtn setImage:WHImageNamed(@"share_QQ") forState:UIControlStateNormal];
        [_QQBtn setTitleColor:wh_colorWithHexString(@"#939399") forState:UIControlStateNormal];
        [_QQBtn setTitle:@"QQ" forState:UIControlStateNormal];
    }
    return _QQBtn;
}

- (WHTopImageBtn *)weiboBtn {
    if (!_weiboBtn) {
        _weiboBtn = [WHTopImageBtn buttonWithType:UIButtonTypeCustom];
        [_weiboBtn setImage:WHImageNamed(@"share_weibo") forState:UIControlStateNormal];
        [_weiboBtn setTitleColor:wh_colorWithHexString(@"#939399") forState:UIControlStateNormal];
        [_weiboBtn setTitle:@"微博" forState:UIControlStateNormal];
    }
    return _weiboBtn;
}

- (WHTopImageBtn *)QQZoneBtn {
    if (!_QQZoneBtn) {
        _QQZoneBtn = [WHTopImageBtn buttonWithType:UIButtonTypeCustom];
        [_QQZoneBtn setImage:WHImageNamed(@"share_QQZone") forState:UIControlStateNormal];
        [_QQZoneBtn setTitleColor:wh_colorWithHexString(@"#939399") forState:UIControlStateNormal];
        [_QQZoneBtn setTitle:@"空间" forState:UIControlStateNormal];
    }
    return _QQZoneBtn;
}

@end
