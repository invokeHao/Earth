//
//  MFYChatService.m
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatService.h"

@implementation MFYChatService

+ (void)getTopChatListCompletion:(void (^)(NSArray<NSString *> * , NSError * ))completion {
    
    [[MFYHTTPManager sharedManager] POST:@"/api/self/chat/tops" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        MFYResponseObject * resp = responseObject;
        if (resp.code == 1) {
            NSArray * arr = resp.result;
            completion(arr,nil);
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)postSearchFriendsPramaDic:(NSDictionary *)dic Completion:(nonnull void (^)(NSArray<MFYProfile *> * , NSError * ))completion{
    [[MFYHTTPManager sharedManager] POST:@"/api/profile/search" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * dic in responseObject.result[@"rows"]) {
                MFYProfile * profile = [[MFYProfile alloc]initWithDictionary:dic];
                [arr addObject:profile];
            }
            completion(arr,nil);
        }else{
            completion(nil,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

+ (void)postMayKnowFriendsWithPhoneNum:(NSArray *)numArr Completion:(void (^)(NSArray<MFYProfile *> * , NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"mobiles"] = numArr;
    [[MFYHTTPManager sharedManager] POST:@"/api/profile/recommends" HTTPBody:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * dic in responseObject.result) {
                MFYProfile * profile = [[MFYProfile alloc]initWithDictionary:dic];
                [arr addObject:profile];
            }
            completion(arr,nil);
        }else{
            completion(nil,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

+ (void)postAddTopsChat:(NSString *)userId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"userid"] = userId;
    [[MFYHTTPManager sharedManager] POST:@"/api/self/chat/tops/add" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)postRemoveTopsChat:(NSString *)userId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"userid"] = userId;
    [[MFYHTTPManager sharedManager] POST:@"/api/self/chat/tops/remove" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
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
