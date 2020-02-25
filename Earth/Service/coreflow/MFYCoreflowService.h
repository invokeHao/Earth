//
//  MFYCoreflowService.h
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYArticle.h"

typedef enum : NSUInteger {
    MFYCoreflowImageAllType,
    MFYCoreflowImageFriendsType,
    MFYCoreflowImageTopType,
    MFYCoreflowAudioAllType,
    MFYCoreflowAudioFriendsType,
    MFYCoreflowAudioTopType
} MFYCoreFlowType;

NS_ASSUME_NONNULL_BEGIN

@interface MFYCoreflowService : NSObject

#pragma mark- 颜控卡片

#pragma mark- 根据名字获取颜值卡片列表
+ (void)getTheImageCardWithFlowType:(MFYCoreFlowType)type completion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;

#pragma mark- 根据topicId获取颜值卡片列表

+ (void)getTheImageCardWithTopicId:(NSString *)topicId completion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;


#pragma mark- 声控卡片

//根据topicId获取声控卡片列表

+ (void)getTheAudioCardWithTopicId:(NSString *)topicId completion:(void(^)(NSArray<MFYArticle*> *aritlceList, NSError * error))completion;



#pragma mark- 我喜欢的卡片列表

+ (void)getMyLikeCardListWithPage:(NSInteger)page completion:(void(^)(NSArray<MFYArticle*> *aritlceList, NSError * error))completion;


#pragma mark- 我发布的卡片列表

+ (void)getMyPostCardListWithPage:(NSInteger)page completion:(void(^)(NSArray<MFYArticle*> *aritlceList, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
