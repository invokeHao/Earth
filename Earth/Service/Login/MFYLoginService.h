//
//  MFYLoginService.h
//  Earth
//
//  Created by colr on 2020/1/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYLoginService : NSObject


#pragma mark- 验证码登录
+ (void)loginWithPhoneNum:(NSString *)phoneNum
               verifyCode:(NSString *)verifyCode
               completion:(void(^)(MFYLoginModel * loginModel, NSError * error))completion;

#pragma mark- 退出登录
+ (void)singOutCompletion:(void(^)(BOOL success, NSError * error))completion;

#pragma mark- 一键登录

+ (void)loginWithUMToken:(NSString *)token
              completion:(void(^)(MFYLoginModel * loginModel, NSError * error))completion;;

@end

NS_ASSUME_NONNULL_END
