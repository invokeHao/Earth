//
//  WHHud.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval const HUDHideDelay = 1.5f;

NS_ASSUME_NONNULL_BEGIN

@interface WHHud : NSObject

@property (nonatomic, strong, readonly) MBProgressHUD *hud;
@property (nonatomic, strong, readonly) UIView *targetView;

- (instancetype)initWithTargetView:(UIView *)view;

- (void)showActivityView;

- (void)hideActivityView;

// On Window

+ (void)showActivityView;

+ (void)hideActivityView;

+ (void)hideActivityViewWithComplete:(void(^)())complete;

+ (void)showString:(NSString *)string;

+ (void)showString:(NSString *)string hideDelay:(NSTimeInterval)time;

+ (void)showString:(NSString *)string hideDelay:(NSTimeInterval)time offsetY:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
