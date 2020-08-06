//
//  MOPhotoToMFYTransformer.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOAssetModel.h"
#import "MFYAssetModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MOPhotoToMFYTransformer : NSObject

+ (NSArray<MFYAssetModel *> *)wh_assetListTransformer:(NSArray<MOAssetModel *> *)list;
+ (NSArray<MOAssetModel *> *)assetListTransformer:(NSArray<MFYAssetModel *> *)list;

+ (MFYAssetModel *)wh_assetTransformer:(MOAssetModel *)data;
+ (MOAssetModel *)assetTransformer:(MFYAssetModel *)data;

@end

NS_ASSUME_NONNULL_END
