//
//  MFYGlobalModel.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYGlobalModel.h"

NSString *const kMFYGlobalModelAudioRereadFreeTimes = @"audioRereadFreeTimes";
NSString *const kMFYGlobalModelAudioRereadRechargeProducts = @"audioRereadRechargeProducts";
NSString *const kMFYGlobalModelAudioTopicTip = @"audioTopicTip";
NSString *const kMFYGlobalModelAudioTopics = @"audioTopics";
NSString *const kMFYGlobalModelBannedTip = @"bannedTip";
NSString *const kMFYGlobalModelImageRereadFreeTimes = @"imageRereadFreeTimes";
NSString *const kMFYGlobalModelImageRereadRechargeProducts = @"imageRereadRechargeProducts";
NSString *const kMFYGlobalModelImageTopicTip = @"imageTopicTip";
NSString *const kMFYGlobalModelImageTopics = @"imageTopics";
NSString *const kMFYGlobalModelPrivacyUrl = @"privacyUrl";
NSString *const kMFYGlobalModelPurchaseRechargeTip = @"purchaseRechargeTip";
NSString *const kMFYGlobalModelRereadArticleTip = @"rereadArticleTip";
NSString *const kMFYGlobalModelRereadRechargeTip = @"rereadRechargeTip";
NSString *const kMFYGlobalModelWarningTip = @"warningTip";
NSString *const kMFYGlobalModelWithdrawTip = @"withdrawTip";

