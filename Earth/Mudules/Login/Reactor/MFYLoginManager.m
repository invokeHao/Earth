//
//  MFYLoginManager.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYLoginManager.h"
#import "MFYLoginVIewController.h"
#import "UDIDWithKeyChain.h"
#import "MFYLoginService.h"
#import "MFYBaseNavigationController.h"
#import "MFYCoreFlowVC.h"

NSString *const kUserTabelName = @"userModel";

@implementation MFYLoginManager

+ (instancetype)sharedManager {
    static MFYLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYLoginManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)jumpToLoginWithCompletion:(void (^)(void))completion {
    UIViewController * VC = [WHAlertTool WHTopViewController];
    if ([VC isKindOfClass:[MFYLoginVIewController class]]) {
        return;
    };
    MFYLoginVIewController *loginViewController = [[MFYLoginVIewController alloc] init];
    MFYBaseNavigationController *logoinNavigationController = [[MFYBaseNavigationController alloc] initWithRootViewController:loginViewController];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = logoinNavigationController;
    if (completion) {
        completion();
    }
}

+ (void)logoutWithCompletion:(void(^)(void))completion {
    [MFYLoginService singOutCompletion:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
            [JMSGUser logout:^(id resultObject, NSError *error) {
            }];
            [MFYLoginManager jumpToLoginWithCompletion:^{
                [WHHud showString:@"退出登录成功"];
                if (completion) {
                    completion();
                }
            }];
        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}
+ (void)jumpToMainVC {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (viewController.presentedViewController) {
        [viewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
        }];
    }else {
        UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        MFYBaseNavigationController *navigationController = (MFYBaseNavigationController *)viewController;
        MFYCoreFlowVC * flowVC = [[MFYCoreFlowVC alloc]init];
        [navigationController setViewControllers:@[flowVC] animated:YES];
    }
}

#pragma mark- 数据库管理

+ (void)saveTheLoginModel:(MFYLoginModel *)model completion:(nonnull void (^)(BOOL))completion {
    model.bg_tableName = kUserTabelName;
    [model bg_coverAsync:^(BOOL isSuccess) {
        if (isSuccess) {
            completion(YES);
        }
    }];
}

+ (MFYLoginModel *)getTheLoginMode {
    return [MFYLoginModel bg_firstObjet:kUserTabelName];
}


+ (NSString *)token {
    return [MFYLoginManager getTheLoginMode].token;
}

+ (NSString *)deviceID {
    WHLog(@"%@",[UDIDWithKeyChain getUUID]);
    return [UDIDWithKeyChain getUUID];
}

@end
