//
//  MFYMineService.m
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMineService.h"

@implementation MFYMineService

+ (void)getSelfDetailInfoCompletion:(void (^)(MFYProfile * , NSError * ))completion {
    [[MFYHTTPManager sharedManager] GET:@"/api/self/detail" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        if (cmsResponse.code == 1) {
            MFYProfile * profile = [MFYProfile yy_modelWithDictionary:cmsResponse.result];
            completion(profile, nil);
        }else {
            NSError * error = [NSError errorWithCode:cmsResponse.code desc:cmsResponse.errorDesc];
            completion(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion (nil, error);
    }];
}

+(void)getMyLikeCardListCompletion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    [[MFYHTTPManager sharedManager] GET:@"/api/self/liked" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
            NSArray * arr = resp.result;
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MFYArticle * article = [[MFYArticle alloc]initWithDictionary:obj];
                [ArticleArr addObject:article];
            }];
            completion(ArticleArr.copy,nil);
            
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)getMypostCardListCompletion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    [[MFYHTTPManager sharedManager] GET:@"/api/self/post" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
            NSArray * arr = resp.result;
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MFYArticle * article = [[MFYArticle alloc]initWithDictionary:obj];
                [ArticleArr addObject:article];
            }];
            completion(ArticleArr.copy,nil);
            
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)getMyPurchasedCardListCompletion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    [[MFYHTTPManager sharedManager] GET:@"/api/self/purchased" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
            NSArray * arr = resp.result;
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MFYArticle * article = [[MFYArticle alloc]initWithDictionary:obj];
                [ArticleArr addObject:article];
            }];
            completion(ArticleArr.copy,nil);
            
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)postModifyNickname:(NSString *)nickname Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (nickname.length > 0) {
        dic[@"value"] = nickname;
    }
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/nickname" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+(void)postModifyGender:(NSInteger)genderType Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"value"] = @(genderType);
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/gender" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+(void)postModifyAge:(NSInteger)age Completion:(void (^)(BOOL, NSError * ))completion{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"value"] = @(age);
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/age" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)postModifyIcon:(NSString *)iconId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"value"] = iconId;
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/headicon" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)postModifyTag:(NSString *)tagStr isremove:(BOOL)isRemove Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"tag"] = tagStr;
    dic[@"remove"] = @(isRemove);
    [[MFYHTTPManager sharedManager] POST:@"/api/self/modify/tags" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)postWXWithDrawCode:(NSString *)code Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"code"] = code;
    [[MFYHTTPManager sharedManager] POST:@"/api/self/withdraw/target/weixin/set" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
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
