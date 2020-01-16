//
//  MFYServiceURLConfig.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYServiceConstant.h"

typedef NS_ENUM(NSInteger, MFYServiceGlobalConfigType) {
    MFYServiceGlobalConfigTypeDevelop = 0,
    MFYServiceGlobalConfigTypeAlpha,
    MFYServiceGlobalConfigTypeBeta,
    MFYServiceGlobalConfigTypeLive
};


NS_ASSUME_NONNULL_BEGIN

@interface MFYServiceURLConfig : NSObject

@property (nonatomic, copy) NSString *apiDomain;

+ (instancetype)shareInstance;

- (void)apiEnvironment:(MFYServiceGlobalConfigType)type;

@end

NS_ASSUME_NONNULL_END
