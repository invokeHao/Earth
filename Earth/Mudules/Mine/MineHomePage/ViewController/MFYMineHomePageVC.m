//
//  MFYMineHomePageVC.m
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMineHomePageVC.h"
#import "MFYSettingListVC.h"
#import "MFYHomeItemView.h"
#import "MFYMineHpVM.h"
#import "MFYInfoSelectView.h"
#import "MFYPublicManager.h"
#import "MFYDynamicManager.h"
#import "MFYMineService.h"
#import "MFYMyLikeListVC.h"
#import "MFYMyNoteVC.h"

@interface MFYMineHomePageVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MFYHomeItemView * myLikeCell;
@property (nonatomic, strong) MFYHomeItemView * myNoteCell;
@property (nonatomic, strong) MFYHomeItemView * myPayedCell;
@property (nonatomic, strong) MFYHomeItemView * myIconCell;
@property (nonatomic, strong) MFYHomeItemView * myNickNameCell;
@property (nonatomic, strong) MFYHomeItemView * myGenderCell;
@property (nonatomic, strong) MFYHomeItemView * myOldCell;
@property (nonatomic, strong) MFYHomeItemView * settingCell;

@property (nonatomic, strong) MFYMineHpVM * viewModel;
@property (nonatomic, strong) MFYPublicManager * publicManager;

@end

@implementation MFYMineHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self bindingData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel refreshData];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"我的";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");

    self.view.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.myLikeCell];
    [self.contentView addSubview:self.myNoteCell];
    [self.contentView addSubview:self.myPayedCell];
    [self.contentView addSubview:self.myIconCell];
    [self.contentView addSubview:self.myNickNameCell];
    [self.contentView addSubview:self.myGenderCell];
    [self.contentView addSubview:self.myOldCell];
    [self.contentView addSubview:self.settingCell];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
        make.width.height.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.settingCell.mas_bottom).offset(10);
        make.top.equalTo(self.myLikeCell.mas_top).offset(-12);
    }];
    
    [self.myLikeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(55);
    }];
    
    [self.myNoteCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myLikeCell.mas_bottom).offset(12);
    }];
    
    [self.myPayedCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myNoteCell.mas_bottom).offset(12);
    }];
    
    [self.myIconCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myPayedCell.mas_bottom).offset(25);
    }];
    
    [self.myNickNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myIconCell.mas_bottom).offset(12);
    }];
    [self.myGenderCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myNickNameCell.mas_bottom).offset(12);
    }];
    [self.myOldCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myGenderCell.mas_bottom).offset(12);
    }];
    
    [self.settingCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.myLikeCell);
        make.top.mas_equalTo(self.myOldCell.mas_bottom).offset(25);
    }];
}

- (void)bindingData {
    
    self.viewModel = [[MFYMineHpVM alloc]init];
    RACSignal * tagObserve = RACObserve(self, viewModel.profile);
    @weakify(self)
     [[[tagObserve skipUntilBlock:^BOOL(id x) {
         @strongify(self)
         return self.viewModel.profile != nil;
     }] deliverOnMainThread] subscribeNext:^(id x) {
         @strongify(self)
         [self reloadProfile];
     }];
}

