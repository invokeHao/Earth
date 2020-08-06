//
//  MFYMFYAudioRereadRechargeProduct.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioRereadRechargeProduct : NSObject

@property (nonatomic, assign) NSInteger priceAmount;
@property (nonatomic, assign) NSInteger productAmount;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, assign) NSInteger type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
