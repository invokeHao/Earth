//
//  MFYQiniuSystemService.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QiniuSDK.h"
#import "MFYDynamicManager.h"


@class MFYAssetModel;

NS_ASSUME_NONNULL_BEGIN

@interface MFYQiniuSystemService : NSObject

//获取token

+ (void)getQiniuUploadTockenSuccess:(void(^)(id model))success failure:(void(^)(NSError* error))failure;

/// 上传音频
+ (void)uploadAudio:(NSString *)filePath progress:(QNUpProgressHandler)progress success:(void (^)(NSDictionary *resp))success failure:(void (^)(void))failure;

/// 单个上传
+ (void)uploadAssetModel:(MFYAssetModel *)assetModel progress:(QNUpProgressHandler)progress success:(void(^)(NSDictionary *resp))success failure:(void(^)(void))failure;

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSDictionary *resp))success failure:(void (^)(void))failure;

/// 异步上传
+ (void)uploadAssetArray:(NSArray *)assetArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray *))success failure:(void(^)(void))failure;


@end

NS_ASSUME_NONNULL_END
