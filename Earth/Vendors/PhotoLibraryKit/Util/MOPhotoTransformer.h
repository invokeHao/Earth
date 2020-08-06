//
//  MOPhotoTransformer.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MOAlbumModel.h"
#import "MOAssetModel.h"

@interface MOPhotoTransformer : NSObject

+ (NSArray<MOAlbumModel *> *)collectionTransformer:(NSArray<PHAssetCollection *> *)list;
+ (NSArray<MOAssetModel *> *)assetTransformer:(NSArray<PHAsset *> *)list;

@end
