//
//  AppDelegate+MFYCustomConfig.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "AppDelegate+MFYCustomConfig.h"

@implementation AppDelegate (MFYCustomConfig)

- (void)initialization {
    [self setupIQKeyboardManager];
    [self configTheUmeng];
    WHLog(@"%@",[MFYLoginManager token]);
}


- (void)setupIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)configTheUmeng {
    [UMConfigure initWithAppkey:@"5e4e8cc67ba7e954e9f6a577" channel:@"APP Store"];
}

@end