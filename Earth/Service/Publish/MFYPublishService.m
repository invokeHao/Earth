//
//  MFYPublishService.m
//  Earth
//
//  Created by colr on 2020/2/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublishService.h"

@implementation MFYPublishService

+ (void)publishTheArticleParam:(NSDictionary *)dic completion:(nonnull void (^)(MFYArticle * , NSError * ))completion {
    [[MFYHTTPManager sharedManager] POST:@"/api/article/image/post" HTTPBody:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code == 1) {
            MFYArticle * article = [MFYArticle yy_modelWithDictionary:responseObject.result];
            completion(article, nil);
        }else{
            NSError * error = [NSError errorWithCode:responseObject.code desc:responseObject.errorDesc];
            completion(nil,error);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

@end
