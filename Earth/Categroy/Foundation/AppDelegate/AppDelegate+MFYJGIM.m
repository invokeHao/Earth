//
//  AppDelegate+MFYJGIM.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "AppDelegate+MFYJGIM.h"

#define CHANNEL @"IOS"

@implementation AppDelegate (MFYJGIM)

- (void)initJGIMWithLaunchOptions:(NSDictionary *)launchOptions {
    
    //在setup之前添加，监听h数据库是否升级，来提前处理
    [JMessage addDelegate:self withConversation:nil];
    
    [JMessage setupJMessage:launchOptions
                     appKey:JMESSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:NO category:nil messageRoaming:YES];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [self registerJPushStatusNotification];
    
    [JCHATFileManager initWithFilePath];//demo 初始化存储路径
    
    [JMessage resetBadge]; //清理角标
}

- (void)registerJPushStatusNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJMSGNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkIsConnecting:)
                          name:kJMSGNetworkIsConnectingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJMSGNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJMSGNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJMSGNetworkDidLoginNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJMSGNetworkDidReceiveMessageNotification
                        object:nil];
    
}


- (void)networkDidSetup:(NSNotification *)notification {
    WHLog(@"Event - networkDidSetup");
}

- (void)networkIsConnecting:(NSNotification *)notification {
    WHLog(@"Event - networkIsConnecting");
}

- (void)networkDidClose:(NSNotification *)notification {
    WHLog(@"Event - networkDidClose");
}

- (void)networkDidRegister:(NSNotification *)notification {
    WHLog(@"Event - networkDidRegister");
}

- (void)networkDidLogin:(NSNotification *)notification {
    WHLog(@"Event - networkDidLogin");
}

- (void)receivePushMessage:(NSNotification *)notification {
    WHLog(@"Event - receivePushMessage");
    
    NSDictionary *info = notification.userInfo;
    if (info) {
        WHLog(@"The message - %@", info);
    } else {
        WHLog(@"Unexpected - no user info in jpush mesasge");
    }
}

#pragma mark- JChatMessage Delegate

- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationCurrentUserInfoChange:{
            NSLog(@"Current user info change Notification Event ");
        }
            break;
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend:
        {
            //JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"Friend Notification Event");
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"Receive Server Friend update Notification Event");
            break;
            
            
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"LoginKicked Notification Event ");
        case kJMSGEventNotificationServerAlterPassword:{
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"AlterPassword Notification Event ");
            }
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"User login status unexpected Notification Event ");
            }
            [WHHud showString:@"注册推送错误"];
        }
            break;
            
        default:
            break;
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    [JMessage resetBadge];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    WHLog(@"Action - applicationDidEnterBackground");
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    WHLog(@"Action - applicationWillEnterForeground");
    
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    WHLog(@"Action - didReceiveRemoteNotification:fetchCompletionHandler:");
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    WHLog(@"Action - didRegisterForRemoteNotificationsWithDeviceToken");
    WHLogSuccess(@"Got Device Token - %@", deviceToken);
    
    [JMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    WHLog(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
}






@end
