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

+ (instancetype)sharedManager;

+ (void)sendWXAuthReq;

- (BOOL)mfy_thirdPatyHandleTheUrl:(NSURL*)url;
- (BOOL)mfy_handleOpenUniversalLink:(NSUserActivity*)userActivity;


@end

NS_ASSUME_NONNULL_END
