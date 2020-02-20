//
//  MFYPhotoCropVC.h
//  Earth
//
//  Created by colr on 2020/2/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MFYAssetModel;
@interface MFYPhotoCropVC : MFYBaseViewController

- (instancetype)initWithModel:(MFYAssetModel *)model didCropedImage:(void (^)(UIImage *cropedImage))dismissAction;

@end

NS_ASSUME_NONNULL_END
