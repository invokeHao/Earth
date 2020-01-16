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

+ (void)loginWithPhoneNum:(NSString *)phoneNum
               verifyCode:(NSString *)verifyCode
               completion:(void(^)(MFYLoginModel * loginModel, NSError * error))completion;


@end

NS_ASSUME_NONNULL_END
