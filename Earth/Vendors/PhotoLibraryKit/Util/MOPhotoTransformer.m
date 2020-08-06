//
//  MOPhotoTransformer.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoTransformer.h"

@implementation MOPhotoTransformer

+ (NSArray<MOAlbumModel *> *)collectionTransformer:(NSArray<PHAssetCollection *> *)list {
    NSMutableArray<MOAlbumModel *> *mutableArray = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MOAlbumModel *albumModel = [[MOAlbumModel alloc] initWithAssetCollection:obj];
        [mutableArray addObject:albumModel];
    }];
    return [mutableArray copy];
}

+ (NSArray<MOAssetModel *> *)assetTransformer:(NSArray<PHAsset *> *)list {
    NSMutableArray<MOAssetModel *> *mutableArray = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MOAssetModel *assetModel = [[MOAssetModel alloc] init];
        assetModel.type = [MOPhotoUtil getAssetType:obj];
        assetModel.phAsset = obj;
        [mutableArray addObject:assetModel];
    }];
    return [mutableArray copy];
}

@end
