//
//  AppDelegate.m
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "AppDelegate.h"
#import "MFYBaseNavigationController.h"
#import "MFYCoreFlowVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initialization];
    [self loadCustomViewControllers];
    return YES;
}


#pragma mark - Custom

- (void)loadCustomViewControllers {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *viewController = nil;
    viewController = [[MFYCoreFlowVC alloc]init];
    MFYBaseNavigationController *navigationController = [[MFYBaseNavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

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
