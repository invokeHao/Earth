//
//  MFYWXOrderModel.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import "MFYWXOrderModel.h"

NSString *const kMFYWXOrderModelAmount = @"amount";
NSString *const kMFYWXOrderModelDeductStatus = @"deductStatus";
NSString *const kMFYWXOrderModelOrderId = @"orderId";
NSString *const kMFYWXOrderModelRechargeSource = @"rechargeSource";
NSString *const kMFYWXOrderModelWxPayAppId = @"wxPayAppId";
NSString *const kMFYWXOrderModelWxPayNonceStr = @"wxPayNonceStr";
NSString *const kMFYWXOrderModelWxPayPackage = @"wxPayPackage";
NSString *const kMFYWXOrderModelWxPayPartnerId = @"wxPayPartnerId";
NSString *const kMFYWXOrderModelWxPayPrepayId = @"wxPayPrepayId";
NSString *const kMFYWXOrderModelWxPaySign = @"wxPaySign";
NSString *const kMFYWXOrderModelWxPayTimestamp = @"wxPayTimestamp";

@interface MFYWXOrderModel ()
@end
@implementation MFYWXOrderModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYWXOrderModelAmount] isKindOfClass:[NSNull class]]){
        self.amount = [dictionary[kMFYWXOrderModelAmount] integerValue];
    }

    if(![dictionary[kMFYWXOrderModelDeductStatus] isKindOfClass:[NSNull class]]){
        self.deductStatus = [[MFYDeductStatu alloc] initWithDictionary:dictionary[kMFYWXOrderModelDeductStatus]];
    }

    if(![dictionary[kMFYWXOrderModelOrderId] isKindOfClass:[NSNull class]]){
        self.orderId = dictionary[kMFYWXOrderModelOrderId];
    }
    if(![dictionary[kMFYWXOrderModelRechargeSource] isKindOfClass:[NSNull class]]){
        self.rechargeSource = [dictionary[kMFYWXOrderModelRechargeSource] integerValue];
    }

    if(![dictionary[kMFYWXOrderModelWxPayAppId] isKindOfClass:[NSNull class]]){
        self.wxPayAppId = dictionary[kMFYWXOrderModelWxPayAppId];
    }
    if(![dictionary[kMFYWXOrderModelWxPayNonceStr] isKindOfClass:[NSNull class]]){
        self.wxPayNonceStr = dictionary[kMFYWXOrderModelWxPayNonceStr];
    }
    if(![dictionary[kMFYWXOrderModelWxPayPackage] isKindOfClass:[NSNull class]]){
        self.wxPayPackage = dictionary[kMFYWXOrderModelWxPayPackage];
    }
    if(![dictionary[kMFYWXOrderModelWxPayPartnerId] isKindOfClass:[NSNull class]]){
        self.wxPayPartnerId = dictionary[kMFYWXOrderModelWxPayPartnerId];
    }
    if(![dictionary[kMFYWXOrderModelWxPayPrepayId] isKindOfClass:[NSNull class]]){
        self.wxPayPrepayId = dictionary[kMFYWXOrderModelWxPayPrepayId];
    }
    if(![dictionary[kMFYWXOrderModelWxPaySign] isKindOfClass:[NSNull class]]){
        self.wxPaySign = dictionary[kMFYWXOrderModelWxPaySign];
    }
    if(![dictionary[kMFYWXOrderModelWxPayTimestamp] isKindOfClass:[NSNull class]]){
        self.wxPayTimestamp = dictionary[kMFYWXOrderModelWxPayTimestamp];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYWXOrderModelAmount] = @(self.amount);
    if(self.deductStatus != nil){
        dictionary[kMFYWXOrderModelDeductStatus] = [self.deductStatus toDictionary];
    }
    if(self.orderId != nil){
        dictionary[kMFYWXOrderModelOrderId] = self.orderId;
    }
    dictionary[kMFYWXOrderModelRechargeSource] = @(self.rechargeSource);
    if(self.wxPayAppId != nil){
        dictionary[kMFYWXOrderModelWxPayAppId] = self.wxPayAppId;
    }
    if(self.wxPayNonceStr != nil){
        dictionary[kMFYWXOrderModelWxPayNonceStr] = self.wxPayNonceStr;
    }
    if(self.wxPayPackage != nil){
        dictionary[kMFYWXOrderModelWxPayPackage] = self.wxPayPackage;
    }
    if(self.wxPayPartnerId != nil){
        dictionary[kMFYWXOrderModelWxPayPartnerId] = self.wxPayPartnerId;
    }
    if(self.wxPayPrepayId != nil){
        dictionary[kMFYWXOrderModelWxPayPrepayId] = self.wxPayPrepayId;
    }
    if(self.wxPaySign != nil){
        dictionary[kMFYWXOrderModelWxPaySign] = self.wxPaySign;
    }
    if(self.wxPayTimestamp != nil){
        dictionary[kMFYWXOrderModelWxPayTimestamp] = self.wxPayTimestamp;
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
    [aCoder encodeObject:@(self.amount) forKey:kMFYWXOrderModelAmount];    if(self.deductStatus != nil){
        [aCoder encodeObject:self.deductStatus forKey:kMFYWXOrderModelDeductStatus];
    }
    if(self.orderId != nil){
        [aCoder encodeObject:self.orderId forKey:kMFYWXOrderModelOrderId];
    }
    [aCoder encodeObject:@(self.rechargeSource) forKey:kMFYWXOrderModelRechargeSource];    if(self.wxPayAppId != nil){
        [aCoder encodeObject:self.wxPayAppId forKey:kMFYWXOrderModelWxPayAppId];
    }
    if(self.wxPayNonceStr != nil){
        [aCoder encodeObject:self.wxPayNonceStr forKey:kMFYWXOrderModelWxPayNonceStr];
    }
    if(self.wxPayPackage != nil){
        [aCoder encodeObject:self.wxPayPackage forKey:kMFYWXOrderModelWxPayPackage];
    }
    if(self.wxPayPartnerId != nil){
        [aCoder encodeObject:self.wxPayPartnerId forKey:kMFYWXOrderModelWxPayPartnerId];
    }
    if(self.wxPayPrepayId != nil){
        [aCoder encodeObject:self.wxPayPrepayId forKey:kMFYWXOrderModelWxPayPrepayId];
    }
    if(self.wxPaySign != nil){
        [aCoder encodeObject:self.wxPaySign forKey:kMFYWXOrderModelWxPaySign];
    }
    if(self.wxPayTimestamp != nil){
        [aCoder encodeObject:self.wxPayTimestamp forKey:kMFYWXOrderModelWxPayTimestamp];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.amount = [[aDecoder decodeObjectForKey:kMFYWXOrderModelAmount] integerValue];
    self.deductStatus = [aDecoder decodeObjectForKey:kMFYWXOrderModelDeductStatus];
    self.orderId = [aDecoder decodeObjectForKey:kMFYWXOrderModelOrderId];
    self.rechargeSource = [[aDecoder decodeObjectForKey:kMFYWXOrderModelRechargeSource] integerValue];
    self.wxPayAppId = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayAppId];
    self.wxPayNonceStr = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayNonceStr];
    self.wxPayPackage = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayPackage];
    self.wxPayPartnerId = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayPartnerId];
    self.wxPayPrepayId = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayPrepayId];
    self.wxPaySign = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPaySign];
    self.wxPayTimestamp = [aDecoder decodeObjectForKey:kMFYWXOrderModelWxPayTimestamp];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYWXOrderModel *copy = [MFYWXOrderModel new];

    copy.amount = self.amount;
    copy.deductStatus = [self.deductStatus copy];
    copy.orderId = [self.orderId copy];
    copy.rechargeSource = self.rechargeSource;
    copy.wxPayAppId = [self.wxPayAppId copy];
    copy.wxPayNonceStr = [self.wxPayNonceStr copy];
    copy.wxPayPackage = [self.wxPayPackage copy];
    copy.wxPayPartnerId = [self.wxPayPartnerId copy];
    copy.wxPayPrepayId = [self.wxPayPrepayId copy];
    copy.wxPaySign = [self.wxPaySign copy];
    copy.wxPayTimestamp = [self.wxPayTimestamp copy];

    return copy;
}
@end
