//
//  MFYGlobalManager.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYGlobalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYGlobalManager : NSObject

+ (instancetype)sharedManager;

+ (MFYGlobalModel *)shareGlobalModel;

+ (void)setupGlobalData;

@end

NS_ASSUME_NONNULL_END
