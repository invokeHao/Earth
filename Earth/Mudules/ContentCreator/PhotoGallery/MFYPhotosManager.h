//
//  MFYPhotosManager.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYPhotosManager.h"
#import "MFYAlbumModel.h"
#import "MFYAssetModel.h"

typedef NS_ENUM(NSInteger, CMSFilterAlbumsType) {
    CMSFilterAlbumsTypeNone      = 0, ///什么都不过滤
    CMSFilterAlbumsTypeVideo     = 1, ///过滤掉视频相册
    CMSFilterAlbumsTypeImage     = 2, ///过滤掉照片相册
};

typedef NS_ENUM(NSInteger, CMSAuthorizationStatus) {
    CMSAuthorizationStatusNotDetermined = 0,
    CMSAuthorizationStatusRestricted,
    CMSAuthorizationStatusDenied,
    CMSAuthorizationStatusAuthorized
};

typedef NS_ENUM(NSInteger, CMSAlbumsSelectedType) {
    CMSAlbumsSelectedTypePhoto = 0,
    CMSAlbumsSelectedTypeVideo,
    CMSAlbumsSelectedTypePhotoOnly,
    CMSAlbumsSelectedTypePhotoSingleSquare,
    CMSAlbumsSelectedTypeText
};

///照片最大选择个数1，视屏1
#define CMSMaxMediaSelectedCount ([CMSPhotosManager sharedManager].selectedAlbumsType == CMSAlbumsSelectedTypePhoto || \
[CMSPhotosManager sharedManager].selectedAlbumsType == CMSAlbumsSelectedTypePhotoOnly ? 1 : 1)

#define CMS_iOS9Before ([UIDevice currentDevice].systemVersion.floatValue <= 9.0f)
#define CMS_iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define CMS_iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)


NS_ASSUME_NONNULL_BEGIN

@interface MFYPhotosManager : NSObject

@property (nonatomic, strong) NSMutableArray <MFYAssetModel *> *selectedList;
@property (nonatomic, assign) CMSAlbumsSelectedType selectedAlbumsType;

+ (instancetype)sharedManager;

- (void)reset;

/**
 相册认证状态

 @return 相册认证结果
 */
- (CMSAuthorizationStatus)authorizationStatus;

/**
 请求访问用户相册

 @param handler 访问权限结果回调
 */
- (void)requestAuthorization:(void (^) (CMSAuthorizationStatus status))handler;

///取消
- (void)cancelImageRequest:(PHImageRequestID)requestID;

/**
 获取所有相册

 @param type 需要过滤的相册类型 默认不过滤
 @param completion 获取成功回调 主线程
 */
- (void)requestAllAlbumsWithFilterType:(CMSFilterAlbumsType)type
                            completion:(void (^)(NSArray <MFYAssetModel *> *albumModels))completion;


- (void)requestAllAssetModelForPHFetchResult:(PHFetchResult *)result
                                  completion:(void (^)(NSArray <MFYAssetModel *> *allAssets, NSArray <MFYAssetModel *> *photos, NSArray <MFYAssetModel *> *videos))completion;
/**
 获取UIImage
 
 @param asset 图片资源
 @param completion 获取成功回调 主线程
 @return PHImageRequestID
 */
- (PHImageRequestID)requestPhotoWithTargetSize:(CGSize)targetSize
                                         asset:(PHAsset *)asset
                                    resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                    completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;



+ (PHImageRequestID)requestHighQualitPhotoForPHAsset:(PHAsset *)asset
                                          targetSize:(CGSize)size
                                          completion:(void(^)(UIImage *image,NSDictionary *info))completion
                                               error:(void(^)(NSDictionary *info))error;
/**
 获取LivePhoto

 @param targetSize 目标Size
 @param asset PHAsset
 @param completion 获取成功回调 主线程
 @return PHImageRequestID
 */
- (PHImageRequestID)requestLivePhotoWithTargetSize:(CGSize)targetSize
                                             asset:(PHAsset *)asset
                                    completion:(void (^)(PHLivePhoto *livePhoto,NSDictionary *info))completion;

/**
 获取视频

 @param asset PHAsset
 @param completion 完成回调 sync main_queue
 @param progressHandler 如果视频不在本地，此block会回调
 @return PHImageRequestID 请求ID 可以用来取消
 */
- (PHImageRequestID)requestVideoWithAsset:(PHAsset *)asset
                               completion:(void (^) (AVPlayerItem *playerItem, NSDictionary *info))completion
                          progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;


- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset
                                completion:(void(^)(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info))completion;

/**
 获取ImageData
 
 @param asset 图片资源
 @param completion 获取成功回调 主线程
 @return PHImageRequestID
 */
- (PHImageRequestID)requestImageDataWithAsset:(PHAsset *)asset
                                   completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *assetInfo))completion;


- (NSString *)checkMaximumWithModel:(MFYAssetModel *)model limitMaxCount:(NSInteger )limitMaxCount;


@end

NS_ASSUME_NONNULL_END
