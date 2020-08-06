//
//  MOPhotoLibraryConfiguration.m
//  PhotoLibraryKit
//
//  Created by 黑眼圈 on 2018/6/10.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoLibraryConfiguration.h"

@implementation MOPhotoLibraryConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSelectedCount = 1;
        self.assetType = MOAssetTypeGif | MOAssetTypePhoto | MOAssetTypeVideo;
        self.albumType = MOAlbumTypSmartAlbumUserLibrary | MOAlbumTypSmartAlbumRecentlyAdded
        | MOAlbumTypSmartAlbumFavorites | MOAlbumTypSmartAlbumVideos | MOAlbumTypAlbumAny;
    }
    return self;
}

@end
