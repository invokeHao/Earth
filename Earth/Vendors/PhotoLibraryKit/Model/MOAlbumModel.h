//
//  MOAlbumModel.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//
//
//  ---相册实体类---

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MOAssetModel.h"

@interface MOAlbumModel : NSObject

@property (nonatomic, strong, readonly) PHAssetCollection *collection;
@property (nonatomic, copy) NSArray<MOAssetModel*> *assetModelList;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger count;

@property (nonatomic, copy, readonly) NSArray *selectedModels;
@property (nonatomic, assign, readonly) NSUInteger selectedCount;

- (instancetype)initWithAssetCollection:(PHAssetCollection*)collection;

@end
