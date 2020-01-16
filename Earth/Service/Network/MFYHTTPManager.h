//
//  MFYHTTPManager.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "MFYResponseObject.h"
#import "MFYServiceURLConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYHTTPManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

+ (void)tearDown;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id )parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse))success
                      failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, MFYResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                      HTTPBody:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, MFYResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)request:(NSMutableURLRequest *)req
                       success:(void (^)(MFYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
