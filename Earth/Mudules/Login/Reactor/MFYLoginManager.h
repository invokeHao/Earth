//
//  MFYLoginManager.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYLoginManager : NSObject

+ (instancetype)sharedManager;

+ (NSString *)token;


+ (void)jumpToLoginWithCompletion:(void (^)(void))completion ;

@end

NS_ASSUME_NONNULL_END
