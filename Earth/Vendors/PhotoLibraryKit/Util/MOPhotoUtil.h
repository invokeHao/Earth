//
//  MOPhotoUtil.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//
//
//  ---图片选择工具类---

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MOAssetCollectionInfoModel.h"
#import "MOPhotoLibraryConfiguration.h"


@interface MOPhotoUtil : NSObject


/// 请求相册资源访问权限
+ (void)checkAuthStatus:(void (^)(BOOL))completion;

/// 获取相册相关

+ (void)fetchAssetCollectionsWithAlbumType:(MOAlbumType)albumType
                                completion:(void (^)(NSArray<PHAssetCollection *> *))completion;

+ (void)fetchAssetInfoFromAssetCollection:(PHAssetCollection *)collection
                                     size:(CGSize)size
                               completion:(void (^)(MOAssetCollectionInfoModel*))completion;

+ (void)fetchAssetListFromAssetCollection:(PHAssetCollection*)collection
                                assetType:(MOAssetType)assetType
                               completion:(void (^)(NSArray<PHAsset*> *))completionn;

/// 导出资源

+ (int32_t)fetchImageFromPHAsset:(PHAsset *)phAsset
                         size:(CGSize)size
              progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                   completion:(void (^)(UIImage*))completion;

+ (int32_t)fetchOriginalPhotoDataWithAsset:(PHAsset *)phAsset
                        progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                             completion:(void (^)(NSData*))completion;

+ (int32_t)fetchVideoFromPHAsset:(PHAsset *)phAsset
         judgeisNeedDownloadHandler:(void (^)(BOOL isDownloadFinish))judgeisNeedDownloadHandler
              progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
                   completion:(void (^)(AVAsset*))completion;


/// 获取类型
+ (MOAssetType)getAssetType:(PHAsset *)phAsset;


@end
