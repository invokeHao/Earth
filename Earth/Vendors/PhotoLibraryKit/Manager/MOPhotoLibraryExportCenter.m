//
//  MOPhotoLibraryExportCenter.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/11.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoLibraryExportCenter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MOPhotoLibraryManager.h"
#import "MOPhotoUtil.h"
#import "MOMacro.h"

@interface MOPhotoLibraryExportCenter ()

@property (nonatomic, strong) NSMutableArray<YYImage *> *photos;

@end

@implementation MOPhotoLibraryExportCenter

- (void)exportPhotoLibrary:(void (^)(NSArray<YYImage *> *))completion {
    
    self.photos = [NSMutableArray array];
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.photos addObject:[YYImage new]];
    }];
    dispatch_group_t group = dispatch_group_create();
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != MOAssetTypeOnlineGif) {
            dispatch_group_enter(group);
            @weakify(self)
            [self exportAssetModel:obj completion:^(YYImage *image) {
                @strongify(self)
                self.photos[idx] = image;
                dispatch_group_leave(group);
            }];
        }
    }];
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self.photos copy]);
        });
    });
}

- (void)exportAssetModel:(MOAssetModel *)assetModel
              completion:(void (^)(YYImage*))completion {
    
    if (assetModel.type == MOAssetTypeGif) {
        [MOPhotoUtil fetchOriginalPhotoDataWithAsset:assetModel.phAsset progressHandler:nil completion:^(NSData *imageData) {
            YYImage *yyImage = [YYImage imageWithData:imageData];
            completion(yyImage);
        }];
    }else {
        [MOPhotoUtil fetchImageFromPHAsset:assetModel.phAsset size:CGSizeMake(High_PHOTOWIDTH, High_PHOTOWIDTH*assetModel.aspectRatio) progressHandler:nil completion:^(UIImage *image) {
            YYImage *yyImage = (YYImage*)image;
            completion(yyImage);
        }];
    }
}



@end






