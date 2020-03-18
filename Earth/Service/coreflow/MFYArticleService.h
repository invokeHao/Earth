//
//  MFYArticleService.h
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYArticleService : NSObject

#pragma mark- 喜欢/不喜欢卡片
+ (void)postLikeArticle:(NSString *)articleId isLike:(BOOL)like Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 删除卡片
+ (void)deleteArticle:(NSString *)articleId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 返回阅读上一张卡片
+ (void)rereadArticle:(NSString *)articleId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

#pragma mark- 举报卡片
+ (void)reportArticle:(NSString *)articleId Completion:(void(^)(BOOL isSuccess, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
