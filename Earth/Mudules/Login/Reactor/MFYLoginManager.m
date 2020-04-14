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
#import <UMVerify/UMVerify.h>
#import "UMModelCreate.h"
#import "MFYMineService.h"

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

#pragma mark- 退出登录
+ (void)logoutWithCompletion:(void(^)(void))completion {
    [MFYLoginService singOutCompletion:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
            [JMSGUser logout:^(id resultObject, NSError *error) {}];
            [MFYLoginManager umengPhoneVerifyLogin];
            if (completion) {
                completion();
            }
        }else{
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

#pragma mark-一键登录
+ (void)umengPhoneVerifyLogin {
    [MFYLoginManager jumpToLoginWithCompletion:^{}];
    return;
    //设置秘钥
    NSString *info = @"sNpLSdXjarJOabWFvS/q1LOFGs4yYRj7wFJYUJQsNQrRkTMGsGYWJBtytNEsXA82CGGtFTUblYIwFsVQr3sduNLH4SbeZf1Kv4WCrxCs83ZCaKRG68IBsXSi4ltftndsx7rYW9B4aRpH6rwTNHWjv/pzLFDr67RC6Pxxx3mQUzd4/RkeIj6RfYx0/C3wzxptTcE2qW0HXBSqA4lzuPFGnS4rn8QEvnRwnSxVsnntXWs=";
    @weakify(self)
    [UMCommonHandler setVerifySDKInfo:info complete:^(NSDictionary * _Nonnull resultDic) {
        WHLog(@"%@",resultDic);
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]]) {
            //设置密钥成功
            [[MFYLoginManager sharedManager] checkTheVerify];
        }else {
            [MFYLoginManager jumpToLoginWithCompletion:^{}];
        }
    }];
}

- (void)checkTheVerify {
    [WHHud showActivityView];
    //1. 调用check接口检查及准备接口调用环境
    [UMCommonHandler checkEnvAvailableWithComplete:^(NSDictionary * _Nullable resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
            [WHHud showString:@"check 接口检查失败，环境不满足"];
            [MFYLoginManager jumpToLoginWithCompletion:^{}];
            return;
        }
        //2. 调用预取号接口，加速授权页的弹起
        [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
                [WHHud showString:@"取号，加速授权页弹起失败"];
                [MFYLoginManager jumpToLoginWithCompletion:^{}];
                return ;
            }
            //3. 调用获取登录Token接口，可以立马弹起授权页
            [WHHud hideActivityView];
            UMCustomModel *model = [self buildCustomModel];
            model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
            [UMCommonHandler getLoginTokenWithTimeout:3.0 controller:[WHAlertTool WHTopViewController] model:model complete:^(NSDictionary * _Nonnull resultDic) {
                     NSString *code = [resultDic objectForKey:@"resultCode"];
                     if ([PNSCodeLoginControllerPresentSuccess isEqualToString:code]) {
//                        [WHHud showString:@"弹起授权页成功"];
                    } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
//                        [WHHud showString:@"点击了授权页的返回"];
                    } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
//                        [WHHud showString:@"点击切换其他登录方式按钮"];
                        [MFYLoginManager jumpToLoginWithCompletion:^{}];
                    } else if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]) {
                        if ([[resultDic objectForKey:@"isChecked"] boolValue] == YES) {
//                            [WHHud showString:@"点击了登录按钮，check box选中，SDK内部接着会去获取登陆Token"];
                            
                        } else {
//                            [WHHud showString:@"点击了登录按钮，check box选中，SDK内部不会去获取登陆Token"];
                        }
                     } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) {
//                         [WHHud showString:@"点击check box"];
                     } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:code]) {
//                         [WHHud showString:@"点击了协议富文本"];
                     } else if ([PNSCodeSuccess isEqualToString:code]) {
                         //点击登录按钮获取登录Token成功回调
                         NSString *token = [resultDic objectForKey:@"token"];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
                         });
                         //拿Token去服务器换手机号
                         [self umengLoginWithToken:token];
                     }else {
                         [WHHud showString:@"获取token失败"];
                     }
            }];
            
        }];
        
    }];
}

- (void)umengLoginWithToken:(NSString *)token {
    [MFYLoginService loginWithUMToken:token completion:^(MFYLoginModel * _Nonnull loginModel, NSError * _Nonnull error) {
        if(!error){
            [WHHud showActivityView];
            [MFYLoginManager saveTheLoginModel:loginModel completion:^(BOOL isSuccess) {
                if (isSuccess) {
                    //登录IM
                    [self loginJChatIM:loginModel];
                }
            }];
        }else {
            [WHHud showString:error.descriptionFromServer];
            [WHHud hideActivityView];
            [MFYLoginManager jumpToLoginWithCompletion:^{}];
        }
    }];
}

#pragma mark- 登录IM
- (void)loginJChatIM:(MFYLoginModel *)loginModel {
    //先获取用户IM信息
    [MFYMineService getSelfDetailInfoCompletion:^(MFYProfile * _Nonnull profile, NSError * _Nonnull error) {
        [WHHud hideActivityView];
        if (!error) {
            //IM登录
            [JMSGUser loginWithUsername:profile.imId
                               password:profile.imPwd
                      completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    loginModel.imId = profile.imId;
                    loginModel.imPwd = profile.imPwd;
                    [MFYLoginManager saveTheLoginModel:loginModel completion:^(BOOL isSuccess) {}];
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];
                    [MFYLoginManager jumpToMainVC];

                }else {
                    [WHHud showString:@"登录聊天系统失败"];
                    WHLogError(@"%@",error);
                }
            }];

        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}


- (UMCustomModel *)buildCustomModel {
    return [UMModelCreate createFullScreen];
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
