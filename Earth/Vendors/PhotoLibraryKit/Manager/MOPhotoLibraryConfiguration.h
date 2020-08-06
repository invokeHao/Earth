//
//  MOPhotoLibraryConfiguration.h
//  PhotoLibraryKit
//
//  Created by 黑眼圈 on 2018/6/10.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MOAlbumType) {
    MOAlbumTypSmartAlbumUserLibrary = 1 << 0,
    MOAlbumTypSmartAlbumRecentlyAdded = 1 << 1,
    MOAlbumTypSmartAlbumFavorites = 1 << 2,
    MOAlbumTypSmartAlbumVideos = 1 << 3,
    MOAlbumTypAlbumAny = 1 << 4
};

typedef NS_ENUM(NSInteger, MOAssetType) {
    MOAssetTypePhoto = 1 << 0,
    MOAssetTypeGif = 1 << 1,
    MOAssetTypeVideo = 1 << 2,
    
    MOAssetTypeOnlineGif = 1 << 3, // 线上的gif
    MOAssetTypeVideoTranformGif = 1 << 4, // 视频转换的gif
};

@interface MOPhotoLibraryConfiguration : NSObject

@property (nonatomic, assign) MOAlbumType albumType;
@property (nonatomic, assign) MOAssetType assetType;

@property (nonatomic, assign) NSInteger maxSelectedCount;

@end



