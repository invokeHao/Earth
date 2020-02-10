//
//  MFYQiniuSystemService.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYQiniuSystemService.h"
#import "MFYAssetModel.h"
#import "MFYVideoManager.h"

@implementation MFYQiniuSystemService

+ (void)getQiniuUploadTockenSuccess:(void (^)(id _Nonnull))success failure:(void (^)(void))faulure {
    [[MFYHTTPManager sharedManager] POST:@"/api/misc/config/upload/token" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        WHLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

+ (void)uploadAudio:(NSString *)filePath progress:(QNUpProgressHandler)progress success:(void (^)(NSDictionary *))success failure:(void (^)(void))failure {
    //生成文件名称，调用上面的时间函数，和随机字符串函数
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.mp3",[MFYQiniuSystemService getDateTimeString],[MFYQiniuSystemService randomStringWithLength:8]];

    QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
    QNUploadManager *manager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    
    [manager putFile:filePath key:fileName token:[MFYDynamicManager sharedManager].qiniuTocken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            if (success) {
                success(resp);
            }
        } else {
            if (failure) {
                failure();
            }
        }
    } option:option];
}

+ (void)uploadAssetModel:(MFYAssetModel *)assetModel progress:(QNUpProgressHandler)progress success:(void (^)(NSDictionary *resp))success failure:(void (^)(void))failure {
    //生成文件名称，调用上面的时间函数，和随机字符串函数
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.png",[MFYQiniuSystemService getDateTimeString],[MFYQiniuSystemService randomStringWithLength:8]];
    QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
    QNUploadManager *manager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    
    void (^block)(QNResponseInfo *, NSString * key, NSDictionary *resp) = ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            if (success) {
                success(resp);
            }
        } else {
            if (failure) {
                failure();
            }
        }
    };
    switch (assetModel.type) {
        case CMSAssetMediaTypePhoto:
        case CMSAssetMediaTypeLivePhoto: {
            __block NSData *data = nil;
            if (assetModel.resizeImage) {
                data = UIImageJPEGRepresentation(assetModel.resizeImage, 0.7);
                if (data.length) {
                    [manager putData:data key:fileName token:[MFYDynamicManager sharedManager].qiniuTocken complete:block option:option];
                } else {
                    failure();
                }
            } else if (assetModel.highImage) {
                data = UIImageJPEGRepresentation(assetModel.highImage, 0.7);
                if (data.length) {
                    [manager putData:data key:fileName token:[MFYDynamicManager sharedManager].qiniuTocken complete:block option:option];
                } else {
                    failure();
                }
            } else {
//                CGFloat aspectRatio = (CGFloat)assetModel.asset.pixelHeight / (CGFloat)assetModel.asset.pixelWidth;
//                [[CMSPhotosManager sharedManager] requestPhotoWithTargetSize:CGSizeMake(High_PHOTOWIDTH, High_PHOTOWIDTH*aspectRatio)
//                                                                       asset:assetModel.asset
//                                                                  resizeMode:PHImageRequestOptionsResizeModeFast
//                                                                  completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//                                                                      if (!isDegraded) {
//                                                                          data = UIImageJPEGRepresentation(photo, 0.7);
//                                                                          if (data.length) {
//                                                                              [manager putData:data key:fileName token:[CMSDynamicConfig shared].qiniuTocken complete:block option:option];
//                                                                          } else {
//                                                                              failure();
//                                                                          }
//                                                                      }
//                                                                  }];
            }
        }
            break;
        case CMSAssetMediaTypeOnlineGif:
        case CMSAssetMediaTypeVideoTranformGif: {
//            fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@".gif"];
//            UIImage *image = [[YYImageCache sharedCache] getImageForKey:assetModel.gifItem.url];
//            if (image == nil) {
//               image = [YYImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:assetModel.gifItem.url]]];
//            }
//            NSData *data = nil;
//            if ([image isKindOfClass:[YYImage class]]) {
//                data = [(YYImage *)image animatedImageData];
//            } else {
//                [YYImageEncoder encodeImage:image type:YYImageTypeGIF quality:0.5];
//            }
//            if (data.length) {
//                [manager putData:data key:fileName token:[CMSDynamicConfig shared].qiniuTocken complete:block option:option];
//            } else {
//                failure();
//            }
//            [manager putFile:assetModel.gifItem.url key:fileName token:[CMSDynamicConfig shared].qiniuTocken complete:block option:option];
        }
            break;
        case CMSAssetMediaTypeGif: {
//            fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@".gif"];
//            [manager putPHAsset:assetModel.asset key:fileName token:[CMSDynamicConfig shared].qiniuTocken complete:block option:option];
        }
            break;
        case CMSAssetMediaTypeVideo: {
            // 先压缩再上传
            fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@".mp4"];
            [MFYVideoManager exportVideoForAsset:assetModel.asset presetName:AVAssetExportPreset960x540 complete:^(NSString *exportPath, NSError *error) {
                if (!error) {
                    [manager putFile:exportPath key:fileName token:[MFYDynamicManager sharedManager].qiniuTocken complete:block option:option];
                } else {
                    failure();
                    NSLog(@"压缩失败---%@",error);
                }
            }];
        }
            break;
        case CMSAssetMediaTypeEditVideo: {
//            fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@".mp4"];
//            [manager putFile:assetModel.videoPath key:fileName token:[CMSDynamicConfig shared].qiniuTocken complete:block option:option];
        }
            break;
        default: {
           failure();
        }
            break;
    }
}

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSDictionary *resp))success failure:(void (^)(void))failure {
    //生成文件名称，调用上面的时间函数，和随机字符串函数
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.png",[MFYQiniuSystemService getDateTimeString],[MFYQiniuSystemService randomStringWithLength:8]];
    QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
    QNUploadManager *manager = [QNUploadManager sharedInstanceWithConfiguration:nil];

    void (^block)(QNResponseInfo *, NSString * key, NSDictionary *resp) = ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            if (success) {
                success(resp);
            }
        } else {
            if (failure) {
                failure();
            }
        }
    };
    NSData *data = [image uploadImageCompress];
    if (data.length) {
        [manager putData:data key:fileName token:[MFYDynamicManager sharedManager].qiniuTocken complete:block option:option];
    } else {
        failure();
    }
}

+ (void)uploadAssetArray:(NSArray *)assetArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray *))success failure:(void(^)(void))failure {
    if (assetArray.count == 0) {
        success(nil);
        return;
    }
    
    NSRecursiveLock *lock = [NSRecursiveLock new];
    NSMutableArray *array = [[NSMutableArray alloc] init];

    __block NSUInteger successCount = 0;
    for (NSInteger idx = 0; idx < assetArray.count; idx++) {
        [array addObject:[NSNull null]];
        [MFYQiniuSystemService uploadAssetModel:assetArray[idx] progress:nil success:^(NSDictionary *resp) {
            [lock lock];
            successCount += 1;
            [array replaceObjectAtIndex:idx withObject:resp];
            [lock unlock];
            if (successCount >= [assetArray count]) {
               return success([array copy]);
            }
        } failure:failure];
    }
}


+ (NSString *)getDateTimeString {
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)randomStringWithLength:(int)len {
//    NSString * letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//    NSMutableString * randomString = [NSMutableString stringWithCapacity:len];
//    for(int i = 0; i < len; i++) {
//        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
//    }
    NSString* tick=[[NSUUID UUID] UUIDString];
    return [tick lowercaseString];
}


@end
