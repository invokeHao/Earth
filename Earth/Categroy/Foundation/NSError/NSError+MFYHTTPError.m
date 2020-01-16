//
//  NSError+MFYHTTPError.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "NSError+MFYHTTPError.h"

NSString *MFYErrorDesc = @"desc";
NSString *MFYDomain = @"com.shellcolr.cosmos";
NSString *NSErrorDesc = @"NSLocalizedDescription";



@implementation NSError (MFYHTTPError)

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)userInfo {
    NSError *error = [NSError errorWithDomain:MFYDomain
                                         code:code
                                     userInfo:userInfo];
    return error;
}

+ (instancetype)errorWithCode:(NSInteger)code desc:(NSString *)desc {
    NSError *error = [NSError errorWithDomain:MFYDomain
                                         code:code
                                     userInfo:@{MFYErrorDesc: desc ? desc : @"no desc"}];
    return error;
}

- (NSString *)descriptionFromServer {
    NSString *descriptionString = [self.userInfo valueForKey:MFYErrorDesc];
    if (!descriptionString || [descriptionString isEqualToString:@""]) {
        if ([self.userInfo valueForKey:NSErrorDesc]) {
            descriptionString = [self.userInfo valueForKey:NSErrorDesc];
        }else{
            descriptionString = @"服务异常，请稍后再试";
        }
    }
    return descriptionString;
}

@end
