//
//  MFYAlbumModel.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>


NS_ASSUME_NONNULL_BEGIN

@interface MFYAlbumModel : NSObject

///相册名
@property (nonatomic, strong) NSString *name;

///相册名 English
@property (nonatomic, strong) NSString *localizedTitle;

///相册图片集合
@property (nonatomic, strong) PHFetchResult <PHAsset *> *fetchResult;

@property (nonatomic, strong) NSData *imageData;

///相册图片个数
@property (nonatomic, assign) uint64_t count;

///选中的个数
@property (nonatomic, assign) NSInteger selectCount;

@end

NS_ASSUME_NONNULL_END
