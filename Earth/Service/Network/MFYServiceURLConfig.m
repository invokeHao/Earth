//
//  MFYServiceURLConfig.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYServiceURLConfig.h"

@implementation MFYServiceURLConfig

+ (instancetype)shareInstance {
    static MFYServiceURLConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MFYServiceURLConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        BOOL isDebugMode =  YES;
        if (isDebugMode) {
            _apiDomain = MFYServiceDomainDevelop;
            NSLog(@"🚀==> 测试环境");
        } else {
            _apiDomain = MFYServiceDomainLive;
            NSLog(@"🚀==> 正式环境");
        }
    }
    return self;
}

- (void)apiEnvironment:(MFYServiceGlobalConfigType)type {
    switch (type) {
        case MFYServiceGlobalConfigTypeAlpha:
            _apiDomain = MFYServiceDomainAlpha;
            break;
        case MFYServiceGlobalConfigTypeBeta:
            _apiDomain = MFYServiceDomainBeta;
            break;
        case MFYServiceGlobalConfigTypeLive:
            _apiDomain = MFYServiceDomainLive;
            break;
            
        default:
            _apiDomain = MFYServiceDomainDevelop;
            break;
    }
}

@end
