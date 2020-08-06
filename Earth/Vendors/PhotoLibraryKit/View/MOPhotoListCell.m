//
//  MOPhotoListCell.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoListCell.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MOPhotoUtil.h"
#import "MOPhotoLibraryManager.h"

@interface MOPhotoListCell ()

@property (nonatomic, strong) UIImageView *logoimageView;
@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UIView *selectedView;

@end

@implementation MOPhotoListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupConstraint];
    }
    return self;
}

-(void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.logoimageView];
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.selectedView];
}

-(void)setupConstraint {
    [self.logoimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(65);
    }];
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.logoimageView.mas_trailing).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logoimageView.mas_right).offset(-2);
        make.top.equalTo(self.logoimageView.mas_top).offset(2);
        make.width.height.mas_equalTo(12);
    }];
}

#pragma mark - pubilc method

- (void)loadData:(MOAlbumModel *)albumModel {
    [MOPhotoUtil fetchAssetInfoFromAssetCollection:albumModel.collection size:CGSizeMake(40, 40) completion:^(MOAssetCollectionInfoModel *infoModel) {
        self.logoimageView.image = infoModel.headImage;
        self.titLabel.text = [NSString stringWithFormat:@"%@ (%ld)",albumModel.name,(long)infoModel.assetCount];
    }];
    
    // 相册标签小红点逻辑
    __block BOOL hasSelectedItem = NO;
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull selectObj, NSUInteger selectIdx, BOOL * _Nonnull selectStop) {
        [albumModel.assetModelList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:selectObj]) {
                hasSelectedItem = YES;
                *stop = YES;
            }
        }];
        if (hasSelectedItem == YES) {
            *selectStop = YES;
        }
    }];
    self.selectedView.hidden = !hasSelectedItem;
}


#pragma mark - getting

- (UIImageView *)logoimageView {
    if (!_logoimageView) {
        _logoimageView = [[UIImageView alloc] init];
        _logoimageView.backgroundColor = [UIColor lightGrayColor];
        _logoimageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoimageView.clipsToBounds = YES;
    }
    return _logoimageView;
}

- (UILabel *)titLabel {
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        _titLabel.font = [UIFont systemFontOfSize:17];
        _titLabel.textColor = [UIColor lightTextColor];
        [_titLabel sizeToFit];
    }
    return _titLabel;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor wh_colorWithHexString:@"#7D95FF"];
        _selectedView.layer.cornerRadius = 6;
        _selectedView.layer.masksToBounds = YES;
        _selectedView.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectedView.layer.borderWidth = 1;
        _selectedView.hidden = YES;
    }
    return _selectedView;
}


@end
