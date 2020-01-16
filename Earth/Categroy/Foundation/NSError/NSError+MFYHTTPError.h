//
//  NSError+MFYHTTPError.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (MFYHTTPError)

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo;

+ (instancetype)errorWithCode:(NSInteger)code desc:(NSString *)desc;

- (NSString *)descriptionFromServer;


@end

NS_ASSUME_NONNULL_END
