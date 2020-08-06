//
//  MOAssetDownloadManager.m
//  PhotoLibraryKit
//
//  Created by 黑眼圈 on 2018/6/10.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOAssetDownloadManager.h"
#import "MODownloadCacheModel.h"
#import "MOPhotoUtil.h"
#import "MOMacro.h"

// notifications
NSString * const MOAssetDownloadWillDownloadNotification = @"MOAssetDownloadWillDownloadNotification";
NSString * const MOAssetDownloadDidFinishDownloadNotification = @"MOAssetDownloadDidFinishDownloadNotification";
NSString * const MOAssetDownloadProgressNotification = @"MOAssetDownloadProgressNotification";
NSString * const MOAssetIsNeedDownloadNotification = @"MOAssetIsNeedDownloadNotification";

@interface MOAssetDownloadManager ()

@property (nonatomic, strong) NSMutableArray<MODownloadCacheModel *> *downloadList;

@end

@implementation MOAssetDownloadManager


+ (instancetype)sharedManager {
    static MOAssetDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[MOAssetDownloadManager alloc] init];
        downloadManager.downloadList = [NSMutableArray array];
    });
    return downloadManager;
}

#pragma mark - public methods

- (void)startDownloadTaskWithAsset:(MOAssetModel *)assetModel {
    if (assetModel == nil) {
        return;
    }
    
    MODownloadCacheModel *cacheModel = [[MODownloadCacheModel alloc] init];
    cacheModel.identifier = assetModel.identifier;
    
    if (![self.downloadList containsObject:cacheModel]) {
        if (assetModel.type == MOAssetTypeGif) {
            if (!assetModel.identifier) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadWillDownloadNotification
                                                                object:nil
                                                              userInfo:@{@"progress":@(0),
                                                                         @"identifier":assetModel.identifier}];
            int32_t imageRequestID = [MOPhotoUtil fetchOriginalPhotoDataWithAsset:assetModel.phAsset progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadProgressNotification
                                                                    object:nil
                                                                  userInfo:@{@"progress":@(progress),
                                                                             @"identifier":assetModel.identifier}];
            } completion:^(NSData *data) {
                if (data) {
                    [self.downloadList removeObject:cacheModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadDidFinishDownloadNotification
                                                                        object:nil
                                                                      userInfo:@{@"progress":@(1),
                                                                                 @"identifier":assetModel.identifier,
                                                                                 @"imageData":data}];
                }
            }];
            cacheModel.imageRequestID = imageRequestID;
        }else if (assetModel.type == MOAssetTypePhoto) {
            if (!assetModel.identifier) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadWillDownloadNotification
                                                                object:nil
                                                              userInfo:@{@"progress":@(0),
                                                                         @"identifier":assetModel.identifier}];
            int32_t imageRequestID = [MOPhotoUtil fetchImageFromPHAsset:assetModel.phAsset size:CGSizeMake(High_PHOTOWIDTH, High_PHOTOWIDTH*assetModel.aspectRatio) progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                NSLog(@"%f",progress);
                [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadProgressNotification
                                                                    object:nil
                                                                  userInfo:@{@"progress":@(progress),
                                                                             @"identifier":assetModel.identifier}];
                
            } completion:^(UIImage *image) {
                if (image) {
                    [self.downloadList removeObject:cacheModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadDidFinishDownloadNotification
                                                                        object:nil
                                                                      userInfo:@{@"progress":@(1),
                                                                                 @"identifier":assetModel.identifier,
                                                                                 @"highImage":image}];
                }
            }];
            cacheModel.imageRequestID = imageRequestID;
        }else if (assetModel.type == MOAssetTypeVideo) {
            if (!assetModel.identifier) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadWillDownloadNotification
                                                                object:nil
                                                              userInfo:@{@"progress":@(0),
                                                                         @"identifier":assetModel.identifier}];
            int32_t imageRequestID = [MOPhotoUtil fetchVideoFromPHAsset:assetModel.phAsset judgeisNeedDownloadHandler:^(BOOL isNeedDownload) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetIsNeedDownloadNotification
                                                                    object:nil
                                                                  userInfo:@{@"isNeedDownload":@(isNeedDownload),
                                                                             @"identifier":assetModel.identifier}];
            } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadProgressNotification
                                                                    object:nil
                                                                  userInfo:@{@"progress":@(progress),
                                                                             @"identifier":assetModel.identifier}];
            } completion:^(AVAsset *avAsset) {
                if (avAsset) {
                    [self.downloadList removeObject:cacheModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MOAssetDownloadDidFinishDownloadNotification
                                                                        object:nil
                                                                      userInfo:@{@"progress":@(1),
                                                                                 @"identifier":assetModel.identifier}];
                }
            }];
            cacheModel.imageRequestID = imageRequestID;
        }
        [self.downloadList addObject:cacheModel];
    }
}

- (void)cancelImageRequest:(MOAssetModel *)assetModel {
    [self.downloadList enumerateObjectsUsingBlock:^(MODownloadCacheModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:assetModel.identifier]) {
            [[PHImageManager defaultManager] cancelImageRequest:obj.imageRequestID];
        }
    }];
}

- (void)cancelAllImageRequest {
    [self.downloadList enumerateObjectsUsingBlock:^(MODownloadCacheModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] cancelImageRequest:obj.imageRequestID];
    }];
}

- (void)reset {
    [self.downloadList removeAllObjects];
}

@end






