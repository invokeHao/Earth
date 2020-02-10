//
//  MOPhotoLibraryController.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoPreviewViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <YYImage.h>
#import <Masonry.h>
#import "MOPhotoUtil.h"
#import "MOMacro.h"

#import "MOPhotoPreviewNavigationBar.h"

@interface MOPhotoPreviewViewController () <MOPhotoPreviewNavigationBarDelegate>

@property (nonatomic, strong) YYAnimatedImageView *previewImageView;
@property (nonatomic, strong) MOAssetModel *assetModel;
@property (nonatomic, strong) YYImage *image;
@property (nonatomic, strong) MOPhotoPreviewNavigationBar *navigationBar;

@end

@implementation MOPhotoPreviewViewController

- (instancetype)initWithAssetModel:(MOAssetModel *)assetModel andYYImage:(YYImage *)image {
    self = [super init];
    if (self) {
        self.assetModel = assetModel;
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupConstraint];
    [self dataBinding];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewImageView];
    [self.view addSubview:self.navigationBar];
}

-(void)setupConstraint {
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)dataBinding {
//    @weakify(self)
//    if (self.assetModel.type == CMSAssetMediaTypeGif) {
//        [MOPhotoUtil fetchOriginalPhotoDataWithAsset:self.assetModel.phAsset progressHandler:nil completion:^(NSData *imageData) {
//            @strongify(self)
//            self.previewImageView.image = [YYImage imageWithData:imageData];
//        }];
//    }else {
//        [MOPhotoUtil fetchImageFromPHAsset:self.assetModel.phAsset size:CGSizeMake(High_PHOTOWIDTH*self.assetModel.aspectRatio, High_PHOTOWIDTH) progressHandler:nil completion:^(UIImage *image) {
//            @strongify(self)
//            self.previewImageView.image = image;
//        }];
//    }
    self.previewImageView.image = self.image;
}


#pragma mark - getting

- (YYAnimatedImageView *)previewImageView {
    if (!_previewImageView) {
        _previewImageView = [[YYAnimatedImageView alloc] init];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView.clipsToBounds = YES;
    }
    return _previewImageView;
}

- (MOPhotoPreviewNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[MOPhotoPreviewNavigationBar alloc] init];
        _navigationBar.delegate = self;
    }
    return _navigationBar;
    return _navigationBar;
}


#pragma mark - MOPhotoPreviewNavigationBarDelegate

- (void)navigationBar:(MOPhotoPreviewNavigationBar *)navigationBar didClickLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBar:(MOPhotoPreviewNavigationBar *)navigationBar didClickRightButton:(UIButton *)rightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end





