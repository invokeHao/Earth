//
//  AppDelegate+MFYJGIM.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (MFYJGIM)<JMessageDelegate>

- (void)initJGIMWithLaunchOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
