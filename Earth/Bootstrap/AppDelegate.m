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
#import "DHLaunchAdPageHUD.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initialization];
    [self showLaunchScreen];
    [self loadCustomViewControllers];
    [self initJGIMWithLaunchOptions:launchOptions];
    return YES;
}


#pragma mark - Custom

- (void)loadCustomViewControllers {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    UIViewController *viewController = nil;
    viewController = [[MFYCoreFlowVC alloc]init];
    MFYBaseNavigationController *navigationController = [[MFYBaseNavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

- (void)showLaunchScreen {
    NSString *adImageJPGPath = [[NSBundle mainBundle] pathForResource:@"launchImg@3x" ofType:@"png"];
    DHLaunchAdPageHUD *launchAd = [[DHLaunchAdPageHUD alloc] initWithFrame:CGRectMake(0, 0,VERTICAL_SCREEN_WIDTH , VERTICAL_SCREEN_HEIGHT) aDduration:3.0 aDImageUrl:adImageJPGPath hideSkipButton:NO launchAdClickBlock:^{
        NSLog(@"[AppDelegate]:点了广告图片");
    } Completion:^{
    }];
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

#pragma mark- APPdelegate delegate
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL result = NO;
    result = [[MFYRechargeManager sharedManager] WXHandleUrl:url];
    result = [[MFYShareManager sharedManager] mfy_thirdPatyHandleTheUrl:url];
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = NO;
    result = [[MFYRechargeManager sharedManager] WXHandleUrl:url];
    result = [[MFYShareManager sharedManager] mfy_thirdPatyHandleTheUrl:url];
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    BOOL result = NO;
    result = [[MFYRechargeManager sharedManager] WXhandleOpenUniversalLink:userActivity];
    result = [[MFYShareManager sharedManager] mfy_handleOpenUniversalLink:userActivity];
    return result;
}


@end
