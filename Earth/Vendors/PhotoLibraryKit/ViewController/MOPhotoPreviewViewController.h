//
//  MOPhotoPreviewViewController.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAssetModel.h"

@interface MOPhotoPreviewViewController : UIViewController

- (instancetype)initWithAssetModel:(MOAssetModel *)assetModel andYYImage:(YYImage *)image;

@end
