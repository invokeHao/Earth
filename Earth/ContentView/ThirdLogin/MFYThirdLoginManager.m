//
//  MFYThirdLoginManager.m
//  Earth
//
//  Created by colr on 2020/4/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYThirdLoginManager.h"
#import "MFYMineService.h"

@implementation MFYThirdLoginManager


+ (instancetype)sharedManager {
    static MFYThirdLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYThirdLoginManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)setupConfig {
    [WXApi registerApp:MFYWeChatAppKey universalLink:MFYUniversalLink];
}

+ (void)sendWXAuthReq{
     MFYThirdLoginManager * manager = [MFYThirdLoginManager sharedManager];
    
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"mfy_wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        //唤起微信
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }else{
        [WHAlertTool showActionSheetWithTitle:@"未安装微信应用或版本过低" withActionBlock:^(UIAlertAction * _Nonnull action) {
        }];
    }
}

- (void)onResp:(BaseResp *)resp{
    
    // =============== 获得的微信登录授权回调 ============
    if ([resp isMemberOfClass:[SendAuthResp class]])  {
        NSLog(@"******************获得的微信登录授权******************");
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode != 0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WHHud showString:@"微信授权失败"];
            });
            return;
        }
        //授权成功获取 OpenId
        NSString *code = aresp.code;
        [MFYMineService postWXWithDrawCode:code Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                [WHHud showString:@"微信绑定成功"];
            }
        }];
    }
}

#pragma mark- Appdelegate

-(BOOL)mfy_thirdPatyHandleTheUrl:(NSURL *)url {
    BOOL result = NO;
    result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)mfy_handleOpenUniversalLink:(NSUserActivity*)userActivity {
    BOOL result = NO;
    result = [WXApi handleOpenUniversalLink:userActivity delegate:self];
    return result;
}



@end
