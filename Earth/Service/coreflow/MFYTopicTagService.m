//
//  MFYTopicTagService.m
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYTopicTagService.h"

@implementation MFYTopicTagService

+(void)getTheImageTopicTagsCompletion:(void (^)(NSArray<MFYCoreflowTag *> * ,NSError *))completion {
    
    [[MFYHTTPManager sharedManager] GET:@"/api/misc/config/image/topics" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        if (cmsResponse.code == 1) {
            NSMutableArray * tagArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * itemDic in cmsResponse.result) {
                MFYCoreflowTag * tag = [[MFYCoreflowTag alloc]initWithDictionary:itemDic];
                [tagArr addObject:tag];
            }
            completion([tagArr copy], nil);
        }else {
            NSError * error = [NSError errorWithCode:cmsResponse.code desc:cmsResponse.errorDesc];
            completion(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion (nil, error);
    }];
}


+ (void)getTheaudioTopicTagsCompletion:(void (^)(NSArray<MFYCoreflowTag *> * , NSError *))completion {
    
    [[MFYHTTPManager sharedManager] GET:@"" parameters:@[] success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        if (cmsResponse.code == 1) {
            NSMutableArray * tagArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * itemDic in cmsResponse.result) {
                MFYCoreflowTag * tag = [MFYCoreflowTag yy_modelWithDictionary:itemDic];
                [tagArr addObject:tag];
            }
            completion([tagArr copy], nil);
        }else {
            NSError * error = [NSError errorWithCode:cmsResponse.code desc:cmsResponse.errorDesc];
            completion(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];

}

@end
