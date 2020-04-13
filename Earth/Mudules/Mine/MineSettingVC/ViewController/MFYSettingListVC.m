//
//  MFYSettingListVC.m
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYSettingListVC.h"
#import "MFYAllowSearchView.h"
#import "MFYHomeItemView.h"
#import "MFYModifyPhoneVC.h"
#import "MFYAboutUsVC.h"
#import "MFYLoginService.h"

@interface MFYSettingListVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) MFYAllowSearchView * allowSearchView;
@property (nonatomic, strong) MFYHomeItemView * changePhoneCell;
@property (nonatomic, strong) MFYHomeItemView * blackMenuCell;
@property (nonatomic, strong) MFYHomeItemView * aboutUsCell;
@property (nonatomic, strong) MFYHomeItemView * checkVersionCell;

@property (nonatomic, strong) UIButton * singOutBtn;

@end

@implementation MFYSettingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self dataBinding];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"设置";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.allowSearchView];
    [self.contentView addSubview:self.changePhoneCell];
    [self.contentView addSubview:self.blackMenuCell];
    [self.contentView addSubview:self.aboutUsCell];
    [self.contentView addSubview:self.checkVersionCell];
    [self.contentView addSubview:self.singOutBtn];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
           make.left.right.bottom.equalTo(self.view);
           make.width.height.equalTo(self.view);
       }];
       
   [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.scrollView);
       make.width.equalTo(self.scrollView);
       make.bottom.equalTo(self.singOutBtn.mas_bottom).offset(20);
       make.top.equalTo(self.allowSearchView.mas_top).offset(-12);
   }];
    
    [self.allowSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(55);
    }];
    
    [self.changePhoneCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allowSearchView.mas_bottom).offset(25);
        make.left.right.height.mas_equalTo(self.allowSearchView);
    }];
    
//    [self.blackMenuCell mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.top.mas_equalTo(self.changePhoneCell.mas_bottom).offset(8);
//       make.left.right.height.mas_equalTo(self.allowSearchView);
//    }];
    
    [self.aboutUsCell mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.changePhoneCell.mas_bottom).offset(25);
       make.left.right.height.mas_equalTo(self.allowSearchView);
    }];
    
    [self.checkVersionCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aboutUsCell.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.allowSearchView);
    }];
    
    [self.singOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.checkVersionCell.mas_bottom).offset(90);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(200, 48));
    }];
}

- (void)dataBinding {
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, profileModel);
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.profileModel != nil;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.allowSearchView setSearchOn:self.profileModel.allowSearch];
    }];

}

- (void)bindEvents {
    @weakify(self)
    [self.allowSearchView setModifyBlock:^(BOOL isAllow) {
        @strongify(self)
        self.profileModel.allowSearch = isAllow;
    }];
    
    [self.changePhoneCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        MFYModifyPhoneVC * phoneVC = [[MFYModifyPhoneVC alloc]init];
        [self.navigationController pushViewController:phoneVC animated:YES];
    }];
    
    [self.blackMenuCell setSelectB:^(BOOL isTap) {
        @strongify(self)
    }];
    
    [self.aboutUsCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        MFYAboutUsVC * aboutUsVC = [[MFYAboutUsVC alloc]init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }];
    
    [self.checkVersionCell setSelectB:^(BOOL isTap) {
        @strongify(self)
    }];
    
    [[self.singOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MFYLoginManager logoutWithCompletion:^{}];
    }];
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
    }
    return _contentView;
}

- (MFYAllowSearchView *)allowSearchView {
    if (!_allowSearchView) {
        _allowSearchView = [[MFYAllowSearchView alloc]init];
    }
    return _allowSearchView;
}

- (MFYHomeItemView *)changePhoneCell {
    if (!_changePhoneCell) {
        _changePhoneCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _changePhoneCell.titleLabel.text = @"账号安全";
    }
    return _changePhoneCell;
}

- (MFYHomeItemView *)blackMenuCell {
    if (!_blackMenuCell) {
        _blackMenuCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _blackMenuCell.titleLabel.text = @"黑名单";
    }
    return _blackMenuCell;
}

- (MFYHomeItemView *)aboutUsCell {
    if (!_aboutUsCell) {
        _aboutUsCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _aboutUsCell.titleLabel.text = @"关于";
        _aboutUsCell.subtitleLabel.text = @"基于生活圈的社交平台";
    }
    return _aboutUsCell;
}

- (MFYHomeItemView *)checkVersionCell {
    if (!_checkVersionCell) {
        _checkVersionCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _checkVersionCell.titleLabel.text = @"版本更新";
        _checkVersionCell.subtitleLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];;
    }
    return _checkVersionCell;
}

- (UIButton *)singOutBtn {
    if (!_singOutBtn) {
        _singOutBtn = UIButton.button.WH_titleLabel_font(WHFont(17));
        _singOutBtn.WH_setTitleColor_forState(wh_colorWithHexString(@"#C4C4CC"),UIControlStateNormal);
        _singOutBtn.WH_setTitle_forState(@"退出登录",UIControlStateNormal);
        _singOutBtn.layer.cornerRadius = 8;
        _singOutBtn.backgroundColor = [UIColor whiteColor];
        _singOutBtn.clipsToBounds = YES;
    }
    return _singOutBtn;
}

@end
