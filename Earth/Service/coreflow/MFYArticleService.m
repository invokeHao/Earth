//
//  MFYArticleService.m
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYArticleService.h"

@implementation MFYArticleService

+ (void)postLikeArticle:(NSString *)articleId isLike:(BOOL)like Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSInteger likeValue = like ? 1 : -1;
    dic[@"value"] = @(likeValue);
    dic[@"articleid"] = articleId;
    [[MFYHTTPManager sharedManager] POST:@"/api/article/like" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)deleteArticle:(NSString *)articleId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"articleid"] = articleId;
    [[MFYHTTPManager sharedManager] POST:@"/api/article/remove" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            completion(YES,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)rereadArticle:(NSString *)articleId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"articleid"] = articleId;
    [[MFYHTTPManager sharedManager] POST:@"/api/article/reread" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            BOOL isAble = [responseObject.result boolValue];
            completion(isAble,nil);
        }else{
            completion(NO,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

+ (void)reportArticle:(NSString *)articleId Completion:(void (^)(BOOL, NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"articleid"] = articleId;
    [[MFYHTTPManager sharedManager] POST:@"/api/article/complain" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
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
