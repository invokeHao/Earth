//
//  MFYPublicManager.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublicManager.h"
#import "MOPhotoLibraryConfiguration.h"
#import "MOPhotoLibraryController.h"
#import "MFYBaseNavigationController.h"
#import "MFYPhotosManager.h"
#import "MOPhotoToMFYTransformer.h"
#import "MFYPhotoCropVC.h"
#import "MOPhotoLibraryManager.h"
#import "MOAssetDownloadManager.h"
#import "MODownloadNotificationModel.h"


@interface MFYPublicManager()<MOPhotoLibraryControllerDelegate, MOPhotoLibraryControllerDataSource>

@property (nonatomic, strong) MFYAssetModel *singleVideoModel;

@end

@implementation MFYPublicManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoIsNeedDownloadNotification:) name:MOAssetIsNeedDownloadNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)publishPhotoFromVC:(UIViewController *)viewController publishType:(MFYPublicType)publishType completion:(nonnull successBlock)completion{
    self.successB = completion;
    if (!viewController) {
        WHLogError(@"No Present viewController specify!");
        return;
    }
    self.fromViewController = viewController;
    self.publishType = publishType;
    switch (publishType) {
            
        case mfyPublicTypeNull:{
            MOPhotoLibraryConfiguration *configuration = [[MOPhotoLibraryConfiguration alloc] init];
             configuration.assetType = MOAssetTypePhoto | MOAssetTypeVideo;
             configuration.maxSelectedCount = 1;
             MOPhotoLibraryController *picker = [[MOPhotoLibraryController alloc] initWithPhotoLibraryConfiguration:configuration];
             picker.delegate = self;
             picker.dataSource = self;
             @weakify(self);
             [picker setDismissBlock:^{
                 
             }];
             MFYBaseNavigationController *nav = [[MFYBaseNavigationController alloc] initWithRootViewController:picker];
             nav.navigationBar.translucent = NO;
             [[MFYPhotosManager sharedManager] setSelectedAlbumsType:CMSAlbumsSelectedTypePhoto];
             [viewController presentViewController:nav animated:YES completion:NULL];
        }
            break;
        case MFYPublicTypeImage: {
            MOPhotoLibraryConfiguration *configuration = [[MOPhotoLibraryConfiguration alloc] init];
            configuration.assetType = MOAssetTypePhoto | MOAssetTypeGif;
            configuration.maxSelectedCount = 1;
            MOPhotoLibraryController *picker = [[MOPhotoLibraryController alloc] initWithPhotoLibraryConfiguration:configuration];
            picker.delegate = self;
            picker.dataSource = self;
            @weakify(self);
            [picker setDismissBlock:^{
                
            }];
            MFYBaseNavigationController *nav = [[MFYBaseNavigationController alloc] initWithRootViewController:picker];
            nav.navigationBar.translucent = NO;
            [[MFYPhotosManager sharedManager] setSelectedAlbumsType:CMSAlbumsSelectedTypePhoto];
            [viewController presentViewController:nav animated:YES completion:NULL];
        }
            break;
        case MFYPublicTypeVideo: {
            MOPhotoLibraryConfiguration *configuration = [[MOPhotoLibraryConfiguration alloc] init];
            configuration.albumType = MOAlbumTypSmartAlbumVideos;
            configuration.assetType = MOAssetTypeVideo;
            configuration.maxSelectedCount = 1;
            MOPhotoLibraryController *picker = [[MOPhotoLibraryController alloc] initWithPhotoLibraryConfiguration:configuration];
            picker.delegate = self;
            @weakify(self);
            [picker setDismissBlock:^{
                
            }];
            MFYBaseNavigationController *nav = [[MFYBaseNavigationController alloc] initWithRootViewController:picker];
            nav.navigationBar.translucent = NO;
            [[MFYPhotosManager sharedManager] setSelectedAlbumsType:CMSAlbumsSelectedTypeVideo];
            [viewController presentViewController:nav animated:YES completion:NULL];
        }
            break;

        default:
            break;
    }
}

//- (void)publishPhotoFromVC:(UIViewController *)viewController publishType:(MFYPublicType)publishType topicId:(nonnull NSString *)topicId {
//
//}

#pragma mark - Privates

