//
//  MFYMineService.h
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYMineService : NSObject

#pragma mark- 获取自己喜欢的卡片列表
+ (void)getMyLikeCardListCompletion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;

#pragma mark- 获取自己发布的卡片列表
+ (void)getMypostCardListCompletion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;

#pragma mark- 获取自己购买的卡片列表
+ (void)getMyPurchasedCardListCompletion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;



#pragma mark- 获取个人信息详情
+ (void)getSelfDetailInfoCompletion:(void(^)(MFYProfile * profile, NSError * error))completion;

#pragma mark- 修改昵称
+ (void)postModifyNickname:(NSString *)nickname Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 修改性别
+ (void)postModifyGender:(NSInteger)genderType Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 修改年龄
+ (void)postModifyAge:(NSInteger)age Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 修改头像
+ (void)postModifyIcon:(NSString *)iconId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
