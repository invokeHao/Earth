//
//  MFYMFYAudioRereadRechargeProduct.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioRereadRechargeProduct.h"

NSString *const kMFYAudioRereadRechargeProductPriceAmount = @"priceAmount";
NSString *const kMFYAudioRereadRechargeProductProductAmount = @"productAmount";
NSString *const kMFYAudioRereadRechargeProductProductId = @"productId";
NSString *const kMFYAudioRereadRechargeProductProductName = @"productName";
NSString *const kMFYAudioRereadRechargeProductType = @"type";

@interface MFYAudioRereadRechargeProduct ()
@end
@implementation MFYAudioRereadRechargeProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYAudioRereadRechargeProductPriceAmount] isKindOfClass:[NSNull class]]){
        self.priceAmount = [dictionary[kMFYAudioRereadRechargeProductPriceAmount] integerValue];
    }

    if(![dictionary[kMFYAudioRereadRechargeProductProductAmount] isKindOfClass:[NSNull class]]){
        self.productAmount = [dictionary[kMFYAudioRereadRechargeProductProductAmount] integerValue];
    }

    if(![dictionary[kMFYAudioRereadRechargeProductProductId] isKindOfClass:[NSNull class]]){
        self.productId = dictionary[kMFYAudioRereadRechargeProductProductId];
    }
    if(![dictionary[kMFYAudioRereadRechargeProductProductName] isKindOfClass:[NSNull class]]){
        self.productName = dictionary[kMFYAudioRereadRechargeProductProductName];
    }
    if(![dictionary[kMFYAudioRereadRechargeProductType] isKindOfClass:[NSNull class]]){
        self.type = [dictionary[kMFYAudioRereadRechargeProductType] integerValue];
    }

    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYAudioRereadRechargeProductPriceAmount] = @(self.priceAmount);
    dictionary[kMFYAudioRereadRechargeProductProductAmount] = @(self.productAmount);
    if(self.productId != nil){
        dictionary[kMFYAudioRereadRechargeProductProductId] = self.productId;
    }
    if(self.productName != nil){
        dictionary[kMFYAudioRereadRechargeProductProductName] = self.productName;
    }
    dictionary[kMFYAudioRereadRechargeProductType] = @(self.type);
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
    [aCoder encodeObject:@(self.priceAmount) forKey:kMFYAudioRereadRechargeProductPriceAmount];    [aCoder encodeObject:@(self.productAmount) forKey:kMFYAudioRereadRechargeProductProductAmount];    if(self.productId != nil){
        [aCoder encodeObject:self.productId forKey:kMFYAudioRereadRechargeProductProductId];
    }
    if(self.productName != nil){
        [aCoder encodeObject:self.productName forKey:kMFYAudioRereadRechargeProductProductName];
    }
    [aCoder encodeObject:@(self.type) forKey:kMFYAudioRereadRechargeProductType];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.priceAmount = [[aDecoder decodeObjectForKey:kMFYAudioRereadRechargeProductPriceAmount] integerValue];
    self.productAmount = [[aDecoder decodeObjectForKey:kMFYAudioRereadRechargeProductProductAmount] integerValue];
    self.productId = [aDecoder decodeObjectForKey:kMFYAudioRereadRechargeProductProductId];
    self.productName = [aDecoder decodeObjectForKey:kMFYAudioRereadRechargeProductProductName];
    self.type = [[aDecoder decodeObjectForKey:kMFYAudioRereadRechargeProductType] integerValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYAudioRereadRechargeProduct *copy = [MFYAudioRereadRechargeProduct new];

    copy.priceAmount = self.priceAmount;
    copy.productAmount = self.productAmount;
    copy.productId = [self.productId copy];
    copy.productName = [self.productName copy];
    copy.type = self.type;

    return copy;
}
@end
