//
//  MFYPhotosManager.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPhotosManager.h"

@interface MFYPhotosManager ()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation MFYPhotosManager

+ (instancetype)sharedManager {
    static MFYPhotosManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MFYPhotosManager alloc] init];
        instance.selectedList = [NSMutableArray array];
        instance.lock = [NSLock new];
    });
    return instance;
}

- (void)reset {
    [self.selectedList removeAllObjects];
}

#pragma mark -
- (CMSAuthorizationStatus)authorizationStatus {
    return (CMSAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

- (void)requestAuthorization:(void (^)(CMSAuthorizationStatus))handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !handler ? : handler((CMSAuthorizationStatus)status);
            });
        }];
    });
}

- (void)cancelImageRequest:(PHImageRequestID)requestID {
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

#pragma mark -
- (void)requestAllAlbumsWithFilterType:(CMSFilterAlbumsType)type
                            completion:(void (^)(NSArray<MFYAlbumModel *> *))completion {
    //我的照片流
    PHFetchResult *myPhotostreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    //智能相册(相机胶卷，最近删除，最近添加，自拍，Videos.edg.)
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //An album synced to the device from iPhoto
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    
    NSMutableArray *allAlbums = [NSMutableArray array];
    NSArray *albums = @[smartAlbums, myPhotostreamAlbum, topLevelUserCollections, syncedAlbums];
    [albums enumerateObjectsUsingBlock:^(PHFetchResult *obj, NSUInteger idx, BOOL * stop) {
        [obj enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                // 是否按创建时间排序
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                switch (type) {
                    case CMSFilterAlbumsTypeNone:
                        break;
                    case CMSFilterAlbumsTypeImage:
                        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
                        break;
                    case CMSFilterAlbumsTypeVideo:
                        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                        break;
                }
                
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
                NSString *name = [MFYPhotosManager transformPhotoTitle:collection.localizedTitle];
                if (fetchResult.count > 0) {//过滤空相册
                    if (![name isEqualToString:@"最近删除"]) {
                        MFYAlbumModel *albumsModel = [MFYAlbumModel new];
                        albumsModel.localizedTitle = collection.localizedTitle;
                        albumsModel.name = name;
                        albumsModel.fetchResult = fetchResult;
                        if ([albumsModel.name isEqualToString:@"相机胶卷"] || [albumsModel.name isEqualToString:@"所有照片"]) {
                            [allAlbums insertObject:albumsModel atIndex:0];
                        } else {
                            [allAlbums addObject:albumsModel];
                        }
                    }
                }
            }
        }];
    }];
    if (completion && allAlbums.count > 0) {
        completion(allAlbums);
    }
}

- (void)requestAllAssetModelForPHFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray<MFYAssetModel *> *, NSArray<MFYAssetModel *> *, NSArray<MFYAssetModel *> *))completion {
    NSMutableArray *assetModels = [NSMutableArray arrayWithCapacity:result.count];
    NSMutableArray *photoModels = [NSMutableArray array];
    NSMutableArray *videoModels = [NSMutableArray array];
    [WHHud showActivityView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            MFYAssetModel *model = [MFYAssetModel new];
            [self.lock lock];
            model.asset = asset;
            [self.lock unlock];
            switch (asset.mediaType) {
                case PHAssetMediaTypeImage: {
                    if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                        [self.lock lock];
                        model.type = CMSAssetMediaTypeGif;
                        [self.lock unlock];
                    }
                    if (CMS_iOS9Later) {
                        if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
                            [self.lock lock];
                            model.type = CMSAssetMediaTypeLivePhoto;
                            [self.lock unlock];
                        }
                    }
                    [self.lock lock];
                    [photoModels addObject:model];
                    [assetModels addObject:model];
                    [self.lock unlock];
                }
                    break;
                case PHAssetMediaTypeVideo: {
                    [self.lock lock];
                    model.type = CMSAssetMediaTypeVideo;
                    [self.lock unlock];
                    [self requestAVAssetForVideo:asset completion:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                        model.avAsset = asset;
                    }];
                    [self.lock lock];
                    [videoModels addObject:model];
                    [assetModels addObject:model];
                    [self.lock unlock];
                }
                    break;
                case PHAssetMediaTypeAudio: {
                    [self.lock lock];
                    model.type = CMSAssetMediaTypeAudio;
                    [self.lock unlock];
                }
                    break;
                default:
                    break;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [WHHud showActivityView];
            !completion ? : completion(assetModels, photoModels, videoModels);
        });
    });
}

