//
//  MODownloadNotificationModel.h
//  PhotoLibraryKit
//
//  Created by 黑眼圈 on 2018/6/10.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MODownloadNotificationModel : NSObject

// 下载进度
@property (nonatomic, assign) double progress;

// 资源的唯一标识
@property (nonatomic, copy) NSString *identifier;

// 是否需要下载
@property (nonatomic, assign) BOOL isNeedDownload;

//// 大图
@property (nonatomic, strong) UIImage *highImage;
@property (nonatomic, strong) NSData *imageData;

@end
