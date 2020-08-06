//
//  MFYTopicTagService.h
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYCoreflowTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYTopicTagService : NSObject

#pragma mark- 获取颜控tag
+ (void)getTheImageTopicTagsCompletion:(void(^)(NSArray <MFYCoreflowTag *>* array, NSError * error))completion;

#pragma mark- 获取声控tag
+ (void)getTheaudioTopicTagsCompletion:(void(^)(NSArray <MFYCoreflowTag *>* array, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
