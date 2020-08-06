//
//  MFYShareManager.h
//  Earth
//
//  Created by colr on 2020/3/18.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "MFYArticle.h"
#import <WeiboSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface MFYShareManager : NSObject <QQApiInterfaceDelegate,WXApiDelegate,TencentSessionDelegate,WeiboSDKDelegate>

+ (instancetype)sharedManager;

- (BOOL)mfy_thirdPatyHandleTheUrl:(NSURL*)url;
- (BOOL)mfy_handleOpenUniversalLink:(NSUserActivity*)userActivity;

+ (void)shareToWechatFriend:(BOOL)isFriend article:(MFYArticle *)article completion:(void(^)(BOOL success))completion;

+ (void)shareToQQ:(BOOL)isQQ andArticle:(MFYArticle *)article completion:(void(^)(BOOL success))completion;

+ (void)shareToWeiboWithArticle:(MFYArticle *)article completion:(void(^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
