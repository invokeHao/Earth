//
//  MFYAssetModel.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


typedef NS_ENUM(NSInteger, CMSAssetMediaType) {
    CMSAssetMediaTypePhoto = 0,
    CMSAssetMediaTypeLivePhoto,
    CMSAssetMediaTypeGif,
    CMSAssetMediaTypeVideo,
    CMSAssetMediaTypeAudio,
    CMSAssetMediaTypeOnlineGif, // 线上的gif
    CMSAssetMediaTypeVideoTranformGif, // 视频转换的gif
    CMSAssetMediaTypeEditVideo // 裁剪视频
};


NS_ASSUME_NONNULL_BEGIN

@interface MFYAssetModel : NSObject


@property (nonatomic, strong) MFYAssetModel *videoTransformGifAssetModel;

@property (nonatomic, strong) PHAsset *asset;

/// 图片宽高
@property (assign, nonatomic) CGSize imageSize;

///缩略图
@property (strong, nonatomic) UIImage *thumbImage;

///裁剪图
@property (strong, nonatomic) UIImage *resizeImage;

// 大图
@property (strong, nonatomic) UIImage *highImage;
@property (strong, nonatomic) NSData *imageData;

///
@property (strong, nonatomic) AVAsset *avAsset;

/// avAsset的path
@property (nonatomic, strong) NSString *videoPath;

///video时长
@property (nonatomic, assign, readonly) NSTimeInterval videoDuration;

/**media type*/
@property (nonatomic, assign) CMSAssetMediaType type;

///是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;

///选中的序号 默认是-1表示没选中
@property (nonatomic, assign) NSInteger photoSerialnumber;

///选中的序号 默认是-1表示没选中 视频
@property (nonatomic, assign) NSInteger vodeoSerialnumber;

// 是否下载完成
@property (nonatomic, assign) BOOL isDownloadFinish;
@property (nonatomic, assign) double progress;

@property (nonatomic, assign) CGFloat fileSize;

- (void)getVideoCoverImageCompletion:(void(^)(UIImage * image))completion;

@end

NS_ASSUME_NONNULL_END
