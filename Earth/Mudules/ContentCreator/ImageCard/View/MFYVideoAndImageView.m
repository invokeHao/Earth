//
//  MFYVideoAndImageView.m
//  Earth
//
//  Created by colr on 2020/1/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYVideoAndImageView.h"

@interface MFYVideoAndImageView()

@property (strong, nonatomic)UIImageView * coverImageV;

@property (strong, nonatomic)UIButton * addbutton;

@property (assign, nonatomic)MFYVideoAndImageViewType type;

@end

@implementation MFYVideoAndImageView

- (instancetype)initWithType:(MFYVideoAndImageViewType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.coverImageV];
    [self addSubview:self.addbutton];
    [self setupAddBtn];
}

- (void)setupAddBtn {
    if (self.type == MFYVideoAndImageViewBigType) {
        [self.addbutton setImage:WHImageNamed(@"public_bigAdd") forState:UIControlStateNormal];
    }else {
        [self.addbutton setImage:WHImageNamed(@"public_smallAdd") forState:UIControlStateNormal];
    }
}

- (void)setImageData:(MFYAssetModel *)model {
    if (model) {
        if (model.type == CMSAssetMediaTypePhoto) {
            if (!model.highImage) {
                [self.coverImageV setImage:model.thumbImage];
            }else {
                [self.coverImageV setImage:model.highImage];
            }
            [self setupAddBtn];
        }else if(model.type == CMSAssetMediaTypeVideo || model.type == CMSAssetMediaTypeEditVideo){
            [model getVideoCoverImageCompletion:^(UIImage * _Nonnull image) {
                [self.coverImageV setImage:image];
                [self.addbutton setImage:WHImageNamed(@"video_tag") forState:UIControlStateNormal];
            }];
        }
    }
}

- (void)bindEvents {
    [[self.addbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.tapAddBlock) {
            self.tapAddBlock();
        }
    }];
}

- (void)layoutSubviews {
    [self.coverImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat sizeW = self.type == MFYVideoAndImageViewBigType ? W_SCALE(51) : W_SCALE(40);
    [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(sizeW, sizeW));
    }];
}

- (UIImageView *)coverImageV {
    if (!_coverImageV) {
        _coverImageV = UIImageView.imageView;
        _coverImageV.backgroundColor = [UIColor whiteColor];
        _coverImageV.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageV.clipsToBounds = YES;
        _coverImageV.backgroundColor = wh_colorWithHexString(@"#EBECF5");
    }
    return _coverImageV;
}

- (UIButton *)addbutton {
    if (!_addbutton) {
        _addbutton = UIButton.button;
        _addbutton.contentMode = UIViewContentModeCenter;
        _addbutton.clipsToBounds = YES;
    }
    return _addbutton;
}


@end
