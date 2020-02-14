//
//  MFYAssetModel.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAssetModel.h"

@implementation MFYAssetModel

- (instancetype)init {
    if (self = [super init]) {
        self.selected = NO;
        self.isDownloadFinish = YES;
        _photoSerialnumber = -1;
        _vodeoSerialnumber = -1;
    }
    return self;
}

- (CGSize)imageSize {
//    if (self.type == CMSAssetMediaTypeOnlineGif || self.type == CMSAssetMediaTypeVideoTranformGif) {
//        return CGSizeMake(self.gifItem.width, self.gifItem.height);
//    }
    if (_imageSize.width == 0 || _imageSize.height == 0) {
        _imageSize = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
    }
    return _imageSize;
}

- (NSTimeInterval)videoDuration {
    return self.asset.duration;
}

- (CGFloat)fileSize {
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:self.asset] firstObject];
    long long size = [[resource valueForKey:@"fileSize"] longLongValue];
    CGFloat mSize = (CGFloat)size/(1024 *1024);
    return mSize;
}

- (void)getVideoCoverImageCompletion:(void (^)(UIImage * ))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(240, 320) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            completion(result);
        }
    }];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        MFYAssetModel *temp = (MFYAssetModel *)object;
        if (self.type == CMSAssetMediaTypeOnlineGif) {
//            return [self.gifItem.url isEqualToString:temp.gifItem.url];
            return YES;
        }else {
            return [self.asset.localIdentifier isEqualToString:temp.asset.localIdentifier];
        }
    }
    return NO;
}

@end
