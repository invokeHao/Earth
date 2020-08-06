//
//  MOPhotoUtil.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MOPhotoUtil

#pragma mark - pubilc method

// 获取所有相册 (过滤掉为空和不需要展示的)
+ (void)fetchAssetCollectionsWithAlbumType:(MOAlbumType)albumType
                                completion:(void (^)(NSArray<PHAssetCollection *> *))completion {
    
    NSMutableArray<PHAssetCollection *> *collectionList = [NSMutableArray array];
    
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((albumType & MOAlbumTypSmartAlbumUserLibrary)  == MOAlbumTypSmartAlbumUserLibrary) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [collectionList insertObject:collection atIndex:0];
            }
        }
        if ((albumType & MOAlbumTypSmartAlbumRecentlyAdded) == MOAlbumTypSmartAlbumRecentlyAdded) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                [collectionList addObject:collection];
            }
        }
        if ((albumType & MOAlbumTypSmartAlbumFavorites) == MOAlbumTypSmartAlbumFavorites) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumFavorites) {
                [collectionList addObject:collection];
            }
        }
        if ((albumType & MOAlbumTypSmartAlbumVideos) == MOAlbumTypSmartAlbumVideos) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
                [collectionList addObject:collection];
            }
        }
    }];
    if ((albumType & MOAlbumTypAlbumAny) == MOAlbumTypAlbumAny) {
        PHFetchResult<PHAssetCollection *> *userFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        [userFetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
            [collectionList addObject:collection];
        }];
    }
    
    NSMutableArray *resultCollectionList = [NSMutableArray array];
    [collectionList enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset *> *assetList = [PHAsset fetchAssetsInAssetCollection:collection options:[MOPhotoUtil getFetchOptions]];
        if (assetList.count > 0) {
            [resultCollectionList addObject:collection];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion([resultCollectionList copy]);
    });
}


/**
 根据PHCollection获取所有资源
 
 @param collection 相册
 @param completion 结果
 */
+ (void)fetchAssetListFromAssetCollection:(PHAssetCollection*)collection
                                assetType:(MOAssetType)assetType
                               completion:(void (^)(NSArray<PHAsset*> *))completion {
    
    NSMutableArray<PHAsset*> *dataList = [NSMutableArray array];
    PHFetchResult<PHAsset *> *assetList = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [assetList enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MOAssetType type = [MOPhotoUtil getAssetType:obj];
        if ((assetType & MOAssetTypePhoto) == type) {
            [dataList addObject:obj];
        }
        if ((assetType & MOAssetTypeGif) == type) {
            [dataList addObject:obj];
        }
        if ((assetType & MOAssetTypeVideo) == type) {
            [dataList addObject:obj];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion([[dataList reverseObjectEnumerator] allObjects]);
    });
}


/**
 获取相册的头图和图片数量
 
 @param collection 相册
 @param size 头像尺寸
 @param completion 结果回调
 */
+ (void)fetchAssetInfoFromAssetCollection:(PHAssetCollection *)collection
                                     size:(CGSize)size
                               completion:(void (^)(MOAssetCollectionInfoModel*))completion {
    
    PHFetchResult<PHAsset *> *assetList = [PHAsset fetchAssetsInAssetCollection:collection options:[MOPhotoUtil getFetchOptions]];
    PHAsset *firstPhAsset = assetList.firstObject;
    if (firstPhAsset) {
        [MOPhotoUtil fetchImageFromPHAsset:firstPhAsset size:size progressHandler:nil completion:^(UIImage * result) {
            MOAssetCollectionInfoModel *infoModel = [[MOAssetCollectionInfoModel alloc] init];
            infoModel.headImage = result;
            infoModel.assetCount = assetList.count;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(infoModel);
            });
        }];
    }else {
        completion(nil);
    }
}



/**
 获取原图(gif)

 @param phAsset 资源对象
 @param completion 结果回调
 */
+ (int32_t)fetchOriginalPhotoDataWithAsset:(PHAsset *)phAsset
                        progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                             completion:(void (^)(NSData*))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.version = PHImageRequestOptionsVersionOriginal;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    
    return [[PHImageManager defaultManager] requestImageDataForAsset:phAsset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(imageData);
                }
            });
        }
    }];
}

/**
 根据PHAsset 获取图片

 @param phAsset 资源对象
 @param size 目标图片尺寸
 @param completion 结果回调
 */
+ (int32_t)fetchImageFromPHAsset:(PHAsset *)phAsset
                         size:(CGSize)size
              progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                   completion:(void (^)(UIImage*))completion {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;

    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    
   return [[PHCachingImageManager defaultManager] requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //根据请求会调中的参数重 NSDictionary *info 是否有cloudKey 来判断是否是  iCloud
            if ([info objectForKey: PHImageResultIsInCloudKey]) {
                completion(result);
            }else {
                completion(result);
            }
        });
    }];
}


// 根据PHAsset 获取视频AVAsset
+ (int32_t)fetchVideoFromPHAsset:(PHAsset *)phAsset
              judgeisNeedDownloadHandler:(void (^)(BOOL isNeedDownload))judgeisNeedDownloadHandler
              progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                   completion:(void (^)(AVAsset*))completion {
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
   return [[PHCachingImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                judgeisNeedDownloadHandler(NO);
                completion(asset);
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                judgeisNeedDownloadHandler(YES);
            });
            
            // 从iCloud下载
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.networkAccessAllowed = YES;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
            
            [[PHCachingImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(asset);
                });
            }];
        }
    }];
  
}




// 检测资源访问权限
+ (void)checkAuthStatus:(void (^)(BOOL))completion {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
            case PHAuthorizationStatusAuthorized:
                completion(YES);
                break;
            default:
                completion(NO);
                break;
        }
    }];
}


/**
 获取资源类型
 */
+ (MOAssetType)getAssetType:(PHAsset *)phAsset {
    MOAssetType type = MOAssetTypePhoto;
    if (phAsset.mediaType == PHAssetMediaTypeVideo) {
        type = MOAssetTypeVideo;
    }else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        type = MOAssetTypePhoto;
        // Gif
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = MOAssetTypeGif;
        }
    }
    return type;
}

#pragma mark - private method

// 获取配置项
+ (PHFetchOptions *)getFetchOptions {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    return options;
}












@end
