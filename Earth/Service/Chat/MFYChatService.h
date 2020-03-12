//
//  MFYChatService.h
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYChatService : NSObject

#pragma mark- 修改昵称
+ (void)postAddTopsChat:(NSString *)userId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 移除置顶
+ (void)postRemoveTopsChat:(NSString *)userId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 获取置顶聊天列表
+ (void)getTopChatListCompletion:(void(^)(NSArray<NSString *> *imIdArr, NSError * error))completion;

#pragma mark- 搜索聊天好友
+ (void)postSearchFriendsPramaDic:(NSDictionary *)dic Completion:(void(^)(NSArray<MFYProfile *> *userArr, NSError * error))completion;

#pragma mark- 获取可能认识的人
+ (void)postMayKnowFriendsWithPhoneNum:(NSArray *)numArr Completion:(void(^)(NSArray<MFYProfile *> *userArr, NSError * error))completion;


@end

NS_ASSUME_NONNULL_END
