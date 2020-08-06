//
//  MFYGlobalConfigService.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYVersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYGlobalConfigService : NSObject

#pragma mark- 获取全局数据
+ (void)getTheGlobalConfigCompletion:(void(^)(MFYGlobalModel * model, NSError * error))completion;

#pragma mark- 查看版本更新
+ (void)versionUpDateCheckCompletion:(void(^)(MFYVersionModel * model, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
