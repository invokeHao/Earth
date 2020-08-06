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

+(void)getTheImageCardWithTopicId:(NSString *)topicId completion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    dic[@"size"] = @(50);
    NSString * path = FORMAT(@"/api/article/image/next/%@",topicId);
    [[MFYHTTPManager sharedManager] GET:path parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
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

+ (void)getTheAudioCardWithTopicId:(NSString *)topicId completion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    NSString * path = FORMAT(@"/api/article/audio/next/%@",topicId);
    [[MFYHTTPManager sharedManager] GET:path parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
            NSArray * arr = resp.result;
           __block NSInteger bgNameNum = 1;
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MFYArticle * article = [[MFYArticle alloc]initWithDictionary:obj];
                article.bgName = bgNameNum;
                bgNameNum ++;
                if (bgNameNum > 6) {
                    bgNameNum = 1;
                }
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

+ (void)getMyLikeCardListWithPage:(NSInteger)page completion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    dic[@"page"] = @(page);
    dic[@"size"] = @(20);
    [[MFYHTTPManager sharedManager] GET:@"/api/self/liked" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
            NSArray * arr = resp.result[@"rows"];
            __block NSInteger bgNameNum = 1;
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MFYArticle * article = [[MFYArticle alloc]initWithDictionary:obj];
                article.bgName = bgNameNum;
                bgNameNum ++;
                if (bgNameNum > 6) {
                    bgNameNum = 1;
                }
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

+ (void)getMyPostCardListWithPage:(NSInteger)page completion:(void (^)(NSArray<MFYArticle *> * , NSError * ))completion {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
       dic[@"page"] = @(page);
       dic[@"size"] = @(20);
       [[MFYHTTPManager sharedManager] GET:@"/api/self/post" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
           MFYResponseObject * resp = cmsResponse;
           if (resp.code == 1) {
               NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
               NSArray * arr = resp.result[@"rows"];
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

+ (void)getMyPurchasedCardListWithPage:(NSInteger)page completion:(void (^)(NSArray<MFYItem *> *, NSError * ))completion {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
       dic[@"page"] = @(page);
       dic[@"size"] = @(20);
       [[MFYHTTPManager sharedManager] GET:@"/api/self/purchased" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
           MFYResponseObject * resp = cmsResponse;
           if (resp.code == 1) {
               NSMutableArray * ArticleArr = [NSMutableArray arrayWithCapacity:0];
               NSArray * arr = resp.result[@"rows"];
               [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   MFYItem * article = [[MFYItem alloc]initWithDictionary:obj];
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
            case MFYCoreflowAudioAllType:
            return @"all";
            break;
            case MFYCoreflowAudioTopType:
            return @"top";
            break;
            case MFYCoreflowAudioFriendsType:
            return @"friends";
            break;
            default:
            return @"all";
    }
}

@end
