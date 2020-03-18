//
//  MFYGlobalManager.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYGlobalManager.h"
#import "MFYGlobalConfigService.h"

@interface MFYGlobalManager ()

@property (nonatomic, strong)MFYGlobalModel * globalModel;

@end

@implementation MFYGlobalManager

+ (instancetype)sharedManager {
    static MFYGlobalManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYGlobalManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)setupGlobalData {
    MFYGlobalManager * manager = [MFYGlobalManager sharedManager];
    [MFYGlobalConfigService getTheGlobalConfigCompletion:^(MFYGlobalModel * _Nonnull model, NSError * _Nonnull error) {
        if (model) {
            manager.globalModel = model;
        }
    }];
}


+ (MFYGlobalModel *)shareGlobalModel {
    MFYGlobalManager * manager = [MFYGlobalManager sharedManager];
    return manager.globalModel;
}


@end