- (void)bindEvents {
    @weakify(self)
    [self.myLikeCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        MFYMyLikeListVC * listVC = [[MFYMyLikeListVC alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
    }];
    [self.myNoteCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        MFYMyNoteVC * noteVC = [[MFYMyNoteVC alloc]init];
        [self.navigationController pushViewController:noteVC animated:YES];
    }];
    [self.myPayedCell setSelectB:^(BOOL isTap) {
        
    }];
    [self.myIconCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        [self.publicManager publishPhotoFromVC:self publishType:MFYPublicTypeImage completion:^(MFYAssetModel * _Nullable model) {
            [WHHud showActivityView];
            [MFYDynamicManager UploadTheAssetModel:model completion:^(MFYQiNiuResponse * _Nonnull resp, NSError * _Nonnull error) {
                NSString * fileId = resp.storeId;
                [MFYMineService postModifyIcon:fileId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
                    @strongify(self)
                    [self.viewModel refreshData];
                    [WHHud hideActivityView];
                }];
            }];
        }];
    }];
    [self.myNickNameCell setSelectB:^(BOOL isTap) {
        [MFYInfoSelectView showWithType:MFYInfoNameType completion:^(BOOL needRefresh) {
            @strongify(self)
            [self.viewModel refreshData];
        }];
    }];
    [self.myGenderCell setSelectB:^(BOOL isTap) {
        [MFYInfoSelectView showWithType:MFYInfoGenderType completion:^(BOOL needRefresh) {
           @strongify(self)
            [self.viewModel refreshData];
        }];
    }];
    [self.myOldCell setSelectB:^(BOOL isTap) {
        [MFYInfoSelectView showWithType:MFYInfoAgeType completion:^(BOOL needRefresh) {
           @strongify(self)
            [self.viewModel refreshData];
        }];
    }];
    [self.settingCell setSelectB:^(BOOL isTap) {
        @strongify(self)
        MFYSettingListVC * settingVC = [[MFYSettingListVC alloc]init];
        settingVC.profileModel = self.viewModel.profile;
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
}

- (void)reloadProfile {
    MFYProfile * profile = self.viewModel.profile;
    MFYGender * gender = profile.gender;
    [self.myIconCell.userIconView yy_setImageWithURL:[NSURL URLWithString:profile.headIconUrl] options:YYWebImageOptionProgressive];
    [self.myNickNameCell.subtitleLabel setText:profile.nickname];
    [self.myOldCell.subtitleLabel setText:FORMAT(@"%ld",profile.age)];
    [self.myGenderCell.subtitleLabel setText:gender.name];
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

- (MFYHomeItemView *)myLikeCell {
    if (!_myLikeCell) {
        _myLikeCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemLikeType];
        _myLikeCell.titleLabel.text = @"我喜欢的";
        _myLikeCell.iconView.image = WHImageNamed(@"mine_like");
    }
    return _myLikeCell;
}

- (MFYHomeItemView *)myNoteCell {
    if (!_myNoteCell) {
        _myNoteCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemLikeType];
        _myNoteCell.titleLabel.text = @"我的日记";
        _myNoteCell.iconView.image = WHImageNamed(@"mine_note");
    }
    return _myNoteCell;
}

- (MFYHomeItemView *)myPayedCell {
    if (!_myPayedCell) {
        _myPayedCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemLikeType];
        _myPayedCell.titleLabel.text = @"我购买的";
        _myPayedCell.iconView.image = WHImageNamed(@"mine_payed");
    }
    return _myPayedCell;
}

- (MFYHomeItemView *)myIconCell {
    if (!_myIconCell) {
        _myIconCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemIconType];
        _myIconCell.titleLabel.text = @"头像";
    }
    return _myIconCell;
}

- (MFYHomeItemView *)myNickNameCell {
    if (!_myNickNameCell) {
        _myNickNameCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _myNickNameCell.titleLabel.text = @"昵称";
    }
    return _myNickNameCell;
}

- (MFYHomeItemView *)myGenderCell {
    if (!_myGenderCell) {
        _myGenderCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _myGenderCell.titleLabel.text = @"性别";
    }
    return _myGenderCell;
}

- (MFYHomeItemView *)myOldCell {
    if (!_myOldCell) {
        _myOldCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemInfoType];
        _myOldCell.titleLabel.text = @"年龄";
    }
    return _myOldCell;
}

- (MFYHomeItemView *)settingCell {
    if (!_settingCell) {
        _settingCell = [[MFYHomeItemView alloc]initWithType:MFYHomeItemSettingType];
        _settingCell.titleLabel.text = @"设置";
    }
    return _settingCell;
}

- (MFYPublicManager *)publicManager {
    if (!_publicManager) {
        _publicManager = [[MFYPublicManager alloc]init];
    }
    return _publicManager;
}

@end