@interface MFYGlobalModel ()
@end
@implementation MFYGlobalModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYGlobalModelAudioRereadFreeTimes] isKindOfClass:[NSNull class]]){
        self.audioRereadFreeTimes = [dictionary[kMFYGlobalModelAudioRereadFreeTimes] integerValue];
    }

    if(dictionary[kMFYGlobalModelAudioRereadRechargeProducts] != nil && [dictionary[kMFYGlobalModelAudioRereadRechargeProducts] isKindOfClass:[NSArray class]]){
        NSArray * audioRereadRechargeProductsDictionaries = dictionary[kMFYGlobalModelAudioRereadRechargeProducts];
        NSMutableArray * audioRereadRechargeProductsItems = [NSMutableArray array];
        for(NSDictionary * audioRereadRechargeProductsDictionary in audioRereadRechargeProductsDictionaries){
            MFYAudioRereadRechargeProduct * audioRereadRechargeProductsItem = [[MFYAudioRereadRechargeProduct alloc] initWithDictionary:audioRereadRechargeProductsDictionary];
            [audioRereadRechargeProductsItems addObject:audioRereadRechargeProductsItem];
        }
        self.audioRereadRechargeProducts = audioRereadRechargeProductsItems;
    }
    if(![dictionary[kMFYGlobalModelAudioTopicTip] isKindOfClass:[NSNull class]]){
        self.audioTopicTip = dictionary[kMFYGlobalModelAudioTopicTip];
    }
    if(dictionary[kMFYGlobalModelAudioTopics] != nil && [dictionary[kMFYGlobalModelAudioTopics] isKindOfClass:[NSArray class]]){
        NSArray * audioTopicsDictionaries = dictionary[kMFYGlobalModelAudioTopics];
        NSMutableArray * audioTopicsItems = [NSMutableArray array];
        for(NSDictionary * audioTopicsDictionary in audioTopicsDictionaries){
            MFYAudioTopic * audioTopicsItem = [[MFYAudioTopic alloc] initWithDictionary:audioTopicsDictionary];
            [audioTopicsItems addObject:audioTopicsItem];
        }
        self.audioTopics = audioTopicsItems;
    }
    if(![dictionary[kMFYGlobalModelBannedTip] isKindOfClass:[NSNull class]]){
        self.bannedTip = dictionary[kMFYGlobalModelBannedTip];
    }
    if(![dictionary[kMFYGlobalModelImageRereadFreeTimes] isKindOfClass:[NSNull class]]){
        self.imageRereadFreeTimes = [dictionary[kMFYGlobalModelImageRereadFreeTimes] integerValue];
    }

    if(dictionary[kMFYGlobalModelImageRereadRechargeProducts] != nil && [dictionary[kMFYGlobalModelImageRereadRechargeProducts] isKindOfClass:[NSArray class]]){
        NSArray * imageRereadRechargeProductsDictionaries = dictionary[kMFYGlobalModelImageRereadRechargeProducts];
        NSMutableArray * imageRereadRechargeProductsItems = [NSMutableArray array];
        for(NSDictionary * imageRereadRechargeProductsDictionary in imageRereadRechargeProductsDictionaries){
            MFYAudioRereadRechargeProduct * imageRereadRechargeProductsItem = [[MFYAudioRereadRechargeProduct alloc] initWithDictionary:imageRereadRechargeProductsDictionary];
            [imageRereadRechargeProductsItems addObject:imageRereadRechargeProductsItem];
        }
        self.imageRereadRechargeProducts = imageRereadRechargeProductsItems;
    }
    if(![dictionary[kMFYGlobalModelImageTopicTip] isKindOfClass:[NSNull class]]){
        self.imageTopicTip = dictionary[kMFYGlobalModelImageTopicTip];
    }
    if(dictionary[kMFYGlobalModelImageTopics] != nil && [dictionary[kMFYGlobalModelImageTopics] isKindOfClass:[NSArray class]]){
        NSArray * imageTopicsDictionaries = dictionary[kMFYGlobalModelImageTopics];
        NSMutableArray * imageTopicsItems = [NSMutableArray array];
        for(NSDictionary * imageTopicsDictionary in imageTopicsDictionaries){
            MFYAudioTopic * imageTopicsItem = [[MFYAudioTopic alloc] initWithDictionary:imageTopicsDictionary];
            [imageTopicsItems addObject:imageTopicsItem];
        }
        self.imageTopics = imageTopicsItems;
    }
    if(![dictionary[kMFYGlobalModelPrivacyUrl] isKindOfClass:[NSNull class]]){
        self.privacyUrl = dictionary[kMFYGlobalModelPrivacyUrl];
    }
    if(![dictionary[kMFYGlobalModelPurchaseRechargeTip] isKindOfClass:[NSNull class]]){
        self.purchaseRechargeTip = dictionary[kMFYGlobalModelPurchaseRechargeTip];
    }
    if(![dictionary[kMFYGlobalModelRereadArticleTip] isKindOfClass:[NSNull class]]){
        self.rereadArticleTip = dictionary[kMFYGlobalModelRereadArticleTip];
    }
    if(![dictionary[kMFYGlobalModelRereadRechargeTip] isKindOfClass:[NSNull class]]){
        self.rereadRechargeTip = dictionary[kMFYGlobalModelRereadRechargeTip];
    }
    if(![dictionary[kMFYGlobalModelWarningTip] isKindOfClass:[NSNull class]]){
        self.warningTip = dictionary[kMFYGlobalModelWarningTip];
    }
    if(![dictionary[kMFYGlobalModelWithdrawTip] isKindOfClass:[NSNull class]]){
        self.withdrawTip = dictionary[kMFYGlobalModelWithdrawTip];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYGlobalModelAudioRereadFreeTimes] = @(self.audioRereadFreeTimes);
    if(self.audioRereadRechargeProducts != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYAudioRereadRechargeProduct * audioRereadRechargeProductsElement in self.audioRereadRechargeProducts){
            [dictionaryElements addObject:[audioRereadRechargeProductsElement toDictionary]];
        }
        dictionary[kMFYGlobalModelAudioRereadRechargeProducts] = dictionaryElements;
    }
    if(self.audioTopicTip != nil){
        dictionary[kMFYGlobalModelAudioTopicTip] = self.audioTopicTip;
    }
    if(self.audioTopics != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYAudioTopic * audioTopicsElement in self.audioTopics){
            [dictionaryElements addObject:[audioTopicsElement toDictionary]];
        }
        dictionary[kMFYGlobalModelAudioTopics] = dictionaryElements;
    }
    if(self.bannedTip != nil){
        dictionary[kMFYGlobalModelBannedTip] = self.bannedTip;
    }
    dictionary[kMFYGlobalModelImageRereadFreeTimes] = @(self.imageRereadFreeTimes);
    if(self.imageRereadRechargeProducts != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYAudioRereadRechargeProduct * imageRereadRechargeProductsElement in self.imageRereadRechargeProducts){
            [dictionaryElements addObject:[imageRereadRechargeProductsElement toDictionary]];
        }
        dictionary[kMFYGlobalModelImageRereadRechargeProducts] = dictionaryElements;
    }
    if(self.imageTopicTip != nil){
        dictionary[kMFYGlobalModelImageTopicTip] = self.imageTopicTip;
    }
    if(self.imageTopics != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYAudioTopic * imageTopicsElement in self.imageTopics){
            [dictionaryElements addObject:[imageTopicsElement toDictionary]];
        }
        dictionary[kMFYGlobalModelImageTopics] = dictionaryElements;
    }
    if(self.privacyUrl != nil){
        dictionary[kMFYGlobalModelPrivacyUrl] = self.privacyUrl;
    }
    if(self.purchaseRechargeTip != nil){
        dictionary[kMFYGlobalModelPurchaseRechargeTip] = self.purchaseRechargeTip;
    }
    if(self.rereadArticleTip != nil){
        dictionary[kMFYGlobalModelRereadArticleTip] = self.rereadArticleTip;
    }
    if(self.rereadRechargeTip != nil){
        dictionary[kMFYGlobalModelRereadRechargeTip] = self.rereadRechargeTip;
    }
    if(self.warningTip != nil){
        dictionary[kMFYGlobalModelWarningTip] = self.warningTip;
    }
    if(self.withdrawTip != nil){
        dictionary[kMFYGlobalModelWithdrawTip] = self.withdrawTip;
    }
    return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.audioRereadFreeTimes) forKey:kMFYGlobalModelAudioRereadFreeTimes];    if(self.audioRereadRechargeProducts != nil){
        [aCoder encodeObject:self.audioRereadRechargeProducts forKey:kMFYGlobalModelAudioRereadRechargeProducts];
    }
    if(self.audioTopicTip != nil){
        [aCoder encodeObject:self.audioTopicTip forKey:kMFYGlobalModelAudioTopicTip];
    }
    if(self.audioTopics != nil){
        [aCoder encodeObject:self.audioTopics forKey:kMFYGlobalModelAudioTopics];
    }
    if(self.bannedTip != nil){
        [aCoder encodeObject:self.bannedTip forKey:kMFYGlobalModelBannedTip];
    }
    [aCoder encodeObject:@(self.imageRereadFreeTimes) forKey:kMFYGlobalModelImageRereadFreeTimes];    if(self.imageRereadRechargeProducts != nil){
        [aCoder encodeObject:self.imageRereadRechargeProducts forKey:kMFYGlobalModelImageRereadRechargeProducts];
    }
    if(self.imageTopicTip != nil){
        [aCoder encodeObject:self.imageTopicTip forKey:kMFYGlobalModelImageTopicTip];
    }
    if(self.imageTopics != nil){
        [aCoder encodeObject:self.imageTopics forKey:kMFYGlobalModelImageTopics];
    }
    if(self.privacyUrl != nil){
        [aCoder encodeObject:self.privacyUrl forKey:kMFYGlobalModelPrivacyUrl];
    }
    if(self.purchaseRechargeTip != nil){
        [aCoder encodeObject:self.purchaseRechargeTip forKey:kMFYGlobalModelPurchaseRechargeTip];
    }
    if(self.rereadArticleTip != nil){
        [aCoder encodeObject:self.rereadArticleTip forKey:kMFYGlobalModelRereadArticleTip];
    }
    if(self.rereadRechargeTip != nil){
        [aCoder encodeObject:self.rereadRechargeTip forKey:kMFYGlobalModelRereadRechargeTip];
    }
    if(self.warningTip != nil){
        [aCoder encodeObject:self.warningTip forKey:kMFYGlobalModelWarningTip];
    }
    if(self.withdrawTip != nil){
        [aCoder encodeObject:self.withdrawTip forKey:kMFYGlobalModelWithdrawTip];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.audioRereadFreeTimes = [[aDecoder decodeObjectForKey:kMFYGlobalModelAudioRereadFreeTimes] integerValue];
    self.audioRereadRechargeProducts = [aDecoder decodeObjectForKey:kMFYGlobalModelAudioRereadRechargeProducts];
    self.audioTopicTip = [aDecoder decodeObjectForKey:kMFYGlobalModelAudioTopicTip];
    self.audioTopics = [aDecoder decodeObjectForKey:kMFYGlobalModelAudioTopics];
    self.bannedTip = [aDecoder decodeObjectForKey:kMFYGlobalModelBannedTip];
    self.imageRereadFreeTimes = [[aDecoder decodeObjectForKey:kMFYGlobalModelImageRereadFreeTimes] integerValue];
    self.imageRereadRechargeProducts = [aDecoder decodeObjectForKey:kMFYGlobalModelImageRereadRechargeProducts];
    self.imageTopicTip = [aDecoder decodeObjectForKey:kMFYGlobalModelImageTopicTip];
    self.imageTopics = [aDecoder decodeObjectForKey:kMFYGlobalModelImageTopics];
    self.privacyUrl = [aDecoder decodeObjectForKey:kMFYGlobalModelPrivacyUrl];
    self.purchaseRechargeTip = [aDecoder decodeObjectForKey:kMFYGlobalModelPurchaseRechargeTip];
    self.rereadArticleTip = [aDecoder decodeObjectForKey:kMFYGlobalModelRereadArticleTip];
    self.rereadRechargeTip = [aDecoder decodeObjectForKey:kMFYGlobalModelRereadRechargeTip];
    self.warningTip = [aDecoder decodeObjectForKey:kMFYGlobalModelWarningTip];
    self.withdrawTip = [aDecoder decodeObjectForKey:kMFYGlobalModelWithdrawTip];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYGlobalModel *copy = [MFYGlobalModel new];

    copy.audioRereadFreeTimes = self.audioRereadFreeTimes;
    copy.audioRereadRechargeProducts = [self.audioRereadRechargeProducts copy];
    copy.audioTopicTip = [self.audioTopicTip copy];
    copy.audioTopics = [self.audioTopics copy];
    copy.bannedTip = [self.bannedTip copy];
    copy.imageRereadFreeTimes = self.imageRereadFreeTimes;
    copy.imageRereadRechargeProducts = [self.imageRereadRechargeProducts copy];
    copy.imageTopicTip = [self.imageTopicTip copy];
    copy.imageTopics = [self.imageTopics copy];
    copy.privacyUrl = [self.privacyUrl copy];
    copy.purchaseRechargeTip = [self.purchaseRechargeTip copy];
    copy.rereadArticleTip = [self.rereadArticleTip copy];
    copy.rereadRechargeTip = [self.rereadRechargeTip copy];
    copy.warningTip = [self.warningTip copy];
    copy.withdrawTip = [self.withdrawTip copy];

    return copy;
}
@end
