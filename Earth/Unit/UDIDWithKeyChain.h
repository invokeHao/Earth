//
//  UDIDWithKeyChain.h
//  Earth
//
//  Created by colr on 2020/1/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDIDWithKeyChain : NSObject

+(NSString *)getUUID;

+ (void)deleteKeyData;

@end


@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
