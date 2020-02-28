//
//  AppDelegate.m
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+MFYCustomConfig.h"
#import "AppDelegate+MFYJGIM.h"
#import "MFYBaseNavigationController.h"
#import "MFYCoreFlowVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initialization];
    [self loadCustomViewControllers];
    [self initJGIMWithLaunchOptions:launchOptions];
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

#pragma mark- JMSGDBMigrateDelegate

- (void)onDBMigrateStart {
    NSLog(@"onDBmigrateStart in appdelegate");
    _isDBMigrating = YES;
}

- (void)onDBMigrateFinishedWithError:(NSError *)error {
    NSLog(@"onDBmigrateFinish in appdelegate");
    _isDBMigrating = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDBMigrateFinishNotification object:nil];
}


@end
