//
//  MFYImageDetailVC.m
//  Earth
//
//  Created by colr on 2020/2/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYImageDetailVC.h"
#import "MFYRedPacketView.h"

@interface MFYImageDetailVC ()

@property (strong, nonatomic)YYAnimatedImageView * imageView;

@property (strong, nonatomic)UIImageView * mosaciView;

@property (strong, nonatomic)UIButton * reportBtn;

@property (strong, nonatomic)MFYRedPacketView * redPacketView;

@end

@implementation MFYImageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self configTheImage];
}

- (void)setupViews {
    self.navBar.titleLabel.text = self.itemModel.bodyText.length > 0 ? self.itemModel.bodyText : @"图片详情";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar setRightButton:self.reportBtn];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.mosaciView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    [self.mosaciView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.imageView);
    }];
}

- (void)bindEvents {
    
}

- (void)configTheImage {
    @weakify(self)
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:self.itemModel.media.mediaUrl] placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self)
        if (!self.itemModel.isbig && self.itemModel.priceAmount > 0) {
            UIImage * mosaciImage = [UIImage mosaicImage:image mosaicLevel:80];
            [self.mosaciView setImage:mosaciImage];
            [MFYRedPacketView showInViwe:self.view itemModel:self.itemModel completion:^(BOOL isPayed) {
                if (isPayed) {
                    self.mosaciView.hidden = YES;
                }
            }];
        }
    }];
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIImageView *)mosaciView {
    if (!_mosaciView) {
        _mosaciView = UIImageView.imageView;
        _mosaciView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mosaciView;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = UIButton.button.WH_setTitle_forState(@"举报",UIControlStateNormal).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
    }
    return _reportBtn;
}



@end
