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


@end
