//
//  MOAssetDownloadManager.h
//  PhotoLibraryKit
//
//  Created by 黑眼圈 on 2018/6/10.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOAssetModel.h"

// notifications
extern NSString * const MOAssetDownloadWillDownloadNotification;
extern NSString * const MOAssetDownloadDidFinishDownloadNotification;
extern NSString * const MOAssetDownloadProgressNotification;
extern NSString * const MOAssetIsNeedDownloadNotification;


@interface MOAssetDownloadManager : NSObject

+ (instancetype)sharedManager;

- (void)startDownloadTaskWithAsset:(MOAssetModel *)assetModel;

- (void)cancelImageRequest:(MOAssetModel *)assetModel;
- (void)cancelAllImageRequest;

- (void)reset;

@end
