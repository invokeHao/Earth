//
//  MOAssetModel.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//
//
//  ---资源实体类---

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <YYImage.h>
#import "MOPhotoUtil.h"
#import "MFYAssetModel.h"


@interface MOAssetModel : NSObject

@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, assign) MOAssetType type;
@property (nonatomic, assign) BOOL selected;

// 宽高比
@property (nonatomic, assign, readonly) CGFloat aspectRatio;

// 资源的唯一标识
@property (nonatomic, copy, readonly) NSString *identifier;

// 是否下载完成
@property (nonatomic, assign) BOOL isDownloadFinish;
@property (nonatomic, assign) double progress;

// 缩略图
@property (nonatomic, strong) UIImage *thumbImage;

///选中的序号
@property (nonatomic, assign) NSInteger serialNumber;

// 视频转换的gif资源
@property (nonatomic, strong) MFYAssetModel *videoTransformGifAssetModel;



@end
