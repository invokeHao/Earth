//
//  MFYThirdLoginManager.h
//  Earth
//
//  Created by colr on 2020/4/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYThirdLoginManager : NSObject<WXApiDelegate>

@property (nonatomic, copy)void(^WXAuthBlock)(BOOL isSuccess);
@property (nonatomic, copy)void(^ALiAuthBlock)(BOOL isSuccess);

+ (instancetype)sharedManager;

+ (void)sendWXAuthReqCoompletion:(void(^)(BOOL isSuccess))completion;

+ (void)sendALiInfo:(NSDictionary *)userInfo Coompletion:(void(^)(BOOL isSuccess))completion;

- (BOOL)mfy_thirdPatyHandleTheUrl:(NSURL*)url;
- (BOOL)mfy_handleOpenUniversalLink:(NSUserActivity*)userActivity;


@end

NS_ASSUME_NONNULL_END
