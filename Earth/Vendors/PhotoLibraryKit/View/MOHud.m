//
//  MOHud.m
//  cosmos
//
//  Created by Lane on 2018/5/27.
//  Copyright © 2018年 Shell&Colr. All rights reserved.
//

#import "MOHud.h"
#import "UIView+MOHud.h"
#import "UIColor+MOKit.h"

@interface MOHud ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *targetView;

@end

@implementation MOHud

- (instancetype)initWithTargetView:(UIView *)view {
    self = [super init];
    if (self) {
        _targetView = view;
        _hud = [[MBProgressHUD alloc] initWithView:_targetView];
        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.bezelView.color = [UIColor cms_colorWithHexString:@"#000000" alpha:0.65];
        _hud.removeFromSuperViewOnHide = YES;
        [self addHudToTargetViewIfNeededAndBringToFront];
    }
    return self;
}

- (void)showActivityView {
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.contentColor = [UIColor whiteColor];
    [_hud showAnimated:YES];
}

- (void)hideActivityView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_hud hideAnimated:YES];
    });
}

#pragma mark - Helper Method

- (void)addHudToTargetViewIfNeededAndBringToFront {
    if (![_targetView.subviews containsObject:_hud]) {
        [_targetView addSubview:_hud];
    }
    else {
        [_targetView bringSubviewToFront:_hud];
    }
}

// On Window

+ (void)showActivityView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window showActivityView];
}

+ (void)hideActivityView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window hideActivityView];
}

+ (void)showString:(NSString *)string {
    [self showString:string hideDelay:HUDHideDelay];
}

+ (void)showString:(NSString *)string hideDelay:(NSTimeInterval)time {
    [self showString:string hideDelay:time offsetY:0.f];
}

+ (void)showString:(NSString *)string hideDelay:(NSTimeInterval)time offsetY:(CGFloat)offsetY {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor cms_colorWithHexString:@"#000000" alpha:0.65];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = string;
        hud.margin = 20.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.offset = CGPointMake(0.f, offsetY);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:time];
        });
    }
}

@end
