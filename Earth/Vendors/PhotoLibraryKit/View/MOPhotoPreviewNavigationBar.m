//
//  MOPhotoPreviewNavigationBar.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/11.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoPreviewNavigationBar.h"

#import <Masonry.h>
#import "MOMacro.h"
#import "UIColor+MOKit.h"

#import "MOIndicatorButton.h"
#import "MONotHighlightButton.h"

@interface MOPhotoPreviewNavigationBar ()

@property (nonatomic, strong) MONotHighlightButton *leftButton;
@property (nonatomic, strong) MONotHighlightButton *rightButton;

@end


@implementation MOPhotoPreviewNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    
    self.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    CGFloat centerLabelY = SREEN_HEIGHT == 812 ? (22) : (10);
    self.frame = CGRectMake(0, 0, SREEN_WIDTH, NAVIGATION_HEIGHT);
    
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(centerLabelY);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(centerLabelY);
    }];
}


#pragma mark - event response

- (void)leftAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didClickLeftButton:)]) {
        [self.delegate navigationBar:self didClickLeftButton:button];
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
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"ico_arrow_back"] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (MONotHighlightButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[MONotHighlightButton alloc] init];
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [_rightButton setTintColor:[UIColor whiteColor]];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightButton;
}


@end
