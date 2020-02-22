//
//  MFYLoginService.m
//  Earth
//
//  Created by colr on 2020/1/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYLoginService.h"
#import "MFYLoginModel.h"

@implementation MFYLoginService

+ (void)loginWithPhoneNum:(NSString *)phoneNum verifyCode:(NSString *)verifyCode completion:(void (^)(MFYLoginModel * , NSError * ))completion {
    NSString * path = @"/api/auth/signon/verify";
    NSDictionary * dic = @{@"authvalue": phoneNum,@"verifycode": verifyCode};
    [[MFYHTTPManager sharedManager] POST:path parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        MFYResponseObject * resp = responseObject;
        if (resp.code == 1) {
            MFYLoginModel * model = [[MFYLoginModel alloc]initWithDictionary:resp.result];
            completion(model, nil);
        }else{
            NSError * error = [NSError errorWithCode:resp.code desc:resp.errorDesc];
            completion(nil,error);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

+ (void)singOutCompletion:(void (^)(BOOL, NSError *))completion {
    [[MFYHTTPManager sharedManager] POST:@"/api/auth/signoff" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
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