//- (void)pushToSearchGifVC {
//    NSArray<MOAssetModel *> *assetList = [MOPhotoLibraryManager sharedManager].selectedList;
//    NSArray<MFYAssetModel *> *cmsAssetList = [MOPhotoToCMSTransformer cms_assetListTransformer:assetList];
//    [MFYPhotosManager sharedManager].selectedList = [cmsAssetList mutableCopy];
//
//    MOPhotoLibraryController *picker = (MOPhotoLibraryController *)[CMSAlertTool WHTopViewController];
//    CMSSearchGifViewController *searchGifVC = [[CMSSearchGifViewController alloc] init];
//    searchGifVC.selectedAction = ^ (MFYAssetModel *model) {
//        for (MFYAssetModel *x in [MFYPhotosManager sharedManager].selectedList) {
//            if (x.type == CMSAssetMediaTypeOnlineGif) {
//                if (x.gifItem) {
//                    if ([x.gifItem.url isEqualToString:model.gifItem.url]) {
//                        return;
//                    }
//                }
//            }
//        }
//        [[MFYPhotosManager sharedManager].selectedList addObject:model];
//        model.photoSerialnumber = [MFYPhotosManager sharedManager].selectedList.count;
//
//        MOAssetModel *assetModel = [MOPhotoToCMSTransformer assetTransformer:model];
//        if (![picker.dataList containsObject:assetModel]) {
//            [picker addItem:assetModel];
//        }
//
//        NSArray<MFYAssetModel *> *selectedAssetList = [MFYPhotosManager sharedManager].selectedList;
//        NSArray<MOAssetModel *> *photos = [MOPhotoToCMSTransformer assetListTransformer:selectedAssetList];
//        [MOPhotoLibraryManager sharedManager].selectedList = [photos mutableCopy];
//        [picker loadWithSelectedData];
//    };
//    [picker.navigationController pushViewController:searchGifVC animated:YES];
//}

//- (void)pushToVideoEditVC:(MFYAssetModel *)model {
//    MOPhotoLibraryController *picker = (MOPhotoLibraryController *)[CMSAlertTool WHTopViewController];
//    CMSVideoEditViewController *videoEditVC = [[CMSVideoEditViewController alloc] initWithEditType:CMSVideoEditTypeClipVideo];
//    videoEditVC.asset = model.asset;
//    [picker.navigationController pushViewController:videoEditVC animated:YES];
//}

#pragma mark - notification

- (void)videoIsNeedDownloadNotification:(NSNotification *)notification {
    MODownloadNotificationModel *notificationModel = [MODownloadNotificationModel yy_modelWithDictionary:notification.userInfo];
    if ([notificationModel.identifier isEqualToString:self.singleVideoModel.asset.localIdentifier]) {
        if (notificationModel.isNeedDownload) {
            [WHHud showString:@"正在下载iCloud视频,请稍后..."];
        } else {
            if (self.singleVideoModel.fileSize > 40) {
//                [self pushToVideoEditVC:self.singleVideoModel];
                [WHHud showString:@"视频超过40M，请重新选择"];
            } else {
                WHLogSuccess(@"40M内视频");
                if (self.successB) {
                    self.successB(self.singleVideoModel);
                }
                [[WHAlertTool WHTopViewController] dismissViewControllerAnimated:YES completion:NULL];
//                CMSPublishViewController *publishPhotoVC = [[CMSPublishViewController alloc] initWithModels:@[self.singleVideoModel]];
//                MFYBaseNavigationController *nav = [[MFYBaseNavigationController alloc] initWithRootViewController:publishPhotoVC];
//                if (self.fromViewController.presentedViewController) {
//                    @weakify(self);
//                    [self.fromViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
//                        @strongify(self);
//                        [self.fromViewController presentViewController:nav animated:YES completion:nil];
//                    }];
//                } else {
//                    [self.fromViewController presentViewController:nav animated:YES completion:nil];
//                }
            }
        }
    }
}

#pragma mark - MOPhotoLibraryControllerDelegate

- (void)photoLibraryController:(MOPhotoLibraryController *)picker
        didFinishPickingPhotos:(NSArray<YYImage *> *)photos
                  sourceAssets:(NSArray<MOAssetModel *> *)assetList {
    
    NSArray<MFYAssetModel *> *mfyAssetList = [MOPhotoToMFYTransformer wh_assetListTransformer:assetList];
    [MFYPhotosManager sharedManager].selectedList = [mfyAssetList mutableCopy];
    MFYAssetModel * asset = [mfyAssetList firstObject];
    if (self.publishType == MFYPublicTypeChat) {
        if (self.successB) {
            self.successB(asset);
        }
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }else {
        MFYCropType type = self.publishType == mfyPublicTypeNull ? MFYImageCardType : MFYUserIconType;
        MFYPhotoCropVC * cropVC = [[MFYPhotoCropVC alloc]initWithModel:asset cropType:type didCropedImage:^(MFYAssetModel * _Nonnull asset) {
            WHLog(@"裁切成功");
            if (self.successB) {
                self.successB(asset);
            }
        }];
        [picker dismissViewControllerAnimated:NO completion:^{
            [self.fromViewController presentViewController:cropVC animated:YES completion:^{
            }];
        }];
    }
}

- (void)photoLibraryController:(MOPhotoLibraryController *)picker didFinishVideoAssets:(MOAssetModel *)asset {
    self.singleVideoModel = [MOPhotoToMFYTransformer wh_assetTransformer:asset];
    WHLog(@"视频%@",self.singleVideoModel);
    if (!asset.isDownloadFinish) {
        [WHHud showString:@"正在下载iCloud视频,请稍后..."];
    }
}


@end
