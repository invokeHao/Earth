//
//  MFYVideoDetailVC.m
//  Earth
//
//  Created by colr on 2020/2/14.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYVideoDetailVC.h"
#import <JPVideoPlayer/UIView+WebVideoCache.h>
#import "MFYVideoProgressView.h"
#import "MFYHTTPCacheService.h"
#import <JPNavigationControllerKit.h>
#import "MFYRedPacketView.h"
#import "MFYArticleService.h"


@interface MFYVideoDetailVC ()<JPVideoPlayerDelegate>

@property (nonatomic, strong) UIView *videoContainer;

@property (nonatomic, strong) UIButton * reportBtn;

@property (nonatomic, strong) YYAnimatedImageView * imageView;

@property (nonatomic, strong) UIImageView * mosaciView;

@end

@implementation MFYVideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用 `JPNavigationController` 处理 pop 手势导致 `AVPlayer` 播放器播放视频卡顿.如果需要使用，需要修改Appdelegate的navigationcontroller
//    self.navigationController.jp_useCustomPopAnimationForCurrentViewController = YES;
    [self setupView];
    [self bindEvents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoContainer jp_stopPlay];
}

- (void)setupView {
    self.navBar.titleLabel.text = self.itemModel.bodyText.length > 0 ? self.itemModel.bodyText : @"视频详情";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar setRightButton:self.reportBtn];

    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoContainer];
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.mosaciView];
    
    [self.videoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.videoContainer);
    }];
    
    [self.mosaciView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self configTheImage];
}

- (void)bindEvents {
    @weakify(self)
    [[self.reportBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        if (self.itemModel.complained) {
             [WHHud showString:@"您已举报过该帖子"];
             return;
         }
         [MFYArticleService reportArticle:self.itemModel.articleId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
             if (isSuccess) {
                 [WHHud showString:@"举报成功"];
                 self.itemModel.complained = YES;
             }else {
                 [WHHud showString:error.descriptionFromServer];
             }
         }];
    }];
}

- (void)configTheImage {
    @weakify(self)
    if (!self.itemModel.isbig && self.itemModel.priceAmount > 0 && !self.itemModel.purchased) {
        self.imageView.hidden = NO;
        NSURL * coverImageURL = [NSURL URLWithString:self.itemModel.media.mediaUrl];
        if (self.itemModel.media.mediaType > 2) {
            coverImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/0.2", self.itemModel.media.mediaUrl]];
        }
        [self.imageView yy_setImageWithURL:coverImageURL placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self)
            UIImage * mosaciImage = [UIImage mosaicImage:image mosaicLevel:80];
            [self.mosaciView setImage:mosaciImage];
            [MFYRedPacketView showInViwe:self.view itemModel:self.itemModel completion:^(BOOL isPayed) {
                if (isPayed) {
                    self.imageView.hidden = YES;
                    self.mosaciView.hidden = YES;
                }
            }];
        }];
    }else {
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            [self playTheVideo];
        });
    }
}


- (void)playTheVideo {
    if (self.itemModel.media.mediaUrl == nil) {
        return;
    }
    NSURL * playUrl = [MFYHTTPCacheService proxyURLWithOriginalUrl:self.itemModel.media.mediaUrl];

    [self.videoContainer jp_playVideoWithURL:playUrl bufferingIndicator:nil controlView:nil progressView:[MFYVideoProgressView new] configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
    
    }];
}

- (UIView *)videoContainer {
    if (!_videoContainer) {
        _videoContainer = [[UIView alloc]init];
        _videoContainer.backgroundColor = [UIColor clearColor];
    }
    return _videoContainer;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = UIButton.button.WH_setImage_forState(WHImageNamed(@"detail_report"),UIControlStateNormal);
    }
    return _reportBtn;
}

- (UIImageView *)mosaciView {
    if (!_mosaciView) {
        _mosaciView = UIImageView.imageView;
        _mosaciView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mosaciView;
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.hidden = YES;
    }
    return _imageView;
}


@end
