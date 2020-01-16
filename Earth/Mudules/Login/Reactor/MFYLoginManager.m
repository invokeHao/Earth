//
//  MFYLoginManager.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYLoginManager.h"
#import "MFYLoginVIewController.h"

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



+ (NSString *)token {
    return @"access-token-test";
}

@end
