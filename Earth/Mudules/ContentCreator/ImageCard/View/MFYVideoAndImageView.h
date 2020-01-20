//
//  MFYVideoAndImageView.h
//  Earth
//
//  Created by colr on 2020/1/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MFYVideoAndImageViewBigType,
    MFYVideoAndImageViewSmallType
} MFYVideoAndImageViewType;

NS_ASSUME_NONNULL_BEGIN

@interface MFYVideoAndImageView : UIView

- (instancetype)initWithType:(MFYVideoAndImageViewType)type;

@end

NS_ASSUME_NONNULL_END
