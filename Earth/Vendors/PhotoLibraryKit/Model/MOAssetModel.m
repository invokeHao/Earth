//
//  MOAssetModel.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOAssetModel.h"

@implementation MOAssetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDownloadFinish = YES;
    }
    return self;
}

- (CGFloat)aspectRatio {
    return (CGFloat)self.phAsset.pixelHeight / (CGFloat)self.phAsset.pixelWidth;
}

- (NSString *)identifier {
    return self.phAsset.localIdentifier;
}


- (BOOL)isEqual:(MOAssetModel *)object {
    if (self.type == MOAssetTypeOnlineGif) {
//        return [self.gifItem.url isEqualToString:object.gifItem.url];
        return  YES;
    }else {
        return [self.identifier isEqualToString:object.identifier];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    MOAssetModel * model = [[MOAssetModel allocWithZone:zone] init];
    model.phAsset = self.phAsset;
    model.type = self.type;
    model.selected = self.selected;
    model.thumbImage = self.thumbImage;
    model.serialNumber = self.serialNumber;
    return model;
}


@end
