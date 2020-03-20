//
//  MOPhotoLibraryController.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YYImage.h"
#import "MOAssetModel.h"
#import "MOPhotoLibraryConfiguration.h"


@class MOPhotoLibraryController;

@protocol MOPhotoLibraryControllerDataSource <NSObject>

@optional
// 注入头部视图
- (UIView *)photoLibraryControllerAddHeaderView:(MOPhotoLibraryController *)picker;

@end

@protocol MOPhotoLibraryControllerDelegate <NSObject>

@optional

//拿到照片的回调代理
- (void)photoLibraryController:(MOPhotoLibraryController *)picker
        didFinishPickingPhotos:(NSArray<YYImage *> *)photos
                  sourceAssets:(NSArray<MOAssetModel *> *)assetList;

// 如果用户选择了一个视频，下面的handle会被执行
- (void)photoLibraryController:(MOPhotoLibraryController *)picker
          didFinishVideoAssets:(MOAssetModel *)asset;

// 选择视频去转GIF
- (void)photoLibraryController:(MOPhotoLibraryController *)picker
     didFinishVideoTranformGif:(MOAssetModel *)asset;

// 预览
- (void)photoLibraryController:(MOPhotoLibraryController *)picker
          didPreviewWithAssets:(NSArray<MOAssetModel *> *)assetList
            selectedAssetModel:(MOAssetModel *)assetModel;

// 是否可以选中(单个元素)
- (BOOL)photoLibraryController:(MOPhotoLibraryController *)picker
                canDidSelected:(MOAssetModel *)assetModel;

//拍照业务

- (void)takePhotoController:(MOPhotoLibraryController *)picker
     didFinishPickingPhoto:(UIImage*)photo;

- (void)takeVedioController:(MOPhotoLibraryController *)picker
      didFinishPickingVideo:(NSString *)filePath;   


@end

@interface MOPhotoLibraryController : UIViewController

@property (nonatomic, weak) id<MOPhotoLibraryControllerDelegate> delegate;
@property (nonatomic, weak) id<MOPhotoLibraryControllerDataSource> dataSource;
@property (nonatomic, copy, readonly) NSArray<MOAssetModel *> *dataList;

@property (nonatomic, copy) void(^dismissBlock)(void);


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (instancetype)initWithPhotoLibraryConfiguration:(MOPhotoLibraryConfiguration *)configuration;

- (void)loadWithSelectedData;
- (void)addItem:(MOAssetModel *)item;

@end





