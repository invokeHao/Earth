//
//  MOExportLoadingView.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/11.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOExportLoadingView.h"
#import <Masonry.h>
#import "MOMacro.h"

@interface MOExportLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MOExportLoadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SREEN_WIDTH, SREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.activityIndicatorView];
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.activityIndicatorView startAnimating];
    }
    return self;
}

#pragma mark - publc method

- (void)showInView:(UIView *)view {
    if (!self.superview) {
        [view addSubview:self];
    }
}

- (void)hide {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - getting
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    }
    return _activityIndicatorView;
}



@end
