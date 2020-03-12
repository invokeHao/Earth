//
//  MFYLoginManager.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYLoginManager : NSObject

+ (instancetype)sharedManager;

+ (NSString *)token;

+ (NSString *)deviceID;


+ (void)jumpToLoginWithCompletion:(void (^)(void))completion;

+ (void)logoutWithCompletion:(void(^)(void))completion;

+ (void)jumpToMainVC;

+ (void)umengPhoneVerifyLogin;

+ (void)saveTheLoginModel:(MFYLoginModel*)model completion:(void(^)(BOOL isSuccess))completion;

@end

NS_ASSUME_NONNULL_END
