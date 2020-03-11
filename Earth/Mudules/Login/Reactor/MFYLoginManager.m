//
//  MFYLoginManager.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYLoginManager.h"
#import "MFYLoginVIewController.h"
#import "UDIDWithKeyChain.h"

NSString *const kUserTabelName = @"userModel";

@implementation MFYLoginManager

+ (instancetype)sharedManager {
    static MFYLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYLoginManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)jumpToLoginWithCompletion:(void (^)(void))completion {
    UIViewController * VC = [WHAlertTool WHTopViewController];
    if ([VC isKindOfClass:[MFYLoginVIewController class]]) {
        return;
    };
    [VC presentViewController:[MFYLoginVIewController new] animated:YES completion:NULL];
}

#pragma mark- 数据库管理

+ (void)saveTheLoginModel:(MFYLoginModel *)model completion:(nonnull void (^)(BOOL))completion {
    model.bg_tableName = kUserTabelName;
    [model bg_coverAsync:^(BOOL isSuccess) {
        if (isSuccess) {
            completion(YES);
        }
    }];
}

+ (MFYLoginModel *)getTheLoginMode {
    return [MFYLoginModel bg_firstObjet:kUserTabelName];
}


+ (NSString *)token {
    return [MFYLoginManager getTheLoginMode].token;
}

+ (NSString *)deviceID {
    WHLog(@"%@",[UDIDWithKeyChain getUUID]);
    return [UDIDWithKeyChain getUUID];
}

@end
