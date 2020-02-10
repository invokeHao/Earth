//
//  MOAssetCell.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOAssetCell.h"

#import <YYImage.h>
#import <YYModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry.h>
#import "MOPhotoUtil.h"
#import "MOMacro.h"
#import "MOAssetDownloadManager.h"
#import "MOPhotoLibraryManager.h"
#import "MODownloadNotificationModel.h"

#import "MOHud.h"
#import "MOProgressView.h"
#import "MOSelectedButton.h"

@interface MOAssetCell ()

@property (nonatomic, strong) YYAnimatedImageView *dataImageView;
@property (nonatomic, strong) MOSelectedButton *selectButton;
@property (nonatomic, strong) UIButton *videoDurationBtn;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) MOProgressView *progressView;

@property (nonatomic, strong) MOAssetModel *assetModel;

@end

@implementation MOAssetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraint];
        [self addNotification];
    }
    return self;
}

-(void)setupUI {
    [self.contentView addSubview:self.dataImageView];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.videoDurationBtn];
    [self.contentView addSubview:self.gifImageView];
    [self.contentView addSubview:self.progressView];
}

-(void)setupConstraint {
    [self.dataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.height.width.mas_equalTo(50);
    }];
    [self.videoDurationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.leading.mas_equalTo(5);
        make.width.mas_offset(100);
    }];
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.leading.mas_equalTo(5);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDownloadNotification:) name:MOAssetDownloadWillDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProgressNotification:) name:MOAssetDownloadProgressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFinishDownloadNotification:) name:MOAssetDownloadDidFinishDownloadNotification object:nil];
}

#pragma mark - pubilc method

- (void)loadData:(MOAssetModel *)assetModel {
    self.assetModel = assetModel;
    if (assetModel.serialNumber == 0) {
        self.selectButton.selected = NO;
        [self.selectButton setTitle:@"" forState:(UIControlStateNormal)];
    }else {
        self.selectButton.selected = YES;
        [self.selectButton setTitle:
         [NSString stringWithFormat:@"%ld",(long)assetModel.serialNumber] forState:UIControlStateNormal];
    }
    [self loadTypeWithAssetModel:assetModel];

    if (assetModel.type == MOAssetTypeOnlineGif) {
//        [self.dataImageView yy_setImageWithURL:[NSURL URLWithString:assetModel.gifItem.url] options:YYWebImageOptionProgressive];
    }else {
        if (assetModel.thumbImage) {
            self.dataImageView.image = assetModel.thumbImage;
        }else {
            CGFloat itemWidth = (SREEN_WIDTH - 5 * 4) * 3 / 3.0;
            @weakify(self)
            [MOPhotoUtil fetchImageFromPHAsset:assetModel.phAsset size:CGSizeMake(itemWidth, itemWidth) progressHandler:nil completion:^(UIImage *image) {
                @strongify(self)
                self.dataImageView.image = image;
                self.assetModel.thumbImage = image;
            }];
        }
    }
    if ([MOPhotoLibraryManager sharedManager].maxSelectedCount == 1) {
        self.selectButton.hidden = YES;
    }else {
        self.selectButton.hidden = NO;
    }
    if (assetModel.progress > 0 && assetModel.progress < 1) {
        self.progressView.hidden = NO;
        self.progressView.progress = assetModel.progress;
    }else {
        self.progressView.hidden = YES;
    }
}

- (void)loadTypeWithAssetModel:(MOAssetModel *)assetModel {
    switch (assetModel.type) {
        case MOAssetTypeGif: {
            self.gifImageView.hidden = NO;
            self.videoDurationBtn.hidden = YES;
        }
            break;
        case MOAssetTypeVideo: {
            self.videoDurationBtn.hidden = NO;
            self.gifImageView.hidden = YES;
            [self.videoDurationBtn setTitle:[self videoTimeFromDurationSecond:assetModel.phAsset.duration]
                                   forState:(UIControlStateNormal)];
        }
            break;
        default:
            self.gifImageView.hidden = YES;
            self.videoDurationBtn.hidden = YES;
            break;
    }
}

- (NSString *)videoTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%ld",(long)duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%ld",(long)duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%ld:0%ld",(long)min,(long)sec];
        } else {
            newTime = [NSString stringWithFormat:@"%ld:%ld",(long)min,(long)sec];
        }
    }
    return newTime;
}

#pragma mark - notification

- (void)willDownloadNotification:(NSNotification *)notification {
    
}

- (void)downloadProgressNotification:(NSNotification *)notification {
    MODownloadNotificationModel *notificationModel = [MODownloadNotificationModel yy_modelWithDictionary:notification.userInfo];
    if ([notificationModel.identifier isEqualToString:self.assetModel.identifier]) {
        self.progressView.progress = (double)notificationModel.progress;
        self.progressView.hidden = NO;
    }
}

- (void)downloadDidFinishDownloadNotification:(NSNotification *)notification {
    MODownloadNotificationModel *notificationModel = [MODownloadNotificationModel yy_modelWithDictionary:notification.userInfo];
    if ([notificationModel.identifier isEqualToString:self.assetModel.identifier]) {
        self.progressView.hidden = YES;
    }
}

#pragma mark - event response

- (void)didSelectClick:(UIButton *)sender {
    if (![[MOPhotoLibraryManager sharedManager] canSelected] && !sender.isSelected) {
        NSString *hintString = [NSString stringWithFormat:@"最多选择%ld张图片",[MOPhotoLibraryManager sharedManager].maxSelectedCount];
        [MOHud showString:hintString];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cellDidClickSelectBtn:selectedModel:)]) {
        [self.delegate cellDidClickSelectBtn:self.selectButton selectedModel:self.assetModel];
    }
    if (sender.isSelected) {
        [[MOAssetDownloadManager sharedManager] startDownloadTaskWithAsset:self.assetModel];
    }
}


#pragma mark - getting

- (YYAnimatedImageView *)dataImageView {
    if (!_dataImageView) {
        _dataImageView = [[YYAnimatedImageView alloc] init];
        _dataImageView.backgroundColor = [UIColor lightGrayColor];
        _dataImageView.contentMode = UIViewContentModeScaleAspectFill;
        _dataImageView.clipsToBounds = YES;
    }
    return _dataImageView;
}

- (MOSelectedButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[MOSelectedButton alloc] init];
        [_selectButton addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setImage:[UIImage imageNamed:@"ico_confirm_small"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"Oval_small"] forState:UIControlStateSelected];
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
    }
    return _selectButton;
}

- (UIButton *)videoDurationBtn {
    if (!_videoDurationBtn) {
        _videoDurationBtn = [[UIButton alloc] init];
        _videoDurationBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_videoDurationBtn setTintColor:[UIColor whiteColor]];
        _videoDurationBtn.backgroundColor = [UIColor clearColor];
        _videoDurationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _videoDurationBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _videoDurationBtn.userInteractionEnabled = NO;
        [_videoDurationBtn setImage:[UIImage imageNamed:@"ico_video"] forState:UIControlStateNormal];
        _videoDurationBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 5, 0, 0);
        _videoDurationBtn.hidden = YES;
    }
    return _videoDurationBtn;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_gifImageView setImage:[UIImage imageNamed:@"ico_gif"]];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}

- (MOProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[MOProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end








