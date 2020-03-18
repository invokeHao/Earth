//
//  MFYWXOrderModel.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYDeductStatu.h"

@interface MFYWXOrderModel : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) MFYDeductStatu * deductStatus;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, assign) NSInteger rechargeSource;
@property (nonatomic, strong) NSString * wxPayAppId;
@property (nonatomic, strong) NSString * wxPayNonceStr;
@property (nonatomic, strong) NSString * wxPayPackage;
@property (nonatomic, strong) NSString * wxPayPartnerId;
@property (nonatomic, strong) NSString * wxPayPrepayId;
@property (nonatomic, strong) NSString * wxPaySign;
@property (nonatomic, strong) NSString * wxPayTimestamp;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

