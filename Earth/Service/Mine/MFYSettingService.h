//
//  MFYSettingService.h
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYSettingService : NSObject

#pragma mark- 修改是否允许搜索
+ (void)postModifyAllowSearch:(BOOL)allow Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 修改绑定手机
+ (void)postModifyBindPhone:(NSDictionary *)pramaDic Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
