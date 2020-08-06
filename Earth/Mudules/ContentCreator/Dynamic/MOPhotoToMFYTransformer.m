//
//  MOPhotoToMFYTransformer.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MOPhotoToMFYTransformer.h"

@implementation MOPhotoToMFYTransformer

+ (NSArray<MFYAssetModel *> *)wh_assetListTransformer:(NSArray<MOAssetModel *> *)list {
    NSMutableArray<MFYAssetModel *> *mutableArray = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MFYAssetModel *model = [[MFYAssetModel alloc] init];
        model.asset = obj.phAsset;
        model.thumbImage = obj.thumbImage;
        model.photoSerialnumber = obj.serialNumber;
        model.selected = obj.selected;
        model.videoTransformGifAssetModel = obj.videoTransformGifAssetModel;
        switch (obj.type) {
            case MOAssetTypePhoto:
                model.type = CMSAssetMediaTypePhoto;
                break;
            case MOAssetTypeGif:
                model.type = CMSAssetMediaTypeGif;
                break;
            case MOAssetTypeVideo:
                model.type = CMSAssetMediaTypeVideo;
                break;
            case MOAssetTypeOnlineGif:
                model.type = CMSAssetMediaTypeOnlineGif;
                break;
            case MOAssetTypeVideoTranformGif:
                model.type = CMSAssetMediaTypeVideoTranformGif;
                break;
            default:
                break;
        }
        [mutableArray addObject:model];
    }];
    return [mutableArray copy];
}

+ (NSArray<MOAssetModel *> *)assetListTransformer:(NSArray<MFYAssetModel *> *)list {
    NSMutableArray<MOAssetModel *> *mutableArray = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(MFYAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MOAssetModel *model = [[MOAssetModel alloc] init];
        model.phAsset = obj.asset;
        model.thumbImage = obj.thumbImage;
        model.serialNumber = obj.photoSerialnumber;
        model.selected = obj.selected;
        model.videoTransformGifAssetModel = obj.videoTransformGifAssetModel;
        switch (obj.type) {
            case CMSAssetMediaTypePhoto:
                model.type = MOAssetTypePhoto;
                break;
            case CMSAssetMediaTypeGif:
                model.type = MOAssetTypeGif;
                break;
            case CMSAssetMediaTypeVideo:
                model.type = MOAssetTypeVideo;
                break;
            case CMSAssetMediaTypeOnlineGif:
                model.type = MOAssetTypeOnlineGif;
                break;
            case CMSAssetMediaTypeVideoTranformGif:
                model.type = MOAssetTypeVideoTranformGif;
                break;
            default:
                break;
        }
        [mutableArray addObject:model];
    }];
    return [mutableArray copy];
}


+ (MFYAssetModel *)wh_assetTransformer:(MOAssetModel *)data {
    MFYAssetModel *model = [[MFYAssetModel alloc] init];
    model.asset = data.phAsset;
    model.thumbImage = data.thumbImage;
    model.photoSerialnumber = data.serialNumber;
    model.selected = data.selected;
    model.videoTransformGifAssetModel = data.videoTransformGifAssetModel;
    switch (data.type) {
        case MOAssetTypePhoto:
            model.type = CMSAssetMediaTypePhoto;
            break;
        case MOAssetTypeGif:
            model.type = CMSAssetMediaTypeGif;
            break;
        case MOAssetTypeVideo:
            model.type = CMSAssetMediaTypeVideo;
            break;
        case MOAssetTypeOnlineGif:
            model.type = CMSAssetMediaTypeOnlineGif;
            break;
        case MOAssetTypeVideoTranformGif:
            model.type = CMSAssetMediaTypeVideoTranformGif;
            break;
        default:
            break;
    }
    return model;
}

+ (MOAssetModel *)assetTransformer:(MFYAssetModel *)data {
    MOAssetModel *model = [[MOAssetModel alloc] init];
    model.phAsset = data.asset;
    model.thumbImage = data.thumbImage;
    model.serialNumber = data.photoSerialnumber;
    model.selected = data.selected;
    model.videoTransformGifAssetModel = data.videoTransformGifAssetModel;
    switch (data.type) {
        case CMSAssetMediaTypePhoto:
            model.type = MOAssetTypePhoto;
            break;
        case CMSAssetMediaTypeGif:
            model.type = MOAssetTypeGif;
            break;
        case CMSAssetMediaTypeVideo:
            model.type = MOAssetTypeVideo;
            break;
        case CMSAssetMediaTypeOnlineGif:
            model.type = MOAssetTypeOnlineGif;
            break;
        case CMSAssetMediaTypeVideoTranformGif:
            model.type = MOAssetTypeVideoTranformGif;
            break;
        default:
            break;
    }
    return model;
}


@end