#pragma mark - Photo
- (PHImageRequestID)requestPhotoWithTargetSize:(CGSize)targetSize
                                         asset:(PHAsset *)asset
                                    resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                    completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
    }];
}

+ (PHImageRequestID)requestHighQualitPhotoForPHAsset:(PHAsset *)asset targetSize:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion error:(void(^)(NSDictionary *info))error {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(result,info);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    error(info);
                }
            });
        }
    }];
    return requestID;
}

#pragma mark - LivePhoto
- (PHImageRequestID)requestLivePhotoWithTargetSize:(CGSize)targetSize asset:(PHAsset *)asset completion:(void (^)(PHLivePhoto *, NSDictionary *))completion {
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.networkAccessAllowed = YES;
    
    return [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHLivePhotoInfoCancelledKey] boolValue] && ![[info objectForKey:PHLivePhotoInfoErrorKey] boolValue]);
        if (downloadFinined && completion && livePhoto) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(livePhoto,info);
            });
        }
    }];
}

#pragma mark - Video
- (PHImageRequestID)requestVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion progressHandler:(void (^)(double, NSError *, BOOL *, NSDictionary *))progressHandler {
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.progressHandler = progressHandler;
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? : completion(playerItem, info);
        });
    }];
}

- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset completion:(void (^)(AVAsset *, AVAudioMix *, NSDictionary *))completion {
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? : completion(asset, audioMix, info);
        });
    }];
}

#pragma mark - ImageData
- (PHImageRequestID)requestImageDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *assetInfo))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinished = ![info[PHImageCancelledKey] boolValue] && ![info[PHImageErrorKey] boolValue];
        if (downloadFinished) {
            !completion ? : completion(imageData, dataUTI, orientation, info);
        }
    }];
}

#pragma mark - private
- (MFYAssetModel *)assetModelWithAsset:(PHAsset *)asset {
    CMSAssetMediaType type = CMSAssetMediaTypePhoto;
    MFYAssetModel *model = [MFYAssetModel new];
    switch (asset.mediaType) {
        case PHAssetMediaTypeImage: {
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                type = CMSAssetMediaTypeGif;
            }
        }
            break;
        case PHAssetMediaTypeVideo: {
            type = CMSAssetMediaTypeVideo;
            [self requestAVAssetForVideo:asset completion:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                model.avAsset = asset;
            }];
        }
            break;
        case PHAssetMediaTypeAudio:
            type = CMSAssetMediaTypeAudio;
            break;
        default:
            break;
    }
    if (CMS_iOS9Later) {
        if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
            type = CMSAssetMediaTypeLivePhoto;
        }
    }
    model.type = type;
    model.asset = asset;
    return model;
}

+ (NSString *)transformPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"]){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"]){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"]){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"]){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"]){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"]){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"]){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"]){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"]){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"]){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}


- (NSString *)checkMaximumWithModel:(MFYAssetModel *)model limitMaxCount:(NSInteger )limitMaxCount {
    NSInteger limitCount = limitMaxCount;
    if ([MFYPhotosManager sharedManager].selectedList.count >= limitCount) {
        return [NSString stringWithFormat:@"最多只能选择%@张图片",@(limitCount)];
    }
    if (model.type == CMSAssetMediaTypeVideo) {
        //视频时长需要在10秒到30min之间，视频大小500k到100m
//        if (model.videoDuration < 10 || model.videoDuration >= 30 * 60) { //小于10秒
//            return @"视频时长在10秒到30分钟之间，且大小不超过100M的视频才可以上传哦╮(╯▽╰)╭";
//        }
    } else if (model.type == CMSAssetMediaTypePhoto || model.type == CMSAssetMediaTypeLivePhoto || model.type == CMSAssetMediaTypeGif) {
        if (model.asset.representsBurst) {
            return @"不支持连拍的照片格式";
        }
        //照片大小在200像素到20m之间
        if (model.asset.pixelWidth < 200 || model.asset.pixelHeight < 200) {
            return @"请上传宽和高≥200px的图片";
        }
        __block NSString *toast;
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:model.asset] firstObject];
        long long originFileSize = [[resource valueForKey:@"fileSize"] longLongValue];
        int fileSize = (int)originFileSize;
        if (model.type == CMSAssetMediaTypeGif) {
            if (fileSize > 2 * 1024 * 1024) {
                toast = @"素材需小于2M";
            }
        }
        if (model.type == CMSAssetMediaTypePhoto || model.type == CMSAssetMediaTypeLivePhoto) {
            if (fileSize > 20 * 1024 * 1024) {
                toast = @"请上传＜20M的图片";
            }
        }
        return toast;
    }
    return nil;
}


@end
