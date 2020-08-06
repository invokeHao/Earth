//
//  MFYVersionManager.h
//  Earth
//
//  Created by colr on 2020/4/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYVersionManager : NSObject

+ (instancetype)sharedManager;

+ (void)mfy_checkTheVerionShowTheVersion:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
