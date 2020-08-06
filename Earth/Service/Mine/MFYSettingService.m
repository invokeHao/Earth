//
//  MFYSettingService.m
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYSettingService.h"

@implementation MFYSettingService

+(void)postModifyAllowSearch:(BOOL)allow Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"value"] = @(allow);
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/auth/allowsearch" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)postModifyBindPhone:(NSDictionary *)pramaDic Completion:(void (^)(BOOL, NSError * ))completion {
    
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/auth/replace" parameters:pramaDic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

@end
