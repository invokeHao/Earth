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


@interface MFYVideoDetailVC ()<JPVideoPlayerDelegate>

@property (nonatomic, strong) UIView *videoContainer;

@property (nonatomic, strong) UIButton * reportBtn;

@end

@implementation MFYVideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用 `JPNavigationController` 处理 pop 手势导致 `AVPlayer` 播放器播放视频卡顿.
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self playTheVideo];
    });

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
    
    [self.videoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
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
        _reportBtn = UIButton.button.WH_setTitle_forState(@"举报",UIControlStateNormal).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
    }
    return _reportBtn;
}


@end
