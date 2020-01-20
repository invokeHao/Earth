//
//  MFYCoreflowService.m
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCoreflowService.h"

@implementation MFYCoreflowService

+ (void)getTheImageCardWithFlowType:(MFYCoreFlowType)type completion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    NSString * typeStr = [MFYCoreflowService typeStrWithType:type];
    NSString * path = FORMAT(@"/api/article/image/next/%@",typeStr);
    [[MFYHTTPManager sharedManager] GET:path parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
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

+ (NSString *)typeStrWithType:(MFYCoreFlowType)type {
    switch (type) {
            case MFYCoreflowImageAllType:
            return @"all";
            break;
            case MFYCoreflowImageFriendsType:
            return @"friends";
            break;
            case MFYCoreflowImageTopType:
            return @"top";
            break;
            case MFYCoreflowAutoAllType:
            return @"all";
            break;
            case MFYCoreflowAutoTopType:
            return @"top";
            break;
            case MFYCoreflowAutoFriendsType:
            return @"friends";
            break;
            default:
            return @"all";
    }
}

@end
