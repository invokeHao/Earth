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
    MFYCoreflowAutoAllType,
    MFYCoreflowAutoFriendsType,
    MFYCoreflowAutoTopType
} MFYCoreFlowType;

NS_ASSUME_NONNULL_BEGIN

@interface MFYCoreflowService : NSObject

#pragma mark- 颜控卡片

+ (void)getTheImageCardWithFlowType:(MFYCoreFlowType)type completion:(void(^)(NSArray<MFYArticle *> *articleList, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
