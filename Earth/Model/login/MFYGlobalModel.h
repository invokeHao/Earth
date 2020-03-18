//
//  MFYGlobalModel.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYAudioRereadRechargeProduct.h"
#import "MFYAudioTopic.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYGlobalModel : NSObject

@property (nonatomic, assign) NSInteger audioRereadFreeTimes;
@property (nonatomic, strong) NSArray * audioRereadRechargeProducts;
@property (nonatomic, strong) NSString * audioTopicTip;
@property (nonatomic, strong) NSArray * audioTopics;
@property (nonatomic, strong) NSString * bannedTip;
@property (nonatomic, assign) NSInteger imageRereadFreeTimes;
@property (nonatomic, strong) NSArray * imageRereadRechargeProducts;
@property (nonatomic, strong) NSString * imageTopicTip;
@property (nonatomic, strong) NSArray * imageTopics;
@property (nonatomic, strong) NSString * privacyUrl;
@property (nonatomic, strong) NSString * purchaseRechargeTip;
@property (nonatomic, strong) NSString * rereadArticleTip;
@property (nonatomic, strong) NSString * rereadRechargeTip;
@property (nonatomic, strong) NSString * warningTip;
@property (nonatomic, strong) NSString * withdrawTip;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
