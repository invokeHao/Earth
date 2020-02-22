//
//  MFYPhotoCropVC.m
//  Earth
//
//  Created by colr on 2020/2/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPhotoCropVC.h"
#import "TKImageView.h"
#import "MFYPhotosManager.h"

@interface MFYPhotoCropVC ()

@property (nonatomic, assign) BOOL oldNavigationBarHiddenStatus;

@property (nonatomic, strong) MFYAssetModel *model;
@property (nonatomic, copy) void (^didCropedImageCallback)(MFYAssetModel *asset);
@property (nonatomic, strong) MFYAssetModel *currentModel;

@property (nonatomic, strong) TKImageView *cropingImageView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, assign) MFYCropType cropType;
@end

@implementation MFYPhotoCropVC

- (instancetype)initWithModel:(MFYAssetModel *)model cropType:(MFYCropType)type didCropedImage:(void (^)(MFYAssetModel *asset))didCropedImageCallback {
    if (self = [super init]) {
        _model = model;
        _cropType = type;
        if (didCropedImageCallback) {
            _didCropedImageCallback = [didCropedImageCallback copy];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wh_colorWithHexString:@"1B1A28"];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.oldNavigationBarHiddenStatus = self.navigationController.navigationBarHidden;
    self.navBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:self.oldNavigationBarHiddenStatus];
}

#pragma mark - Private

- (void)initSubviews {
    [self cropingImageView];
    [self bottomBarView];
    [self cancelButton];
    [self okButton];
    
    
    CGFloat width = VERTICAL_SCREEN_WIDTH;
    CGFloat height = VERTICAL_SCREEN_HEIGHT - 90;
    
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
    } else {
        w = width;
        h = imgHeight;
    }

    [[MFYPhotosManager sharedManager] requestPhotoWithTargetSize:CGSizeMake(w * [UIScreen mainScreen].scale,
                                                                            h * [UIScreen mainScreen].scale)
                                                           asset:self.model.asset
                                                      resizeMode:PHImageRequestOptionsResizeModeFast
                                                      completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                                          self.cropingImageView.toCropImage = photo;
                                                      }];
}

#pragma mark - Action

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)okButtonClicked {
    UIImage *image = [self.cropingImageView currentCroppedImage];
    self.model.resizeImage = image;
    self.didCropedImageCallback(self.model);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Getter Setter

- (TKImageView *)cropingImageView {
    if (_cropingImageView == nil) {
        _cropingImageView = [[TKImageView alloc] init];
        _cropingImageView.showMidLines = YES;
        _cropingImageView.needScaleCrop = YES;
        _cropingImageView.showCrossLines = YES;
        _cropingImageView.cornerBorderInImage = NO;
        _cropingImageView.cropAreaCornerWidth = 44;
        _cropingImageView.cropAreaCornerHeight = 44;
        _cropingImageView.minSpace = 30;
        _cropingImageView.cropAreaCornerLineColor = [UIColor whiteColor];
        _cropingImageView.cropAreaBorderLineColor = [UIColor whiteColor];
        _cropingImageView.cropAreaCornerLineWidth = 3;
        _cropingImageView.cropAreaBorderLineWidth = 1;
        _cropingImageView.cropAreaMidLineWidth = 1;
        _cropingImageView.cropAreaMidLineHeight = 1;
        _cropingImageView.cropAreaMidLineColor = [UIColor whiteColor];
        _cropingImageView.cropAreaCrossLineColor = [UIColor whiteColor];
        _cropingImageView.cropAreaCrossLineWidth = 1;
        _cropingImageView.initialScaleFactor = 1;
        _cropingImageView.cropAspectRatio = _cropType == MFYImageCardType ? 0.7 : 1;
        [self.view addSubview:_cropingImageView];
        [_cropingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(45);
            make.bottom.equalTo(self.view).offset(-45);
            make.left.right.equalTo(self.view);
        }];
    }
    return _cropingImageView;
}

- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] init];
        [self.view addSubview:_bottomBarView];
        [_bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(- HOME_INDICATOR_HEIGHT);
            make.height.equalTo(@(45));
        }];
    }
    return _bottomBarView;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBarView).offset(16);
            make.centerY.equalTo(self.bottomBarView);
        }];
    }
    return _cancelButton;
}

- (UIButton *)okButton {
    if (_okButton == nil) {
        _okButton = [[UIButton alloc] init];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor wh_colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:_okButton];
        [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomBarView).offset(-16);
            make.centerY.equalTo(self.bottomBarView);
        }];
    }
    return _okButton;
}


@end
