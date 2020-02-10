//
//  MOAlbumModel.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOAlbumModel.h"
#import "MOPhotoUtil.h"

@interface MOAlbumModel()

@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;

@end

@implementation MOAlbumModel

- (instancetype)initWithAssetCollection:(PHAssetCollection*)collection
{
    self = [super init];
    if (self) {
        [self fetchData:collection];
    }
    return self;
}

- (void)fetchData:(PHAssetCollection*)collection {
    self.name = collection.localizedTitle;
    self.collection = collection;
}

- (NSInteger)count {
    return self.assetModelList.count;
}

- (NSArray *)selectedModels {
    NSMutableArray *arrM = [NSMutableArray array];
    [self.assetModelList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            [arrM addObject:obj];
        }
    }];
    return [arrM copy];
}

- (NSUInteger)selectedCount {
    return self.selectedModels.count;
}



@end




