//
//  MFYPublishService.h
//  Earth
//
//  Created by colr on 2020/2/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYPublishService : NSObject

#pragma mark- 上传颜值贴
+ (void)publishTheArticleParam:(NSDictionary *)dic completion:(void(^)(MFYArticle * article, NSError * error))completion;

#pragma mark- 上传颜值贴
+ (void)publishTheAudioArticleParam:(NSDictionary *)dic completion:(void(^)(MFYArticle * article, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
