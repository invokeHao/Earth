//
//  MFYVideoAndImageView.h
//  Earth
//
//  Created by colr on 2020/1/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYAssetModel.h"

typedef enum : NSUInteger {
    MFYVideoAndImageViewBigType,
    MFYVideoAndImageViewSmallType
} MFYVideoAndImageViewType;

NS_ASSUME_NONNULL_BEGIN

@interface MFYVideoAndImageView : UIView

@property (copy, nonatomic) void(^tapAddBlock)(void);

- (instancetype)initWithType:(MFYVideoAndImageViewType)type;

- (void)setImageData:(MFYAssetModel *)model;

@end

NS_ASSUME_NONNULL_END
