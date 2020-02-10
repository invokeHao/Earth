//
//  MOPhotoLibraryNavigationBar.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoLibraryNavigationBar.h"

#import <Masonry.h>
#import "MOMacro.h"
#import "UIColor+MOKit.h"

#import "MOIndicatorButton.h"
#import "MONotHighlightButton.h"

@interface MOPhotoLibraryNavigationBar ()

@property (nonatomic, strong) MONotHighlightButton *leftButton;
@property (nonatomic, strong) MOIndicatorButton *centerButton;
@property (nonatomic, strong) MONotHighlightButton *rightButton;

@property (nonatomic, assign) MOAlbumType albumType;

@end

@implementation MOPhotoLibraryNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {

    CGFloat centerLabelY = SREEN_HEIGHT == 812 ? (22) : (10);
    self.frame = CGRectMake(0, 0, SREEN_WIDTH, NAVIGATION_HEIGHT);
    
//    CAGradientLayer *gradientColorLayer = [CAGradientLayer layer];
//    gradientColorLayer.frame = self.bounds;
//    gradientColorLayer.colors = @[(__bridge id)[UIColor cms_colorWithHexString:@"E44256"].CGColor,
//                                  (__bridge id)[UIColor cms_colorWithHexString:@"FFAF90"].CGColor];
//    gradientColorLayer.startPoint = CGPointMake(0, 0.5);
//    gradientColorLayer.endPoint = CGPointMake(1, 0.5);
//    [self.layer addSublayer:gradientColorLayer];
    self.backgroundColor = [UIColor cms_colorWithHexString:@"0x1B1A28"];
    
    [self addSubview:self.leftButton];
    [self addSubview:self.centerButton];
    [self addSubview:self.rightButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(centerLabelY);
    }];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(centerLabelY);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(centerLabelY);
    }];
}

#pragma mark - pubilc method
- (void)loadWithPhotoLibraryConfiguration:(MOPhotoLibraryConfiguration *)configuration {
    if (configuration.maxSelectedCount == 1) {
        self.rightButton.hidden = YES;
    }
    self.albumType = configuration.albumType;
    if (self.albumType == 1 || self.albumType == 2 || self.albumType == 4 || self.albumType == 8 || self.albumType == 16) {
        [self.centerButton setImage:[UIImage new] forState:(UIControlStateNormal)];
    }
}

- (void)changePhotoColletionTitle:(NSString*)title {
    [self.centerButton setTitle:title forState:UIControlStateNormal];
}

- (void)changeRightTitle:(NSString*)title {
    [self.rightButton setTitle:title forState:UIControlStateNormal];
}

- (void)changeViewAlpha:(CGFloat)alpha {
//    self.leftButton.alpha = alpha;
    self.rightButton.alpha = alpha;
}

- (void)recoverEvent {
    [self changeViewAlpha:NO];
    self.centerButton.selected = false;
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didClickCenterButtonWithSelected:)]) {
        [self.delegate navigationBar:self didClickCenterButtonWithSelected:self.centerButton.selected];
    }
}

#pragma mark - event response

- (void)leftAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didClickLeftButton:)]) {
        [self.delegate navigationBar:self didClickLeftButton:button];
    }
}

- (void)centerAction:(UIButton *)button {
    if (self.albumType == 1 || self.albumType == 2 || self.albumType == 4 || self.albumType == 8 || self.albumType == 16) {
        return;
    }
    button.selected = !button.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didClickCenterButtonWithSelected:)]) {
        [self.delegate navigationBar:self didClickCenterButtonWithSelected:button.selected];
    }
}

- (void)rightAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didClickRightButton:)]) {
        [self.delegate navigationBar:self didClickRightButton:button];
    }
}

#pragma mark - getting

- (MONotHighlightButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[MONotHighlightButton alloc] init];
        [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (MOIndicatorButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[MOIndicatorButton alloc] init];
        [_centerButton addTarget:self action:@selector(centerAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _centerButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_centerButton setTitle:@"相机胶卷" forState:UIControlStateNormal];
        [_centerButton sizeToFit];
    }
    return _centerButton;
}

- (MONotHighlightButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[MONotHighlightButton alloc] init];
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor cms_colorWithHexString:@"7D95FF"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _rightButton;
}


@end





