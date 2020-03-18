//
//  MFYGlobalConfigService.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYGlobalConfigService.h"

@implementation MFYGlobalConfigService

+ (void)getTheGlobalConfigCompletion:(void (^)(MFYGlobalModel * , NSError * ))completion{
    [[MFYHTTPManager sharedManager] GET:@"/api/misc/config/global" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            MFYGlobalModel * model = [[MFYGlobalModel alloc]initWithDictionary:resp.result];
            completion(model.copy,nil);
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];

}

@end
