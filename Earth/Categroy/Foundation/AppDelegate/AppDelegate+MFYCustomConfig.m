//
//  AppDelegate+MFYCustomConfig.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "AppDelegate+MFYCustomConfig.h"
#import "MFYGlobalConfigService.h"

@implementation AppDelegate (MFYCustomConfig)

- (void)initialization {
    [self getTheConfigData];
    [self setupIQKeyboardManager];
    [self configTheUmeng];
    
}


- (void)setupIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)configTheUmeng {
    [UMConfigure initWithAppkey:@"5e4e8cc67ba7e954e9f6a577" channel:@"APP Store"];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:MFYWeiboAppkey];
    
}


- (void)getTheConfigData {
    [MFYGlobalManager setupGlobalData];
}


@end
